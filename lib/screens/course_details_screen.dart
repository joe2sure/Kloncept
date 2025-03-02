import 'dart:convert';
import 'dart:developer';
import 'package:kloncept/Screens/rate_course_screen.dart';
import 'package:kloncept/Widgets/videoplayer.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/model/purchase_history_model.dart';
import 'package:kloncept/provider/recent_course_provider.dart';
import 'package:kloncept/provider/watchlist_provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Widgets/course_detail_menu.dart';
import '../Widgets/course_tile_widget_list.dart';
import '../Widgets/expandable_text.dart';
import '../Widgets/rating_star.dart';
import '../Widgets/resume_and_startbeg.dart';
import '../Widgets/add_and_buy.dart';
import '../Widgets/course_grid_item.dart';
import '../Widgets/course_key_points.dart';
import '../Widgets/html_text.dart';
import '../Widgets/instructorwidget.dart';
import '../Widgets/lessons.dart';
import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../common/facebook_ads.dart';
import '../common/theme.dart' as T;
import '../model/course.dart';
import '../model/course_with_progress.dart';
import '../model/include.dart';
import '../model/instructor_model.dart';
import '../provider/full_course_detail.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Widgets/studfeedwid.dart';
import '../provider/courses_provider.dart';
import '../services/http_services.dart';

// ignore: must_be_immutable
class CourseDetailScreen extends StatefulWidget {
  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with TickerProviderStateMixin {
  int tabIndex = 0;

  double textSize = 15.0;
  double textSizeCol = 15.0;
  Color? txtcolor;

  var purchaseDate;
  Future<void> getPurchaseDate(int? courseId) async {
    print("object123");
    List<Orderhistory> orderHistory =
        await HttpService().fetchPurchaseHistory();
    print("object1234: $orderHistory");
    if (orderHistory.isNotEmpty) {
      Orderhistory? singleOrder;
      orderHistory.forEach((element) {
        if (element.courses != null) {
          if (element.courses!.id == courseId) {
            singleOrder = element;
          }
        }
      });
      if (singleOrder != null)
        purchaseDate = singleOrder!.createdAt;
      else
        purchaseDate = DateTime.now();
    } else
      purchaseDate = DateTime.now();
  }

  Widget include(Include inc) {
    return Container(
      margin: EdgeInsets.fromLTRB(18, 10, 0, 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Image.asset(
              "assets/icons/requirements.png",
              width: 15.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.17,
            child: Text(
              inc.detail.toString(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: txtcolor, fontSize: 16.0),
            ),
          )
        ],
      ),
    );
  }

  Widget courseIncludes(List<Include>? whatIncludes) {
    return Container(
      child: Column(
        children: whatIncludes!.map((e) => include(e)).toList(),
      ),
    );
  }

  Widget overview(
      String? overview, Color txtcolor, List<Include>? whatIncludes) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headingTitle(translate("Course_Includes"), txtcolor, 20),
          courseIncludes(whatIncludes),
          headingTitle(translate("Description_"), txtcolor, 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: html(overview, txtcolor, 16),
          ),
        ],
      ),
    );
  }

  Future<FullCourse?> getCourseDetails(int? id) async {
    DataSend apiData = ModalRoute.of(context)!.settings.arguments as DataSend;

    await getPurchaseDate(apiData.id);
    print("urlll:");
    String url = "${APIData.courseDetail}${APIData.secretKey}";

    Response res = await post(
      Uri.parse(url),
      body: {"course_id": id.toString()},
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );
    FullCourse? courseDetails;
    log("Course Details : ${res.body}");
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      try {
        courseDetails = FullCourse.fromJson(body);
      } catch (e) {
        print("Exception : $e");
      }
    } else {
      print("Can't get Course Details - Status Code : ${res.statusCode}");
      if (detail == null) {
        Fluttertoast.showToast(
            msg: translate("You_cant_access_this_course"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Future.delayed(Duration(seconds: 3));
        Navigator.pop(context);
      }
    }
    return courseDetails;
  }

  var detail;

  int checkDatatype(dynamic x) {
    if (x is int)
      return 0;
    else
      return 1;
  }

  String getRating(List<Review>? data) {
    double ans = 0.0;
    bool calcAsInt = true;
    if (data!.length > 0)
      calcAsInt = checkDatatype(data[0].learn) == 0 ? true : false;

    data.forEach((element) {
      if (!calcAsInt)
        ans += (int.tryParse(element.price)! +
                    int.parse(element.value) +
                    int.parse(element.learn))
                .toDouble() /
            3.0;
      else {
        ans += (int.tryParse(element.price)! +
                int.parse(element.value) +
                int.parse(element.learn)) /
            3.0;
      }
    });
    if (ans == 0.0) return 0.toString();
    return (ans / data.length).toStringAsPrecision(2);
  }

  Widget fun(String a, String b) {
    return Row(
      children: [
        Text(
          a + " : ",
          style: TextStyle(color: Colors.grey, fontSize: textSize),
        ),
        Text(
          b,
          style: TextStyle(fontSize: textSize),
        )
      ],
    );
  }

  Widget funcol(String a, String b) {
    return Column(
      children: [
        Text(
          a,
          style: TextStyle(color: Colors.grey, fontSize: textSizeCol),
        ),
        Container(
          alignment: Alignment.topCenter,
          width: 90.0,
          child: Text(
            b,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: textSizeCol,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  Future<Instructor> getinstdata(dynamic id) async {
    Instructor insdetail;
    String url = "${APIData.instructorProfile}${APIData.secretKey}";
    Response res = await post(Uri.parse(url), body: {"instructor_id": "$id"});
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      insdetail = Instructor.fromJson(body);
    } else {
      print(
          "Instructor API Status Code :-> ${APIData.instructorProfile}${APIData.secretKey}");
      print("Instructor API Status Code2 :-> ${id}");
      throw "err";
    }

    return insdetail;
  }

  var getinstdetails;

  bool adShown = false;
  void didChangeDependencies() {
    Provider.of<WatchlistProvider>(context, listen: false)
        .loadData(delayInSeconds: 2);

    DataSend apiData = ModalRoute.of(context)!.settings.arguments as DataSend;

    detail = getCourseDetails(apiData.id);
    // log(detail);
    getinstdetails = getinstdata(apiData.userId);
    if (!adShown) {
      loadInterstitialAd().then((value) => showInterstitialAd_());
      adShown = true;
    }
    super.didChangeDependencies();
  }

  Route _menuRoute(
      int id, bool isPurchased, FullCourse details, List<String> pro) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          CourseDetailMenuScreen(isPurchased, details, pro, purchaseDate),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  int getLength(List<Review>? revs) {
    if (revs == null)
      return 0;
    else
      return revs.length;
  }

  Widget purchasedCourseDetails(FullCourse details, double progress) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
      margin: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Text(
              details.course!.title.toString(),
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: Color(0xff404455)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StarRating(
                rating: details.review == null
                    ? 0.0
                    : double.parse(getRating(details.review)),
                size: 15.0,
                color: Color(0xff0284a2),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                details.review == null
                    ? "0 ${translate('Rating_')} ${translate('and_')} 0 ${translate('Review_')}"
                    : "${getRating(details.review)} ${translate('Rating_')} ${translate('and_')} ${getLength(details.review)} ${translate('Review_')}",
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          cusprogressbar(MediaQuery.of(context).size.width / 1.38, progress),
          SizedBox(
            height: 10.0,
          ),
          Text(
            details.course!.shortDetail.toString(),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: txtcolor, fontSize: 16),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 75.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: fun(
                        translate("Course_By"),
                        "${details.course!.user!.fname}" +
                            " " +
                            "${details.course!.user!.lname}")),
                Expanded(
                    child: fun(
                        translate("Last_Updated"),
                        DateFormat.yMMMd()
                            .format(details.course?.createdAt as DateTime))),
                Expanded(
                    child: fun(
                        translate("Language_"),
                        details.course!.language == null
                            ? "N/A"
                            : "${details.course!.language!.name}")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String tMonth(String x) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sept",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[int.tryParse(x)! - 1];
  }

  String convertDate(String x) {
    String ans = x.substring(0, 4);
    ans = x.substring(8, 10) + " " + tMonth(x.substring(5, 7)) + " " + ans;
    return ans;
  }

  Widget unPurchasedCourseDetails(FullCourse details, String currency) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
      margin: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
          child: Text(
            details.course!.title.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                color: Color(0xff404455)),
          ),
        ),

        // ignore: unrelated_type_equality_checks
        if (details.course!.type.toString() == "1")
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (details.course!.discountPrice != null)
                Text(
                    "${currencySymbol(currency)} ${(num.tryParse(details.course!.discountPrice.toString())! * selectedCurrencyRate)}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Color(0xff404455))),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "${currencySymbol(currency)} ${(num.tryParse(details.course!.price.toString())! * selectedCurrencyRate)}",
                style: TextStyle(
                  color: details.course!.discountPrice != null
                      ? Color(0xff943f4654)
                      : Color(0xff404455),
                  fontWeight: details.course!.discountPrice != null
                      ? FontWeight.normal
                      : FontWeight.bold,
                  fontSize: details.course!.discountPrice != null ? 16.0 : 22.0,
                  decoration: details.course!.discountPrice != null
                      ? TextDecoration.lineThrough
                      : null,
                ),
              )
            ],
          )
        else
          Text(translate("Free_"),
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22.0,
                  color: Colors.red)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            details.course!.shortDetail.toString(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 4.0,
        ),
        Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: funcol(translate("Course_By"),
                      details.course!.user!.fname.toString())),
              Expanded(
                  child: funcol(
                      translate("Last_Updated"),
                      DateFormat.yMMMd()
                          .format(details.course!.createdAt as DateTime))),
              Expanded(
                  child: funcol(
                      translate("Language_"),
                      details.course!.language == null
                          ? "N/A"
                          : details.course!.language!.name.toString())),
            ],
          ),
        ),
        Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: func(
                      details.studentEnrolled,
                      translate("Students_"),
                      1,
                      "assets/icons/studentsicon.png",
                      Color(0xff3f4654),
                      0)),
              Expanded(
                  child: func(
                      details.review == null ? "0" : getRating(details.review),
                      translate("Rating_"),
                      2,
                      "assets/icons/star_icon.png",
                      Color(0xff3f4654),
                      0)),
              Expanded(
                  child: func(
                      details.course!.courseclass!.length.toDouble(),
                      translate("Lecture_"),
                      4,
                      "assets/icons/lecturesicon.png",
                      Color(0xff3f4654),
                      0)),
            ],
          ),
        )
      ]),
    );
  }

  SliverAppBar appB(String category, FullCourse details,
      List<String> markedChpIds, bool isPur) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Color(0xff29303b),
      centerTitle: true,
      title: Text(
        "$category",
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 18.0,
          color: Colors.white),
      actions: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                _menuRoute(
                    details.course?.id as int, isPur, details, markedChpIds),
              );
            },
            child: Image.asset("assets/icons/coursedetailmenu.png", width: 17),
          ),
        ),
      ],
    );
  }

  Widget tabBar() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.0),
        height: 50.0,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  tabIndex = 0;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2 - 12,
                height: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0))),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    translate("LESSON_"),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          tabIndex == 0 ? Color(0xfff44a4a) : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  tabIndex = 1;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2 - 12,
                height: 50.0,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    translate("OVERVIEW_"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: tabIndex == 1
                            ? Color(0xfff44a4a)
                            : Colors.grey[600]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget scaffoldBody(
      String category,
      List<String> markedChpIds,
      bool purchased,
      String type,
      String currency,
      double progress,
      List<Course> relatedCourses) {
    var recentCoursesList =
        Provider.of<RecentCourseProvider>(context).recentCourseList;

    return FutureBuilder(
      future: detail,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          FullCourse details = snapshot.data as FullCourse;

          return Container(
            color: Color(0xffE5E5EF),
            child: CustomScrollView(
              slivers: [
                appB(category, details, markedChpIds, purchased),
                detailsSection(purchased, details, currency, progress),

                // if course is not free
                if (!purchased && type == "1")
                  AddAndBuy(details.course!.id as int, details.course!.price,
                      details),
                // if course is free
                if (!purchased && type == "0")
                  AddAndBuy(details.course!.id as int, null, details),

                if (purchased)
                  ResumeAndStart(details, markedChpIds, purchaseDate),

                if (details.course!.url != null &&
                    details.course!.video == null)
                  previewVideoPlayer(details.course!.url.toString()),
                if (details.course!.url == null &&
                    details.course!.video != null)
                  previewVideoPlayer(
                      APIData.previewVideoLink + details.course!.video),

                // what will you learn
                if (details.course!.whatlearns!.length == 0)
                  SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  )
                else
                  SliverToBoxAdapter(
                    child: headingTitle(translate("What_will_you_learn"),
                        Color(0xff404455), 20),
                  ),

                whatWillYouLearn(details.course!.whatlearns),

                // requirement's
                if (details.course!.requirement!.length == 0)
                  SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  )
                else
                  SliverToBoxAdapter(
                    child:
                        headingTitle(translate("Requirements_"), txtcolor!, 20),
                  ),

                //requirement text
                if (details.course!.requirement!.length == 0)
                  SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  )
                else
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: details.course!.requirement!.length > 400
                          ? ExpandableText(
                              txtcolor!,
                              details.course!.requirement.toString(),
                              4,
                            )
                          : Text(
                              details.course!.requirement.toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20.0,
                  ),
                ),

                //tabBar for lesson and overview
                tabBar(),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20.0,
                  ),
                ),

                if (tabIndex == 1)
                  overview(details.course!.detail, txtcolor!,
                      details.course!.include)
                else if (tabIndex == 0)
                  Lessons(details, purchased, markedChpIds, type != "1",
                      purchaseDate),

                //RecentCourses
                relatedCourses.length == 0
                    ? SliverToBoxAdapter(
                        child: SizedBox.shrink(),
                      )
                    : SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(18.0, 20.0, 18.0, 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate("Recent_Courses"),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0083A4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                relatedCourses.length == 0
                    ? SliverToBoxAdapter(
                        child: SizedBox.shrink(),
                      )
                    : SliverToBoxAdapter(
                        child: Container(
                          height: MediaQuery.of(context).size.height /
                              (MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? 1.5
                                  : 2.5),
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                                left: 18.0, bottom: 24.0, top: 5.0),
                            itemBuilder: (context, idx) =>
                                CourseListItem(recentCoursesList[idx], true),
                            scrollDirection: Axis.horizontal,
                            itemCount: recentCoursesList!.length,
                          ),
                        ),
                      ),
                SliverToBoxAdapter(
                  child: showBannerAd_(),
                ),
                //AboutTheInstructor
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 25.0, 12.0, 5.0),
                    child: Text(
                      translate("About_The_Instructor"),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0083A4),
                      ),
                    ),
                  ),
                ),

                FutureBuilder(
                    future: getinstdetails,
                    builder: (context, snap) {
                      if (snap.hasData)
                        return SliverToBoxAdapter(
                            child: InstructorWidget(snap.data as Instructor));
                      else
                        return SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  new AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          ),
                        );
                    }),

                if (purchased)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10.0,
                        right: 80.0,
                        left: 80.0,
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xfff44a4a),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return RateCourseScreen(
                                  courseName: details.course!.title.toString(),
                                  courseId: details.course!.id as int,
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          translate("Rate_this_Course"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                if (details.review != null)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.only(top: 23.0, bottom: 5.0),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate("Student_FeedBack"),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0083A4),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 5.0),
                                width: 50.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[400]!),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Text(
                                  getLength(details.review).toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                getRating(details.review),
                                style: TextStyle(
                                  fontSize: 27.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff404455),
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              StarRating(
                                size: 28.0,
                                rating: double.parse(getRating(details.review)),
                                color: Color(0xffFDC600),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                if (details.review != null)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, idx) => Studentfeedback(
                          details.review![idx], details.course!.id as int),
                      childCount: details.review!.length > 3
                          ? 3
                          : details.review!.length,
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 25.0,
                    ),
                  ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 12.0,
                    ),
                    child: Text(
                      translate("Related_Courses"),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0083A4),
                      ),
                    ),
                  ),
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, idx) => CourseGridItem(relatedCourses[idx], idx),
                    childCount: relatedCourses.length,
                  ),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 13,
                    crossAxisSpacing: 13,
                    childAspectRatio: 0.72,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 40,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 120,
                    child: showNativeBannerAd_(),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          print("xxx1: ${snapshot}");
          print("xxx: ${snapshot.error}");
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          );
        }
      },
    );
  }

  Widget whatWillYouLearn(List<Include>? whatlearns) {
    return whatlearns!.length == 0
        ? SliverToBoxAdapter(
            child: SizedBox.shrink(),
          )
        : KeyPoints(whatlearns);
  }

  Widget previewVideoPlayer(String? url) {
    return url == null
        ? SliverToBoxAdapter(
            child: SizedBox.shrink(),
          )
        : SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: VideoPlayerScreen(url)),
            ),
          );
  }

  Widget detailsSection(
      bool purchased, FullCourse details, String currency, double progress) {
    return SliverToBoxAdapter(
      child: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height / (5.5),
          color: Color(0xff29303b),
        ),
        !purchased
            ? unPurchasedCourseDetails(details, currency)
            : purchasedCourseDetails(details, progress),
      ]),
    );
  }

  final HttpService httpService = HttpService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String currency = selectedCurrency;
    T.Theme mode = Provider.of<T.Theme>(context);
    txtcolor = mode.txtcolor;
    DataSend apiData = ModalRoute.of(context)!.settings.arguments as DataSend;
    CoursesProvider course = Provider.of<CoursesProvider>(context);
    bool useAsInt = false;
    if (apiData.categoryId is int) useAsInt = true;
    List<Course> allCategory = course.getCategoryCourses(
        useAsInt ? apiData.categoryId : int.tryParse(apiData.categoryId));
    var category = Provider.of<HomeDataProvider>(context).getCategoryName(
        !useAsInt ? apiData.categoryId : apiData.categoryId.toString());
    double progress = 0.0;
    Progress? allProgress;
    bool isProgressEmpty = false;
    List<String>? markedChpIds = [];
    if (apiData.purchased as bool) {
      progress = course.getProgress(apiData.id);
      allProgress = course.getAllProgress(apiData.id);
      if (allProgress == null) {
        isProgressEmpty = true;
      }
      if (!isProgressEmpty) {
        markedChpIds = allProgress!.markChapterId;
      } else {
        markedChpIds = [];
      }
    }

    // apiData.purchased as bool,
    return Scaffold(
      key: _scaffoldKey,
      body: scaffoldBody(
        category,
        markedChpIds!,
        apiData.purchased as bool,
        apiData.type.toString(),
        currency,
        progress,
        allCategory,
      ),
    );
  }
}
