// File: lib/model/course.dart
class Course {
  final int? id;
  final String? userId;
  final String? categoryId;
  final String? subcategoryId;
  final String? childcategoryId;
  final String? languageId;
  final String? title;
  final String? shortDetail;
  final String? detail;
  final String? requirement;
  final String? price;
  final String? discountPrice;
  final String? day;
  final String? video;
  final String? url;
  final String? featured;
  final String? slug;
  final String? status;
  final String? previewImage;
  final String? videoUrl;
  final String? previewType;
  final String? type;
  final String? duration;
  final String? lastActive;
  final String? createdAt;
  final String? updatedAt;
  final String? include;
  final String? whatlearns;
  final String? review;
  final String? imageUrl;
  final String? categoryName;
  final String? instructorName;
  final String? instructorImage;
  final String? rating;
  final String? ratingCount;
  final String? totalLessons;

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
    this.lastActive,
    this.createdAt,
    this.updatedAt,
    this.include,
    this.whatlearns,
    this.review,
    this.imageUrl,
    this.categoryName,
    this.instructorName,
    this.instructorImage,
    this.rating,
    this.ratingCount,
    this.totalLessons,
  });

  // Factory method to convert from DummyCourse to Course
  factory Course.fromDummyCourse(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      userId: json['userId']?.toString() ?? '1',
      categoryId: json['categoryId']?.toString() ?? '1',
      subcategoryId: json['subcategoryId']?.toString() ?? '1',
      childcategoryId: json['childcategoryId']?.toString() ?? '1',
      languageId: json['languageId']?.toString() ?? '1',
      title: json['title'],
      shortDetail: json['shortDetail'] ?? json['description']?.substring(0, min(50, json['description']?.length ?? 0)),
      detail: json['detail'] ?? json['description'],
      requirement: json['requirement'] ?? 'No specific requirements',
      price: json['price']?.toString(),
      discountPrice: json['discountPrice']?.toString(),
      day: json['day'] ?? json['duration'],
      video: json['video'] ?? 'no-video.mp4',
      url: json['url'] ?? '',
      featured: json['featured'] == true ? '1' : '0',
      slug: json['slug'] ?? 'course-${json['id']}',
      status: json['status'] ?? '1',
      previewImage: json['previewImage'] ?? json['imageUrl'],
      videoUrl: json['videoUrl'] ?? '',
      previewType: json['previewType'] ?? 'image',
      type: json['type'] ?? '1',
      duration: json['duration'],
      lastActive: json['lastActive'] ?? DateTime.now().toString(),
      createdAt: json['createdAt'] ?? DateTime.now().subtract(Duration(days: 30)).toString(),
      updatedAt: json['updatedAt'] ?? DateTime.now().toString(),
      include: json['include'] ?? 'What\'s included',
      whatlearns: json['whatlearns'] ?? 'What you\'ll learn',
      review: json['review']?.toString() ?? json['rating']?.toString(),
      imageUrl: json['imageUrl'],
      categoryName: json['categoryName']?.toString(),
      instructorName: json['instructorName'],
      instructorImage: json['instructorImage'],
      rating: json['rating']?.toString(),
      ratingCount: json['ratingCount']?.toString(),
      totalLessons: json['totalLessons']?.toString(),
    );
  }
}

// Helper function for string manipulation
int min(int a, int b) {
  return a < b ? a : b;
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
