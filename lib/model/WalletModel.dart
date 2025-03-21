class WalletModel {
  int? id;
  int? userId;
  String? balance;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? totalTransactions;
  String? lastTransaction;

  WalletModel({
    this.id,
    this.userId,
    this.balance,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.totalTransactions,
    this.lastTransaction,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      userId: json['user_id'],
      balance: json['balance'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      totalTransactions: json['total_transactions'],
      lastTransaction: json['last_transaction'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['balance'] = this.balance;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['total_transactions'] = this.totalTransactions;
    data['last_transaction'] = this.lastTransaction;
    return data;
  }
}


// import 'dart:convert';

// /// wallet : "100"
// /// path : "https://168.119.119.227/eclass_purchasecopy/public/register/?ref=G1HQ9OK8EY&2O3FVKLAM"

// WalletModel walletModelFromJson(String str) =>
//     WalletModel.fromJson(json.decode(str));
// String walletModelToJson(WalletModel data) => json.encode(data.toJson());

// class WalletModel {
//   WalletModel({
//     this.wallet,
//     this.path,
//   });

//   WalletModel.fromJson(dynamic json) {
//     wallet = json['wallet'].toString();
//     path = json['path'];
//   }
//   String? wallet;
//   String? path;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['wallet'] = wallet;
//     map['path'] = path;
//     return map;
//   }
// }
