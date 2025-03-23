import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:kloncept/model/dummy/dummy_currencies_model.dart';


class DummyCurrenciesProvider with ChangeNotifier {
  DummyCurrenciesModel? currenciesModel;
  List<String> currencyList = [];
  String defaultCurrency = "USD";

  Future<void> fetchData() async {
    log("Fetching dummy currencies data");
    
    // Use the dummy data method from the model
    currenciesModel = DummyCurrenciesModel.getDummyData();
    
    log("Dummy Currencies Data loaded successfully");
    
    if (currenciesModel != null && currenciesModel!.currencies != null) {
      // Clear and rebuild the currency list
      currencyList.clear();
      currenciesModel!.currencies!.forEach((currency) {
        currencyList.add(currency.code.toString());
        if (currency.defaultCurrency.toString() == "1") {
          defaultCurrency = currency.code!;
        }
      });
      
      log("Currency List: $currencyList");
      log("Default Currency: $defaultCurrency");
    }
    
    notifyListeners();
  }
}