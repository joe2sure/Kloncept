import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/screens/setReminderScreen.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:share_plus/share_plus.dart';
import '../Widgets/course_tile_widget_list.dart';
import '../Widgets/add_and_buy_bundleCourses.dart';
import '../Widgets/html_text.dart';
import '../Widgets/utils.dart';
import '../common/theme.dart' as T;
import '../model/bundle_courses_model.dart';
import '../model/course.dart';
import '../provider/courses_provider.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BundleDetailScreen extends StatefulWidget {
  @override
  _BundleDetailScreenState createState() => _BundleDetailScreenState();
}

class _BundleDetailScreenState extends State<BundleDetailScreen> {
  double textsize = 14.0;

  Widget fun(String a, String b) {
    return Row(
      children: [
        Text(
          a + " : ",
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
        Text(
          b,
          style: TextStyle(fontSize: 15, color: txtcolor),
        )
      ],
    );
  }

  Widget bundleDetails(
      BundleCourses bundleDetail, bool purchased, String currency) {
    return SliverToBoxAdapter(
      child: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height / (8.5),
          color: Color(0xff29303b),
        ),
        Container(
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
                  bundleDetail.title.toString(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      color: Color(0xff404455)),
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              if (!purchased)
                if (bundleDetail.type == "1")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (bundleDetail.discountPrice != null)
                        Text(
                            "${currencySymbol(selectedCurrency)} ${(num.tryParse(bundleDetail.discountPrice.toString())! * selectedCurrencyRate)}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                                color: Color(0xff404455))),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "${currencySymbol(selectedCurrency)} ${(num.tryParse(bundleDetail.price.toString())! * selectedCurrencyRate)}",
                        style: TextStyle(
                            color: bundleDetail.discountPrice != null
                                ? Color(0xff943f4654)
                                : Color(0xff404455),
                            fontSize: bundleDetail.discountPrice != null
                                ? 16.0
                                : 22.0,
                            decoration: bundleDetail.discountPrice != null
                                ? TextDecoration.lineThrough
                                : null,
                            fontWeight: bundleDetail.discountPrice != null
                                ? FontWeight.normal
                                : FontWeight.bold),
                      )
                    ],
                  )
                else
                  Text(
                    translate("Free_"),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.0,
                      color: Colors.red,
                    ),
                  ),
              Container(
                padding: EdgeInsets.only(top: 10),
                height: 85.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child:
                            fun(translate("Created_by"), translate("Admin_"))),
                    Expanded(
                        child: fun(
                            translate("Last_Updated"),
                            bundleDetail.updatedAt == null
                                ? ""
                                : DateFormat.yMMMd().format(
                                    DateTime.parse(bundleDetail.updatedAt.toString())))),
                    Expanded(
                        child: fun(translate("No_of_Courses"),
                            bundleDetail.courseId!.length.toString())),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget appBar(int? courseId, String? title) {
    return SliverAppBar(
      centerTitle: true,
      backgroundColor: Color(0xff29303b),
      title: Text(
        translate("Bundle_Course"),
        style: TextStyle(fontSize: 18.0),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_ios),
        iconSize: 18.0,
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SetReminderScreen(
                  title: '${bundleDetail!.title}',
                  description: '${bundleDetail!.detail}',
                ),
              ),
            );
          },
          icon: Icon(Icons.add_alert),
          iconSize: 25.0,
        ),
        IconButton(
          onPressed: () async {
            await Share.share(
              'Bundle Course \n$title \n${APIData.shareBundleCourse}$courseId',
              subject: 'Bundle Course',
            );
          },
          icon: Icon(Icons.share_sharp),
          iconSize: 25.0,
        ),
      ],
    );
  }

  Widget bundleDescription(String? desc) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: html(desc, txtcolor!, 16),
      ),
    );
  }

  Widget headings(String title, Color clr) {
    return SliverToBoxAdapter(
      child: headingTitle(title, clr, 22),
    );
  }

  Widget bundleCoursesList(List<Course> courses) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.height /
            (MediaQuery.of(context).orientation == Orientation.landscape
                ? 1.5
                : 2.5),
        child: ListView.builder(
          padding: EdgeInsets.only(left: 18.0, bottom: 23.0, top: 5.0),
          itemBuilder: (context, idx) => CourseListItem(courses[idx], true),
          scrollDirection: Axis.horizontal,
          itemCount: courses.length,
        ),
      ),
    );
  }

  Widget block() {
    return SliverToBoxAdapter(
      child: Container(
        height: 10.0,
        color: Color(0xff29303b),
      ),
    );
  }

  Widget scaffoldBody(BundleCourses bundleDetail, bool purchased,
      List<Course> courses, dynamic currency) {
    return Container(
      color: Color(0xffE5E5EF),
      child: CustomScrollView(
        slivers: [
          appBar(bundleDetail.id, bundleDetail.title),
          block(),
          bundleDetails(bundleDetail, purchased, currency),
          if (!purchased)
            AddAndBuyBundle(bundleDetail.id as int, bundleDetail.discountPrice),
          headings(translate("Details_"), Color(0xff0083A4)),
          bundleDescription(bundleDetail.detail),
          headings(translate("Courses_in_Bundle"), Color(0xff0083A4)),
          bundleCoursesList(courses),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          )
        ],
      ),
    );
  }

  Color? txtcolor;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BundleCourses? bundleDetail;
  @override
  Widget build(BuildContext context) {
    bundleDetail = ModalRoute.of(context)!.settings.arguments as BundleCourses?;
    String? currency = Provider.of<HomeDataProvider>(context).homeModel!.currency!.currency;
    var courses = Provider.of<CoursesProvider>(context);
    List<Course>? bundleCourses = courses.getCourses(bundleDetail!.courseId);

    bool purchased = courses.bundlePurchasedListIds!.contains(bundleDetail!.id);
    T.Theme mode = Provider.of<T.Theme>(context);
    txtcolor = mode.txtcolor;
    return Scaffold(
      key: _scaffoldKey,
      body: scaffoldBody(bundleDetail!, purchased, bundleCourses, currency),
    );
  }
}
