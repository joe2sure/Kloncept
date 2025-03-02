import 'package:kloncept/Screens/payment_gateway.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/appbar.dart';

class TopUpWalletScreen extends StatefulWidget {
  final String currentBalance;
  final String currencySymbol;
  const TopUpWalletScreen(this.currentBalance, this.currencySymbol);

  @override
  State<TopUpWalletScreen> createState() => _TopUpWalletScreenState();
}

class _TopUpWalletScreenState extends State<TopUpWalletScreen> {
  TextEditingController topUpAmountTEC = TextEditingController();
  bool isValidInput = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, translate("Top_Up_Wallet")),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10.0),
          child: Card(
            elevation: 5.0,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate("Current_Balance"),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.currentBalance,
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.indigo,
                    ),
                  ),
                  Divider(
                    height: 30.0,
                  ),
                  TextField(
                    controller: topUpAmountTEC,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      labelText: translate("Enter_Top_up_Amount"),
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(),
                      prefix: Text(
                        "${widget.currencySymbol} ",
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      errorText:
                          isValidInput ? null : translate("Enter_valid_amount"),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          isValidInput =
                              double.tryParse("${topUpAmountTEC.text}") !=
                                      null &&
                                  topUpAmountTEC.text.isNotEmpty;
                          if (isValidInput) {
                            topUpWalletCheckout(topUpAmountTEC.text);
                          }
                        });
                      },
                      child: Text(
                        translate("Proceed_to_Top_Up"),
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
        ),
      ),
    );
  }

  Future<void> topUpWalletCheckout(String amount) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setInt("topUpWallet", int.parse("$amount"));

    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: PaymentGateway(
          int.tryParse("$amount"),
          int.tryParse("$amount"),
        ),
      ),
    ).then((_) async {
      if (sharedPreferences.containsKey("topUpWallet")) {
        await sharedPreferences.remove("topUpWallet");
      }
    });
  }
}
