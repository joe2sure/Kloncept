import 'dart:convert';
import 'dart:io';
import 'package:kloncept/provider/payment_api_provider.dart';
import 'package:kloncept/provider/user_profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:flutterwave_standard/models/subaccount.dart';
import 'package:intl/intl.dart';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/provider/home_data_provider.dart';
import 'package:kloncept/screens/bottom_navigation_screen.dart';
import 'package:kloncept/widgets/appbar.dart';
import 'package:kloncept/widgets/success_ticket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RavePayment extends StatefulWidget {
  final int? amount;

  RavePayment({this.amount});

  @override
  _RavePaymentState createState() => _RavePaymentState();
}

class _RavePaymentState extends State<RavePayment> {
  void loadData() async {
    homeDataProvider = Provider.of<HomeDataProvider>(context, listen: false);
    await Provider.of<UserProfile>(context, listen: false).fetchUserProfile();
    setState(() {
      firstName = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .fname.toString();
      lastName = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .lname.toString();
      email = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .email.toString();
      // phone = Provider.of<UserProfile>(context, listen: false)
      //     .profileInstance
      //     .mobile;
      // address = Provider.of<UserProfile>(context, listen: false)
      //     .profileInstance
      //     .address;
      publicKey = Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .allKeys!
          .rAVEPUBLICKEY.toString();
      encryptionKey = Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .allKeys!
          .rAVESECRETKEY.toString();
      currency = "${homeDataProvider.homeModel!.currency!.currency}";
      amount = widget.amount!.toDouble();
      isBack = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  var phone, address;
  var paymentResponse, createdDate, createdTime;
  bool isShowing = true;
  bool isLoading = true;
  bool isBack = false;
  late String selectedUrl;
  double progress = 0;
  late HomeDataProvider homeDataProvider;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var autoValidate = false;
  bool acceptCardPayment = true;
  bool acceptAccountPayment = true;
  bool acceptMpesaPayment = false;
  bool shouldDisplayFee = true;
  bool acceptAchPayments = false;
  bool acceptGhMMPayments = false;
  bool acceptUgMMPayments = false;
  bool acceptMMFrancophonePayments = false;
  bool live = true;
  bool preAuthCharge = false;
  bool addSubAccounts = false;
  List<SubAccount> subAccounts = [];
  late String email;
  late double amount;
  String publicKey = "PASTE PUBLIC KEY HERE";
  String encryptionKey = "PASTE ENCRYPTION KEY HERE";
  String txRef = 'TXREF-${DateTime.now().microsecondsSinceEpoch}';
  String orderRef = 'ORDERREF-${DateTime.now().microsecondsSinceEpoch}';
  late String narration;
  late String currency;
  late String country;
  late String firstName;
  late String lastName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: customAppBar(context, "Rave Payment"),
      body: Center(
        child: !isBack
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      startPayment();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.indigo,
                      child: Text(
                        'Pay Now',
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

  void startPayment() async {
    final Customer customer = Customer(
      name: "$firstName $lastName",
      phoneNumber: phone,
      email: email,
    );

    final Flutterwave flutterwave = Flutterwave(
      context: context,
      publicKey: publicKey,
      currency: currency,
      redirectUrl: "${APIData.confirmation}",
      txRef: txRef,
      amount: amount.toString(),
      customer: customer,
      paymentOptions: "card, payattitude, barter, bank transfer, ussd",
      customization: Customization(title: "Rave Payment"),
      isTestMode: live,
    );
    final ChargeResponse response = await flutterwave.charge();
    if (response.success!) {
      sendPaymentDetails(txRef, "Rave");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text((response.status.toString())),
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
            ));
  }

  goToDialog2() {
    if (isShowing == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
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
              onWillPop: () async => isBack));
    } else {
      Navigator.pop(context);
    }
  }
}
