import 'dart:developer';
import 'package:flutter/material.dart';


class HomeModel {
  Currency? currency;
  
  HomeModel({this.currency});
  
  // Factory method to create a dummy home model
  factory HomeModel.dummy() {
    return HomeModel(
      currency: Currency(
        id: 1,
        currency: 'USD',
        symbol: '\$',
        position: 'left',
        format: '1,0.00',
      ),
    );
  }
}

class Currency {
  final int id;
  final String currency;
  final String symbol;
  final String position;
  final String format;
  
  Currency({
    required this.id,
    required this.currency,
    required this.symbol,
    required this.position,
    required this.format,
  });
}

class DummyHomeDataExtraProvider with ChangeNotifier {
  HomeModel? homeModel;
  bool dataLoaded = false;
  
  Future<void> fetchHomeData() async {
    log("Fetching dummy home data");
    
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));
    
    // Create dummy home model
    homeModel = HomeModel.dummy();
    dataLoaded = true;
    
    log("Dummy home data loaded successfully");
    log("Current currency: ${homeModel?.currency?.currency}");
    
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