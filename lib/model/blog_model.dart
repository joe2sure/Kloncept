class BlogModel {
  BlogModel({
    this.blog,
  });

  List<Blog>? blog;

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
        blog: List<Blog>.from(json["blog"].map((x) => Blog.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "blog": List<dynamic>.from(blog!.map((x) => x.toJson())),
      };
}

class Blog {
  Blog({
    this.id,
    this.userId,
    this.date,
    this.image,
    this.heading,
    this.detail,
    this.text,
    this.approved,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  dynamic userId;
  String? date;
  String? image;
  String? heading;
  String? detail;
  String? text;
  dynamic approved;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        id: json["id"],
        userId: json["user_id"],
        date: json["date"],
        image: json["image"],
        heading: json["heading"],
        detail: json["detail"],
        text: json["text"],
        approved: json["approved"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "date": date,
        "image": image,
        "heading": heading,
        "detail": detail,
        "text": text,
        "approved": approved,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
