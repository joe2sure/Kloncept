import 'dart:convert';

DummyCurrenciesModel DummycurrenciesModelFromJson(String str) =>
    DummyCurrenciesModel.fromJson(json.decode(str));
String DummycurrenciesModelToJson(DummyCurrenciesModel data) =>
    json.encode(data.toJson());

class DummyCurrenciesModel {
  DummyCurrenciesModel({
    this.currencies,
  });

  DummyCurrenciesModel.fromJson(dynamic json) {
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

  // Generate dummy currencies data
  static DummyCurrenciesModel getDummyData() {
    final dummyJson = {
      'currencies': [
        {
          'id': 1,
          'icon': 'icon_usd.png',
          'currency': 'US Dollar',
          'default': 1,
          'created_at': '2023-01-01 00:00:00',
          'updated_at': '2023-01-01 00:00:00',
          'name': 'US Dollar',
          'code': 'USD',
          'symbol': '\$',
          'format': '1,0.00',
          'exchange_rate': '1.00',
          'active': 1,
          'position': 'left'
        },
        {
          'id': 2,
          'icon': 'icon_eur.png',
          'currency': 'Euro',
          'default': 0,
          'created_at': '2023-01-01 00:00:00',
          'updated_at': '2023-01-01 00:00:00',
          'name': 'Euro',
          'code': 'EUR',
          'symbol': '€',
          'format': '1,0.00',
          'exchange_rate': '0.92',
          'active': 1,
          'position': 'left'
        },
        {
          'id': 3,
          'icon': 'icon_gbp.png',
          'currency': 'British Pound',
          'default': 0,
          'created_at': '2023-01-01 00:00:00',
          'updated_at': '2023-01-01 00:00:00',
          'name': 'British Pound',
          'code': 'GBP',
          'symbol': '£',
          'format': '1,0.00',
          'exchange_rate': '0.78',
          'active': 1,
          'position': 'left'
        },
        {
          'id': 4,
          'icon': 'icon_inr.png',
          'currency': 'Indian Rupee',
          'default': 0,
          'created_at': '2023-01-01 00:00:00',
          'updated_at': '2023-01-01 00:00:00',
          'name': 'Indian Rupee',
          'code': 'INR',
          'symbol': '₹',
          'format': '1,0.00',
          'exchange_rate': '83.50',
          'active': 1,
          'position': 'left'
        },
        {
          'id': 5,
          'icon': 'icon_jpy.png',
          'currency': 'Japanese Yen',
          'default': 0,
          'created_at': '2023-01-01 00:00:00',
          'updated_at': '2023-01-01 00:00:00',
          'name': 'Japanese Yen',
          'code': 'JPY',
          'symbol': '¥',
          'format': '1,0',
          'exchange_rate': '151.80',
          'active': 1,
          'position': 'left'
        }
      ]
    };
    return DummyCurrenciesModel.fromJson(dummyJson);
  }
}

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