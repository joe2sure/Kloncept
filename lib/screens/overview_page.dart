import 'package:auto_size_text/auto_size_text.dart';
import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/provider/content_provider.dart';
import 'package:kloncept/provider/full_course_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:kloncept/common/theme.dart' as T;

class OverviewPage extends StatefulWidget {
  OverviewPage(this.courseDetails);

  final FullCourse courseDetails;

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var content =
        Provider.of<ContentProvider>(context, listen: false).contentModel;
    return Scaffold(
        appBar: customAppBar(context, translate("Overview_")),
        backgroundColor: mode.backgroundColor,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate("About_this_course"),
                  style: TextStyle(
                      color: mode.titleTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 22.0),
                ),
                SizedBox(
                  height: 5.0,
                ),
                AutoSizeText(content != null
                    ? "${content.overview![0].shortDetail}"
                    : "NA"),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      translate("Description_"),
                      style: TextStyle(
                          color: mode.titleTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0),
                    ),
                    Text(
                      "${translate("Classes_")} : ${widget.courseDetails.course!.courseclass!.length}",
                      style: TextStyle(
                          color: mode.txtcolor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0),
                    ),
                  ],
                ),
                AutoSizeText(
                    content != null ? "${content.overview![0].detail}" : "NA"),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  translate("About_Instructor"),
                  style: TextStyle(
                      color: mode.titleTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 22.0),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  content != null ? "${content.overview![0].instructor}" : "NA",
                  style: TextStyle(
                      color: mode.titleTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0),
                ),
                Text(
                  content != null
                      ? "${content.overview![0].instructorEmail}"
                      : "NA",
                  style: TextStyle(
                      color: mode.txtcolor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                AutoSizeText(content != null
                    ? "${content.overview![0].instructorDetail}"
                    : "NA"),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Text(
                      "${translate("User_Enrolled")}: ",
                      style: TextStyle(
                          color: mode.titleTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0),
                    ),
                    Text(
                      content != null
                          ? "${content.overview![0].userEnrolled}"
                          : "NA",
                      style: TextStyle(color: mode.txtcolor, fontSize: 18.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ));
  }
}
