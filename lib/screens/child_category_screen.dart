import 'package:flutter_translate/flutter_translate.dart';
import '../Widgets/course_grid_item.dart';
import '../Widgets/utils.dart';
import '../model/course.dart';
import '../model/home_model.dart';
import '../provider/courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class ChildCategoryScreen extends StatelessWidget {
  Widget whenEmpty() {
    return Center(
      child: Container(
        height: 300,
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
                      translate(
                          "Your_admin_havent_uploaded_courses_for_this_child_category"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15, color: Colors.black.withOpacity(0.7)),
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

  Widget scaffoldView(courses) {
    return Container(
      child: courses.length == 0
          ? whenEmpty()
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: headingTitle(
                        translate("Courses_"), Color(0xff0083A4), 16)),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 13,
                  ),
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, idx) => CourseGridItem(courses[idx], idx),
                    childCount: courses.length,
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
                    height: 20,
                  ),
                )
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ChildCategory childCategory = ModalRoute.of(context)!.settings.arguments as ChildCategory;
    T.Theme mode = Provider.of<T.Theme>(context);
    // List<Course> courses = Provider.of<CoursesProvider>(context)
    //     .getchildcatecourses(
    //         childCategory.id,
    //         childCategory.subcategoryId.toString(),
    //         childCategory.categoryId.toString());
    return Scaffold(
        backgroundColor: mode.bgcolor,
        appBar: secondaryAppBar(
            Colors.black, mode.bgcolor, context, childCategory.title.toString()),
        // body: scaffoldView(Courses)
        body: Column(
          children: [
            Center(
              child: Text('Courses'),
            )
          ],
        ),
        );
  }
}
