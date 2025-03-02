import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../model/WalletModel.dart';

class WalletDetailsProvider with ChangeNotifier {
  WalletModel? walletModel;

  Future<void> fetchData() async {
    Response response = await get(
      Uri.parse(APIData.walletDetails),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );
    log("Wallet API Status Code :-> ${response.statusCode}");
    log("Wallet API Response :-> ${response.body}");
    if (response.statusCode == 200) {
      walletModel = walletModelFromJson(response.body);
    }
    notifyListeners();
  }
}
