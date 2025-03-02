import 'dart:io';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/common/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:dio/dio.dart';

class RateCourseScreen extends StatefulWidget {
  RateCourseScreen({@required this.courseName, @required this.courseId});

  final String? courseName;
  final int? courseId;

  @override
  _RateCourseScreenState createState() => _RateCourseScreenState();
}

class _RateCourseScreenState extends State<RateCourseScreen> {
  // For Learn Star
  IconData? firstStarLearn;
  IconData? secondStarLearn;
  IconData? thirdStarLearn;
  IconData? fourthStarLearn;
  IconData? fifthStarLearn;
  Color? firstStarClrLearn;
  Color? secondStarClrLearn;
  Color? thirdStarClrLearn;
  Color? fourthStarClrLearn;
  Color? fifthStarClrLearn;
  int? userRatingLearn = 1;
  // For Price Star
  IconData? firstStarPrice;
  IconData? secondStarPrice;
  IconData? thirdStarPrice;
  IconData? fourthStarPrice;
  IconData? fifthStarPrice;
  Color? firstStarClrPrice;
  Color? secondStarClrPrice;
  Color? thirdStarClrPrice;
  Color? fourthStarClrPrice;
  Color? fifthStarClrPrice;
  int? userRatingPrice = 1;
  // For Value Star
  IconData? firstStarValue;
  IconData? secondStarValue;
  IconData? thirdStarValue;
  IconData? fourthStarValue;
  IconData? fifthStarValue;
  Color? firstStarClrValue;
  Color? secondStarClrValue;
  Color? thirdStarClrValue;
  Color? fourthStarClrValue;
  Color? fifthStarClrValue;
  int? userRatingValue = 1;
  String? exampleText = "${translate("Write_your_reviews_here")}...";

  TextEditingController controller = TextEditingController();

  bool isSubmitting = false;

  Future<void> addReview() async {
    Dio dio = new Dio();
    String url = APIData.reviewCourse + APIData.secretKey;
    print(
      "course_id ${widget.courseId}",
    );
    var body = FormData.fromMap({
      "course_id": widget.courseId,
      "learn": userRatingLearn,
      "price": userRatingPrice,
      "value": userRatingValue,
      "review": controller.text,
    });

    Response response;
    try {
      response = await dio.post(
        url,
        data: body,
        options: Options(
            method: 'POST',
            headers: {
              HttpHeaders.authorizationHeader: "Bearer " + authToken,
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      print('helo${response.statusCode}');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: translate("Review_Submitted_Successfully"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
        await Future.delayed(Duration(seconds: 3));
        Navigator.of(context).pop();
      } else if (response.statusCode! == 201) {
        Fluttertoast.showToast(
            msg: translate("Already_Reviewed_"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        await Future.delayed(Duration(seconds: 3));
        setState(() {
          isSubmitting = false;
        });
      } else {
        Fluttertoast.showToast(
            msg: translate("Failed_"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        await Future.delayed(Duration(seconds: 3));
        setState(() {
          isSubmitting = false;
        });
      }
    } catch (e) {
      print('Exception : $e');
      Fluttertoast.showToast(
          msg: translate("Failed_"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        isSubmitting = false;
      });
    }

    print(
        "You have given $userRatingLearn star for Learning, $userRatingPrice star for Price & $userRatingValue star for Value for course ${widget.courseName} which ID is ${widget.courseId}. Your text review is ${controller.text}.");
  }

  @override
  void initState() {
    super.initState();
    // For Learn Star
    firstStarLearn = FontAwesomeIcons.solidStar;
    secondStarLearn = FontAwesomeIcons.solidStar;
    thirdStarLearn = FontAwesomeIcons.solidStar;
    fourthStarLearn = FontAwesomeIcons.solidStar;
    fifthStarLearn = FontAwesomeIcons.solidStar;

    firstStarClrLearn = Color(0xffFDC600);
    secondStarClrLearn = Colors.grey.shade300;
    thirdStarClrLearn = Colors.grey.shade300;
    fourthStarClrLearn = Colors.grey.shade300;
    fifthStarClrLearn = Colors.grey.shade300;

    // For Price Star
    firstStarPrice = FontAwesomeIcons.solidStar;
    secondStarPrice = FontAwesomeIcons.solidStar;
    thirdStarPrice = FontAwesomeIcons.solidStar;
    fourthStarPrice = FontAwesomeIcons.solidStar;
    fifthStarPrice = FontAwesomeIcons.solidStar;

    firstStarClrPrice = Color(0xffFDC600);
    secondStarClrPrice = Colors.grey.shade300;
    thirdStarClrPrice = Colors.grey.shade300;
    fourthStarClrPrice = Colors.grey.shade300;
    fifthStarClrPrice = Colors.grey.shade300;

    // For Value Star
    firstStarValue = FontAwesomeIcons.solidStar;
    secondStarValue = FontAwesomeIcons.solidStar;
    thirdStarValue = FontAwesomeIcons.solidStar;
    fourthStarValue = FontAwesomeIcons.solidStar;
    fifthStarValue = FontAwesomeIcons.solidStar;

    firstStarClrValue = Color(0xffFDC600);
    secondStarClrValue = Colors.grey.shade300;
    thirdStarClrValue = Colors.grey.shade300;
    fourthStarClrValue = Colors.grey.shade300;
    fifthStarClrValue = Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 10.0,
        title: Text(
          translate("Review_Course"),
          style: TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios, color: Colors.black, // add custom icons also
          ),
        ),
      ),
      body: LoadingOverlay(
        isLoading: isSubmitting,
        progressIndicator: CircularProgressIndicator(
          color: Colors.red,
        ),
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Card(
            elevation: 10.0,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      widget.courseName.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 0.5,
                      width: MediaQuery.of(context).size.width / 1.2,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      translate("Rate_the_course"),
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      maxLines: 2,
                    ),
                    Text(
                      translate(
                          "How_do_you_find_the_course_based_on_your_learning"),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    // Star Pattern For LEARN Rating
                    Text(
                      translate("Learn_"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingLearn = 1;
                              firstStarClrLearn = Color(0xffFDC600);
                              secondStarClrLearn = Colors.grey.shade300;
                              thirdStarClrLearn = Colors.grey.shade300;
                              fourthStarClrLearn = Colors.grey.shade300;
                              fifthStarClrLearn = Colors.grey.shade300;
                            });
                          },
                          child: Icon(
                            firstStarLearn,
                            color: firstStarClrLearn,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingLearn = 2;
                              firstStarClrLearn = Color(0xffFDC600);
                              secondStarClrLearn = Color(0xffFDC600);
                              thirdStarClrLearn = Colors.grey.shade300;
                              fourthStarClrLearn = Colors.grey.shade300;
                              fifthStarClrLearn = Colors.grey.shade300;
                            });
                          },
                          child: Icon(
                            firstStarLearn,
                            color: secondStarClrLearn,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingLearn = 3;
                              firstStarClrLearn = Color(0xffFDC600);
                              secondStarClrLearn = Color(0xffFDC600);
                              thirdStarClrLearn = Color(0xffFDC600);
                              fourthStarClrLearn = Colors.grey.shade300;
                              fifthStarClrLearn = Colors.grey.shade300;
                            });
                          },
                          child: Icon(
                            firstStarLearn,
                            color: thirdStarClrLearn,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingLearn = 4;
                              firstStarClrLearn = Color(0xffFDC600);
                              secondStarClrLearn = Color(0xffFDC600);
                              thirdStarClrLearn = Color(0xffFDC600);
                              fourthStarClrLearn = Color(0xffFDC600);
                              fifthStarClrLearn = Colors.grey.shade300;
                            });
                          },
                          child: Icon(
                            firstStarLearn,
                            color: fourthStarClrLearn,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingLearn = 5;
                              firstStarClrLearn = Color(0xffFDC600);
                              secondStarClrLearn = Color(0xffFDC600);
                              thirdStarClrLearn = Color(0xffFDC600);
                              fourthStarClrLearn = Color(0xffFDC600);
                              fifthStarClrLearn = Color(0xffFDC600);
                            });
                          },
                          child: Icon(
                            firstStarLearn,
                            color: fifthStarClrLearn,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    // Star Pattern For PRICE Rating
                    Text(
                      translate("Price_"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingPrice = 1;
                              firstStarClrPrice = Color(0xffFDC600);
                              secondStarClrPrice = Colors.grey.shade300;
                              thirdStarClrPrice = Colors.grey.shade300;
                              fourthStarClrPrice = Colors.grey.shade300;
                              fifthStarClrPrice = Colors.grey.shade300;
                            });
                          },
                          child: Icon(
                            firstStarPrice,
                            color: firstStarClrPrice,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingPrice = 2;
                              firstStarClrPrice = Color(0xffFDC600);
                              secondStarClrPrice = Color(0xffFDC600);
                              thirdStarClrPrice = Colors.grey.shade300;
                              fourthStarClrPrice = Colors.grey.shade300;
                              fifthStarClrPrice = Colors.grey.shade300;
                            });
                          },
                          child: Icon(
                            firstStarPrice,
                            color: secondStarClrPrice,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingPrice = 3;
                              firstStarClrPrice = Color(0xffFDC600);
                              secondStarClrPrice = Color(0xffFDC600);
                              thirdStarClrPrice = Color(0xffFDC600);
                              fourthStarClrPrice = Colors.grey.shade300;
                              fifthStarClrPrice = Colors.grey.shade300;
                            });
                          },
                          child: Icon(
                            firstStarPrice,
                            color: thirdStarClrPrice,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingPrice = 4;
                              firstStarClrPrice = Color(0xffFDC600);
                              secondStarClrPrice = Color(0xffFDC600);
                              thirdStarClrPrice = Color(0xffFDC600);
                              fourthStarClrPrice = Color(0xffFDC600);
                              fifthStarClrPrice = Colors.grey.shade300;
                            });
                          },
                          child: Icon(
                            firstStarPrice,
                            color: fourthStarClrPrice,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingPrice = 5;
                              firstStarClrPrice = Color(0xffFDC600);
                              secondStarClrPrice = Color(0xffFDC600);
                              thirdStarClrPrice = Color(0xffFDC600);
                              fourthStarClrPrice = Color(0xffFDC600);
                              fifthStarClrPrice = Color(0xffFDC600);
                            });
                          },
                          child: Icon(
                            firstStarPrice,
                            color: fifthStarClrPrice,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    // Star Pattern For VALUE Rating
                    Text(
                      translate("Value_"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingValue = 1;
                              firstStarClrValue = Color(0xffFDC600);
                              secondStarClrValue = Colors.grey.shade300;
                              thirdStarClrValue = Colors.grey.shade300;
                              fourthStarClrValue = Colors.grey.shade300;
                              fifthStarClrValue = Colors.grey.shade300;
                            });
                          },
                          child: Icon(
                            firstStarValue,
                            color: firstStarClrValue,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingValue = 2;
                              firstStarClrValue = Color(0xffFDC600);
                              secondStarClrValue = Color(0xffFDC600);
                              thirdStarClrValue = Colors.grey.shade300;
                              fourthStarClrValue = Colors.grey.shade300;
                              fifthStarClrValue = Colors.grey.shade300;
                            });
                          },
                          child: Icon(
                            firstStarValue,
                            color: secondStarClrValue,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingValue = 3;
                              firstStarClrValue = Color(0xffFDC600);
                              secondStarClrValue = Color(0xffFDC600);
                              thirdStarClrValue = Color(0xffFDC600);
                              fourthStarClrValue = Colors.grey.shade300;
                              fifthStarClrValue = Colors.grey.shade300;
                            });
                          },
                          child: Icon(
                            firstStarValue,
                            color: thirdStarClrValue,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingValue = 4;
                              firstStarClrValue = Color(0xffFDC600);
                              secondStarClrValue = Color(0xffFDC600);
                              thirdStarClrValue = Color(0xffFDC600);
                              fourthStarClrValue = Color(0xffFDC600);
                              fifthStarClrValue = Colors.grey.shade300;
                            });
                          },
                          child: Icon(
                            firstStarValue,
                            color: fourthStarClrValue,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userRatingValue = 5;
                              firstStarClrValue = Color(0xffFDC600);
                              secondStarClrValue = Color(0xffFDC600);
                              thirdStarClrValue = Color(0xffFDC600);
                              fourthStarClrValue = Color(0xffFDC600);
                              fifthStarClrValue = Color(0xffFDC600);
                            });
                          },
                          child: Icon(
                            firstStarValue,
                            color: fifthStarClrValue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 0.5,
                      width: MediaQuery.of(context).size.width / 1.2,
                      color: Colors.grey,
                    ),
                    TextFormField(
                      minLines: 2,
                      maxLines: 100,
                      cursorColor: Colors.red,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        hintText: exampleText,
                      ),
                      controller: controller,
                    ),
                    Container(
                      height: 0.5,
                      width: MediaQuery.of(context).size.width / 1.2,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xfff44a4a),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(
                          () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    translate("Are_you_sure"),
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: Text(translate(
                                      "Do_you_want_to_the_submit_review")),
                                  actions: [
                                    // ignore: deprecated_member_use
                                    TextButton(
                                      child: Text(translate("Yes_")),
                                      onPressed: () {
                                        setState(() {
                                          isSubmitting = true;
                                          Navigator.of(context).pop();
                                          addReview();
                                        });
                                      },
                                    ),
                                    // ignore: deprecated_member_use
                                    TextButton(
                                      child: Text(translate("No_")),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Text(
                        translate("Submit_Review"),
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
