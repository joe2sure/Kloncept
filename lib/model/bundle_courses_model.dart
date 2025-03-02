class BundleCourses {
  int? id;
  String? userId;
  List<String>? courseId;
  String? title;
  String? detail;
  dynamic price;
  dynamic discountPrice;
  String? type;
  String? slug;
  dynamic status;
  dynamic featured;
  String? previewImage;
  String? createdAt;
  String? updatedAt;

  BundleCourses({
    this.id,
    this.userId,
    this.courseId,
    this.title,
    this.detail,
    this.price,
    this.discountPrice,
    this.type,
    this.slug,
    this.status,
    this.featured,
    this.previewImage,
    this.createdAt,
    this.updatedAt,
  });

  BundleCourses.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["user_id"];
    courseId = json["course_id"];
    title = json["title"];
    detail = json["detail"];
    price = json["price"];
    discountPrice = json["discount_price"];
    type = json["type"];
    slug = json["slug"];
    status = json["status"].toString();
    featured = json["featured"];
    previewImage = json["preview_image"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["user_id"] = userId;
    data["course_id"] = courseId;
    data["title"] = title;
    data["detail"] = detail;
    data["price"] = price;
    data["discount_price"] = discountPrice;
    data["type"] = type;
    data["slug"] = slug;
    data["status"] = status;
    data["featured"] = featured;
    data["preview_image"] = previewImage;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}
