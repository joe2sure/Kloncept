import 'dart:convert';

/// currencies : [{"id":1,"icon":"fa fa-dollar","currency":"USD","default":1,"created_at":"2019-12-11T00:54:24.000000Z","updated_at":"2023-01-17T09:00:00.000000Z","name":"US Dollar","code":"USD","symbol":"$","format":"$1,0.00","exchange_rate":"1","active":0,"position":"l"},{"id":2,"icon":"","currency":"","default":0,"created_at":"2022-10-17T19:21:20.000000Z","updated_at":"2023-01-17T09:00:00.000000Z","name":"Indian Rupee","code":"INR","symbol":"₹","format":"1,0.00₹","exchange_rate":"81.824554","active":1,"position":"l"},{"id":3,"icon":"","currency":"","default":0,"created_at":"2022-10-17T19:21:38.000000Z","updated_at":"2023-01-17T09:00:00.000000Z","name":"Euro","code":"EUR","symbol":"€","format":"1.0,00 €","exchange_rate":"0.923601","active":1,"position":"l"},{"id":4,"icon":"","currency":"","default":0,"created_at":"2022-10-17T19:21:46.000000Z","updated_at":"2023-01-17T09:00:00.000000Z","name":"Franc CFA (XOF)","code":"XOF","symbol":"F.CFA","format":"1,0.00 F.C","exchange_rate":"605.842505","active":1,"position":"l"},{"id":5,"icon":"","currency":"","default":0,"created_at":"2022-10-17T19:21:59.000000Z","updated_at":"2023-01-17T09:00:00.000000Z","name":"Nepalese Rupee","code":"NPR","symbol":"₨","format":"₨1,0.00","exchange_rate":"130.847293","active":1,"position":"l"},{"id":6,"icon":"","currency":"","default":0,"created_at":"2022-10-17T19:22:12.000000Z","updated_at":"2023-01-17T09:00:00.000000Z","name":"Nigeria, Naira","code":"NGN","symbol":"₦","format":"₦1,0.00","exchange_rate":"460.892916","active":1,"position":"l"}]

CurrenciesModel currenciesModelFromJson(String str) =>
    CurrenciesModel.fromJson(json.decode(str));
String currenciesModelToJson(CurrenciesModel data) =>
    json.encode(data.toJson());

class CurrenciesModel {
  CurrenciesModel({
    this.currencies,
  });

  CurrenciesModel.fromJson(dynamic json) {
    if (json['currencies'] != null) {
      currencies = [];
      json['currencies'].forEach((v) {
        currencies!.add(Currencies.fromJson(v));
      });
    }
  }
  List<Currencies>? currencies;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (currencies != null) {
      map['currencies'] = currencies!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// icon : "fa fa-dollar"
/// currency : "USD"
/// default : 1
/// created_at : "2019-12-11T00:54:24.000000Z"
/// updated_at : "2023-01-17T09:00:00.000000Z"
/// name : "US Dollar"
/// code : "USD"
/// symbol : "$"
/// format : "$1,0.00"
/// exchange_rate : "1"
/// active : 0
/// position : "l"

Currencies currenciesFromJson(String str) =>
    Currencies.fromJson(json.decode(str));
String currenciesToJson(Currencies data) => json.encode(data.toJson());

class Currencies {
  Currencies({
    this.id,
    this.icon,
    this.currency,
    this.defaultCurrency,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.code,
    this.symbol,
    this.format,
    this.exchangeRate,
    this.active,
    this.position,
  });

  Currencies.fromJson(dynamic json) {
    id = json['id'];
    icon = json['icon'];
    currency = json['currency'];
    defaultCurrency = json['default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    code = json['code'];
    symbol = json['symbol'];
    format = json['format'];
    exchangeRate = json['exchange_rate'];
    active = json['active'];
    position = json['position'];
  }
  num? id;
  String? icon;
  String? currency;
  num? defaultCurrency;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? code;
  String? symbol;
  String? format;
  String? exchangeRate;
  num? active;
  String? position;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['icon'] = icon;
    map['currency'] = currency;
    map['default'] = defaultCurrency;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['name'] = name;
    map['code'] = code;
    map['symbol'] = symbol;
    map['format'] = format;
    map['exchange_rate'] = exchangeRate;
    map['active'] = active;
    map['position'] = position;
    return map;
  }
}
