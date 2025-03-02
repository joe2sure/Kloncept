import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/provider/full_course_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:kloncept/common/theme.dart' as T;
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:kloncept/common/apidata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';

class AssignmentScreen extends StatefulWidget {
  AssignmentScreen(this.courseDetails);
  final FullCourse courseDetails;
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  Dio dio = new Dio();
  String? _mySelection;
  bool _visible = false;
  FormData? formData;
  TextEditingController titleController = new TextEditingController();
  bool isUploading = false;
  var sFileName;
  List<ChaptersData> data = [];
  PlatformFile? file;

  Widget dropDown(List<ChaptersData> data) {
    if (data.length != 0) {
      return DropdownButton<String>(
        isDense: true,
        hint: new Text(translate("Select_Chapter")),
        value: _mySelection,
        onChanged: (String? newValue) {
          setState(() {
            _mySelection = newValue;
          });

          print(_mySelection);
        },
        items: data.map((ChaptersData item) {
          return DropdownMenuItem<String>(
            value: item.chapterId,
            child: Text(
              item.chapterName,
            ),
          );
        }).toList(),
      );
    } else
      return Center(
        child: CircularProgressIndicator(),
      );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _visible = false;
    });
    getChaptersList();
  }

  getChaptersList() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var chapters = widget.courseDetails.course!.chapter;
      for (int i = 0; i < chapters!.length; i++) {
        data.add(
            ChaptersData("${chapters[i].id}", "${chapters[i].chapterName}"));
      }
      setState(() {
        _visible = true;
      });
    });
  }

  void uploadAssignment(file, courseId, chapterId) async {
    setState(() {
      isUploading = true;
    });
    showLoaderDialog(context);
    var _body;
    String fileName = file != null ? file.path.split('/').last : '';
    print(fileName);
    print(file.path);
    print(titleController.text);
    _body = FormData.fromMap({
      "course_id": "$courseId",
      "chapter_id": "$chapterId",
      "title": "${titleController.text}",
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    final response =
        await dio.post("${APIData.submitAssignment}${APIData.secretKey}",
            data: _body,
            options: Options(
                method: 'POST',
                headers: {
                  "Accept": "application/json",
                  HttpHeaders.authorizationHeader: "Bearer $authToken",
                },
                responseType: ResponseType.plain,
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 500;
                }));
    print(response.statusMessage);
    print(response.data);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        isUploading = false;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: translate("Assignment_submitted_successfully"),
          textColor: Colors.white,
          backgroundColor: Colors.green);
    } else {
      setState(() {
        isUploading = false;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: translate("Assignment_submission_failed"),
          textColor: Colors.white,
          backgroundColor: Colors.red);
    }
  }

  // Alert dialog after clicking on login button
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Uploading ...")),
        ],
      ),
    );
    if (isUploading == true) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
      appBar: customAppBar(context, translate("Assignment_")),
      backgroundColor: mode.backgroundColor,
      body: _visible == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 30.0),
              scrollDirection: Axis.vertical,
              children: [
                dropDown(data),
                Divider(
                  color: mode.titleTextColor.withOpacity(0.5),
                  thickness: 1.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                    child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    decoration:
                        InputDecoration(hintText: translate("Enter_Title")),
                    validator: (value) {
                      if (value!.length == 0) {
                        return translate("Enter_Title");
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) => titleController.text = value!,
                  ),
                )),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: [
                            'jpg',
                            'pdf',
                            'doc',
                            'zip',
                            'png',
                            'jpeg'
                          ],
                        );
                        if (result != null) {
                          file = result.files.first;
                          setState(() {
                            sFileName = file!.name;
                          });
                        } else {}
                      },
                      icon: Icon(Icons.attach_file),
                      label: Text(
                        translate("Choose_file"),
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: mode.titleTextColor.withOpacity(0.09),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    sFileName == null
                        ? SizedBox.shrink()
                        : Flexible(
                            child: Text(
                              sFileName,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                ButtonTheme(
                  height: 40,
                  minWidth: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final form = _formKey.currentState;
                      form!.save();
                      if (form.validate() == true) {
                        if (_mySelection != null) {
                          if (sFileName != null) {
                            uploadAssignment(file,
                                widget.courseDetails.course!.id, _mySelection);
                          } else {
                            Fluttertoast.showToast(
                                msg: translate("Choose_Assignment_file"));
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: translate("Select_Chapter"));
                        }
                      } else {
                        return;
                      }
                    },
                    child: Text(
                      translate("Submit_Assignment"),
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mode.easternBlueColor,
                    ),
                  ),
                )
              ],
            ),
    );
  }
}

class ChaptersData {
  String chapterId;
  String chapterName;

  ChaptersData(this.chapterId, this.chapterName);
}
