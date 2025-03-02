import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:kloncept/Widgets/credit_card_widget.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/bottom_navigation_screen.dart';
import '../Widgets/paystack_paynow_button.dart';
import '../Widgets/success_ticket.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../provider/home_data_provider.dart';
import '../provider/payment_api_provider.dart';
import '../provider/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Widgets/appbar.dart';

String backendUrl = 'https://wilbur-paystack.herokuapp.com';

class PayStackPage extends StatefulWidget {
  final int? amount;
  final String? currency;
  PayStackPage({@required this.amount, @required this.currency});

  @override
  _PayStackPageState createState() => _PayStackPageState();
}

class _PayStackPageState extends State<PayStackPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  int _radioValue = 0;
  bool _inProgress = false;
  String? _cardNumber;
  String? _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;
  var amountInNGN;
  var amountInUSD;
  var ref;
  var paystackPaymentResponse;
  var paystackSubscriptionResponse;
  var msgResponse;
  String createdDatePaystack = '';
  String createdTimePaystack = '';
  bool isBack = true;
  bool isShowing = false;
  var payableAmount;
  final plugin = PaystackPlugin();

  sendPayStackDetailsToServer(transactionId, paymentMethod) async {
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

      paystackPaymentResponse = json.decode(sendResponse.body);
      var date = DateTime.now();
      var time = DateTime.now();
      createdDatePaystack = DateFormat('d MMM y').format(date);
      createdTimePaystack = DateFormat('HH:mm a').format(time);

      if (sendResponse.statusCode == 200) {
        setState(() {
          isShowing = false;
        });

        goToDialog(createdDatePaystack, createdTimePaystack);
      } else {
        setState(() {
          isShowing = false;
        });

        Fluttertoast.showToast(msg: "Your transaction failed.");
      }
    } catch (error) {}
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
          onWillPop: () async => isBack,
        ),
      );
    }
  }

  /*
  After creating successful payment and saving details to server successfully.
  Create a successful dialog
*/
  goToDialog(purDate, time) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => new GestureDetector(
        child: Container(
          color: Colors.black.withOpacity(0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SuccessTicket(
                msgResponse: "Your transaction was successful.",
                transactionAmount: widget.amount,
                purchaseDate: purDate,
                time: time,
              ),
              SizedBox(
                height: 10.0,
              ),
              FloatingActionButton(
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  var router = new MaterialPageRoute(
                    builder: (BuildContext context) => MyBottomNavigationBar(
                      pageInd: 0,
                    ),
                  );
                  Navigator.of(context).push(router);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var payment = Provider.of<PaymentAPIProvider>(context, listen: false);
      if (payment.paymentApi.paystackPublicKey!.isNotEmpty &&
          payment.paymentApi.paystackPublicKey != null) {
        // plugin.initialize(publicKey: payment.paymentApi.paystackPublicKey.toString());
      } else {
        Fluttertoast.showToast(
          msg: "Paystack Payment Public Key is not available.",
          backgroundColor: Colors.red,
        );
      }
      setState(() {
        isBack = true;
      });
      setState(() {
        isShowing = false;
      });
    });
  }

//  Scaffold body contains form to fill card details
  Widget cardDetailsForm(payment, userDetails) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              // UI design for entering card details
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: new TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _cardNumberController,
                  decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Card Number',
                  ),
                  onSaved: (String? value) => _cardNumber = value,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: new TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'CVV',
                  ),
                  onSaved: (String? value) => _cvv = value,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Expiry Month',
                  ),
                  onSaved: (String? value) =>
                      _expiryMonth = int.tryParse(value!)!,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Expiry Year',
                  ),
                  onSaved: (String? value) =>
                      _expiryYear = int.tryParse(value!)!,
                ),
              ),

              _verticalSizeBox,
              _inProgress
                  ? new Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Platform.isIOS
                          ? new CupertinoActivityIndicator()
                          : new CircularProgressIndicator(),
                    )
                  : new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            _horizontalSizeBox,
                            new Flexible(
                              flex: 2,
                              child: new Container(
                                width: double.infinity,
                                child: PayStackPlatformButton(
                                  'Pay Now',
                                  () => _handleCheckout(payment, userDetails),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

//  Build method
  @override
  Widget build(BuildContext context) {
    payableAmount = widget.amount;
    var payment = Provider.of<PaymentAPIProvider>(context);
    var userDetails = Provider.of<UserProfile>(context);

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Color(0xFFF1F3F8),
        appBar: customAppBar(context, "Paystack Payment"),
        key: _scaffoldKey,
        body: cardDetailsForm(payment, userDetails),
      ),
      onWillPop: () async => isBack,
    );
  }

//   This will handle all checkout process after tapping on Pay Now button
  _handleCheckout(payment, userDetails) async {
    if (payment.paymentApi.paystackPublicKey.isNotEmpty &&
        payment.paymentApi.paystackPublicKey != null) {
      setState(() {
        isBack = false;
        _inProgress = true;
      });
      _formKey.currentState!.save();
      Charge charge = Charge()
        ..amount = widget.amount! * 100
        ..email = "${userDetails.profileInstance.email}"
        ..currency = widget.currency
        ..card = _getCardFromUI();

      if (!_isLocal()) {
        var accessCode = await _fetchAccessCodeFrmServer(_getReference());
        charge.accessCode = accessCode;
      } else {
        charge.reference = _getReference();
      }

      CheckoutResponse response = await plugin.checkout(context,
          method: CheckoutMethod.card, charge: charge, fullscreen: false);
      ref = response.reference;
      if (response.message == 'Success') {
        setState(() {
          isShowing = true;
        });
        await sendPayStackDetailsToServer(ref, "Paystack");
      }
      setState(() {
        isBack = true;
        _inProgress = false;
      });

      // _updateStatus(response.reference.toString(), '$response');
    } else {
      Fluttertoast.showToast(
        msg: "Paystack Payment Public Key is not available.",
        backgroundColor: Colors.red,
      );
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );
  }

  Future<String?> _fetchAccessCodeFrmServer(String reference) async {
    String url = '$backendUrl/new-access-code';
    String? accessCode;
    try {
      http.Response response = await http.get(Uri.parse(url));
      accessCode = response.body;
    } catch (e) {
      setState(() => _inProgress = false);
      _updateStatus(
          reference,
          'There was a problem getting a new access code form'
          ' the backend: $e');
    }

    return accessCode;
  }

  _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n\ Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {}

  bool _isLocal() {
    return _radioValue == 0;
  }
}
