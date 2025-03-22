// import 'course.dart';

// class CoursesModel {
//   CoursesModel({
//     this.course,
//   });

//   List<Course>? course;

//   factory CoursesModel.fromJson(Map<String, dynamic> json) => CoursesModel(
//         course: json["course"] == null
//             ? null
//             : List<Course>.from(json["course"].map((x) => Course.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "course": List<dynamic>.from(course!.map((x) => x.toJson())),
//       };
// }