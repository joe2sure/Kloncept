import 'package:kloncept/common/global.dart';
import 'package:kloncept/provider/home_data_provider.dart';
import 'package:kloncept/provider/walletDetailsProvider.dart';
import 'package:kloncept/screens/top_up_wallet_screen.dart';
import 'package:kloncept/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    currency = Provider.of<HomeDataProvider>(context, listen: false)
        .homeModel!
        .currency!
        .currency;
    super.initState();
  }

  String? currency;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, translate("Wallet_")),
      backgroundColor: Color(0xFFf6f8fa),
      body: Consumer<WalletDetailsProvider>(
        builder: (_, provider, __) {
          print("wallet: ${provider.walletModel}");
          String currentBalance = provider.walletModel!.wallet != null
              ? provider.walletModel!.wallet!.contains(".")
                  ? "${currencySymbol(currency.toString())} ${provider.walletModel!.wallet}"
                  : "${currencySymbol(currency.toString())} ${provider.walletModel!.wallet}.00"
              : "${currencySymbol(currency!)} 0.00";
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Card(
                    elevation: 0.0,
                    child: Container(
                      height: 255,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xFFeaecf2),
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.all(15.0),
                              // decoration: BoxDecoration(
                              //   border: Border(
                              //     right: BorderSide(
                              //       color: Colors.black45,
                              //       width: 1,
                              //     ),
                              //   ),
                              // ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // CircleAvatar(
                                  //   radius: 15.0,
                                  // ),
                                  Container(
                                    // backgroundColor: Color(0xfff6f8fa),
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFf6f8fa),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Color(0xFFeaecf2),
                                        style: BorderStyle.solid,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Icon(
                                        Icons.account_balance_wallet_outlined,
                                        size: 16.0,
                                        color: Color(0xFF777e8f)),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    translate("Wallet_"),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              // padding: EdgeInsets.only(
                              //     left: 0.0, right: 0.0, bottom: 0.0),
                              margin: EdgeInsets.only(left: 15.0, right: 15.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Color(0xFFeaecf2),
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFf6f8fa),
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(5.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFFeaecf2),
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      translate("Current_Balance"),
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF777e8f)),
                                    ),
                                  ),
                                  Text(
                                    currentBalance,
                                    style: TextStyle(
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                                width: double.infinity,
                                // padding: EdgeInsets.only(
                                //     left: 0.0, right: 0.0, bottom: 0.0),
                                margin: EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    top: 15.0,
                                    bottom: 15.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xfff44a4a),
                                      elevation: 0.0
                                      //  Colors.green,
                                      ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => TopUpWalletScreen(
                                            currentBalance,
                                            "${currencySymbol(currency.toString())}"),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    translate("Top_up_Wallet"),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(translate("Scan_this_QR_Code_for_Referral_Link")),
                  Card(
                    elevation: 0.0,
                    child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color(0xFFeaecf2),
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                        ),
                        child: QrImageView(
                          data: "${provider.walletModel!.path.toString()}",
                          version: QrVersions.auto,
                          size: 350,
                          padding: EdgeInsets.all(30),
                        )),
                  ),
                  SizedBox(height: 25.0),
                  InkWell(
                    onTap: () {
                      Share.share("${provider.walletModel!.path.toString()}",
                          subject: translate("Referral_Link"));
                    },
                    splashColor: Colors.black12,
                    child: Container(
                      height: 30,
                      width: 220,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            translate("Share_Referral_Link"),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.indigo,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Icon(
                            Icons.share,
                            color: Colors.indigo,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
