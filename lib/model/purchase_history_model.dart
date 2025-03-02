class PurchaseHistory {
  PurchaseHistory({
    this.orderhistory,
  });

  List<Orderhistory>? orderhistory;

  factory PurchaseHistory.fromJson(Map<String, dynamic> json) =>
      PurchaseHistory(
        orderhistory: List<Orderhistory>.from(
            json["orderhistory"].map((x) => Orderhistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderhistory":
            List<dynamic>.from(orderhistory!.map((x) => x.toJson())),
      };
}

class Orderhistory {
  Orderhistory({
    required this.id,
    this.courseId,
    this.userId,
    this.instructorId,
    this.orderId,
    required this.transactionId,
    required this.paymentMethod,
    this.totalAmount,
    this.couponDiscount,
    required this.currency,
    required this.currencyIcon,
    this.status,
    this.duration,
    required this.enrollStart,
    required this.enrollExpire,
    this.instructorRevenue,
    this.bundleId,
    required this.bundleCourseId,
    this.proof,
    // ignore: non_constant_identifier_names
    this.sale_id,
    required this.createdAt,
    required this.updatedAt,
    required this.courses,
  });

  dynamic id;
  dynamic courseId;
  dynamic userId;
  dynamic instructorId;
  dynamic orderId;
  dynamic transactionId;
  dynamic paymentMethod;
  dynamic totalAmount;
  dynamic couponDiscount;
  dynamic currency;
  dynamic currencyIcon;
  dynamic status;
  dynamic duration;
  DateTime? enrollStart;
  DateTime? enrollExpire;
  dynamic instructorRevenue;
  dynamic bundleId;
  List<dynamic>? bundleCourseId;
  dynamic proof;
  // ignore: non_constant_identifier_names
  dynamic sale_id;
  DateTime? createdAt;
  DateTime? updatedAt;
  Courses? courses;

  factory Orderhistory.fromJson(Map<String, dynamic> json) => Orderhistory(
        id: json["id"],
        courseId: json["course_id"] == null ? null : json["course_id"],
        userId: json["user_id"],
        instructorId: json["instructor_id"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        transactionId:
            json["transaction_id"] == null ? '' : json["transaction_id"],
        paymentMethod: json["payment_method"],
        totalAmount: json["total_amount"],
        couponDiscount:
            json["coupon_discount"] == null ? '' : json["coupon_discount"],
        currency: json["currency"],
        currencyIcon: json["currency_icon"],
        status: json["status"],
        duration: json["duration"] == null ? '' : json["duration"],
        enrollStart: json["enroll_start"] == null
            ? null
            : DateTime.parse(json["enroll_start"]),
        enrollExpire: json["enroll_expire"] == null
            ? null
            : DateTime.parse(json["enroll_expire"]),
        instructorRevenue: json["instructor_revenue"],
        bundleId: json["bundle_id"] == null ? null : json["bundle_id"],
        bundleCourseId: json["bundle_course_id"] == null
            ? null
            : List<String>.from(json["bundle_course_id"].map((x) => x)),
        proof: json["proof"],
        sale_id: json["sale_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        courses:
            json["courses"] == '' ? null : Courses.fromJson(json["courses"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId == null ? null : courseId,
        "user_id": userId,
        "instructor_id": instructorId,
        "order_id": orderId == null ? null : orderId,
        "transaction_id": transactionId,
        "payment_method": paymentMethod,
        "total_amount": totalAmount,
        "coupon_discount": couponDiscount == null ? null : couponDiscount,
        "status": status,
        "duration": duration == null ? null : duration,
        "enroll_start": enrollStart == null
            ? null
            : "${enrollStart!.year.toString().padLeft(4, '0')}-${enrollStart!.month.toString().padLeft(2, '0')}-${enrollStart!.day.toString().padLeft(2, '0')}",
        "enroll_expire": enrollExpire == null
            ? null
            : "${enrollExpire!.year.toString().padLeft(4, '0')}-${enrollExpire!.month.toString().padLeft(2, '0')}-${enrollExpire!.day.toString().padLeft(2, '0')}",
        "instructor_revenue": instructorRevenue,
        "bundle_id": bundleId == null ? null : bundleId,
        "bundle_course_id": bundleCourseId == null
            ? null
            : List<dynamic>.from(bundleCourseId!.map((x) => x)),
        "proof": proof,
        "sale_id": sale_id,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "courses": courses == null ? null : courses!.toJson(),
      };
}

class Courses {
  Courses({
    required this.id,
    this.userId,
    this.categoryId,
    this.subcategoryId,
    this.childcategoryId,
    this.languageId,
    required this.title,
    required this.shortDetail,
    required this.detail,
    required this.requirement,
    this.price,
    this.discountPrice,
    this.day,
    required this.video,
    required this.url,
    this.featured,
    this.slug,
    this.status,
    this.previewImage,
    this.videoUrl,
    this.previewType,
    this.type,
    this.duration,
    required this.lastActive,
    required this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic userId;
  dynamic categoryId;
  dynamic subcategoryId;
  dynamic childcategoryId;
  dynamic languageId;
  String title;
  String shortDetail;
  String detail;
  String requirement;
  dynamic price;
  dynamic discountPrice;
  dynamic day;
  String video;
  dynamic url;
  dynamic featured;
  dynamic slug;
  dynamic status;
  dynamic previewImage;
  dynamic videoUrl;
  dynamic previewType;
  dynamic type;
  dynamic duration;
  dynamic lastActive;
  DateTime createdAt;
  dynamic updatedAt;

  factory Courses.fromJson(Map<String, dynamic> json) => Courses(
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
        price: json["price"] == '' ? null : json["price"],
        discountPrice:
            json["discount_price"] == '' ? null : json["discount_price"],
        day: json["day"] == '' ? null : json["day"],
        video: json["video"] == null ? '' : json["video"],
        url: json["url"] == '' ? '' : json["url"],
        featured: json["featured"],
        slug: json["slug"],
        status: json["status"],
        previewImage:
            json["preview_image"] == '' ? null : json["preview_image"],
        videoUrl: json["video_url"],
        previewType: json["preview_type"],
        type: json["type"],
        duration: json["duration"] == '' ? null : json["duration"],
        lastActive: json["last_active"] == '' ? null : json["last_active"],
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == '' || json["updated_at"] == null
            ? 'Not Available'
            : DateTime.parse(json["updated_at"]),
      );

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
        "video": video,
        "url": url,
        "featured": featured,
        "slug": slug,
        "status": status,
        "preview_image": previewImage,
        "video_url": videoUrl,
        "type": type,
        "duration": duration == null ? null : duration,
        "last_active": lastActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
