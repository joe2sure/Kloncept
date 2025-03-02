import 'package:kloncept/model/InstituteDetailsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../widgets/institute_course_list_item.dart';

class InstituteCourseScreen extends StatelessWidget {
  final List<Course>? courses;
  InstituteCourseScreen({this.courses});

  @override
  Widget build(BuildContext context) {
    if (courses!.isEmpty) return whenEmptyCourses();
    return Container(
      height: 350,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        itemBuilder: (context, index) =>
            InstituteCourseListItem(courses![index]),
        scrollDirection: Axis.vertical,
        itemCount: courses!.length,
      ),
    );
  }

  Widget whenEmptyCourses() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 40),
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(),
                child: Image.asset("assets/images/emptycourses.png"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              height: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate("Oops_No_courses_availiable"),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    width: 200,
                    child: Text(
                      translate("This_institute_does_not_have_any_course"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
