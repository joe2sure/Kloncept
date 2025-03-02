import 'dart:convert';
import 'dart:io';
import 'package:kloncept/widgets/appbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/provider/home_data_provider.dart';
import 'package:kloncept/screens/bottom_navigation_screen.dart';
import 'package:kloncept/widgets/success_ticket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:upi_india/upi_india.dart';
import '../provider/payment_api_provider.dart';

class UPIPayment extends StatefulWidget {
  final int? amount;

  UPIPayment({this.amount});

  @override
  _UPIPaymentState createState() => _UPIPaymentState();
}

class _UPIPaymentState extends State<UPIPayment> {
  void loadData() async {
    homeDataProvider = Provider.of<HomeDataProvider>(context, listen: false);

    setState(() {
      receiverName = Provider.of<PaymentAPIProvider>(context, listen: false)
          .upiDetailsModel
          .upi!
          .name
          .toString();
      receiverUpiId = Provider.of<PaymentAPIProvider>(context, listen: false)
          .upiDetailsModel
          .upi!
          .upiid
          .toString();
      currency = "${homeDataProvider.homeModel!.currency!.currency}";
      amount = widget.amount.toString();
      orderId = 'UPIPayment-${DateTime.now().microsecondsSinceEpoch}';

      isBack = true;
    });
  }

  var paymentResponse, createdDate, createdTime;
  var currency, amount, orderId;
  bool isShowing = true;
  bool isBack = false;
  double progress = 0;
  late HomeDataProvider homeDataProvider;

  UpiIndia _upiIndia = UpiIndia();
  late List<UpiApp> apps;

  late String receiverUpiId;
  late String receiverName;

  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then(
      (value) {
        setState(
          () {
            apps = value;
          },
        );
      },
    ).catchError(
      (e) {
        apps = [];
      },
    );
    super.initState();
    loadData();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: receiverUpiId,
      receiverName: receiverName,
      transactionRefId: orderId,
      transactionNote: 'Course Purchase',
      amount: double.parse(amount.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "UPI Payment"),
      body: Container(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                UpiResponse upiResponse =
                    await initiateTransaction(apps[index]);
                if (upiResponse.status == UpiPaymentStatus.SUCCESS) {
                  print('-> ${upiResponse.status}');
                  sendPaymentDetails(orderId, "UPI");
                } else
                  print('${upiResponse.status}');
              },
              child: Card(
                elevation: 5.0,
                child: ListTile(
                  leading: Image.memory(apps[index].icon),
                  title: Text(
                    apps[index].name,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: apps.length,
        ),
      ),
    );
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
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  goToDialog2() {
    if (isShowing == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25.0),
              ),
            ),
            backgroundColor: Colors.white,
            title: Text(
              "Saving Payment Info",
              style: TextStyle(
                color: Color(0xFF3F4654),
              ),
            ),
            content: Container(
              height: 70.0,
              width: 150.0,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          onWillPop: () async => isBack,
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
