// import 'package:kloncept/model/dummy/dummy_model.dart';

// class Review {
//   final int? id;
//   final int? userId;
//   final int? courseId;
//   final dynamic learn;
//   final dynamic price;
//   final dynamic value;
//   final String? title;
//   final String? details;
//   final String? status;
//   final String? createdAt;
//   final String? updatedAt;
//   final String? userName;
//   final String? userImage;

//   Review({
//     this.id,
//     this.userId,
//     this.courseId,
//     this.learn,
//     this.price,
//     this.value,
//     this.title,
//     this.details,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//     this.userName,
//     this.userImage,
//   });

//   // Factory method to create a Review from a DummyReview
//   factory Review.fromDummyReview(DummyReview dummyReview) {
//     return Review(
//       id: dummyReview.id,
//       userId: dummyReview.userId,
//       courseId: dummyReview.courseId,
//       learn: dummyReview.learn,
//       price: dummyReview.price,
//       value: dummyReview.value,
//       title: dummyReview.title,
//       details: dummyReview.details,
//       status: dummyReview.status,
//       createdAt: dummyReview.createdAt,
//       updatedAt: dummyReview.updatedAt,
//       userName: dummyReview.userName,
//       userImage: dummyReview.userImage,
//     );
//   }
// }



class Review {
  Review({
    this.id,
    this.courseId,
    this.userId,
    this.learn,
    this.price,
    this.value,
    this.review,
    this.status,
    this.approved,
    this.featured,
    this.createdAt,
    this.updatedAt,
    required String userName,
    required userImage,
    required String comment,
  });

  int? id;
  String? courseId;
  String? userId;
  dynamic learn;
  dynamic price;
  dynamic value;
  String? review;
  dynamic status;
  dynamic approved;
  dynamic featured;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        courseId: json["course_id"],
        userId: json["user_id"],
        learn: json["learn"],
        price: json["price"],
        value: json["value"],
        review: json["review"],
        status: json["status"],
        approved: json["approved"],
        featured: json["featured"] == null ? null : json["featured"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userName: '',
        userImage: 'assets/images/cate1.png',
        comment: '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "user_id": userId,
        "learn": learn,
        "price": price,
        "value": value,
        "review": review,
        "status": status,
        "approved": approved,
        "featured": featured == null ? null : featured,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
