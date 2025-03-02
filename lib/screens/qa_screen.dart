import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/model/content_model.dart';
import 'package:kloncept/provider/content_provider.dart';
import 'package:kloncept/provider/full_course_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:kloncept/common/theme.dart' as T;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:kloncept/provider/user_profile.dart';

class QAScreen extends StatefulWidget {
  QAScreen(this.courseDetails);

  final FullCourse courseDetails;

  @override
  _QAScreenState createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  TextEditingController _replyController = TextEditingController();
  TextEditingController _askQuizController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  bool showFab = true;

  void showFloatingActionButton(bool value) {
    setState(() {
      showFab = value;
    });
  }

  addAnswers(index, courseId, questionId) async {
    var reply = Provider.of<ContentProvider>(context, listen: false)
        .contentModel!
        .questions![index]
        .answer;
    var userDetails =
        Provider.of<UserProfile>(context, listen: false).profileInstance;
    final res = await http.post(
        Uri.parse("${APIData.submitAnswer}${APIData.secretKey}"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $authToken",
          "Accept": "application/json"
        },
        body: {
          "course_id": "$courseId",
          "question_id": "$questionId",
          "answer": "${_replyController.text}",
        });
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      reply!.add(
        Answer(
          course: widget.courseDetails.course!.title,
          user: userDetails.fname,
          instructor: widget.courseDetails.course!.userId,
          image: userDetails.userImg,
          imagepath: "${APIData.userImagePath}${userDetails.userImg}",
          question: "$questionId",
          answer: "${_replyController.text}",
          status: "1",
        ),
      );
      Fluttertoast.showToast(
          msg: translate("Answer_submitted_successfully"),
          backgroundColor: Colors.green,
          textColor: Colors.white);
      _replyController.text = '';
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: translate("Answer_submission_failed"),
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

  askQuestions(BuildContext context, courseId) async {
    FocusScope.of(context).requestFocus(FocusNode());
    var content =
        Provider.of<ContentProvider>(context, listen: false).contentModel;
    var userDetails =
        Provider.of<UserProfile>(context, listen: false).profileInstance;
    final res = await http.post(
        Uri.parse("${APIData.submitQuestion}${APIData.secretKey}"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $authToken",
          "Accept": "application/json"
        },
        body: {
          "course_id": "$courseId",
          "question": "${_askQuizController.text}",
        });

    if (res.statusCode == 200) {
      var response = json.decode(res.body);
      var newQues;
      setState(() {
        newQues = response['question'];
      });
      content!.questions!.add(ContentModelQuestion(
        id: newQues['id'],
        user: userDetails.fname,
        instructor: newQues['instructor_id'],
        image: userDetails.userImg,
        imagepath: "${APIData.userImagePath}${userDetails.userImg}",
        course: "$courseId",
        title: newQues['question'],
        answer: [],
        status: "1",
        createdAt: DateTime.parse(newQues['created_at']),
        updatedAt: DateTime.parse(newQues['updated_at']),
      ));
      Fluttertoast.showToast(
          msg: translate("Question_submitted_successfully"),
          backgroundColor: Colors.green,
          textColor: Colors.white);
      _askQuizController.text = '';
      setState(() {});
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: translate("Question_submission_failed"),
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context, listen: false);
    var questions = Provider.of<ContentProvider>(context).contentModel != null
        ? Provider.of<ContentProvider>(context).contentModel!.questions
        : [];
    return Scaffold(
      backgroundColor: mode.backgroundColor,
      appBar: customAppBar(context, translate("Questions_Answers")),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 5.0,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              contentPadding: EdgeInsets.only(
                top: 10.0,
                left: 20.0,
                bottom: 0.0,
                right: 20.0,
              ),
              title: Text(
                translate("Ask_Questions"),
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Mada',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0284A2),
                ),
              ),
              content: Container(
                height: 125,
                width: 300,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _askQuizController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: translate("Enter_questions"),
                        ),
                        validator: (val) {
                          if (val!.length == 0) {
                            return translate("Enter_question");
                          }
                          return null;
                        },
                        onSaved: (val) => _askQuizController.text = val!,
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "${translate("Cancel_")}".toUpperCase(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF0284A2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    askQuestions(context, widget.courseDetails.course!.id);
                  },
                  child: Text(
                    "${translate("Submit_")}".toUpperCase(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF0284A2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        backgroundColor: mode.easternBlueColor,
        label: Text(
          translate("Ask_new_question"),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: questions!.length,
          padding:
              EdgeInsets.only(left: 18.0, right: 18.0, top: 10, bottom: 5.0),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  questions[index].imagepath == null
                      ? Image.asset(
                          "${questions[index].imagepath}",
                          height: 50,
                          width: 50,
                        )
                      : CachedNetworkImage(
                          height: 50,
                          width: 50,
                          imageUrl: "${questions[index].imagepath}",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${questions[index].user}",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "${questions[index].title}",
                          maxLines: 4,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: mode.titleTextColor,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Text(
                              DateFormat.yMMMd()
                                  .add_jm()
                                  .format(questions[index].updatedAt),
                              style: new TextStyle(
                                color: mode.titleTextColor.withOpacity(0.6),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ButtonTheme(
                              minWidth: 20,
                              height: 40,
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(0.0),
                                ),
                                onPressed: () {
                                  var reply = Provider.of<ContentProvider>(
                                          context,
                                          listen: false)
                                      .contentModel!
                                      .questions![index]
                                      .answer;
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => Container(
                                      color: Colors.white,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.4,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x1c2464)
                                                      .withOpacity(0.30),
                                                  blurRadius: 25.0,
                                                  offset: Offset(0.0, 20.0),
                                                  spreadRadius: -15.0,
                                                )
                                              ],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 18.0,
                                                right: 8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    translate("Answers_"),
                                                    style: TextStyle(
                                                      color:
                                                          mode.titleTextColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    icon: Icon(
                                                      CupertinoIcons
                                                          .clear_thick,
                                                      color:
                                                          mode.titleTextColor,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.4 -
                                                70,
                                            child: ListView.builder(
                                              itemCount: reply!.length,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 18.0,
                                                  vertical: 18.0),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    reply[index].imagepath ==
                                                            null
                                                        ? Image.asset(
                                                            "${reply[index].imagepath}",
                                                            height: 50,
                                                            width: 50,
                                                          )
                                                        : CachedNetworkImage(
                                                            height: 50,
                                                            width: 50,
                                                            imageUrl:
                                                                "${reply[index].imagepath}",
                                                            progressIndicatorBuilder: (context,
                                                                    url,
                                                                    downloadProgress) =>
                                                                CircularProgressIndicator(
                                                                    value: downloadProgress
                                                                        .progress),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${reply[index].user}",
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                          Text(
                                                            "${reply[index].answer}",
                                                            maxLines: 4,
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                              color: mode
                                                                  .titleTextColor,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.comment,
                                  color: mode.titleTextColor.withOpacity(0.8),
                                ),
                                label: Text(
                                  "${questions[index].answer.length}",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: mode.titleTextColor,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                child: Text(
                                  translate("Reply_"),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: mode.easternBlueColor),
                                ),
                              ),
                              onTap: () {
                                var reply = Provider.of<ContentProvider>(
                                        context,
                                        listen: false)
                                    .contentModel!
                                    .questions![index]
                                    .answer;
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => Container(
                                    color: Colors.white,
                                    height: MediaQuery.of(context).size.height /
                                        1.3,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0x1c2464)
                                                    .withOpacity(0.30),
                                                blurRadius: 25.0,
                                                offset: Offset(0.0, 20.0),
                                                spreadRadius: -15.0,
                                              )
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: 18.0,
                                              right: 8.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  translate("Add_Answers"),
                                                  style: TextStyle(
                                                    color: mode.titleTextColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                IconButton(
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    icon: Icon(
                                                      CupertinoIcons
                                                          .clear_thick,
                                                      color:
                                                          mode.titleTextColor,
                                                    ),
                                                    onPressed: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                      Navigator.pop(context);
                                                    })
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  1.3 -
                                              70,
                                          child: SingleChildScrollView(
                                            child: answersList(reply,
                                                questions[index].id, index),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget answersList(reply, questionId, index) {
    T.Theme mode = Provider.of<T.Theme>(context);
    List<Widget> list = [];
    for (int i = 0; i < reply.length; i++) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          reply[i].imagepath == null
              ? Image.asset(
                  "${reply[i].imagepath}",
                  height: 50,
                  width: 50,
                )
              : CachedNetworkImage(
                  height: 50,
                  width: 50,
                  imageUrl: "${reply[i].imagepath}",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${reply[i].user}",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${reply[i].answer}",
                  maxLines: 4,
                  style: TextStyle(fontSize: 16.0, color: mode.titleTextColor),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ],
      ));
    }
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Form(
                    key: _formKey1,
                    child: TextFormField(
                      maxLines: 1,
                      controller: _replyController,
                      decoration: InputDecoration(
                        hintText: translate("Write_your_answer"),
                      ),
                      validator: (val) {
                        if (val!.length == 0) {
                          return translate("Enter_answer");
                        }
                        return null;
                      },
                      onSaved: (val) => _replyController.text = val!,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mode.easternBlueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Text(
                    translate("Submit_"),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    final form = _formKey1.currentState;
                    form!.save();
                    if (form.validate() == true) {
                      addAnswers(
                          index, widget.courseDetails.course!.id, questionId);
                    }
                  },
                ),
              ],
            ),
            Column(
              children: list,
            ),
          ],
        ));
  }
}
