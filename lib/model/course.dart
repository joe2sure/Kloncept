import '../model/review.dart';
import 'include.dart';

class Course {
  Course(
      {this.id,
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
      this.thumbnail,
      this.instructorName,
      this.instructorImage,
      this.categoryName,
      this.rating,
      this.progress,
      this.previewType,
      this.type,
      this.duration,
      this.durationType,
      this.lastActive,
      this.createdAt,
      this.updatedAt,
      this.include,
      this.whatlearns,
      this.review,
      this.country});

  int? id;
  String? userId;
  String? categoryId;
  String? subcategoryId;
  String? childcategoryId;
  String? languageId;
  String? title;
  String? shortDetail;
  String? detail;
  String? requirement;
  num? price;
  num? discountPrice;
  String? day;
  String? video;
  String? thumbnail;
  String? instructorName;
  String? instructorImage;
  String? categoryName;
  String? rating;
  int? progress;
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
  String? lastActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Include>? include;
  List<Include>? whatlearns;
  List<Review>? review;
  String? country;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        childcategoryId: json["childcategory_id"],
        languageId: json["language_id"],
        title: json["title"],
        shortDetail: json["short_detail"],
        detail: json["detail"],
        requirement: json["requirement"],
        price: json["price"] == null ? null : json["price"],
        discountPrice:
            json["discount_price"] == null ? null : json["discount_price"],
        day: json["day"] == null ? null : json["day"],
        thumbnail: json['thumbnail'] == null ? null : json["thumbnail"],
        instructorName: json['instructor_name'] == null ? null : json["instructor_name"],
        instructorImage: json['instructor_image'] == null ? null : json["instructor_image"],
        rating: json['rating'] == null ? null : json["rating"],
        progress: json['progress'] == null ? null : json["progress"],
        video: json["video"] == null ? null : json["video"],
        url: json["url"] == null ? null : json["url"],
        featured: json["featured"],
        slug: json["slug"],
        status: json["status"],
        previewImage:
            json["preview_image"] == null ? null : json["preview_image"],
        videoUrl: json["video_url"],
        previewType: json["preview_type"],
        type: json["type"],
        duration: json["duration"] == null ? null : json["duration"],
        durationType:
            json["duration_type"] == null ? null : json["duration_type"],
        lastActive: json["last_active"] == null ? null : json["last_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        include:
            List<Include>.from(json["include"].map((x) => Include.fromJson(x))),
        whatlearns: List<Include>.from(
            json["whatlearns"].map((x) => Include.fromJson(x))),
        review: json["review"] == null
            ? null
            : List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
        country: json["country"] == null ? "None" : json["country"].toString(),
      );

  // Add this new factory method to convert from DummyCourse
  factory Course.fromDummyCourse(Map<String, dynamic> json) {
    return Course(
      id: json["id"],
      userId: json["userId"]?.toString(),
      categoryId: json["categoryId"]?.toString(),
      subcategoryId: json["subcategoryId"]?.toString(),
      childcategoryId: json["childcategoryId"]?.toString(),
      languageId: json["languageId"]?.toString(),
      title: json["title"],
      shortDetail: json["shortDetail"],
      detail: json["detail"],
      requirement: json["requirement"],
      price: json["price"],
      discountPrice: json["discountPrice"],
      day: json["day"],
      video: json["video"],
      url: json["url"],
      featured: json["featured"]?.toString(),
      slug: json["slug"],
      status: json["status"],
      previewImage: json["previewImage"],
      videoUrl: json["videoUrl"],
      previewType: json["previewType"],
      type: json["type"],
      duration: json["duration"],
      lastActive: json["lastActive"],
      createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
      updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
      include: json["include"] != null ? [Include(id: 0, detail: json["include"])] : [],
      whatlearns: json["whatlearns"] != null ? [Include(id: 0, detail: json["whatlearns"])] : [],
      review: [],
      thumbnail: json["imageUrl"],
      instructorName: json["instructorName"],
      instructorImage: json["instructorImage"],
      categoryName: json["categoryName"]?.toString(),
      rating: json["rating"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "childcategory_id": childcategoryId,
        "language_id": languageId,
        "title": title,
        "short_detail": shortDetail,
        "detail": detail,
        "requirement": requirement,
        "price": price == null ? null : price,
        "discount_price": discountPrice == null ? null : discountPrice,
        "day": day == null ? null : day,
        "video": video == null ? null : video,
        "url": url == null ? null : url,
        "featured": featured,
        "slug": slug,
        "status": status,
        "preview_image": previewImage == null ? null : previewImage,
        "video_url": videoUrl,
        "preview_type": previewType,
        "type": type,
        "duration": duration == null ? null : duration,
        "duration_type": durationType == null ? null : durationType,
        "last_active": lastActive == null ? null : lastActive,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "include": List<dynamic>.from(include!.map((x) => x.toJson())),
        "whatlearns": List<dynamic>.from(whatlearns!.map((x) => x.toJson())),
        "review": List<dynamic>.from(review!.map((x) => x.toJson())),
        "country": country,
        "rating": rating,
        "progress": progress,
        "instructor_name": instructorName,
        "instructor_image" :instructorImage,
        "thumbnail" : thumbnail,
      };
}

enum PreviewType { URL, VIDEO }

final previewTypeValues =
    EnumValues({"url": PreviewType.URL, "video": PreviewType.VIDEO});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}


// import '../model/review.dart';
// import 'include.dart';

// class Course {
//   Course(
//       {this.id,
//       this.userId,
//       this.categoryId,
//       this.subcategoryId,
//       this.childcategoryId,
//       this.languageId,
//       this.title,
//       this.shortDetail,
//       this.detail,
//       this.requirement,
//       this.price,
//       this.discountPrice,
//       this.day,
//       this.video,
//       this.url,
//       this.featured,
//       this.slug,
//       this.status,
//       this.previewImage,
//       this.videoUrl,
//       this.thumbnail,
//       this.instructorName,
//       this.instructorImage,
//       this.categoryName,
//       this.rating,
//       this.progress,
//       this.previewType,
//       this.type,
//       this.duration,
//       this.durationType,
//       this.lastActive,
//       this.createdAt,
//       this.updatedAt,
//       this.include,
//       this.whatlearns,
//       this.review,
//       this.country});

//   int? id;
//   String? userId;
//   String? categoryId;
//   String? subcategoryId;
//   String? childcategoryId;
//   String? languageId;
//   String? title;
//   String? shortDetail;
//   String? detail;
//   String? requirement;
//   num? price;
//   num? discountPrice;
//   String? day;
//   String? video;
//   String? thumbnail;
//   String? instructorName;
//   String? instructorImage;
//   String? categoryName;
//   String? rating;
//   int? progress;
//   String? url;
//   String? featured;
//   String? slug;
//   String? status;
//   String? previewImage;
//   dynamic videoUrl;
//   String? previewType;
//   String? type;
//   dynamic duration;
//   String? durationType;
//   String? lastActive;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   List<Include>? include;
//   List<Include>? whatlearns;
//   List<Review>? review;
//   String? country;

//   factory Course.fromJson(Map<String, dynamic> json) => Course(
//         id: json["id"],
//         userId: json["user_id"],
//         categoryId: json["category_id"],
//         subcategoryId: json["subcategory_id"],
//         childcategoryId: json["childcategory_id"],
//         languageId: json["language_id"],
//         title: json["title"],
//         shortDetail: json["short_detail"],
//         detail: json["detail"],
//         requirement: json["requirement"],
//         price: json["price"] == null ? null : json["price"],
//         discountPrice:
//             json["discount_price"] == null ? null : json["discount_price"],
//         day: json["day"] == null ? null : json["day"],
//         thumbnail: json['thumbnail'] == null ? null : json["thumbnail"],
//            instructorName: json['instructor_name'] == null ? null : json["instructor_name"],
//       instructorImage: json['instructor_image'] == null ? null : json["instructor_image"],
//             rating: json['rating'] == null ? null : json["rating"],
            
//       progress: json['progress'] == null ? null : json["progress"],
//         video: json["video"] == null ? null : json["video"],
//         url: json["url"] == null ? null : json["url"],
//         featured: json["featured"],
//         slug: json["slug"],
//         status: json["status"],
//         previewImage:
//             json["preview_image"] == null ? null : json["preview_image"],
//         videoUrl: json["video_url"],
//         previewType: json["preview_type"],
//         type: json["type"],
//         duration: json["duration"] == null ? null : json["duration"],
//         durationType:
//             json["duration_type"] == null ? null : json["duration_type"],
//         lastActive: json["last_active"] == null ? null : json["last_active"],
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         include:
//             List<Include>.from(json["include"].map((x) => Include.fromJson(x))),
//         whatlearns: List<Include>.from(
//             json["whatlearns"].map((x) => Include.fromJson(x))),
//         review: json["review"] == null
//             ? null
//             : List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
//         country: json["country"] == null ? "None" : json["country"].toString(),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "user_id": userId,
//         "category_id": categoryId,
//         "subcategory_id": subcategoryId,
//         "childcategory_id": childcategoryId,
//         "language_id": languageId,
//         "title": title,
//         "short_detail": shortDetail,
//         "detail": detail,
//         "requirement": requirement,
//         "price": price == null ? null : price,
//         "discount_price": discountPrice == null ? null : discountPrice,
//         "day": day == null ? null : day,
//         "video": video == null ? null : video,
//         "url": url == null ? null : url,
//         "featured": featured,
//         "slug": slug,
//         "status": status,
//         "preview_image": previewImage == null ? null : previewImage,
//         "video_url": videoUrl,
//         "preview_type": previewType,
//         "type": type,
//         "duration": duration == null ? null : duration,
//         "duration_type": durationType == null ? null : durationType,
//         "last_active": lastActive == null ? null : lastActive,
//         "created_at": createdAt!.toIso8601String(),
//         "updated_at": updatedAt!.toIso8601String(),
//         "include": List<dynamic>.from(include!.map((x) => x.toJson())),
//         "whatlearns": List<dynamic>.from(whatlearns!.map((x) => x.toJson())),
//         "review": List<dynamic>.from(review!.map((x) => x.toJson())),
//         "country": country,
//         "rating": rating,
//         "progress": progress,
//         "instructor_name": instructorName,
//         "instructor_image" :instructorImage,
//         "thumbnail" : thumbnail,
//       };
// }

// enum PreviewType { URL, VIDEO }

// final previewTypeValues =
//     EnumValues({"url": PreviewType.URL, "video": PreviewType.VIDEO});

// class EnumValues<T> {
//   Map<String, T>? map;
//   Map<T, String>? reverseMap;

//   EnumValues(this.map);

//   Map<T, String>? get reverse {
//     if (reverseMap == null) {
//       reverseMap = map!.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
