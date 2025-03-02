import 'dart:convert';

/// wallet : "100"
/// path : "https://168.119.119.227/eclass_purchasecopy/public/register/?ref=G1HQ9OK8EY&2O3FVKLAM"

WalletModel walletModelFromJson(String str) =>
    WalletModel.fromJson(json.decode(str));
String walletModelToJson(WalletModel data) => json.encode(data.toJson());

class WalletModel {
  WalletModel({
    this.wallet,
    this.path,
  });

  WalletModel.fromJson(dynamic json) {
    wallet = json['wallet'].toString();
    path = json['path'];
  }
  String? wallet;
  String? path;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['wallet'] = wallet;
    map['path'] = path;
    return map;
  }
}
