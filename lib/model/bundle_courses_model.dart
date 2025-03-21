class BundleCourses {
  int? id;
  String? title;
  String? detail;
  String? price;
  String? discountPrice;
  String? courseId;
  String? image;
  String? instructorId;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? userId;
  int? courseIncluded;
  int? vendorId;
  int? isSubscription;
  String? icon;
  String? billing;
  String? priceId;
  String? productId;
  String? subtitle;
  int? buynow;
  int? organizationId;
  String? duration;
  int? durationId;
  String? short;
  String? totalRevenue;
  int? totalUsers;
  String? instructorName;
  String? instructorImage;

  BundleCourses({
    this.id,
    this.title,
    this.detail,
    this.price,
    this.discountPrice,
    this.courseId,
    this.image,
    this.instructorId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.courseIncluded,
    this.vendorId,
    this.isSubscription,
    this.icon,
    this.billing,
    this.priceId,
    this.productId,
    this.subtitle,
    this.buynow,
    this.organizationId,
    this.duration,
    this.durationId,
    this.short,
    this.totalRevenue,
    this.totalUsers,
    this.instructorName,
    this.instructorImage,
  });

  factory BundleCourses.fromJson(Map<String, dynamic> json) {
    return BundleCourses(
      id: json['id'],
      title: json['title'],
      detail: json['detail'],
      price: json['price'],
      discountPrice: json['discount_price'],
      courseId: json['course_id'],
      image: json['image'],
      instructorId: json['instructor_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
      courseIncluded: json['course_included'],
      vendorId: json['vendor_id'],
      isSubscription: json['is_subscription'],
      icon: json['icon'],
      billing: json['billing'],
      priceId: json['price_id'],
      productId: json['product_id'],
      subtitle: json['subtitle'],
      buynow: json['buynow'],
      organizationId: json['organization_id'],
      duration: json['duration'],
      durationId: json['duration_id'],
      short: json['short'],
      totalRevenue: json['total_revenue'],
      totalUsers: json['total_users'],
      instructorName: json['instructor_name'],
      instructorImage: json['instructor_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['detail'] = this.detail;
    data['price'] = this.price;
    data['discount_price'] = this.discountPrice;
    data['course_id'] = this.courseId;
    data['image'] = this.image;
    data['instructor_id'] = this.instructorId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    data['course_included'] = this.courseIncluded;
    data['vendor_id'] = this.vendorId;
    data['is_subscription'] = this.isSubscription;
    data['icon'] = this.icon;
    data['billing'] = this.billing;
    data['price_id'] = this.priceId;
    data['product_id'] = this.productId;
    data['subtitle'] = this.subtitle;
    data['buynow'] = this.buynow;
    data['organization_id'] = this.organizationId;
    data['duration'] = this.duration;
    data['duration_id'] = this.durationId;
    data['short'] = this.short;
    data['total_revenue'] = this.totalRevenue;
    data['total_users'] = this.totalUsers;
    data['instructor_name'] = this.instructorName;
    data['instructor_image'] = this.instructorImage;
    return data;
  }
}


// class BundleCourses {
//   int? id;
//   String? userId;
//   List<String>? courseId;
//   String? title;
//   String? detail;
//   dynamic price;
//   dynamic discountPrice;
//   String? type;
//   String? slug;
//   dynamic status;
//   dynamic featured;
//   String? previewImage;
//   String? createdAt;
//   String? updatedAt;

//   BundleCourses({
//     this.id,
//     this.userId,
//     this.courseId,
//     this.title,
//     this.detail,
//     this.price,
//     this.discountPrice,
//     this.type,
//     this.slug,
//     this.status,
//     this.featured,
//     this.previewImage,
//     this.createdAt,
//     this.updatedAt,
//   });

//   BundleCourses.fromJson(Map<String, dynamic> json) {
//     id = json["id"];
//     userId = json["user_id"];
//     courseId = json["course_id"];
//     title = json["title"];
//     detail = json["detail"];
//     price = json["price"];
//     discountPrice = json["discount_price"];
//     type = json["type"];
//     slug = json["slug"];
//     status = json["status"].toString();
//     featured = json["featured"];
//     previewImage = json["preview_image"];
//     createdAt = json["created_at"];
//     updatedAt = json["updated_at"];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data["id"] = id;
//     data["user_id"] = userId;
//     data["course_id"] = courseId;
//     data["title"] = title;
//     data["detail"] = detail;
//     data["price"] = price;
//     data["discount_price"] = discountPrice;
//     data["type"] = type;
//     data["slug"] = slug;
//     data["status"] = status;
//     data["featured"] = featured;
//     data["preview_image"] = previewImage;
//     data["created_at"] = createdAt;
//     data["updated_at"] = updatedAt;
//     return data;
//   }
// }
