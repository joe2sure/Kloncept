import 'dart:convert';

/// institute : [{"id":11,"title":"Qui consequatur Iru","detail":"Cupidatat voluptates","user_id":"1","image":"1662447189163757494720943839.jpg","status":"1","verified":"0","skill":"Occaecat et laboris,Non debitis perspici","created_at":"2022-08-19T02:35:55.000000Z","updated_at":"2022-09-06T03:29:52.000000Z","email":"baxyb@mailinator.com","mobile":"1833333333","affilated_by":"Perspiciatis nihil,Sit inventore ex ea","address":"Quis distinctio Exc","slug":"testing"},{"id":12,"title":"Recusandae Unde eli","detail":"Et commodo et maiore","user_id":"1","image":"166088918116591744811641973164157978285110.jpg","status":"1","verified":"1","skill":"Lorem eligendi non v","created_at":"2022-08-19T02:36:21.000000Z","updated_at":"2022-08-19T02:40:57.000000Z","email":"gacefitom@mailinator.com","mobile":"3265456546","affilated_by":"Qui velit lorem prov","address":"Est exercitationem m","slug":"testing02"},{"id":13,"title":"At incidunt neque n","detail":"Velit obcaecati ex v","user_id":"2","image":"1660889225166088918116591744811641973164157978285110.jpg","status":"1","verified":"0","skill":"Incidunt rerum ut e","created_at":"2022-08-19T02:37:05.000000Z","updated_at":"2022-08-19T02:37:05.000000Z","email":"dace@mailinator.com","mobile":"2365656565","affilated_by":"Magna et repellendus","address":"Ea incidunt praesen","slug":"testing03"},{"id":14,"title":"Ipsa culpa sit volu","detail":"Consequatur volupta","user_id":"1","image":"1662447330163757494720943839.jpg","status":"1","verified":"0","skill":"Vel sed enim impedit","created_at":"2022-09-06T03:25:30.000000Z","updated_at":"2022-09-06T03:29:15.000000Z","email":"fisuze@mailinator.com","mobile":"2111111111","affilated_by":"Quo molestias aperia","address":"Aliquid est omnis i","slug":"testing04"},{"id":15,"title":"Officia blanditiis n","detail":"Voluptate cupiditate","user_id":"1","image":"16624480151645186167student.jpg","status":"1","verified":"0","skill":"Quis quo quia anim h","created_at":"2022-09-06T03:36:55.000000Z","updated_at":"2022-09-06T03:36:55.000000Z","email":"rygidesy@mailinator.com","mobile":"2822222222","affilated_by":"Minima placeat dolo","address":"Nisi blanditiis vel","slug":"testing01"}]

InstituteModel instituteModelFromJson(String str) =>
    InstituteModel.fromJson(json.decode(str));
String instituteModelToJson(InstituteModel data) => json.encode(data.toJson());

class InstituteModel {
  InstituteModel({
    this.institute,
  });

  InstituteModel.fromJson(dynamic json) {
    if (json['institute'] != null) {
      institute = [];
      json['institute'].forEach((v) {
        institute!.add(Institute.fromJson(v));
      });
    }
  }
  List<Institute>? institute;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (institute != null) {
      map['institute'] = institute!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 11
/// title : "Qui consequatur Iru"
/// detail : "Cupidatat voluptates"
/// user_id : "1"
/// image : "1662447189163757494720943839.jpg"
/// status : "1"
/// verified : "0"
/// skill : "Occaecat et laboris,Non debitis perspici"
/// created_at : "2022-08-19T02:35:55.000000Z"
/// updated_at : "2022-09-06T03:29:52.000000Z"
/// email : "baxyb@mailinator.com"
/// mobile : "1833333333"
/// affilated_by : "Perspiciatis nihil,Sit inventore ex ea"
/// address : "Quis distinctio Exc"
/// slug : "testing"

Institute instituteFromJson(String str) => Institute.fromJson(json.decode(str));
String instituteToJson(Institute data) => json.encode(data.toJson());

class Institute {
  Institute({
    this.id,
    this.title,
    this.detail,
    this.userId,
    this.image,
    this.status,
    this.verified,
    this.skill,
    this.createdAt,
    this.updatedAt,
    this.email,
    this.mobile,
    this.affilatedBy,
    this.address,
    this.slug,
    this.affiliatePrice,
  });

  Institute.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    detail = json['detail'];
    userId = json['user_id'];
    image = json['image'];
    status = json['status'];
    verified = json['verified'];
    skill = json['skill'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    email = json['email'];
    mobile = json['mobile'];
    affilatedBy = json['affilated_by'];
    address = json['address'];
    slug = json['slug'];
     affiliatePrice: json['affiliate_price'];
  }
  num? id;
  String? title;
  String? detail;
  int? userId;
  String? image;
  int? status;
  int? verified;
  String? skill;
  String? createdAt;
  String? updatedAt;
  String? email;
  String? mobile;
  String? affilatedBy;
  String? address;
  String? slug;
  String? affiliatePrice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['detail'] = detail;
    map['user_id'] = userId;
    map['image'] = image;
    map['status'] = status;
    map['verified'] = verified;
    map['skill'] = skill;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['email'] = email;
    map['mobile'] = mobile;
    map['affilated_by'] = affilatedBy;
    map['address'] = address;
    map['slug'] = slug;
    map['affiliatePrice'] = slug;
    return map;
  }
}
