import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

final storage = FlutterSecureStorage();
var authToken;
Color spcl = Color(0xff655586);
var selectedCurrency;
var selectedCurrencyRate;
var langCode;

String currencySymbol(String currencyCode) {
  NumberFormat format =
      NumberFormat.simpleCurrency(name: currencyCode.toUpperCase());

  if (currencyCode.toUpperCase() == "NGN") {
    return "${format.currencyName}";
  }
  return "${format.currencySymbol}";
}
