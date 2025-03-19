import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/provider/home_data_provider.dart';
import 'package:kloncept/provider/payment_api_provider.dart';
import 'package:kloncept/provider/user_profile.dart';
import 'package:kloncept/screens/bottom_navigation_screen.dart';
import 'package:kloncept/widgets/success_ticket.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PayUPayment extends StatefulWidget {
  final int? amount;

  PayUPayment({this.amount});

  @override
  _PayUPaymentState createState() => _PayUPaymentState();
}

class _PayUPaymentState extends State<PayUPayment>
    implements PayUCheckoutProProtocol {
  var merchantId, merchantKey, salt, transactionId, currency;
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
          .pAYUMERCHANTKEY;
      merchantKey = Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .allKeys!
          .pAYUMERCHANTKEY;
      salt = Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .allKeys!
          .pAYUMERCHANTSALT;
      currency = "${homeDataProvider?.homeModel!.currency!.currency}";
      transactionId = 'PAYU-${DateTime.now().microsecondsSinceEpoch}';
      isBack = true;
    });
  }

  // late PayUWebCheckout _payUWebCheckout;
  late PayUCheckoutProFlutter _checkoutPro;

  late Map<dynamic, dynamic>? response;

  @override
  void initState() {
    // _payUWebCheckout = PayUWebCheckout();
    _checkoutPro = PayUCheckoutProFlutter(this);
    super.initState();
    loadData();

    // _payUWebCheckout.on(
    //     PayUWebCheckout.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _payUWebCheckout.on(
    //     PayUWebCheckout.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void _handlePaymentSuccess(Map<String, dynamic> response) {
    log("PayU Payment Response -> $response");
    sendPaymentDetails(transactionId, "PayU");
    setState(() {
      this.response = response;
    });
  }

  void _handlePaymentError(Map<String, dynamic> response) {
    log("PayU Payment Response -> $response");
    setState(() {
      this.response = response;
    });
  }

  @override
  generateHash(Map response) {
    // Backend will generate the hash which you need to pass to SDK
    // hashResponse: is the response which you get from your server

    Map hashResponse = {};

    //Keep the salt and hash calculation logic in the backend for security reasons. Don't use local hash logic.
    //Uncomment following line to test the test hash.
    // hashResponse = HashService.generateHash(response);

    _checkoutPro.hashGenerated(hash: hashResponse);
  }

  // void pay() {
  //   _payUWebCheckout.doPayment(
  //     context: context,
  //     payuWebCheckoutModel: PayuWebCheckoutModel(
  //       key: merchantKey,
  //       salt: salt,
  //       txnId: transactionId,
  //       phone: phone,
  //       amount: widget.amount.toString(),
  //       productName: "Course",
  //       firstName: fName,
  //       email: email,
  //       udf1: "udf1",
  //       udf2: "udf2",
  //       udf3: "udf3",
  //       udf4: "",
  //       udf5: "",
  //       successUrl: "${APIData.confirmation}",
  //       failedUrl: "https://www.payumoney.com/mobileapp/payumoney/failure.php",
  //       baseUrl:
  //           "https://secure.payu.in", // For Test, use - https://test.payu.in
  //     ),
  //   );
  // }

  @override
  void dispose() {
    // _payUWebCheckout.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayU Money Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            _checkoutPro.openCheckoutScreen(
              payUPaymentParams: PayUParams.createPayUPaymentParams(
                  merchantKey,
                  transactionId,
                  "${APIData.confirmation}",
                  "https://www.payumoney.com/mobileapp/payumoney/failure.php",
                  widget.amount.toString(),
                  phone,
                  email,
                  fName,
                  "Course",
                  1), //0 => Production 1 => Test
              payUCheckoutProConfig: PayUParams.createPayUConfigParams(),
            );
          },
          child: Text(
            "Pay",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
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

  showAlertDialog(BuildContext context, String title, String content) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new Text(content),
            ),
            actions: [okButton],
          );
        });
  }

  @override
  onPaymentSuccess(dynamic response) {
    showAlertDialog(context, "onPaymentSuccess", response.toString());
    log("PayU Payment Response -> $response");
    sendPaymentDetails(transactionId, "PayU");
    setState(() {
      this.response = response;
    });
  }

  @override
  onPaymentFailure(dynamic response) {
    showAlertDialog(context, "onPaymentFailure", response.toString());
  }

  @override
  onPaymentCancel(Map? response) {
    showAlertDialog(context, "onPaymentCancel", response.toString());
  }

  @override
  onError(Map? response) {
    showAlertDialog(context, "onError", response.toString());
    log("PayU Payment Response -> $response");
    setState(() {
      this.response = response;
    });
  }
}

//Pass these values from your app to SDK, this data is only for test purpose
class PayUParams {
  static Map createPayUPaymentParams(merchantKey, transactionId, sUrl, fUrl,
      amount, phone, email, fName, productInfo, isProduction) {
    var additionalParam = {
      PayUAdditionalParamKeys.udf1: "udf1",
      PayUAdditionalParamKeys.udf2: "udf2",
      PayUAdditionalParamKeys.udf3: "udf3",
      PayUAdditionalParamKeys.udf4: "",
      PayUAdditionalParamKeys.udf5: "",
      // PayUAdditionalParamKeys.merchantAccessKey:
      //     PayUTestCredentials.merchantAccessKey,
      // PayUAdditionalParamKeys.sourceId:PayUTestCredentials.sodexoSourceId,
    };

    var payUPaymentParams = {
      PayUPaymentParamKey.key: merchantKey,
      PayUPaymentParamKey.amount: amount,
      PayUPaymentParamKey.productInfo: productInfo,
      PayUPaymentParamKey.firstName: fName,
      PayUPaymentParamKey.email: email,
      PayUPaymentParamKey.phone: phone,
      PayUPaymentParamKey.ios_surl: sUrl,
      PayUPaymentParamKey.ios_furl: fUrl,
      PayUPaymentParamKey.android_surl: sUrl,
      PayUPaymentParamKey.android_furl: fUrl,
      PayUPaymentParamKey.environment: isProduction, //0 => Production 1 => Test

      PayUPaymentParamKey.userCredential:
          null, //Pass user credential to fetch saved cards => A:B - Optional
      PayUPaymentParamKey.transactionId:
          transactionId, //DateTime.now().millisecondsSinceEpoch.toString()
      PayUPaymentParamKey.additionalParam: additionalParam,
      PayUPaymentParamKey.enableNativeOTP: true,
      // PayUPaymentParamKey.splitPaymentDetails:json.encode(spitPaymentDetails),
      PayUPaymentParamKey.userToken:
          "", //Pass a unique token to fetch offers. - Optional
    };

    return payUPaymentParams;
  }

  static Map createPayUConfigParams() {
    var paymentModesOrder = [
      {"Wallets": "PHONEPE"},
      {"UPI": "TEZ"},
      {"Wallets": ""},
      {"EMI": ""},
      {"NetBanking": ""},
    ];

    // var cartDetails = [
    //   {"GST": "5%"},
    //   {"Delivery Date": "25 Dec"},
    //   {"Status": "In Progress"}
    // ];

    // var enforcePaymentList = [
    //   {"payment_type": "CARD", "enforce_ibiboCode": "UTIBENCC"},
    // ];

    // var customNotes = [
    //   {
    //     "custom_note": "Its Common custom note for testing purpose",
    //     "custom_note_category": [
    //       PayUPaymentTypeKeys.emi,
    //       PayUPaymentTypeKeys.card
    //     ]
    //   },
    //   {
    //     "custom_note": "Payment options custom note",
    //     "custom_note_category": null
    //   }
    // ];

    var payUCheckoutProConfig = {
      PayUCheckoutProConfigKeys.primaryColor: "#4994EC",
      PayUCheckoutProConfigKeys.secondaryColor: "#FFFFFF",
      PayUCheckoutProConfigKeys.merchantName: "PayU",
      PayUCheckoutProConfigKeys.merchantLogo: "logo",
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
      // PayUCheckoutProConfigKeys.cartDetails: cartDetails,
      PayUCheckoutProConfigKeys.paymentModesOrder: paymentModesOrder,
      PayUCheckoutProConfigKeys.merchantResponseTimeout: 30000,
      // PayUCheckoutProConfigKeys.customNotes: customNotes,
      PayUCheckoutProConfigKeys.autoSelectOtp: true,
      // PayUCheckoutProConfigKeys.enforcePaymentList: enforcePaymentList,
      PayUCheckoutProConfigKeys.waitingTime: 30000,
      PayUCheckoutProConfigKeys.autoApprove: true,
      PayUCheckoutProConfigKeys.merchantSMSPermission: true,
      PayUCheckoutProConfigKeys.showCbToolbar: true,
    };
    return payUCheckoutProConfig;
  }
}
