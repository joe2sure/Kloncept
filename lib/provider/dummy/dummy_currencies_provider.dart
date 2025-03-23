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


  // Method to simulate currency rate conversion
  Future<Map<String, dynamic>> getCurrencyRate(String fromCurrency, String toCurrency, String price) async {
    // Dummy exchange rates relative to USD
    Map<String, double> exchangeRates = {
      'USD': 1.0,
      'EUR': 0.92,
      'GBP': 0.78,
      'INR': 83.50,
      'JPY': 151.80,
    };
    
    double priceValue = double.parse(price);
    double fromRate = exchangeRates[fromCurrency] ?? 1.0;
    double toRate = exchangeRates[toCurrency] ?? 1.0;
    
    // Convert to USD first (if not already), then to target currency
    double inUSD = fromCurrency == 'USD' ? priceValue : priceValue / fromRate;
    double result = toCurrency == 'USD' ? inUSD : inUSD * toRate;
    
    return {
      'status': 'success',
      'currency': result.toString(),
    };
  }
}