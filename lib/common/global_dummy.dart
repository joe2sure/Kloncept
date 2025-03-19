import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Global variables
String? authToken;
final storage = FlutterSecureStorage();
String? selectedCurrency = "USD";
int? selectedCurrencyRate = 1;

// Helper function for currency symbol
String currencySymbol(String? currency) {
  switch (currency) {
    case "USD":
      return "\$";
    case "EUR":
      return "€";
    case "GBP":
      return "£";
    default:
      return "\$";
  }
}

