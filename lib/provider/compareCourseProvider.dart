import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../model/CompareCourseModel.dart';

class CompareCourseProvider with ChangeNotifier {
  CompareCourseModel? compareCourseModel;

  Future<void> fetchData() async {
    Response response = await get(
      Uri.parse(APIData.compareCourses),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );
    log("Compare Courses API Status Code :-> ${response.statusCode}");
    log("Compare Courses API Response :-> ${response.body}");
    if (response.statusCode == 200) {
      compareCourseModel = compareCourseModelFromJson(response.body);
    }
    notifyListeners();
  }

  Future<void> addToCompareCourse(int? userId, int? courseId) async {
    Response response = await post(
      Uri.parse(APIData.addToCompareCourses),
      body: {"user_id": "$userId", "course_id": "$courseId"},
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );
    log("Add to Compare Course API Status Code :-> ${response.statusCode}");
    log("Add to Compare Course API Response :-> ${response.body}");
    if (response.statusCode == 200) {
      await fetchData();
    }
  }

  Future<void> removeFromCompareCourse(int? compareCourseId) async {
    Response response = await delete(
      Uri.parse(
          "${APIData.removeFromCompareCoursesPrefix}$compareCourseId${APIData.removeFromCompareCoursesPostfix}"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );
    log("Remove from Compare Course API Status Code :-> ${response.statusCode}");
    log("Remove from Compare Course API Response :-> ${response.body}");
    if (response.statusCode == 200) {
      await fetchData();
    }
  }

  int isCompareCourse(int? courseId) {
    int compareId = 0;
    compareCourseModel!.compare!.forEach((compare) {
      if (compare.courseId == courseId.toString()) {
        compareId = compare.id as int;
      }
    });
    return compareId;
  }
}
