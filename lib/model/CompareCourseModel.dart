import 'dart:convert';


CompareCourseModel compareCourseModelFromJson(String str) =>
    CompareCourseModel.fromJson(json.decode(str));
String compareCourseModelToJson(CompareCourseModel data) =>
    json.encode(data.toJson());

class CompareCourseModel {
  CompareCourseModel({
    this.compare,
  });

  CompareCourseModel.fromJson(dynamic json) {
    if (json['compare'] != null) {
      compare = [];
      json['compare'].forEach((v) {
        compare!.add(Compare.fromJson(v));
      });
    }
  }
  List<Compare>? compare;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (compare != null) {
      map['compare'] = compare!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}



Compare compareFromJson(String str) => Compare.fromJson(json.decode(str));
String compareToJson(Compare data) => json.encode(data.toJson());

class Compare {
  Compare({
    this.id,
    this.userId,
    this.courseId,
    this.createdAt,
    this.updatedAt,
    this.compares,
  });

  Compare.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    courseId = json['course_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['compares'] != null) {
      compares = [];
      json['compares'].forEach((v) {
        compares!.add(Compares.fromJson(v));
      });
    }
  }
  num? id;
  String? userId;
  String? courseId;
  String? createdAt;
  String? updatedAt;
  List<Compares>? compares;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['course_id'] = courseId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (compares != null) {
      map['compares'] = compares!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}




Compares comparesFromJson(String str) => Compares.fromJson(json.decode(str));
String comparesToJson(Compares data) => json.encode(data.toJson());

class Compares {
  Compares({
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

  Compares.fromJson(dynamic json) {
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
    involvementRequest = json['involvement_request'].toString();
    refundPolicyId = json['refund_policy_id'];
    levelTags = json['level_tags'];
    assignmentEnable = json['assignment_enable'].toString();
    appointmentEnable = json['appointment_enable'].toString();
    certificateEnable = json['certificate_enable'].toString();
    courseTags =
        json['course_tags'] != null ? json['course_tags'].cast<String>() : [];
    rejectTxt = json['reject_txt'];
    dripEnable = json['drip_enable'].toString();
    institudeId = json['institude_id'];
    country = json['country'];
    otherCats = json['other_cats'];
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
  String? url;
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
  List<String>? courseTags;
  String? rejectTxt;
  String? dripEnable;
  String? institudeId;
  dynamic country;
  dynamic otherCats;
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


/// compare : [{"id":11,"user_id":"13","course_id":"4","created_at":"2022-12-13T12:58:08.000000Z","updated_at":"2022-12-13T12:58:08.000000Z","compares":[{"id":4,"user_id":"2","category_id":"6","subcategory_id":"16","childcategory_id":"16","language_id":"1","title":"Internationally Accredited Diploma in Yoga Training","short_detail":"Start a New Career in Yoga with this Yoga Course for Beginners/Intermediates","detail":"<p>Now earn your INTERNATIONALLY ACCREDITED DIPLOMA IN YOGA TRAINING accredited by CPD Certification Service, which is an independent body that ensures qualifications are in line with the most current professional standards. This means this course comply with universally accepted principles of Continual Professional Development (CPD) and have been structured to meet the criteria of personal development plans. CPD certification means that the content and structure of the courses have been independently assessed and approved for multi-disciplinary and industry-wide continuing personal and professional development purposes.</p>","requirement":"A Yoga Mat\r\nWillingness to apply Yogic knowledge into regular practice","price":"1500","discount_price":"500","day":null,"video":null,"url":"https://www.youtube.com/watch?v=VaoV1PrYft4","featured":"1","slug":"internationally-accredited-diploma-in-yoga-training","status":"1","preview_image":"yoga.jpg","video_url":null,"preview_type":"url","type":"1","duration":null,"duration_type":"m","last_active":null,"instructor_revenue":null,"created_at":"2020-01-22T11:22:23.000000Z","updated_at":"2022-03-29T06:48:32.000000Z","involvement_request":"0","refund_policy_id":null,"level_tags":"trending","assignment_enable":"1","appointment_enable":"1","certificate_enable":"1","course_tags":["test"],"reject_txt":"<p>Rejected</p>","drip_enable":"0","institude_id":"2","country":null,"other_cats":null,"deleted_at":null}]},{"id":12,"user_id":"13","course_id":"8","created_at":"2022-12-13T13:10:08.000000Z","updated_at":"2022-12-13T13:10:08.000000Z","compares":[{"id":8,"user_id":"1","category_id":"5","subcategory_id":"14","childcategory_id":"19","language_id":"1","title":"Adobe Lightroom","short_detail":"Learn Lightroom Classic CC by Doing Real Time Work - Edit Images to Impress","detail":"<p>Lightroom is most well known programming utilized by milions of picture takers and understanding this product is frequently a key to the stunning pictures. As of now you are in the best spot to begin, having proficient retoucher as your educator!</p>","requirement":"No  prior experience with the software\r\nYou need PC or Laptop\r\nLightroom Classic CC Software","price":"1200","discount_price":"500","day":null,"video":null,"url":"https://www.youtube.com/watch?v=f6RRKgQRQII&list=PL3jDvU7Nxe6GB4Wi01s9kN27XHVPso6D9","featured":"1","slug":"adobe-lightroom","status":"1","preview_image":"1579694025download.jpg","video_url":null,"preview_type":"url","type":"1","duration":null,"duration_type":"m","last_active":null,"instructor_revenue":null,"created_at":"2020-01-22T12:53:45.000000Z","updated_at":"2021-10-29T03:11:36.000000Z","involvement_request":"0","refund_policy_id":null,"level_tags":null,"assignment_enable":"1","appointment_enable":"1","certificate_enable":"1","course_tags":null,"reject_txt":null,"drip_enable":"0","institude_id":"","country":null,"other_cats":null,"deleted_at":null}]}]


/// id : 11
/// user_id : "13"
/// course_id : "4"
/// created_at : "2022-12-13T12:58:08.000000Z"
/// updated_at : "2022-12-13T12:58:08.000000Z"
/// compares : [{"id":4,"user_id":"2","category_id":"6","subcategory_id":"16","childcategory_id":"16","language_id":"1","title":"Internationally Accredited Diploma in Yoga Training","short_detail":"Start a New Career in Yoga with this Yoga Course for Beginners/Intermediates","detail":"<p>Now earn your INTERNATIONALLY ACCREDITED DIPLOMA IN YOGA TRAINING accredited by CPD Certification Service, which is an independent body that ensures qualifications are in line with the most current professional standards. This means this course comply with universally accepted principles of Continual Professional Development (CPD) and have been structured to meet the criteria of personal development plans. CPD certification means that the content and structure of the courses have been independently assessed and approved for multi-disciplinary and industry-wide continuing personal and professional development purposes.</p>","requirement":"A Yoga Mat\r\nWillingness to apply Yogic knowledge into regular practice","price":"1500","discount_price":"500","day":null,"video":null,"url":"https://www.youtube.com/watch?v=VaoV1PrYft4","featured":"1","slug":"internationally-accredited-diploma-in-yoga-training","status":"1","preview_image":"yoga.jpg","video_url":null,"preview_type":"url","type":"1","duration":null,"duration_type":"m","last_active":null,"instructor_revenue":null,"created_at":"2020-01-22T11:22:23.000000Z","updated_at":"2022-03-29T06:48:32.000000Z","involvement_request":"0","refund_policy_id":null,"level_tags":"trending","assignment_enable":"1","appointment_enable":"1","certificate_enable":"1","course_tags":["test"],"reject_txt":"<p>Rejected</p>","drip_enable":"0","institude_id":"2","country":null,"other_cats":null,"deleted_at":null}]

/// id : 4
/// user_id : "2"
/// category_id : "6"
/// subcategory_id : "16"
/// childcategory_id : "16"
/// language_id : "1"
/// title : "Internationally Accredited Diploma in Yoga Training"
/// short_detail : "Start a New Career in Yoga with this Yoga Course for Beginners/Intermediates"
/// detail : "<p>Now earn your INTERNATIONALLY ACCREDITED DIPLOMA IN YOGA TRAINING accredited by CPD Certification Service, which is an independent body that ensures qualifications are in line with the most current professional standards. This means this course comply with universally accepted principles of Continual Professional Development (CPD) and have been structured to meet the criteria of personal development plans. CPD certification means that the content and structure of the courses have been independently assessed and approved for multi-disciplinary and industry-wide continuing personal and professional development purposes.</p>"
/// requirement : "A Yoga Mat\r\nWillingness to apply Yogic knowledge into regular practice"
/// price : "1500"
/// discount_price : "500"
/// day : null
/// video : null
/// url : "https://www.youtube.com/watch?v=VaoV1PrYft4"
/// featured : "1"
/// slug : "internationally-accredited-diploma-in-yoga-training"
/// status : "1"
/// preview_image : "yoga.jpg"
/// video_url : null
/// preview_type : "url"
/// type : "1"
/// duration : null
/// duration_type : "m"
/// last_active : null
/// instructor_revenue : null
/// created_at : "2020-01-22T11:22:23.000000Z"
/// updated_at : "2022-03-29T06:48:32.000000Z"
/// involvement_request : "0"
/// refund_policy_id : null
/// level_tags : "trending"
/// assignment_enable : "1"
/// appointment_enable : "1"
/// certificate_enable : "1"
/// course_tags : ["test"]
/// reject_txt : "<p>Rejected</p>"
/// drip_enable : "0"
/// institude_id : "2"
/// country : null
/// other_cats : null
/// deleted_at : null