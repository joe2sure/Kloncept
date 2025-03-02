import 'package:dio/dio.dart';
import 'package:kloncept/Screens/payment_gateway.dart';
import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/common/apidata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/theme.dart' as T;

class GiftCourseScreen extends StatefulWidget {
  GiftCourseScreen({this.courseId, this.coursePrice});

  final int? courseId;
  final dynamic coursePrice;

  @override
  _GiftCourseScreenState createState() => _GiftCourseScreenState();
}

class _GiftCourseScreenState extends State<GiftCourseScreen> {
  Future<void> giftCheckout(
      int userId, int courseId, dynamic coursePrice) async {
    print("User Id : $userId");
    print("Course Id : $courseId");
    print("Course Price : $coursePrice");

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setInt("giftUserId", userId);
    await sharedPreferences.setInt("giftCourseId", courseId);

    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: PaymentGateway(
          int.parse("$coursePrice"),
          int.tryParse("$coursePrice"),
        ),
      ),
    ).then((_) async {
      if (sharedPreferences.containsKey("giftUserId")) {
        await sharedPreferences.remove("giftUserId");
        await sharedPreferences.remove("giftCourseId");
      }
    });
  }

  Future<void> checkUser() async {
    Dio dio = new Dio();
    String url = APIData.checkUser + APIData.secretKey;

    var body = FormData.fromMap({
      "fname": fName,
      "lname": lName,
      "email": email,
      "course_id": widget.courseId,
      "detail": detail,
    });

    Response? response;
    try {
      response = await dio.post(
        url,
        data: body,
      );
    } catch (e) {
      print('Exception : $e');
      Fluttertoast.showToast(
          msg: translate("Failed_"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    if (response!.statusCode == 200) {
      var jsonData = response.data;
      int userId = jsonData["user"]["id"];
      int courseId = jsonData["course"]["id"];
      dynamic coursePrice = widget.coursePrice;
      await giftCheckout(userId, courseId, coursePrice);
    } else {
      Fluttertoast.showToast(
          msg: translate("Failed_"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  String fName = "", lName = "", email = "", detail = "";

  Widget inputField(String hintTxt, String label, int idx, Color borderColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType: idx >= 0 && idx <= 1
            ? TextInputType.name
            : idx == 2
                ? TextInputType.emailAddress
                : TextInputType.text,
        initialValue: hintTxt,
        validator: (value) {
          if (value == "" && idx != 3) {
            return translate("This_field_cannot_be_left_empty");
          }
          return null;
        },
        maxLines: idx == 3 ? 3 : 1,
        onChanged: (value) {
          if (idx == 0) {
            fName = value;
          } else if (idx == 1) {
            lName = value;
          } else if (idx == 2) {
            email = value;
          } else {
            detail = value;
          }
        },
        cursorColor: Colors.black,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: borderColor.withOpacity(0.7),
              width: 2.0,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: borderColor.withOpacity(0.7),
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
    );
  }

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var borderColor = Provider.of<T.Theme>(context).notificationIconColor;
    return Scaffold(
      appBar: customAppBar(context, translate("Gift_Course")),
      backgroundColor: Color(0xFFF1F3F8),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Name
                inputField("", translate("First_Name"), 0, borderColor),
                inputField("", translate("Last_Name"), 1, borderColor),

                //mobile
                inputField("", translate("Email_"), 2, borderColor),

                //detail
                inputField("", translate("Your_Message"), 3, borderColor),
                SizedBox(
                  height: 15.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      setState(() {
                        isLoading = true;
                      });

                      await checkUser();

                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(isLoading ? 5 : 0),
                    height: 50,
                    width: 180,
                    alignment: Alignment.center,
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Center(
                            child: Text(
                              translate("Proceed_to_Checkout"),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
