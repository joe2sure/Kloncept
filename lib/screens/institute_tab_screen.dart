import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../model/InstituteDetailsModel.dart';
import 'institute_course_screen.dart';

class InstituteTabScreen extends StatefulWidget {
  final InstituteDetailsModel? instituteDetailsModel;
  const InstituteTabScreen({this.instituteDetailsModel});

  @override
  State<InstituteTabScreen> createState() => _InstituteTabScreenState();
}

class _InstituteTabScreenState extends State<InstituteTabScreen> {
  final _tabs = <Tab>[
    Tab(text: translate("Courses_")),
    Tab(text: translate("Details_")),
    Tab(text: translate("Skills_")),
    Tab(text: translate("Affiliated_By")),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.instituteDetailsModel!.institute![0].title.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: Colors.red,
          bottom: TabBar(
            tabs: _tabs,
            isScrollable: true,
            indicatorColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            InstituteCourseScreen(courses: widget.instituteDetailsModel!.course),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.instituteDetailsModel!.institute![0].detail ?? "",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.instituteDetailsModel!.institute![0].skill ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.instituteDetailsModel!.institute![0].affilatedBy ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
