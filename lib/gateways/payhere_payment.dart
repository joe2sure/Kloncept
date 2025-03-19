import 'dart:convert';
import 'dart:io';
import 'package:kloncept/provider/home_data_provider.dart';
import 'package:kloncept/provider/payment_api_provider.dart';
import 'package:kloncept/provider/user_profile.dart';
import 'package:kloncept/screens/bottom_navigation_screen.dart';
import 'package:kloncept/widgets/appbar.dart';
import 'package:kloncept/widgets/success_ticket.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../common/apidata.dart';
import '../common/global.dart';

class PayHerePayment extends StatefulWidget {
  final int? amount;

  PayHerePayment({this.amount});

  @override
  _PayHerePaymentState createState() => _PayHerePaymentState();
}

class _PayHerePaymentState extends State<PayHerePayment> {
  void showAlert(BuildContext context, String title, String msg) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void startOneTimePayment(BuildContext context) async {
    Map paymentObject = {
      "sandbox": false, // true if using Sandbox Merchant ID
      "merchant_id": "$merchantId", // Replace your Merchant ID
      "merchant_secret": "$merchantSecret",
      "notify_url": "${APIData.confirmation}",
      "order_id": "${DateTime.now().millisecondsSinceEpoch}",
      "items": "Course Purchase",
      "amount": "${widget.amount}",
      "currency": "${homeDataProvider!.homeModel!.currency!.currency}",
      "first_name": "$fName",
      "last_name": "$lName",
      "email": "$email",
      "phone": "$phone",
      "address": "$address",
      "city": "",
      "country": "",
      "delivery_address": "",
      "delivery_city": "",
      "delivery_country": "",
      "custom_1": "",
      "custom_2": ""
    };

    PayHere.startPayment(paymentObject, (paymentId) {
      print("One Time Payment Success. Payment Id: $paymentId");
      setState(() {
        isShowing = true;
      });
      sendPaymentDetails(paymentId, "PayHere");
      showAlert(context, "Payment Success!", "Payment Id: $paymentId");
    }, (error) {
      print("One Time Payment Failed. Error: $error");
      showAlert(context, "Payment Failed", "$error");
    }, () {
      print("One Time Payment Dismissed");
      showAlert(context, "Payment Dismissed", "");
    });
  }

  sendPaymentDetails(transactionId, paymentMethod) async {
    try {
      goToDialog2();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      var sendResponse;

      if (sharedPreferences.containsKey("topUpWallet")) {
        var currency = Provider.of<HomeDataProvider>(context, listen: false)
            .homeModel!
            .currency!
            .currency;
        sendResponse = await http.post(
          Uri.parse("${APIData.walletTopUp}"),
          body: {
            "transaction_id": "$transactionId",
            "payment_method": "$paymentMethod",
            "total_amount": "${widget.amount}",
            "currency": "$currency",
            "detail": "$paymentMethod",
          },
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $authToken",
            "Accept": "Application/json",
          },
        );
        print("Top Up Wallet API Status Code :-> ${sendResponse.statusCode}");
        print("Top Up Wallet API Response :-> ${sendResponse.body}");
        await sharedPreferences.remove("topUpWallet");
      } else if (!sharedPreferences.containsKey("giftUserId")) {
        sendResponse = await http.post(
          Uri.parse("${APIData.payStore}${APIData.secretKey}"),
          body: {
            "transaction_id": "$transactionId",
            "payment_method": "$paymentMethod",
            "pay_status": "1",
            "sale_id": "null",
          },
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $authToken",
            HttpHeaders.acceptHeader: "Application/json",
          },
        );
      } else {
        int? giftUserId = sharedPreferences.getInt("giftUserId");
        int? giftCourseId = sharedPreferences.getInt("giftCourseId");

        sendResponse = await http.post(
          Uri.parse("${APIData.giftCheckout}${APIData.secretKey}"),
          body: {
            "gift_user_id": "$giftUserId",
            "course_id": "$giftCourseId",
            "txn_id": "$transactionId",
            "payment_method": "$paymentMethod",
            "pay_status": "1",
          },
        );
        await sharedPreferences.remove("giftUserId");
        await sharedPreferences.remove("giftCourseId");
      }

      paymentResponse = json.decode(sendResponse.body);
      var date = DateTime.now();
      var time = DateTime.now();
      createdDate = DateFormat('d MMM y').format(date);
      createdTime = DateFormat('HH:mm a').format(time);

      if (sendResponse.statusCode == 200 || sendResponse.statusCode == 201) {
        setState(() {
          isShowing = false;
        });

        goToDialog(createdDate, createdTime);
      } else {
        setState(() {
          isShowing = false;
        });

        Fluttertoast.showToast(msg: "Your transaction failed.");
      }
    } catch (error) {}
  }

  goToDialog(subdate, time) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => new GestureDetector(
              child: Container(
                color: Colors.white.withOpacity(0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SuccessTicket(
                      msgResponse: "Your transaction successful",
                      purchaseDate: subdate,
                      time: time,
                      transactionAmount: widget.amount,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyBottomNavigationBar(
                                      pageInd: 0,
                                    )));
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  goToDialog2() {
    if (isShowing == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => PopScope(
                canPop: isBack,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  backgroundColor: Colors.white,
                  title: Text(
                    "Saving Payment Info",
                    style: TextStyle(color: Color(0xFF3F4654)),
                  ),
                  content: Container(
                    height: 70.0,
                    width: 150.0,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ));
    } else {
      Navigator.pop(context);
    }
  }

  var merchantId, merchantSecret;
  var fName, lName, email, phone, address;
  var paymentResponse, createdDate, createdTime;
  bool isShowing = true;
  bool isLoading = true;
  bool isBack = false;
  String? selectedUrl;
  double progress = 0;
  HomeDataProvider? homeDataProvider;

  void loadData() async {
    homeDataProvider = Provider.of<HomeDataProvider>(context, listen: false);
    await Provider.of<UserProfile>(context, listen: false).fetchUserProfile();
    setState(() {
      fName = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .fname;
      lName = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .lname;
      email = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .email;
      // phone = Provider.of<UserProfile>(context, listen: false)
      //     .profileInstance
      //     .mobile;
      // address = Provider.of<UserProfile>(context, listen: false)
      //     .profileInstance
      //     .address;
      merchantId = Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .allKeys!
          .pAYHEREMERCHANTID;
      merchantSecret = Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .allKeys!
          .pAYHEREAPPSECRET;
      isBack = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "PayHere Payment"),
      body: Center(
        child: !isBack
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      startOneTimePayment(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.indigo,
                      child: Text(
                        'Start One Time Payment!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
