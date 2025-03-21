import 'package:kloncept/model/course.dart';

class RecentCourseModel {
  List<Course>? courses;

  RecentCourseModel({this.courses});

  factory RecentCourseModel.fromJson(Map<String, dynamic> json) {
    return RecentCourseModel(
      courses: json['courses'] != null
          ? (json['courses'] as List).map((i) => Course.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.courses != null) {
      data['courses'] = this.courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// import 'course.dart';

// class RecentCourseModel {
//   RecentCourseModel({
//     this.course,
//   });

//   List<Course>? course;

//   factory RecentCourseModel.fromJson(Map<String, dynamic> json) => RecentCourseModel(
//     course: json["course"] == null ? null : List<Course>.from(json["course"].map((x) => Course.fromJson(x))),
//   );

//   Map<String, dynamic> toJson() => {
//     "course": List<dynamic>.from(course!.map((x) => x.toJson())),
//   };
// }


// enum DurationType { M }

// final durationTypeValues = EnumValues({
//   "m": DurationType.M
// });


// enum PreviewType { URL }

// final previewTypeValues = EnumValues({
//   "url": PreviewType.URL
// });

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
