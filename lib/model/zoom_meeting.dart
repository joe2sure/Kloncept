class ZoomMeeting {
  ZoomMeeting({
    this.id,
    this.courseId,
    this.meetingId,
    this.meetingTitle,
    this.startTime,
    this.zoomUrl,
    this.userId,
    this.agenda,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.linkBy,
    this.ownerId,
    this.image,
  });

  int? id;
  String? courseId;
  String? meetingId;
  String? meetingTitle;
  String? startTime;
  String? zoomUrl;
  String? userId;
  String? agenda;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? type;
  String? linkBy;
  String? ownerId;
  String? image;

  factory ZoomMeeting.fromJson(Map<String, dynamic> json) => ZoomMeeting(
        id: json["id"] as int?,
        courseId: json["course_id"] as String?,
        meetingId: json["meeting_id"] as String?,
        meetingTitle: json["meeting_title"] as String?,
        startTime: json["start_time"] as String?,
        zoomUrl: json["zoom_url"] as String?,
        userId: json["user_id"] as String?,
        agenda: json["agenda"] as String?,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"] as String),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"] as String),
        type: json["type"] as String?,
        linkBy: json["link_by"] as String?,
        ownerId: json["owner_id"] as String?,
        image: json["image"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "meeting_id": meetingId,
        "meeting_title": meetingTitle,
        "start_time": startTime,
        "zoom_url": zoomUrl,
        "user_id": userId,
        "agenda": agenda,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "type": type,
        "link_by": linkBy,
        "owner_id": ownerId,
        "image": image,
      };
}

// class ZoomMeeting {
//   ZoomMeeting(
//       {this.id,
//       this.meetingId,
//       this.userId,
//       this.ownerId,
//       this.meetingTitle,
//       this.startTime,
//       this.zoomUrl,
//       this.linkBy,
//       this.courseId,
//       this.createdAt,
//       this.updatedAt,
//       this.type,
//       this.agenda,
//       this.image});

//   int? id;
//   String? meetingId;
//   dynamic userId;
//   String? ownerId;
//   String? meetingTitle;
//   DateTime? startTime;
//   String? zoomUrl;
//   String? linkBy;
//   dynamic courseId;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   dynamic type;
//   String? agenda;
//   String? image;

//   factory ZoomMeeting.fromJson(Map<String, dynamic> json) => ZoomMeeting(
//         id: json["id"],
//         meetingId: json["meeting_id"],
//         userId: json["user_id"],
//         ownerId: json["owner_id"],
//         meetingTitle: json["meeting_title"],
//         startTime: DateTime.parse(json["start_time"]),
//         zoomUrl: json["zoom_url"],
//         linkBy: json["link_by"] == null ? null : json["link_by"],
//         courseId: json["course_id"] == null ? null : json["course_id"],
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         type: json["type"] == null ? null : json["type"],
//         agenda: json["agenda"] == null ? null : json["agenda"],
//         image: json["image"] == null ? null : json["image"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "meeting_id": meetingId,
//         "user_id": userId,
//         "owner_id": ownerId,
//         "meeting_title": meetingTitle,
//         "start_time": startTime!.toIso8601String(),
//         "zoom_url": zoomUrl,
//         "link_by": linkBy == null ? null : linkBy,
//         "course_id": courseId == null ? null : courseId,
//         "created_at": createdAt!.toIso8601String(),
//         "updated_at": updatedAt!.toIso8601String(),
//         "type": type == null ? null : type,
//         "agenda": agenda == null ? null : agenda,
//         "image": image == null ? null : image,
//       };
// }
