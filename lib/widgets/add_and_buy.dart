import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/provider/courses_provider.dart';
import 'package:kloncept/provider/full_course_detail.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../provider/cart_pro_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/bottom_navigation_screen.dart';
import 'triangle.dart';

class AddAndBuy extends StatefulWidget {
  final int? courseId;
  final String? cprice;
  final FullCourse? details;

  AddAndBuy(this.courseId, this.cprice, this.details);

  @override
  _AddAndBuyState createState() => _AddAndBuyState();
}

class _AddAndBuyState extends State<AddAndBuy> {
  Widget addToCart(bool inCart) {
    return Material(
      color: Color(0xfff44a4a),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          setState(() {
            this.isloading = true;
          });
          setState(() {});
          if (!inCart) {
            bool success =
                await crt.addtocart(widget.courseId.toString(), context);
            Navigator.pop(context);
            if (success) {
              print("Hello");
              print("Check Success value ${success.toString()}");

              Fluttertoast.showToast(
                msg: translate("Course_added_to_your_cart"),
                backgroundColor: Colors.red,
                textColor: Colors.white,
                toastLength: Toast.LENGTH_LONG,
              );

              // ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text(translate("Course_added_to_your_cart"),),
              //       duration: new Duration(milliseconds: success == true ? 1200 : 3000),
              //     )
              // ).closed.then((_) {
              //   Navigator.pop(context); /////THIS IS THE ERROR/////
              //
              // });
            } else {
              Fluttertoast.showToast(
                msg: translate("Go_to_Cart_Section"),
                backgroundColor: Colors.red,
                textColor: Colors.white,
                toastLength: Toast.LENGTH_LONG,
              );

              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text(
              //       translate("Go_to_Cart_Section"),
              //     ),
              //   ),
              // );
            }
          } else
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyBottomNavigationBar(
                          pageInd: 3,
                        )));
          setState(() {
            this.isloading = false;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          height: 55.0,
          width: MediaQuery.of(context).size.width - 50,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(width: 1.0, color: Colors.black12),
              borderRadius: BorderRadius.circular(10.0)),
          child: Stack(
            children: [
              Center(
                child: isloading
                    ? CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        inCart
                            ? translate("GO_TO_CART")
                            : translate("ADD_TO_CART"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              Positioned(
                right: 0,
                top: 4,
                child: Container(
                  margin: EdgeInsets.all(3.0),
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.00),
                  ),
                  child: Image.asset(
                    "assets/icons/addtocart.png",
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buyNowButton(bool inCart) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          setState(() {
            this.buynowLoading = true;
          });
          if (!inCart) {
            bool success =
                await crt.addtocart(widget.courseId.toString(), context);
            if (success) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyBottomNavigationBar(
                    pageInd: 3,
                  ),
                ),
              );
            } else {
              Fluttertoast.showToast(
                msg: translate("Go_to_Cart_Section"),
                backgroundColor: Colors.red,
                textColor: Colors.white,
                toastLength: Toast.LENGTH_LONG,
              );

              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text(
              //       translate("Go_to_Cart_Section"),
              //     ),
              //   ),
              // );
            }
          } else
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyBottomNavigationBar(
                          pageInd: 3,
                        )));
          setState(() {
            this.buynowLoading = false;
          });
        },
        child: Container(
          height: 55,
          width: MediaQuery.of(context).size.width - 50,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black12),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              Center(
                child: buynowLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      )
                    : Text(
                        translate("BUY_NOW"),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              Positioned(
                right: 0,
                top: 4,
                child: Container(
                  margin: EdgeInsets.all(3.0),
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.00),
                  ),
                  child: Image.asset(
                    "assets/icons/buynow.png",
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget addandBuyBody(bool inCart) {
    return Container(
      child: Column(
        children: [
          CustomPaint(
            painter: TrianglePainter(
              strokeColor: Colors.white,
              strokeWidth: 4,
              paintingStyle: PaintingStyle.fill,
            ),
            child: Container(
              height: 20,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height /
                (MediaQuery.of(context).orientation == Orientation.landscape
                    ? widget.cprice != null
                        ? 1.5
                        : 3.8
                    : widget.cprice != null
                        ? 3.9
                        : 6.8),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            margin: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: widget.cprice != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      addToCart(inCart),
                      SizedBox(
                        height: 5.0,
                      ),
                      buyNowButton(inCart),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        widget.details!.course!.policy!.days == null
                            ? ''
                            : "${widget.details!.course!.policy!.days}-${translate("day_MoneyBack_Guarantee")}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      enrollNowButton(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> enrollInFreeCourse() async {
    Dio dio = new Dio();
    String url = APIData.enrollInFreeCourse + APIData.secretKey;

    var body = FormData.fromMap({
      "course_id": widget.courseId,
    });

    Response? response;
    try {
      response = await dio.post(
        url,
        data: body,
        options: Options(
          method: 'POST',
          headers: {
            HttpHeaders.authorizationHeader: "Bearer " + authToken,
            HttpHeaders.acceptHeader: "Application/json",
          },
        ),
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
      Fluttertoast.showToast(
          msg: translate("Enrolled_Successfully"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
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

  Widget enrollNowButton() {
    return Material(
      color: Color(0xfff44a4a),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          setState(() {
            this.isloading = true;
          });

          await enrollInFreeCourse();

          await Provider.of<CoursesProvider>(context, listen: false)
              .initPurchasedCourses(context);

          setState(() {
            this.isloading = false;
          });

          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          height: 55.0,
          width: MediaQuery.of(context).size.width - 50,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(width: 1.0, color: Colors.black12),
              borderRadius: BorderRadius.circular(10.0)),
          child: Stack(
            children: [
              Center(
                child: isloading
                    ? CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        translate("ENROLL_NOW"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              Positioned(
                right: 0,
                top: 4,
                child: Container(
                  margin: EdgeInsets.all(3.0),
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.00),
                  ),
                  child: Image.asset(
                    "assets/icons/buynow.png",
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  CartApiCall crt = new CartApiCall();
  bool isloading = false;
  bool buynowLoading = false;

  @override
  Widget build(BuildContext context) {
    CartProducts carts = Provider.of<CartProducts>(context);
    bool inCart = carts.inCart(widget.courseId as int);
    return SliverToBoxAdapter(child: addandBuyBody(inCart));
  }
}
