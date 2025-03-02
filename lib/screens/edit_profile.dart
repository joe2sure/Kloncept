import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import '../provider/visible_provider.dart';
import 'password_reset_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import '../common/apidata.dart';
import '../common/global.dart';
import '../common/theme.dart' as T;
import '../provider/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Dio dio = new Dio();
  File? _image;
  final picker = ImagePicker();

  String extractName(String path) {
    int i;
    for (i = path.length - 1; i >= 0; i--) {
      if (path[i] == "/") break;
    }
    return path.substring(i + 1);
  }

  Future getImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {}
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(translate("Photo_Library")),
                      onTap: () async {
                        await getImageGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(translate("Camera_")),
                    onTap: () async {
                      await getImageCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _getEditIcon() {
    return new InkWell(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 20.0,
        child: new Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: 20.0,
        ),
      ),
      onTap: () {
        _showPicker(context);
      },
    );
  }

  String upfname = "", uplname = "", upmob = "", updetail = "", upaddress = "";

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  Widget inputField(BuildContext ctx, String hintTxt, String label, int idx,
      double width, Color borderclr) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextFormField(
            initialValue: _parseHtmlString(hintTxt),
            validator: (value) {
              if (value == "") {
                return translate("This_field_cannot_be_left_empty");
              }
              return null;
            },
            maxLines: idx == 5 ? 3 : 1,
            onChanged: (value) {
              if (idx == 0) {
                upfname = value;
              } else if (idx == 1) {
                uplname = value;
              } else if (idx == 2) {
                upmob = value;
              } else if (idx == 3) {
                pass = value;
              } else if (idx == 4) {
                upaddress = value;
              } else {
                updetail = value;
              }
            },
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: label,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: borderclr.withOpacity(0.7),
                  width: 2.0,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: borderclr.withOpacity(0.7),
                  width: 1.0,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500]),
            ),
          ),
        ],
      ),
    );
  }

  String pass = "";

  Future<bool> updateDetails(String email) async {
    String url = APIData.updateUserProfile + APIData.secretKey;
    String imagefileName = _image != null ? _image!.path.split('/').last : '';
    var _body;
    if (_image == null) {
      _body = FormData.fromMap({
        "email": email,
        "current_password": pass,
        "fname": upfname.toString(),
        "lname": uplname.toString(),
        "mobile": upmob.toString(),
        "address": upaddress.toString(),
        "detail": updetail.toString(),
      });
    } else {
      _body = FormData.fromMap({
        "email": email,
        "current_password": pass,
        "fname": upfname.toString(),
        "lname": uplname.toString(),
        "mobile": upmob.toString(),
        "address": upaddress.toString(),
        "detail": updetail.toString(),
        "user_img":
            await MultipartFile.fromFile(_image!.path, filename: imagefileName)
      });
    }
    Response res;
    try {
      res = await dio.post(
        url,
        data: _body,
        options: Options(
          method: 'POST',
          headers: {
            HttpHeaders.authorizationHeader: "Bearer " + authToken,
            HttpHeaders.acceptHeader: "Application/json",
          },
        ),
      );
      print("response code: " + "${res.statusCode}");
    } catch (e) {
      print('Exception: $e');
      return false;
    }

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Widget showImage(String? img) {
    return Container(
      height: 130,
      width: 130,
      child: Stack(children: [
        Center(
          child: CircleAvatar(
            radius: 55.0,
            backgroundImage: _image == null
                ? ((img == "" || img == "null")
                    ? AssetImage("assets/placeholder/avatar.png")
                        as ImageProvider
                    : CachedNetworkImageProvider(
                        APIData.userImage + img!,
                      ))
                : FileImage(_image!),
          ),
        ),
        Positioned(right: 7, bottom: 7, child: _getEditIcon())
      ]),
    );
  }

  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;

  Widget form(
      String img,
      String fName,
      String lName,
      String mobileNum,
      String detail,
      String add,
      double halfWi,
      double fullWi,
      Color bordercolor,
      String email) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //img
            showImage(img),
            SizedBox(
              height: 20,
            ),
            //Name
            inputField(context, fName, translate("First_Name"), 0, fullWi,
                bordercolor),
            inputField(
                context, lName, translate("Last_Name"), 1, fullWi, bordercolor),

            //mobile
            inputField(context, mobileNum, translate("Mobile_No"), 2, fullWi,
                bordercolor),
            TextFormField(
              initialValue: "",
              validator: (value) {
                if (value == "") {
                  return translate("This_field_cannot_be_left_empty");
                }
                return null;
              },
              onChanged: (value) {
                pass = value;
              },
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              obscureText: _hidePassword,
              decoration: InputDecoration(
                labelText: translate("Password_"),
                suffixIcon: IconButton(
                    icon: Icon(
                      _hidePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    }),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: bordercolor.withOpacity(0.7),
                    width: 2.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: bordercolor.withOpacity(0.7),
                    width: 1.0,
                  ),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500]),
              ),
            ),
            //address
            inputField(
                context, add, translate("Address_"), 4, fullWi, bordercolor),
            //detail
            inputField(
                context, detail, translate("Detail_"), 5, fullWi, bordercolor),
            SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                UserProfile user =
                    Provider.of<UserProfile>(context, listen: false);
                setState(() {
                  isloading = true;
                });
                if (upfname == "")
                  upfname = user.profileInstance.fname.toString();
                if (uplname == "")
                  uplname = user.profileInstance.lname.toString();
                if (upmob == "") upmob = user.profileInstance.mobile;
                if (upaddress == "")
                  upaddress = user.profileInstance.address.toString();
                if (updetail == "")
                  updetail = user.profileInstance.detail.toString();
                if (_formKey.currentState!.validate())
                  await updateDetails(email).then((value) async {
                    if (value) {
                      await user.fetchUserProfile();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            translate("Profile_Updated"),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            translate("Incorrect_Password"),
                          ),
                        ),
                      );
                    }
                  });

                setState(() {
                  isloading = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(isloading ? 5 : 0),
                height: 50,
                width: 120,
                alignment: Alignment.center,
                child: isloading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Center(
                        child: Text(
                          translate("Update_"),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar pappbar(Color bgColor, Color txtColor) {
    return AppBar(
      elevation: 0.0,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: txtColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      centerTitle: true,
      title: Text(
        translate("Edit_Profile"),
        style: TextStyle(color: txtColor, fontWeight: FontWeight.w600),
      ),
      backgroundColor: bgColor,
      actions: [
        PopupMenuButton<String>(
          child: Container(
            margin: EdgeInsets.only(right: 20),
            child: Icon(
              FontAwesomeIcons.ellipsisVertical,
              color: txtColor,
              size: 20,
            ),
          ),
          onSelected: handleDropDownTap,
          itemBuilder: (BuildContext context) {
            return {translate('Change_Password'), translate('Delete_Account')}
                .map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        )
      ],
    );
  }

  void handleDropDownTap(String value) {
    if (value == translate('Change_Password')) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PasswordReset(1, user?.profileInstance.email)));
    } else if (value == translate('Delete_Account')) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text(
            translate("Confirm_Account_Deletion"),
            style: TextStyle(
              fontFamily: 'Mada',
              fontWeight: FontWeight.w700,
              color: Colors.red,
            ),
          ),
          content: Text(
            translate("Are_you_sure_that_you_want_to_delete_your_account"),
            style: TextStyle(
              fontFamily: 'Mada',
              color: Color(0xFF3F4654),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                translate("No_").toUpperCase(),
                style: TextStyle(
                  color: Color(0xFF0284A2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                deleteAccount();
                Navigator.pop(context);
              },
              child: Text(
                translate("Yes_").toUpperCase(),
                style: TextStyle(
                  color: Color(0xFF0284A2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> deleteAccount() async {
    Response response =
        await dio.delete(APIData.deleteAccount + "${user!.profileInstance.id}");

    if (response.statusCode == 200) {
      print("Delete Account API Response : ${response.data}");
      authToken = null;
      await storage.deleteAll();
      Fluttertoast.showToast(
          msg: translate("Your Account has been deleted successfully."));
      Provider.of<Visible>(context, listen: false).toggleVisible(false);
      Navigator.of(context).pushNamed('/SignIn');
    } else {
      print("Delete Account API Response : ${response.data}");
      Fluttertoast.showToast(
          msg: translate("Failed! Your Account could not be deleted."));
    }
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget scaffoldView(user, halfwi, fullwi, mode) {
    return SingleChildScrollView(
      child: form(
          user.profileInstance.userImg == null
              ? ""
              : user.profileInstance.userImg,
          user.profileInstance.fname == null ? "" : user.profileInstance.fname,
          user.profileInstance.lname == null ? "" : user.profileInstance.lname,
          user.profileInstance.mobile == null
              ? ""
              : user.profileInstance.mobile,
          user.profileInstance.detail == null
              ? ""
              : user.profileInstance.detail,
          user.profileInstance.address == null
              ? ""
              : user.profileInstance.address,
          halfwi,
          fullwi,
          mode.notificationIconColor,
          user.profileInstance.email == null ? "" : user.profileInstance.email),
    );
  }

  UserProfile? user;
  @override
  Widget build(BuildContext context) {
    double fullwi = MediaQuery.of(context).size.width - 30;
    double halfwi = (MediaQuery.of(context).size.width / 2) - 30;
    user = Provider.of<UserProfile>(context);
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: mode.bgcolor,
        appBar: pappbar(mode.bgcolor, mode.notificationIconColor),
        body: scaffoldView(user, halfwi, fullwi, mode));
  }
}
