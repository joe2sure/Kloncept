import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kloncept/widgets/appbar.dart';

class TopUpWalletScreen extends StatefulWidget {
  final String currentBalance;
  final String currencySymbol;

  const TopUpWalletScreen(this.currentBalance, this.currencySymbol, {Key? key}) 
      : super(key: key);

  @override
  State<TopUpWalletScreen> createState() => _TopUpWalletScreenState();
}

class _TopUpWalletScreenState extends State<TopUpWalletScreen> {
  final TextEditingController _amountController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, translate("Top_up_Wallet")),
      backgroundColor: Color(0xFFf6f8fa),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 0.0,
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFFeaecf2),
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate("Current_Balance"),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF777e8f),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        widget.currentBalance,
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                translate("Enter_Amount_to_Add"),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      widget.currencySymbol,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                  hintText: "0.00",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff44a4a), width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfff44a4a),
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  onPressed: () {
                    // Show a success snackbar for demo purposes
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(translate("Amount_Added_Successfully")),
                        backgroundColor: Colors.green,
                      ),
                    );
                    
                    // Navigate back
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    translate("Add_Money"),
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}



// import 'package:kloncept/Screens/payment_gateway.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Widgets/appbar.dart';

// class TopUpWalletScreen extends StatefulWidget {
//   final String currentBalance;
//   final String currencySymbol;
//   const TopUpWalletScreen(this.currentBalance, this.currencySymbol);

//   @override
//   State<TopUpWalletScreen> createState() => _TopUpWalletScreenState();
// }

// class _TopUpWalletScreenState extends State<TopUpWalletScreen> {
//   TextEditingController topUpAmountTEC = TextEditingController();
//   bool isValidInput = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: customAppBar(context, translate("Top_Up_Wallet")),
//       body: SingleChildScrollView(
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           padding: EdgeInsets.all(10.0),
//           child: Card(
//             elevation: 5.0,
//             child: Container(
//               padding: EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     translate("Current_Balance"),
//                     style: TextStyle(
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   Text(
//                     widget.currentBalance,
//                     style: TextStyle(
//                       fontSize: 35.0,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.indigo,
//                     ),
//                   ),
//                   Divider(
//                     height: 30.0,
//                   ),
//                   TextField(
//                     controller: topUpAmountTEC,
//                     keyboardType: TextInputType.number,
//                     style: TextStyle(
//                       fontSize: 26.0,
//                       fontWeight: FontWeight.w700,
//                     ),
//                     decoration: InputDecoration(
//                       labelText: translate("Enter_Top_up_Amount"),
//                       labelStyle: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       border: OutlineInputBorder(),
//                       prefix: Text(
//                         "${widget.currencySymbol} ",
//                         style: TextStyle(
//                           fontSize: 28.0,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                       errorText:
//                           isValidInput ? null : translate("Enter_valid_amount"),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Center(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           isValidInput =
//                               double.tryParse("${topUpAmountTEC.text}") !=
//                                       null &&
//                                   topUpAmountTEC.text.isNotEmpty;
//                           if (isValidInput) {
//                             topUpWalletCheckout(topUpAmountTEC.text);
//                           }
//                         });
//                       },
//                       child: Text(
//                         translate("Proceed_to_Top_Up"),
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> topUpWalletCheckout(String amount) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

//     await sharedPreferences.setInt("topUpWallet", int.parse("$amount"));

//     Navigator.push(
//       context,
//       PageTransition(
//         type: PageTransitionType.rightToLeft,
//         child: PaymentGateway(
//           int.tryParse("$amount"),
//           int.tryParse("$amount"),
//         ),
//       ),
//     ).then((_) async {
//       if (sharedPreferences.containsKey("topUpWallet")) {
//         await sharedPreferences.remove("topUpWallet");
//       }
//     });
//   }
// }
