// File: lib/screens/payment_gateway.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kloncept/provider/dummy/dummy_payment_provider.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_translate/flutter_translate.dart';

// Import the dummy providers and models

import 'package:kloncept/model/payment_gateway_model.dart';
import 'package:kloncept/Widgets/utils.dart';

// Import dummy versions of payment gateways
// These would typically be actual payment gateway implementations


class PaymentGateway extends StatefulWidget {
  final int? tAmount;
  final dynamic disCountedAmount;

  PaymentGateway(this.tAmount, this.disCountedAmount);

  @override
  _PaymentGatewayState createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  int? value;
  int? id;
  var payAbleAmount;
  List<RealPaymentGatewayModel> listPayment = [];
  var loading = true;

  Widget bottomFixed(payment, user) {
    var homeData = Provider.of<DummyEnhancedHomeDataProvider>(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Color(0x1c2464).withOpacity(0.30),
            blurRadius: 15.0,
            offset: Offset(0.0, -20.5),
            spreadRadius: -15.0)
      ]),
      child: InkWell(
        child: Material(
          color: Colors.transparent,
          child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(18.0),
              padding: EdgeInsets.all(10.0),
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Color(0xFFF44A4A),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6E1A52),
                      Color(0xFFF44A4A),
                    ]),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${translate("Amount_")}:  ${payAbleAmount.toString()}",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                  Text(
                    "${translate("Continue_to_payment")} >>",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ],
              )),
        ),
        onTap: () {
          // Handle different payment gateway selections
          if (id == 1) {
            // Stripe
            Fluttertoast.showToast(msg: "Selected Stripe Payment: \$${payAbleAmount}");
          } else if (id == 2) {
            // PayPal
            onPayWithPayPal(homeData, user);
          } else if (id == 3) {
            // PayStack
            if ("${homeData.homeModel.currency!.currency}" == "NGN" ||
                "${homeData.homeModel.currency!.currency}" == "GHS" ||
                "${homeData.homeModel.currency!.currency}" == "USD" ||
                "${homeData.homeModel.currency!.currency}" == "ZAR") {
              Fluttertoast.showToast(msg: "Selected PayStack Payment: \$${payAbleAmount}");
            } else {
              Fluttertoast.showToast(
                  msg: translate("Supports_only_NGN_GHS_USD_&_ZAR_currency"));
            }
          } else if (id == 4) {
            // Paytm
            Fluttertoast.showToast(msg: "Selected Paytm Payment: \$${payAbleAmount}");
          } else if (id == 5) {
            // RazorPay
            Fluttertoast.showToast(msg: "Selected RazorPay Payment: \$${payAbleAmount}");
          } else if (id == 6) {
            // Instamojo
            Fluttertoast.showToast(msg: "Selected Instamojo Payment: \$${payAbleAmount}");
          } else if (id == 7) {
            // PayHere
            Fluttertoast.showToast(msg: "Selected PayHere Payment: \$${payAbleAmount}");
          } else if (id == 71) {
            // Rave
            Fluttertoast.showToast(msg: "Selected Rave Payment: \$${payAbleAmount}");
          } else if (id == 72) {
            // PayU
            Fluttertoast.showToast(msg: "Selected PayU Payment: \$${payAbleAmount}");
          } else if (id == 73) {
            // Cashfree
            Fluttertoast.showToast(msg: "Selected Cashfree Payment: \$${payAbleAmount}");
          } else if (id == 74) {
            // UPI
            Fluttertoast.showToast(msg: "Selected UPI Payment: \$${payAbleAmount}");
          } else if (id == 8) {
            // Bank Transfer
            Fluttertoast.showToast(msg: "Selected Bank Transfer: \$${payAbleAmount}");
          } else if (id == 9) {
            // Manual Payment
            Fluttertoast.showToast(msg: "Selected Manual Payment: \$${payAbleAmount}");
          } else if (id == 10) {
            // Wallet
            Fluttertoast.showToast(msg: "Selected Wallet Payment: \$${payAbleAmount}");
          } else {
            Fluttertoast.showToast(
                msg: translate("Please_select_payment_gateway"));
          }
        },
      ),
    );
  }

  void onPayWithPayPal(homeData, user) {
    var currency = homeData.homeModel.currency!.currency;
    Fluttertoast.showToast(
      msg: "PayPal Payment: \$${payAbleAmount} - ${user.profileInstance.firstName} ${user.profileInstance.lastName}",
    );
  }

  DummyManualPaymentProvider manualPaymentProvider = DummyManualPaymentProvider();

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    payAbleAmount = widget.disCountedAmount;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      // Load payment providers data
      DummyPaymentAPIProvider paymentAPIProvider =
          Provider.of<DummyPaymentAPIProvider>(context, listen: false);
      await paymentAPIProvider.fetchPaymentAPI(context);

      manualPaymentProvider =
          Provider.of<DummyManualPaymentProvider>(context, listen: false);
      await manualPaymentProvider.fetchData();

      DummyWalletDetailsProvider walletDetailsProvider =
          Provider.of<DummyWalletDetailsProvider>(context, listen: false);
      await walletDetailsProvider.fetchWalletDetails();

      var homeDataProvider = Provider.of<DummyEnhancedHomeDataProvider>(context, listen: false);
      await homeDataProvider.loadEnhancedHomeData();

      // Check if manual payment is available
      var manualPayment =
          manualPaymentProvider.manualPaymentModel!.manualPayment!.isNotEmpty
              ? "1"
              : "0";

      // Get payment gateway settings from home data provider
      var stripe = homeDataProvider.homeModel.settings!.stripeEnable;
      var paypal = homeDataProvider.homeModel.settings!.paypalEnable;
      var paystack = homeDataProvider.homeModel.settings!.paystackEnable;
      var paytm = homeDataProvider.homeModel.settings!.paytmEnable;
      var razorpay = homeDataProvider.homeModel.settings!.razorpayEnable;
      var instamojo = homeDataProvider.homeModel.settings!.instamojoEnable;
      var payhere = homeDataProvider.homeModel.settings!.enablePayhere;
      var rave = homeDataProvider.homeModel.settings!.enableRave;
      var payu = homeDataProvider.homeModel.settings!.enablePayu;
      var cashfree = homeDataProvider.homeModel.settings!.enableCashfree;
      
      // Get bank details
      var bank = paymentAPIProvider.paymentApi.bankDetails == null
          ? 0
          : paymentAPIProvider.paymentApi.bankDetails!.bankEnable;

      // Get UPI details
      var upi;
      if (paymentAPIProvider.upiDetailsModel.upi != null) {
        upi = paymentAPIProvider.upiDetailsModel.upi!.status;
      }

      // Check wallet availability
      var wallet = '0';
      if (walletDetailsProvider.walletModel != null &&
          walletDetailsProvider.walletModel!.wallet != null) {
        wallet = "1";
      }

      // Create list of available payment gateways
      if (stripe.toString() == "1") {
        listPayment.add(
          RealPaymentGatewayModel(
            1,
            "Stripe",
            "assets/placeholder/stripe.png",
            "1",
            "description",
            "active",
            "detail"
          ),
        );
      }
      if (paypal.toString() == "1") {
        listPayment.add(
          RealPaymentGatewayModel(
            2,
            "Paypal",
            "assets/placeholder/paypal.png",
            "1",
            "description",
            "active",
            "detail"
          ),
        );
      }
      if (paystack.toString() == "1") {
        listPayment.add(
          RealPaymentGatewayModel(
            3,
            "PayStack",
            "assets/placeholder/paystackwallets.png",
            "1",
            "description",
            "active",
            "detail"
          ),
        );
      }
      if (paytm.toString() == "1") {
        listPayment.add(
          RealPaymentGatewayModel(
            4,
            "Paytm",
            "assets/placeholder/paytm.png",
            "1",
            "description",
            "active",
            "detail"
          ),
        );
      }
      if (razorpay.toString() == "1") {
        listPayment.add(
          RealPaymentGatewayModel(
            5,
            "RazorPay",
            "assets/placeholder/razorpay.png",
            "1",
            "description",
            "active",
            "detail"
          ),
        );
      }
      if (instamojo.toString() == "1") {
        listPayment.add(
          RealPaymentGatewayModel(
            6,
            "Instamojo",
            "assets/placeholder/instamojo.png",
            "1",
            "description",
            "active",
            "detail"
          ),
        );
      }
      if (payhere.toString() == "1") {
        listPayment.add(
          RealPaymentGatewayModel(
            7,
            "PayHere",
            "assets/placeholder/payhere.png",
            "1",
            "description",
            "active",
            "detail"
          ),
        );
      }
      if (rave.toString() == "1") {
        listPayment.add(
          RealPaymentGatewayModel(
            71,
            "Rave",
            "assets/placeholder/rave.png",
            "1",
            "description",
            "active",
            "detail"
          ),
        );
      }
      if (payu.toString() == "1") {
        listPayment.add(
          RealPaymentGatewayModel(
            72,
            "PayU",
            "assets/placeholder/payumoney.png",
            "1",
            "description",
            "active",
            "detail"
          ),
        );
      }
      if (cashfree.toString() == "1") {
        listPayment.add(
          RealPaymentGatewayModel(
            73,
            "Cashfree",
            "assets/placeholder/cashfree.png",
            "1",
            "description",
            "active",
            "detail"
          ),
        );
      }
      if (upi.toString() == "1") {
        listPayment.add(
          RealPaymentGatewayModel(
            74,
            "UPI",
            "assets/placeholder/upi.png",
            "1",
            "description",
            "active",
            "detail"
          ),
        );
      }
      if (bank.toString() == "1") {
        listPayment.add(
          RealPaymentGatewayModel(
            8,
            "Bank Transfer",
            "assets/placeholder/bankwallets.png",
            "1",
            "description",
            "active",
            "detail"
          ),
        );
      }
      if (manualPayment.toString() == "1") {
        listPayment.add(
          RealPaymentGatewayModel(
            9,
            "Manual Payment",
            "assets/placeholder/manualpayment.png",
            "1",
            "description",
            "active",
            "detail"
          ),
        );
      }
      if (wallet.toString() == "1") {
        listPayment.add(
          RealPaymentGatewayModel(
            10,
            "Wallet",
            "assets/placeholder/wallet.png",
            "1",
            "description",
            "active",
            "detail"
          ),
        );
      }
      setState(() {
        loading = false;
      });
    });
  }

  Widget listsOfGateways() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          height: 90,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              top: index == 0
                  ? BorderSide(width: 1, color: Colors.grey.withOpacity(0.4))
                  : BorderSide.none,
              bottom: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(0.4),
              ),
            ),
          ),
          child: RadioListTile(
            activeColor: const Color(0xFF0284A2),
            value: index,
            groupValue: value,
            onChanged: (ind) {
              setState(() {
                value = ind as int?;
                id = listPayment[index].id;
              });
            },
            title: Row(
              children: [
                Container(
                  height: 65,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(listPayment[index].walletImage),
                      ),
                      borderRadius: BorderRadius.circular(15)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    listPayment[index].name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: listPayment.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get providers
    var payment = Provider.of<DummyPaymentAPIProvider>(context).paymentApi;
    var user = Provider.of<DummyUserProvider>(context);
    
    return Scaffold(
        appBar: secondaryAppBar(
            Colors.black, Colors.white, context, translate("Checkout")),
        backgroundColor: Colors.white,
        bottomNavigationBar:
            value == null ? SizedBox.shrink() : bottomFixed(payment, user),
        body: loading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : listsOfGateways());
  }
}



// import 'package:kloncept/gateways/instamojo_payment.dart';
// import 'package:kloncept/gateways/manual_payment_list.dart';
// import 'package:kloncept/gateways/payhere_payment.dart';
// import 'package:kloncept/gateways/paypal/PaypalPayment.dart';
// import 'package:kloncept/gateways/payu_payment.dart';
// import 'package:kloncept/gateways/rave_payment.dart';
// import 'package:kloncept/gateways/stripe_payment.dart';
// import 'package:kloncept/gateways/upi_payment.dart';
// import 'package:kloncept/model/payment_gateway_model.dart';
// import 'package:kloncept/provider/manual_payment_provider.dart';
// import 'package:kloncept/provider/user_profile.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import '../Widgets/utils.dart';
// import '../gateways/bank_payment.dart';
// import '../gateways/paystack_payment.dart';
// import '../gateways/paytm_payment.dart';
// import '../gateways/razor_payments.dart';
// import '../gateways/wallet_payment.dart';
// import '../provider/home_data_provider.dart';
// import '../provider/payment_api_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';
// import '../common/theme.dart' as T;
// import '../provider/walletDetailsProvider.dart';

// class PaymentGateway extends StatefulWidget {
//   final int? tAmount;
//   final disCountedAmount;

//   PaymentGateway(this.tAmount, this.disCountedAmount);

//   @override
//   _PaymentGatewayState createState() => _PaymentGatewayState();
// }

// class _PaymentGatewayState extends State<PaymentGateway> {
//   int? value;
//   int? id;
//   var payAbleAmount;
//   List<PaymentGatewayModel> listPayment = [];
//   var loading = true;

//   Widget bottomFixed(payment, user) {
//     var homeData = Provider.of<HomeDataProvider>(context);
//     return Container(
//       decoration: BoxDecoration(color: Colors.white, boxShadow: [
//         BoxShadow(
//             color: Color(0x1c2464).withOpacity(0.30),
//             blurRadius: 15.0,
//             offset: Offset(0.0, -20.5),
//             spreadRadius: -15.0)
//       ]),
//       child: InkWell(
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//               alignment: Alignment.center,
//               margin: EdgeInsets.all(18.0),
//               padding: EdgeInsets.all(10.0),
//               height: 50.0,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(4.0),
//                 color: Color(0xFFF44A4A),
//                 gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xFF6E1A52),
//                       Color(0xFFF44A4A),
//                     ]),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "${translate("Amount_")}:  ${payAbleAmount.toString()}",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15),
//                   ),
//                   Text(
//                     "${translate("Continue_to_payment")} >>",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15),
//                   ),
//                 ],
//               )),
//         ),
//         onTap: () {
//           if (id == 1) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     StripePaymentScreen(amount: payAbleAmount),
//               ),
//             );
//           } else if (id == 2) {
//             onPayWithPayPal(homeData, user);
//           } else if (id == 3) {
//             if ("${homeData.homeModel!.currency!.currency}" == "NGN" ||
//                 "${homeData.homeModel!.currency!.currency}" == "GHS" ||
//                 "${homeData.homeModel!.currency!.currency}" == "USD" ||
//                 "${homeData.homeModel!.currency!.currency}" == "ZAR") {
//               Navigator.push(
//                 context,
//                 PageTransition(
//                   type: PageTransitionType.rightToLeft,
//                   child: PayStackPage(
//                     amount: payAbleAmount,
//                     currency: "${homeData.homeModel!.currency!.currency}",
//                   ),
//                 ),
//               );
//             } else {
//               Fluttertoast.showToast(
//                   msg: translate("Supports_only_NGN_GHS_USD_&_ZAR_currency"));
//             }
//           } else if (id == 4) {
//             Fluttertoast.showToast(msg: translate("Supported_only_live_mode"));
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PaytmPaymentPage(
//                   amount: payAbleAmount,
//                 ),
//               ),
//             );
//           } else if (id == 5) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MyRazorPaymentPage(
//                   amount: payAbleAmount,
//                 ),
//               ),
//             );
//           } else if (id == 6) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => InstamojoPaymentPage(
//                   amount: payAbleAmount,
//                 ),
//               ),
//             );
//           } else if (id == 7) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PayHerePayment(
//                   amount: payAbleAmount,
//                 ),
//               ),
//             );
//           } else if (id == 71) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => RavePayment(
//                   amount: payAbleAmount,
//                 ),
//               ),
//             );
//           } else if (id == 72) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PayUPayment(
//                   amount: payAbleAmount,
//                 ),
//               ),
//             );
//           } else if (id == 73) {
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (context) => CashfreePayment(
//             //       amount: payAbleAmount,
//             //     ),
//             //   ),
//             // );
//           } else if (id == 74) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => UPIPayment(
//                   amount: payAbleAmount,
//                 ),
//               ),
//             );
//           } else if (id == 8) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => BankPayment(),
//               ),
//             );
//           } else if (id == 9) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ManualPaymentList(
//                   manualPaymentModel: manualPaymentProvider.manualPaymentModel,
//                 ),
//               ),
//             );
//           } else if (id == 10) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => WalletPayment(
//                   amount: payAbleAmount,
//                 ),
//               ),
//             );
//           } else {
//             Fluttertoast.showToast(
//                 msg: translate("Please_select_payment_gateway"));
//           }
//         },
//       ),
//     );
//   }

//   void onPayWithPayPal(homeData, user) {
//     var currency = homeData.homeModel.currency.currency;
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (BuildContext context) => PaypalPayment(
//           onFinish: (number) async {},
//           currency: currency,
//           userFirstName: user.profileInstance.fname,
//           userLastName: user.profileInstance.lname,
//           userEmail: user.profileInstance.email,
//           payAmount: "$payAbleAmount",
//         ),
//       ),
//     );
//   }

//   ManualPaymentProvider manualPaymentProvider = ManualPaymentProvider();

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       loading = true;
//     });
//     payAbleAmount = widget.disCountedAmount;
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       PaymentAPIProvider paymentAPIProvider =
//           Provider.of<PaymentAPIProvider>(context, listen: false);
//       await paymentAPIProvider.fetchPaymentAPI(context);

//       manualPaymentProvider =
//           Provider.of<ManualPaymentProvider>(context, listen: false);
//       await manualPaymentProvider.fetchData();

//       var manualPayment =
//           manualPaymentProvider.manualPaymentModel!.manualPayment!.isNotEmpty
//               ? "1"
//               : "0";

//       var stripe = Provider.of<HomeDataProvider>(context, listen: false)
//           .homeModel!
//           .settings!
//           .stripeEnable;
//       var paypal = Provider.of<HomeDataProvider>(context, listen: false)
//           .homeModel!
//           .settings!
//           .paypalEnable;
//       var paystack = Provider.of<HomeDataProvider>(context, listen: false)
//           .homeModel!
//           .settings!
//           .paystackEnable;
//       var paytm = Provider.of<HomeDataProvider>(context, listen: false)
//           .homeModel!
//           .settings!
//           .paytmEnable;
//       var razorpay = Provider.of<HomeDataProvider>(context, listen: false)
//           .homeModel!
//           .settings!
//           .razorpayEnable;
//       var instamojo = Provider.of<HomeDataProvider>(context, listen: false)
//           .homeModel!
//           .settings!
//           .instamojoEnable;
//       var payhere = Provider.of<HomeDataProvider>(context, listen: false)
//           .homeModel!
//           .settings!
//           .enablePayhere;
//       var rave = Provider.of<HomeDataProvider>(context, listen: false)
//           .homeModel!
//           .settings!
//           .enableRave;
//       var payu = Provider.of<HomeDataProvider>(context, listen: false)
//           .homeModel!
//           .settings!
//           .enablePayu;
//       var cashfree = Provider.of<HomeDataProvider>(context, listen: false)
//           .homeModel!
//           .settings!
//           .enableCashfree;
//       var bank = Provider.of<PaymentAPIProvider>(context, listen: false)
//                   .paymentApi
//                   .bankDetails ==
//               null
//           ? 0
//           : Provider.of<PaymentAPIProvider>(context, listen: false)
//               .paymentApi
//               .bankDetails!
//               .bankEnable;

//       //var upi = '0';

//       var upi;

//       if (Provider.of<PaymentAPIProvider>(context, listen: false)
//               .upiDetailsModel
//               .upi !=
//           null) {
//         upi = Provider.of<PaymentAPIProvider>(context, listen: false)
//             .upiDetailsModel
//             .upi!
//             .status;
//       }

//       var wallet = '0';

//       WalletDetailsProvider walletDetailsProvider =
//           Provider.of<WalletDetailsProvider>(context, listen: false);

//       if (walletDetailsProvider.walletModel != null &&
//           walletDetailsProvider.walletModel!.wallet != null) {
//         wallet = "1";
//       }

//       if (stripe.toString() == "1") {
//         listPayment.add(
//           PaymentGatewayModel(
//             1,
//             "Stripe",
//             "assets/placeholder/stripe.png",
//             "1",
//           ),
//         );
//       }
//       if (paypal.toString() == "1") {
//         listPayment.add(
//           PaymentGatewayModel(
//             2,
//             "Paypal",
//             "assets/placeholder/paypal.png",
//             "1",
//           ),
//         );
//       }
//       if (paystack.toString() == "1") {
//         listPayment.add(
//           PaymentGatewayModel(
//             3,
//             "PayStack",
//             "assets/placeholder/paystackwallets.png",
//             "1",
//           ),
//         );
//       }
//       if (paytm.toString() == "1") {
//         listPayment.add(
//           PaymentGatewayModel(
//             4,
//             "Paytm",
//             "assets/placeholder/paytm.png",
//             "1",
//           ),
//         );
//       }
//       if (razorpay.toString() == "1") {
//         listPayment.add(
//           PaymentGatewayModel(
//             5,
//             "RazorPay",
//             "assets/placeholder/razorpay.png",
//             "1",
//           ),
//         );
//       }
//       if (instamojo.toString() == "1") {
//         listPayment.add(
//           PaymentGatewayModel(
//             6,
//             "Instamojo",
//             "assets/placeholder/instamojo.png",
//             "1",
//           ),
//         );
//       }
//       if (payhere.toString() == "1") {
//         listPayment.add(
//           PaymentGatewayModel(
//             7,
//             "PayHere",
//             "assets/placeholder/payhere.png",
//             "1",
//           ),
//         );
//       }
//       if (rave.toString() == "1") {
//         listPayment.add(
//           PaymentGatewayModel(
//             71,
//             "Rave",
//             "assets/placeholder/rave.png",
//             "1",
//           ),
//         );
//       }
//       if (payu.toString() == "1") {
//         listPayment.add(
//           PaymentGatewayModel(
//             72,
//             "PayU",
//             "assets/placeholder/payumoney.png",
//             "1",
//           ),
//         );
//       }
//       if (cashfree.toString() == "1") {
//         listPayment.add(
//           PaymentGatewayModel(
//             73,
//             "Cashfree",
//             "assets/placeholder/cashfree.png",
//             "1",
//           ),
//         );
//       }
//       if (upi.toString() == "1") {
//         listPayment.add(
//           PaymentGatewayModel(
//             74,
//             "UPI",
//             "assets/placeholder/upi.png",
//             "1",
//           ),
//         );
//       }
//       if (bank.toString() == "1") {
//         listPayment.add(
//           PaymentGatewayModel(
//             8,
//             "Bank Transfer",
//             "assets/placeholder/bankwallets.png",
//             "1",
//           ),
//         );
//       }
//       if (manualPayment.toString() == "1") {
//         listPayment.add(
//           PaymentGatewayModel(
//             9,
//             "Manual Payment",
//             "assets/placeholder/manualpayment.png",
//             "1",
//           ),
//         );
//       }
//       if (wallet.toString() == "1") {
//         listPayment.add(
//           PaymentGatewayModel(
//             10,
//             "Wallet",
//             "assets/placeholder/wallet.png",
//             "1",
//           ),
//         );
//       }
//       setState(() {
//         loading = false;
//       });
//     });
//   }

//   Widget listsOfGateways() {
//     return ListView.builder(
//       itemBuilder: (context, index) {
//         return Container(
//           height: 90,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             border: Border(
//               top: index == 0
//                   ? BorderSide(width: 1, color: Colors.grey.withOpacity(0.4))
//                   : BorderSide.none,
//               bottom: BorderSide(
//                 width: 1,
//                 color: Colors.grey.withOpacity(0.4),
//               ),
//             ),
//           ),
//           child: RadioListTile(
//             activeColor: const Color(0xFF0284A2),
//             value: index,
//             groupValue: value,
//             onChanged: (ind) {
//               setState(() {
//                 value = ind;
//                 id = listPayment[index].id;
//               });
//             },
//             title: Row(
//               children: [
//                 Container(
//                   height: 65,
//                   alignment: Alignment.center,
//                   margin: EdgeInsets.symmetric(horizontal: 15),
//                   width: 100,
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(listPayment[index].walletImage),
//                       ),
//                       borderRadius: BorderRadius.circular(15)),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10.0),
//                   child: Text(
//                     listPayment[index].name,
//                     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       itemCount: listPayment.length,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     T.Theme mode = Provider.of<T.Theme>(context);
//     var payment = Provider.of<PaymentAPIProvider>(context).paymentApi;
//     var user = Provider.of<UserProfile>(context);
//     return Scaffold(
//         appBar: secondaryAppBar(
//             Colors.black, mode.bgcolor, context, translate("Checkout")),
//         backgroundColor: mode.bgcolor,
//         bottomNavigationBar:
//             value == null ? SizedBox.shrink() : bottomFixed(payment, user),
//         body: loading == true
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : listsOfGateways());
//   }
// }
