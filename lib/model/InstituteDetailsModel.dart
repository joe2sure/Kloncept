import 'dart:convert';

/// institute : [{"id":13,"title":"At incidunt neque n","detail":"Velit obcaecati ex v","image":"https://168.119.119.227/eclass_purchasecopy/public/files/institute/1660889225166088918116591744811641973164157978285110.jpg","skill":"Incidunt rerum ut e","slug":"testing03","created_at":"2022-08-19T02:37:05.000000Z","updated_at":"2022-08-19T02:37:05.000000Z"}]
/// course : [{"id":20,"user_id":"2","category_id":"4","subcategory_id":"11","childcategory_id":"16","language_id":"1","title":"Travel Hacking -Smart & Fun Travel testerrrr","short_detail":"60+ World Travel Tips: Cheap Travel. Fear of Flying. Travel Motivation & Safety. Negotiation. Social Success Abroad.","detail":"<p>At that point the course will cover how to discover nearby gatherings to hang out, neighborhood occasions to go to anyplace on the planet, how to meet different explorers simply like you, how to go to astonishing occasions that will transform yourself at a reasonable cost anyplace on the planet. Figure out how to get 100% confided in nearby astounding independently directed visits that you can do without anyone else in any piece of the world, stunning ventures applications to use to grow your voyaging experience, how to discover explicit concentrated data on neighborhood mystery occasions, and how to discover astonishing free nature areas around the globe to unwind in. We at that point proceed onward to the tips on the most proficient method to make durable fellowships with different voyagers. Likewise, something that many individuals don't consider is dating while at the same time voyaging. Well here in this course, we will cover the most ideal approaches to date while voyaging. You will find the probably the best dating applications. We need you can concentrate on movement first and dating second.</p>","requirement":"Find the approaches to kill dejection and dread of voyaging and plan your movement for an astonishing travel encounters at a reasonable expense. The course will tell you the best way to deal with your cash and deal with your consumption effectively so you are never stuck anyplace with no cash during movement.","price":"2","discount_price":"1","day":null,"video":null,"url":null,"featured":"1","slug":"travel-hacking-smart-fun-travel","status":"1","preview_image":"157976457360.jpg","video_url":null,"preview_type":"url","type":"1","duration":null,"duration_type":"m","last_active":null,"instructor_revenue":null,"created_at":"2020-01-23T08:29:33.000000Z","updated_at":"2022-10-05T09:13:34.000000Z","involvement_request":"0","refund_policy_id":null,"level_tags":"trending","assignment_enable":"1","appointment_enable":"1","certificate_enable":"1","course_tags":null,"reject_txt":null,"drip_enable":"0","institude_id":"13","country":["INDIA"],"other_cats":["6"],"deleted_at":null}]

InstituteDetailsModel instituteDetailsModelFromJson(String str) =>
    InstituteDetailsModel.fromJson(json.decode(str));
String instituteDetailsModelToJson(InstituteDetailsModel data) =>
    json.encode(data.toJson());

class InstituteDetailsModel {
  InstituteDetailsModel({
    this.institute,
    this.course,
  });

  InstituteDetailsModel.fromJson(dynamic json) {
    if (json['institute'] != null) {
      institute = [];
      json['institute'].forEach((v) {
        institute!.add(Institute.fromJson(v));
      });
    }
    if (json['course'] != null) {
      course = [];
      json['course'].forEach((v) {
        course!.add(Course.fromJson(v));
      });
    }
  }
  List<Institute>? institute;
  List<Course>? course;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (institute != null) {
      map['institute'] = institute!.map((v) => v.toJson()).toList();
    }
    if (course != null) {
      map['course'] = course!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 20
/// user_id : "2"
/// category_id : "4"
/// subcategory_id : "11"
/// childcategory_id : "16"
/// language_id : "1"
/// title : "Travel Hacking -Smart & Fun Travel testerrrr"
/// short_detail : "60+ World Travel Tips: Cheap Travel. Fear of Flying. Travel Motivation & Safety. Negotiation. Social Success Abroad."
/// detail : "<p>At that point the course will cover how to discover nearby gatherings to hang out, neighborhood occasions to go to anyplace on the planet, how to meet different explorers simply like you, how to go to astonishing occasions that will transform yourself at a reasonable cost anyplace on the planet. Figure out how to get 100% confided in nearby astounding independently directed visits that you can do without anyone else in any piece of the world, stunning ventures applications to use to grow your voyaging experience, how to discover explicit concentrated data on neighborhood mystery occasions, and how to discover astonishing free nature areas around the globe to unwind in. We at that point proceed onward to the tips on the most proficient method to make durable fellowships with different voyagers. Likewise, something that many individuals don't consider is dating while at the same time voyaging. Well here in this course, we will cover the most ideal approaches to date while voyaging. You will find the probably the best dating applications. We need you can concentrate on movement first and dating second.</p>"
/// requirement : "Find the approaches to kill dejection and dread of voyaging and plan your movement for an astonishing travel encounters at a reasonable expense. The course will tell you the best way to deal with your cash and deal with your consumption effectively so you are never stuck anyplace with no cash during movement."
/// price : "2"
/// discount_price : "1"
/// day : null
/// video : null
/// url : null
/// featured : "1"
/// slug : "travel-hacking-smart-fun-travel"
/// status : "1"
/// preview_image : "157976457360.jpg"
/// video_url : null
/// preview_type : "url"
/// type : "1"
/// duration : null
/// duration_type : "m"
/// last_active : null
/// instructor_revenue : null
/// created_at : "2020-01-23T08:29:33.000000Z"
/// updated_at : "2022-10-05T09:13:34.000000Z"
/// involvement_request : "0"
/// refund_policy_id : null
/// level_tags : "trending"
/// assignment_enable : "1"
/// appointment_enable : "1"
/// certificate_enable : "1"
/// course_tags : null
/// reject_txt : null
/// drip_enable : "0"
/// institude_id : "13"
/// country : ["INDIA"]
/// other_cats : ["6"]
/// deleted_at : null

Course courseFromJson(String str) => Course.fromJson(json.decode(str));
String courseToJson(Course data) => json.encode(data.toJson());

class Course {
  Course({
    this.id,
    this.userId,
    this.categoryId,
    this.subcategoryId,
    this.childcategoryId,
    this.languageId,
    this.title,
    this.shortDetail,
    this.detail,
    this.requirement,
    this.price,
    this.discountPrice,
    this.day,
    this.video,
    this.url,
    this.featured,
    this.slug,
    this.status,
    this.previewImage,
    this.videoUrl,
    this.previewType,
    this.type,
    this.duration,
    this.durationType,
    this.lastActive,
    this.instructorRevenue,
    this.createdAt,
    this.updatedAt,
    this.involvementRequest,
    this.refundPolicyId,
    this.levelTags,
    this.assignmentEnable,
    this.appointmentEnable,
    this.certificateEnable,
    this.courseTags,
    this.rejectTxt,
    this.dripEnable,
    this.institudeId,
    this.country,
    this.otherCats,
    this.deletedAt,
  });

  Course.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    childcategoryId = json['childcategory_id'];
    languageId = json['language_id'];
    title = json['title'];
    shortDetail = json['short_detail'];
    detail = json['detail'];
    requirement = json['requirement'];
    price = json['price'];
    discountPrice = json['discount_price'];
    day = json['day'];
    video = json['video'];
    url = json['url'];
    featured = json['featured'];
    slug = json['slug'];
    status = json['status'];
    previewImage = json['preview_image'];
    videoUrl = json['video_url'];
    previewType = json['preview_type'];
    type = json['type'];
    duration = json['duration'];
    durationType = json['duration_type'];
    lastActive = json['last_active'];
    instructorRevenue = json['instructor_revenue'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    involvementRequest = json['involvement_request'];
    refundPolicyId = json['refund_policy_id'];
    levelTags = json['level_tags'];
    assignmentEnable = json['assignment_enable'];
    appointmentEnable = json['appointment_enable'];
    certificateEnable = json['certificate_enable'];
    courseTags = json['course_tags'];
    rejectTxt = json['reject_txt'];
    dripEnable = json['drip_enable'];
    institudeId = json['institude_id'];
    country = json['country'] != null ? json['country'].cast<String>() : [];
    otherCats =
        json['other_cats'] != null ? json['other_cats'].cast<String>() : [];
    deletedAt = json['deleted_at'];
  }
  num? id;
  String? userId;
  String? categoryId;
  String? subcategoryId;
  String? childcategoryId;
  String? languageId;
  String? title;
  String? shortDetail;
  String? detail;
  String? requirement;
  String? price;
  String? discountPrice;
  dynamic day;
  dynamic video;
  dynamic url;
  String? featured;
  String? slug;
  String? status;
  String? previewImage;
  dynamic videoUrl;
  String? previewType;
  String? type;
  dynamic duration;
  String? durationType;
  dynamic lastActive;
  dynamic instructorRevenue;
  String? createdAt;
  String? updatedAt;
  String? involvementRequest;
  dynamic refundPolicyId;
  String? levelTags;
  String? assignmentEnable;
  String? appointmentEnable;
  String? certificateEnable;
  dynamic courseTags;
  dynamic rejectTxt;
  String? dripEnable;
  String? institudeId;
  List<String>? country;
  List<String>? otherCats;
  dynamic deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['category_id'] = categoryId;
    map['subcategory_id'] = subcategoryId;
    map['childcategory_id'] = childcategoryId;
    map['language_id'] = languageId;
    map['title'] = title;
    map['short_detail'] = shortDetail;
    map['detail'] = detail;
    map['requirement'] = requirement;
    map['price'] = price;
    map['discount_price'] = discountPrice;
    map['day'] = day;
    map['video'] = video;
    map['url'] = url;
    map['featured'] = featured;
    map['slug'] = slug;
    map['status'] = status;
    map['preview_image'] = previewImage;
    map['video_url'] = videoUrl;
    map['preview_type'] = previewType;
    map['type'] = type;
    map['duration'] = duration;
    map['duration_type'] = durationType;
    map['last_active'] = lastActive;
    map['instructor_revenue'] = instructorRevenue;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['involvement_request'] = involvementRequest;
    map['refund_policy_id'] = refundPolicyId;
    map['level_tags'] = levelTags;
    map['assignment_enable'] = assignmentEnable;
    map['appointment_enable'] = appointmentEnable;
    map['certificate_enable'] = certificateEnable;
    map['course_tags'] = courseTags;
    map['reject_txt'] = rejectTxt;
    map['drip_enable'] = dripEnable;
    map['institude_id'] = institudeId;
    map['country'] = country;
    map['other_cats'] = otherCats;
    map['deleted_at'] = deletedAt;
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
    affilatedBy = json['affilated'];
    address = json['address'];
    slug = json['slug'];
  }
  num? id;
  String? title;
  String? detail;
  String? userId;
  String? image;
  String? status;
  String? verified;
  String? skill;
  String? createdAt;
  String? updatedAt;
  String? email;
  String? mobile;
  String? affilatedBy;
  String? address;
  String? slug;

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
    map['affilated'] = affilatedBy;
    map['address'] = address;
    map['slug'] = slug;
    return map;
  }
}
