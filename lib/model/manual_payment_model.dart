/// manual_payment : [{"id":0,"name":"Testing","detail":"Just Testing","image":"1634813492payment-method.png","image_path":"https://castleindia.in/eclass/public/images/manualpayment/1634813492payment-method.png","status":"1","created_at":"2021-10-21T10:51:32.000000Z","updated_at":"2021-10-21T10:51:32.000000Z"}]

class ManualPaymentModel {
  List<Manual_payment>? _manualPayment;

  List<Manual_payment>? get manualPayment => _manualPayment;

  ManualPaymentModel({List<Manual_payment>? manualPayment}) {
    _manualPayment = manualPayment;
  }

  ManualPaymentModel.fromJson(dynamic json) {
    if (json['manual_payment'] != null) {
      _manualPayment = [];
      json['manual_payment'].forEach((v) {
        _manualPayment!.add(Manual_payment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_manualPayment != null) {
      map['manual_payment'] = _manualPayment!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 0
/// name : "Testing"
/// detail : "Just Testing"
/// image : "1634813492payment-method.png"
/// image_path : "https://castleindia.in/eclass/public/images/manualpayment/1634813492payment-method.png"
/// status : "1"
/// created_at : "2021-10-21T10:51:32.000000Z"
/// updated_at : "2021-10-21T10:51:32.000000Z"

// ignore: camel_case_types
class Manual_payment {
  int? _id;
  String? _name;
  String? _detail;
  String? _image;
  String? _imagePath;
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;
  String? get name => _name;
  String? get detail => _detail;
  String? get image => _image;
  String? get imagePath => _imagePath;
  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Manual_payment(
      {required int id,
      required String name,
      required String detail,
      required String image,
      required String imagePath,
      required String status,
      required String createdAt,
      required String updatedAt}) {
    _id = id;
    _name = name;
    _detail = detail;
    _image = image;
    _imagePath = imagePath;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Manual_payment.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _detail = json['detail'];
    _image = json['image'];
    _imagePath = json['image_path'];
    _status = json['status'].toString();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['detail'] = _detail;
    map['image'] = _image;
    map['image_path'] = _imagePath;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
