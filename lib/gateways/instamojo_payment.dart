import 'dart:io';
import 'dart:convert';
import 'package:kloncept/Screens/bottom_navigation_screen.dart';
import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/Widgets/success_ticket.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kloncept/provider/payment_api_provider.dart';
import 'package:kloncept/provider/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../provider/home_data_provider.dart';

class InstamojoPaymentPage extends StatefulWidget {
  InstamojoPaymentPage({this.amount});

  final int? amount;

  @override
  _InstamojoPaymentPageState createState() => _InstamojoPaymentPageState();
}

class _InstamojoPaymentPageState extends State<InstamojoPaymentPage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
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
      instamojoUrl = Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .instamojoUrl;
      instamojoApiKey = Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .instamojoApiKey;
      instamojoAuthToken =
          Provider.of<PaymentAPIProvider>(context, listen: false)
              .paymentApi
              .instamojoAuthToken;
      isBack = true;
    });
    createRequest(); //creating the HTTP request
  }

  var instamojoUrl, instamojoApiKey, instamojoAuthToken;
  var fName, lName, email, phone;
  var paymentResponse, createdDate, createdTime;
  bool isShowing = true;
  bool isLoading = true;
  bool isBack = true;
  String? selectedUrl;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Instamojo Payment"),
      body: Container(
        child: Center(
          child: isLoading
              ? //check loadind status
              CircularProgressIndicator()
              : InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri.uri(Uri.tryParse(selectedUrl!)!),
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {},
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                  onUpdateVisitedHistory: (_, Uri? uri, __) {
                    String url = uri.toString();
                    print(uri);
                    // uri containts newly loaded url
                    if (mounted) {
                      if (url.contains(APIData.confirmation)) {
                        //Take the payment_id parameter of the url.
                        String? paymentRequestId =
                            uri!.queryParameters['payment_id'];
                        print("value is: " + paymentRequestId!);
                        //calling this method to check payment status
                        _checkPaymentStatus(paymentRequestId);
                      }
                    }
                  },
                ),
        ),
      ),
    );
  }

  _checkPaymentStatus(String id) async {
    var response =
        await http.get(Uri.parse(instamojoUrl + "payments/$id/"), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "X-Api-Key": "$instamojoApiKey",
      "X-Auth-Token": "$instamojoAuthToken"
    });
    var realResponse = json.decode(response.body);
    print(realResponse);
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
        print('Successful');
        setState(() {
          isShowing = true;
        });
        sendPaymentDetails(id, "Instamojo");
        //payment is successful.
      } else {
        print('failed');
        //payment failed or pending.
      }
    } else {
      print("INSTAMOJO STATUS FAILED");
    }
  }

  Future createRequest() async {
    Map<String, String> body = {
      "amount": '${widget.amount}',
      "purpose": "Course Purchase",
      "buyer_name": '$fName $lName',
      "email": '$email',
      "phone": phone != null ? '$phone' : '8888888888',
      "allow_repeated_payments": "true",
      "send_email": "false",
      "send_sms": "false",
      "redirect_url":
          APIData.confirmation, //Where to redirect after a successful payment.
      "webhook": APIData.confirmation,
    };
    //First we have to create a Payment_Request.
    //then we'll take the response of our request.
    var resp = await http.post(Uri.parse(instamojoUrl + "payment-requests/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "$instamojoApiKey",
          "X-Auth-Token": "$instamojoAuthToken"
        },
        body: body);
    if (json.decode(resp.body)['success'] == true) {
      //If request is successful take the longurl.
      setState(() {
        isLoading = false; //setting state to false after data loaded

        selectedUrl =
            json.decode(resp.body)["payment_request"]['longurl'].toString() +
                "?embed=form";
      });
      print(json.decode(resp.body)['message'].toString());
      //If something is wrong with the data we provided to
      //create the Payment_Request. For Example, the email is in incorrect format, the payment_Request creation will fail.
    }
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
}
