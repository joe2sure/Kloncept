import 'package:kloncept/Screens/certificate_loading_screen.dart';
import 'package:kloncept/Screens/google_meet_screen.dart';
import 'package:kloncept/Screens/overview_page.dart';
import 'package:kloncept/Screens/previous_papers.dart';
import 'package:kloncept/Screens/quiz/home.dart';
import 'package:kloncept/Screens/qa_screen.dart';
import 'package:kloncept/provider/content_provider.dart';
import 'package:kloncept/provider/full_course_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'announcement_screen.dart';
import 'appoinment_screen.dart';
import 'assignment_screen.dart';
import 'package:kloncept/common/theme.dart' as T;
import 'jitsi_meet_screen.dart';

class MoreScreen extends StatefulWidget {
  MoreScreen(this.courseDetails);
  final FullCourse? courseDetails;

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _visible = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    if (!_disposed) {
      setState(() {
        _visible = false;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ContentProvider contentProvider =
          Provider.of<ContentProvider>(context, listen: false);

      // try {
      await contentProvider.getContent(
          context, widget.courseDetails!.course!.id);
      // } catch (e) {
      //   print('More Screen Exception :- $e');
      // }
      if (!_disposed) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context, listen: false);
    return Scaffold(
      body: _visible == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 18.0, right: 18, bottom: 10, top: 10.0),
                      child: Text(
                        translate("Overview_"),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: mode.titleTextColor),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OverviewPage(
                                  widget.courseDetails as FullCourse)));
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                      child: Text(
                        translate("Questions_and_Answers"),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: mode.titleTextColor),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QAScreen(
                                  widget.courseDetails as FullCourse)));
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                      child: Text(
                        translate("Announcement_"),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: mode.titleTextColor),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnnouncementScreen()));
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                      child: Text(
                        translate("Quiz_"),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: mode.titleTextColor),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                      child: Text(
                        translate("Assignment_"),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: mode.titleTextColor),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AssignmentScreen(
                                  widget.courseDetails as FullCourse)));
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                      child: Text(
                        translate("Appointment_"),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: mode.titleTextColor),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppointmentScreen(
                                  widget.courseDetails as FullCourse)));
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                      child: Text(
                        translate("Certificate_"),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: mode.titleTextColor),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CertificateLoadingScreen(
                                  widget.courseDetails as FullCourse)));
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                      child: Text(
                        translate("Previous_Papers"),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: mode.titleTextColor),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreviousPapers()));
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                      child: Text(
                        translate("Google_Meet"),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: mode.titleTextColor),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GoogleMeetScreen()));
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                      child: Text(
                        translate("Jitsi_Meet"),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: mode.titleTextColor),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JitsiMeetScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }
}
