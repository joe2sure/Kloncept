import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../common/apidata.dart';
import '../model/CurrenciesModel.dart';

class CurrenciesProvider with ChangeNotifier {
  CurrenciesModel? currenciesModel;
  List<String> currencyList = [];
  String defaultCurrency = "USD";

  Future<void> fetchData() async {
    Response response = await get(
      Uri.parse(APIData.allCurrencies),
    );
    log("Currencies API Status Code :-> ${response.statusCode}");
    log("Currencies API Response :-> ${response.body}");
    if (response.statusCode == 200) {
      currenciesModel = currenciesModelFromJson(response.body);

      currencyList.clear();
      currenciesModel!.currencies!.forEach((currency) {
        currencyList.add(currency.code.toString());
        if (currency.defaultCurrency.toString() == "1") {
          defaultCurrency = currency.code!;
        }
      });
    }
    notifyListeners();
  }
}
