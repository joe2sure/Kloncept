// import 'dart:convert';
// import 'dart:io';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:cashfree_pg/cashfree_pg.dart';
// import 'package:eclass/provider/home_data_provider.dart';
// import 'package:eclass/provider/payment_api_provider.dart';
// import 'package:eclass/provider/user_profile.dart';
// import 'package:eclass/screens/bottom_navigation_screen.dart';
// import 'package:eclass/widgets/appbar.dart';
// import 'package:eclass/widgets/success_ticket.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../common/apidata.dart';
// import '../common/global.dart';

// class CashfreePayment extends StatefulWidget {
//   final int? amount;

//   const CashfreePayment({this.amount});

//   @override
//   _CashfreePaymentState createState() => _CashfreePaymentState();
// }

// class _CashfreePaymentState extends State<CashfreePayment> {
//   var _selectedApp;

//   void loadData() async {
//     homeDataProvider = Provider.of<HomeDataProvider>(context, listen: false);
//     await Provider.of<UserProfile>(context, listen: false).fetchUserProfile();
//     setState(() {
//       fName = Provider.of<UserProfile>(context, listen: false)
//           .profileInstance
//           .fname;
//       lName = Provider.of<UserProfile>(context, listen: false)
//           .profileInstance
//           .lname;
//       email = Provider.of<UserProfile>(context, listen: false)
//           .profileInstance
//           .email;
//       phone = Provider.of<UserProfile>(context, listen: false)
//           .profileInstance
//           .mobile;
//       address = Provider.of<UserProfile>(context, listen: false)
//           .profileInstance
//           .address;
//       cashfreeAppID = Provider.of<PaymentAPIProvider>(context, listen: false)
//           .paymentApi
//           .allKeys!
//           .cASHFREEAPPID;
//       cashfreeSecretKey =
//           Provider.of<PaymentAPIProvider>(context, listen: false)
//               .paymentApi
//               .allKeys!
//               .cASHFREESECRETKEY;

//       customerName = "$fName $lName";
//       customerPhone = "$phone";
//       customerEmail = "$email";
//       appId = "$cashfreeAppID";
//       orderCurrency = "${homeDataProvider!.homeModel!.currency!.currency}";
//       orderAmount = widget.amount.toString();
//       orderId = 'CASHFREE-${DateTime.now().microsecondsSinceEpoch}';

//       generateToken();

//       isBack = true;
//     });
//   }

//   var fName, lName, email, phone, address;
//   var paymentResponse, createdDate, createdTime;
//   var cashfreeAppID, cashfreeSecretKey;
//   bool isShowing = true;
//   bool isLoading = true;
//   bool isBack = false;
//   String? selectedUrl;
//   double progress = 0;
//   HomeDataProvider? homeDataProvider;
//   bool generatingToken = true;

//   Future<void> generateToken() async {
//     print(
//         'CashFree App ID :-> $cashfreeAppID, \nCashFree Secret Key :-> $cashfreeSecretKey');

//     var response = await http.post(
//       Uri.parse(
//           "https://test.cashfree.com/api/v2/cftoken/order"), // User api.cashfree.com for production
//       headers: {
//         "x-client-id": "$cashfreeAppID",
//         "x-client-secret": "$cashfreeSecretKey"
//       },
//       body: jsonEncode({
//         "orderId": "$orderId",
//         "orderAmount": "$orderAmount",
//         "orderCurrency": "$orderCurrency"
//       }),
//     );
//     print('Cashfree Status Code : ${response.statusCode}');
//     print('Cashfree Response : ${response.body}');
//     if (response.statusCode == 200) {
//       var jsonResponse = json.decode(response.body);
//       print('Cashfree Response : $jsonResponse');
//       if (jsonResponse['status'] == 'OK') {
//         tokenData = jsonResponse['cftoken'];
//         setState(() {
//           generatingToken = false;
//         });
//       } else {
//         print("CASHFREE STATUS FAILED");
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   var scaffoldKey = GlobalKey<ScaffoldState>();

//   //Replace with actual values
//   String? orderId;
//   String stage = "PROD"; // TEST or PROD
//   String? orderAmount;
//   String tokenData = "TOKEN_DATA"; // Generated Token.
//   String? customerName;
//   String orderNote =
//       "Order_Note"; // A help text to make customers know more about the order.
//   String? orderCurrency;
//   String? appId;
//   String? customerPhone;
//   String? customerEmail;
//   String notifyUrl = "https://test.gocashfree.com/notify";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: customAppBar(context, "Cashfree Payment"),
//       body: generatingToken
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : Column(
//               children: [
//                 Center(
//                   child: ElevatedButton(
//                     child: Text('WEB CHECKOUT'),
//                     onPressed: () => makePayment(),
//                   ),
//                 ),
//                 Center(
//                   child: ElevatedButton(
//                     child: Text('SEAMLESS PAYPAL'),
//                     onPressed: () => seamlessPayPalPayment(),
//                   ),
//                 ),
//                 Center(
//                   child: ElevatedButton(
//                     child: Text('UPI INTENT'),
//                     onPressed: () => makeUpiPayment(),
//                   ),
//                 ),
//                 Center(
//                   child: ElevatedButton(
//                     child: Text('GET INSTALLED UPI APPS'),
//                     onPressed: () => getUPIApps(),
//                   ),
//                 ),
//                 Center(
//                   child: ElevatedButton(
//                     child: Text('SEAMLESS UPI INTENT'),
//                     onPressed: () => seamlessUPIIntent(),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   void getUPIApps() {
//     CashfreePGSDK.getUPIApps().then((value) => {
//           if (value != null && value.length > 0) {_selectedApp = value[0]}
//         });
//   }

//   // WEB Intent -
//   makePayment() {
//     Map<String, dynamic> inputParams = {
//       "orderId": orderId,
//       "orderAmount": orderAmount,
//       "customerName": customerName,
//       "orderNote": orderNote,
//       "orderCurrency": orderCurrency,
//       "appId": appId,
//       "customerPhone": customerPhone,
//       "customerEmail": customerEmail,
//       "stage": stage,
//       "tokenData": tokenData,
//       "notifyUrl": notifyUrl
//     };

//     CashfreePGSDK.doPayment(inputParams).then(
//       (value) => value?.forEach(
//         (key, value) {
//           print("$key : $value");
//           //Do something with the result
//           if ('$key' == 'txStatus') {
//             if ('$value' == 'SUCCESS') {
//               setState(() {
//                 isShowing = true;
//               });
//               sendPaymentDetails(orderId, "Cashfree");
//             } else {
//               Fluttertoast.showToast(
//                   msg: "Your transaction ${value.toString().toLowerCase()}.");
//             }
//           }
//         },
//       ),
//     );
//   }

//   // SEAMLESS - Paypal -
//   Future<void> seamlessPayPalPayment() async {
//     Map<String, dynamic> inputParams = {
//       "orderId": orderId,
//       "orderAmount": orderAmount,
//       "customerName": customerName,
//       "orderNote": orderNote,
//       "orderCurrency": orderCurrency,
//       "appId": appId,
//       "customerPhone": customerPhone,
//       "customerEmail": customerEmail,
//       "stage": stage,
//       "tokenData": tokenData,
//       "notifyUrl": notifyUrl,

//       // EXTRA THINGS THAT NEEDS TO BE ADDED
//       "paymentOption": "paypal"
//     };

//     CashfreePGSDK.doPayment(inputParams).then(
//       (value) => value?.forEach(
//         (key, value) {
//           print("$key : $value");
//           //Do something with the result
//           if ('$key' == 'txStatus') {
//             if ('$value' == 'SUCCESS') {
//               setState(() {
//                 isShowing = true;
//               });
//               sendPaymentDetails(orderId, "Cashfree");
//             } else {
//               Fluttertoast.showToast(
//                   msg: "Your transaction ${value.toString().toLowerCase()}.");
//             }
//           }
//         },
//       ),
//     );
//   }

//   // UPI Intent -
//   Future<void> makeUpiPayment() async {
//     Map<String, dynamic> inputParams = {
//       "orderId": orderId,
//       "orderAmount": orderAmount,
//       "customerName": customerName,
//       "orderNote": orderNote,
//       "orderCurrency": orderCurrency,
//       "appId": appId,
//       "customerPhone": customerPhone,
//       "customerEmail": customerEmail,
//       "stage": stage,
//       "tokenData": tokenData,
//       "notifyUrl": notifyUrl
//     };

//     CashfreePGSDK.doUPIPayment(inputParams).then(
//       (value) => value?.forEach(
//         (key, value) {
//           print("$key : $value");
//           //Do something with the result
//           if ('$key' == 'txStatus') {
//             if ('$value' == 'SUCCESS') {
//               setState(() {
//                 isShowing = true;
//               });
//               sendPaymentDetails(orderId, "Cashfree");
//             } else {
//               Fluttertoast.showToast(
//                   msg: "Your transaction ${value.toString().toLowerCase()}.");
//             }
//           }
//         },
//       ),
//     );
//   }

//   // SEAMLESS UPI Intent -
//   Future<void> seamlessUPIIntent() async {
//     Map<String, dynamic> inputParams = {
//       "orderId": orderId,
//       "orderAmount": orderAmount,
//       "customerName": customerName,
//       "orderNote": orderNote,
//       "orderCurrency": orderCurrency,
//       "appId": appId,
//       "customerPhone": customerPhone,
//       "customerEmail": customerEmail,
//       "stage": stage,
//       "tokenData": tokenData,
//       "notifyUrl": notifyUrl,

//       // For seamless UPI Intent
//       "appName": _selectedApp["id"]
//     };

//     CashfreePGSDK.doUPIPayment(inputParams).then(
//       (value) => value?.forEach(
//         (key, value) {
//           print("$key : $value");
//           //Do something with the result
//           if ('$key' == 'txStatus') {
//             if ('$value' == 'SUCCESS') {
//               setState(() {
//                 isShowing = true;
//               });
//               sendPaymentDetails(orderId, "Cashfree");
//             } else {
//               Fluttertoast.showToast(
//                   msg: "Your transaction ${value.toString().toLowerCase()}.");
//             }
//           }
//         },
//       ),
//     );
//   }

//   sendPaymentDetails(transactionId, paymentMethod) async {
//     try {
//       goToDialog2();
//       SharedPreferences sharedPreferences =
//           await SharedPreferences.getInstance();

//       var sendResponse;

//       if (sharedPreferences.containsKey("topUpWallet")) {
//         var currency = Provider.of<HomeDataProvider>(context, listen: false)
//             .homeModel!
//             .currency!
//             .currency;
//         sendResponse = await http.post(
//           Uri.parse("${APIData.walletTopUp}"),
//           body: {
//             "transaction_id": "$transactionId",
//             "payment_method": "$paymentMethod",
//             "total_amount": "${widget.amount}",
//             "currency": "$currency",
//             "detail": "$paymentMethod",
//           },
//           headers: {
//             HttpHeaders.authorizationHeader: "Bearer $authToken",
//             "Accept": "Application/json",
//           },
//         );
//         print("Top Up Wallet API Status Code :-> ${sendResponse.statusCode}");
//         print("Top Up Wallet API Response :-> ${sendResponse.body}");
//         await sharedPreferences.remove("topUpWallet");
//       } else if (!sharedPreferences.containsKey("giftUserId")) {
//         sendResponse = await http.post(
//           Uri.parse("${APIData.payStore}${APIData.secretKey}"),
//           body: {
//             "transaction_id": "$transactionId",
//             "payment_method": "$paymentMethod",
//             "pay_status": "1",
//             "sale_id": "null",
//           },
//           headers: {
//             HttpHeaders.authorizationHeader: "Bearer $authToken",
//             HttpHeaders.acceptHeader: "Application/json",
//           },
//         );
//       } else {
//         int? giftUserId = sharedPreferences.getInt("giftUserId");
//         int? giftCourseId = sharedPreferences.getInt("giftCourseId");

//         sendResponse = await http.post(
//           Uri.parse("${APIData.giftCheckout}${APIData.secretKey}"),
//           body: {
//             "gift_user_id": "$giftUserId",
//             "course_id": "$giftCourseId",
//             "txn_id": "$transactionId",
//             "payment_method": "$paymentMethod",
//             "pay_status": "1",
//           },
//         );
//         await sharedPreferences.remove("giftUserId");
//         await sharedPreferences.remove("giftCourseId");
//       }

//       paymentResponse = json.decode(sendResponse.body);
//       var date = DateTime.now();
//       var time = DateTime.now();
//       createdDate = DateFormat('d MMM y').format(date);
//       createdTime = DateFormat('HH:mm a').format(time);

//       if (sendResponse.statusCode == 200 || sendResponse.statusCode == 201) {
//         setState(() {
//           isShowing = false;
//         });
//         goToDialog(createdDate, createdTime);
//       } else {
//         setState(() {
//           isShowing = false;
//         });
//         Fluttertoast.showToast(msg: "Your transaction failed.");
//       }
//     } catch (error) {}
//   }

//   goToDialog(subdate, time) {
//     showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (context) => new GestureDetector(
//               child: Container(
//                 color: Colors.white.withOpacity(0.05),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     SuccessTicket(
//                       msgResponse: "Your transaction successful",
//                       purchaseDate: subdate,
//                       time: time,
//                       transactionAmount: widget.amount,
//                     ),
//                     SizedBox(
//                       height: 10.0,
//                     ),
//                     FloatingActionButton(
//                       backgroundColor: Colors.white,
//                       child: Icon(
//                         Icons.clear,
//                         color: Colors.black,
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => MyBottomNavigationBar(
//                                       pageInd: 0,
//                                     )));
//                       },
//                     )
//                   ],
//                 ),
//               ),
//             ));
//   }

//   goToDialog2() {
//     if (isShowing == true) {
//       showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) => PopScope(
//                 canPop: isBack,
//                 child: AlertDialog(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(25.0))),
//                   backgroundColor: Colors.white,
//                   title: Text(
//                     "Saving Payment Info",
//                     style: TextStyle(color: Color(0xFF3F4654)),
//                   ),
//                   content: Container(
//                     height: 70.0,
//                     width: 150.0,
//                     child: Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   ),
//                 ),
//               ));
//     } else {
//       Navigator.pop(context);
//     }
//   }
// }
