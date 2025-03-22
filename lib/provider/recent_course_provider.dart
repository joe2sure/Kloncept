// // import 'package:flutter/material.dart';
// // import 'package:kloncept/common/dummy_data.dart';
// // import 'package:kloncept/model/course.dart';
// // import 'package:kloncept/model/recent_course_model.dart';

// // class RecentCourseProvider with ChangeNotifier {
// //   RecentCourseModel? recentCourseModel;
// //   List<Course>? recentCourseList = [];

// //   RecentCourseProvider() {
// //     // Initialize with dummy data
// //     loadDummyData();
// //   }

// //   void loadDummyData() {
// //     recentCourseModel = DummyData.recentCourses;
// //     recentCourseList = recentCourseModel!.course;
// //     notifyListeners();
// //   }

// //   Future<RecentCourseModel?> fetchRecentCourse(BuildContext context) async {
// //     // Just return the already loaded dummy data
// //     return recentCourseModel;
// //   }
// // }




// import 'dart:convert';
// import 'package:kloncept/common/apidata.dart';
// import 'package:kloncept/model/course.dart';
// import 'package:kloncept/model/recent_course_model.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart';

// class RecentCourseProvider with ChangeNotifier{
//   RecentCourseModel? recentCourseModel;
//   List<Course>? recentCourseList = [];

//   Future<RecentCourseModel?> fetchRecentCourse(BuildContext context) async  {
//     String url = "${APIData.recentCourse}${APIData.secretKey}";
//     Response res = await get(Uri.parse(url));
//     if(res.statusCode == 200) {
//       recentCourseModel = RecentCourseModel.fromJson(json.decode(res.body));
//       recentCourseList = List.generate(recentCourseModel!.course == null ? 0: recentCourseModel!.course!.length, (index) => Course(
//         id: recentCourseModel!.course![index].id,
//         userId: recentCourseModel!.course![index].userId,
//         categoryId: recentCourseModel!.course![index].categoryId,
//         subcategoryId: recentCourseModel!.course![index].subcategoryId,
//         childcategoryId: recentCourseModel!.course![index].childcategoryId,
//         languageId: recentCourseModel!.course![index].languageId,
//         title: recentCourseModel!.course![index].title,
//         shortDetail: recentCourseModel!.course![index].shortDetail,
//         detail: recentCourseModel!.course![index].detail,
//         requirement: recentCourseModel!.course![index].requirement,
//         price: recentCourseModel!.course![index].price,
//         discountPrice: recentCourseModel!.course![index].discountPrice,
//         day: recentCourseModel!.course![index].day,
//         video: recentCourseModel!.course![index].video,
//         url: recentCourseModel!.course![index].url,
//         featured: recentCourseModel!.course![index].featured,
//         slug: recentCourseModel!.course![index].slug,
//         status: recentCourseModel!.course![index].status,
//         previewImage: recentCourseModel!.course![index].previewImage,
//         videoUrl: recentCourseModel!.course![index].videoUrl,
//         previewType: recentCourseModel!.course![index].previewType,
//         type: recentCourseModel!.course![index].type,
//         duration: recentCourseModel!.course![index].duration,
//         lastActive: recentCourseModel!.course![index].lastActive,
//         createdAt: recentCourseModel!.course![index].createdAt,
//         updatedAt: recentCourseModel!.course![index].updatedAt,
//         include: recentCourseModel!.course![index].include,
//         whatlearns: recentCourseModel!.course![index].whatlearns,
//         review: recentCourseModel!.course![index].review,
//       ),
//       );
//     }
//     return recentCourseModel;
//   }

// }