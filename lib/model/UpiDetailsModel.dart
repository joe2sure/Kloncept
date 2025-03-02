import 'dart:convert';

/// upi : {"id":1,"created_at":"2022-10-07T13:46:12.000000Z","updated_at":"2022-10-18T02:02:19.000000Z","name":"Mr.doe","upiid":"doe@example.com","status":"1"}

UpiDetailsModel upiDetailsModelFromJson(String str) =>
    UpiDetailsModel.fromJson(json.decode(str));
String upiDetailsModelToJson(UpiDetailsModel data) =>
    json.encode(data.toJson());

class UpiDetailsModel {
  UpiDetailsModel({
    this.upi,
  });

  UpiDetailsModel.fromJson(dynamic json) {
    upi = json['upi'] != null ? Upi.fromJson(json['upi']) : null;
  }
  Upi? upi;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (upi != null) {
      map['upi'] = upi!.toJson();
    }
    return map;
  }
}

/// id : 1
/// created_at : "2022-10-07T13:46:12.000000Z"
/// updated_at : "2022-10-18T02:02:19.000000Z"
/// name : "Mr.doe"
/// upiid : "doe@example.com"
/// status : "1"

Upi upiFromJson(String str) => Upi.fromJson(json.decode(str));
String upiToJson(Upi data) => json.encode(data.toJson());

class Upi {
  Upi({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.upiid,
    this.status,
  });

  Upi.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    upiid = json['upiid'];
    status = json['status'].toString();
  }
  num? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? upiid;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['name'] = name;
    map['upiid'] = upiid;
    map['status'] = status;
    return map;
  }
}
