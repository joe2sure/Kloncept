import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../common/apidata.dart';
import 'full_course_detail.dart';
import 'package:http/http.dart' as http;

class CourseDetailsProvider with ChangeNotifier {
  FullCourse? courseDetails;

  Future<FullCourse?> getCourseDetails(int id, context) async {
    String url = APIData.courseDetail + "${APIData.secretKey}";
    try {
      final res = await http.post(Uri.parse(url), body: {"course_id": id.toString()});
      if (res.statusCode == 200) {
        courseDetails = FullCourse.fromJson(json.decode(res.body));
      } else {
        throw "Can't get course details";
      }
    } catch(error){
      debugPrint(error.toString());
    }
    notifyListeners();
    return courseDetails;
  }

}
