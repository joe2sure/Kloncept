// import 'dart:async';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:kloncept/Widgets/zoom_meeting_list.dart';
// import 'package:kloncept/common/facebook_ads.dart';
// import 'package:kloncept/provider/home_data_provider.dart';
// import 'package:kloncept/provider/recent_course_provider.dart';
// import 'package:kloncept/provider/walletDetailsProvider.dart';
// import 'package:kloncept/services/oneSignal.dart';
// import 'search_result_screen.dart';
// import 'package:kloncept/widgets/institute_image_swiper.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import '../provider/InstituteProvider.dart';
// import '../provider/compareCourseProvider.dart';
// import '../provider/currenciesProvider.dart';
// import 'fact_slider.dart';
// import 'image_swiper.dart';
// import '../Widgets/bundle_courses_list.dart';
// import '../Widgets/featured_category_list.dart';
// import '../Widgets/featured_courses_list.dart';
// import '../Widgets/heading_title.dart';
// import '../Widgets/new_courses_list.dart';
// import '../Widgets/studying_list.dart';
// import '../Widgets/testimonial_list.dart';
// import '../Widgets/trusted_list.dart';
// import '../common/apidata.dart';
// import '../model/bundle_courses_model.dart';
// import '../model/course.dart';
// import '../provider/bundle_course.dart';
// import '../provider/visible_provider.dart';
// import 'package:shimmer/shimmer.dart';
// import '../provider/courses_provider.dart';
// import '../provider/user_profile.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../common/theme.dart' as T;

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   late bool _visible;

//   @override
//   void initState() {
//     super.initState();
//     _visible = Provider.of<Visible>(context, listen: false).globalVisible;
//   }

//   Widget welcomeText(String? name, String? imageUrl, BuildContext context) {
//     return _visible == true
//         ? Padding(
//             padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 30),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Flexible(
//                     flex: 4,
//                     child: Container(
//                       height: 80,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           FittedBox(
//                             fit: BoxFit.fitWidth,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   translate("Hi_"),
//                                   style: TextStyle(
//                                       fontSize: 26.0,
//                                       fontWeight: FontWeight.w700,
//                                       color: Color(0xFF3F4654)),
//                                 ),
//                                 Text(
//                                   name.toString() + "!",
//                                   style: TextStyle(
//                                     fontSize: 26.0,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xFF788295),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 1.0,
//                           ),
//                           Text(
//                             translate("What_would_you_like_to_search_today"),
//                             style: TextStyle(
//                                 color: Color(0xFF3F4654),
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                     )),
//                 Flexible(
//                   flex: 1,
//                   child: Container(
//                     height: 65,
//                     child: CircleAvatar(
//                       radius: 32.5,
//                       backgroundColor: Color(0xFFF44A4A),
//                       backgroundImage: imageUrl == null
//                           ? AssetImage("assets/placeholder/avatar.png")
//                               as ImageProvider
//                           : CachedNetworkImageProvider(
//                               APIData.userImage + imageUrl),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : Padding(
//             padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 30),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   height: 80,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Shimmer.fromColors(
//                         baseColor: Color(0xFFd3d7de),
//                         highlightColor: Color(0xFFe2e4e9),
//                         child: Card(
//                           elevation: 0.0,
//                           color: Color.fromRGBO(45, 45, 45, 1.0),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(10),
//                             ),
//                           ),
//                           clipBehavior: Clip.antiAliasWithSaveLayer,
//                           child: SizedBox(
//                             width: 220,
//                             height: 28,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 1.0,
//                       ),
//                       Shimmer.fromColors(
//                         baseColor: Color(0xFFd3d7de),
//                         highlightColor: Color(0xFFe2e4e9),
//                         child: Card(
//                           elevation: 0.0,
//                           color: Color.fromRGBO(45, 45, 45, 1.0),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(10),
//                             ),
//                           ),
//                           clipBehavior: Clip.antiAliasWithSaveLayer,
//                           child: SizedBox(
//                             width: 220,
//                             height: 16,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: 65,
//                   child: Shimmer.fromColors(
//                     baseColor: Color(0xFFd3d7de),
//                     highlightColor: Color(0xFFe2e4e9),
//                     child: CircleAvatar(
//                       radius: 32.5,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }

//   List<String> list = List.generate(10, (index) => "Text $index");

//   Widget searchBar(BuildContext context) {
//     return _visible == true
//         ? SliverToBoxAdapter(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                       color: Color(0x1c2464).withOpacity(0.30),
//                       blurRadius: 25.0,
//                       offset: Offset(0.0, 20.0),
//                       spreadRadius: -15.0)
//                 ],
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               margin: EdgeInsets.symmetric(horizontal: 18.0),
//               height:
//                   MediaQuery.of(context).orientation == Orientation.landscape
//                       ? 70
//                       : MediaQuery.of(context).size.height / 11,
//               padding: EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     child: Container(
//                       alignment: Alignment.center,
//                       padding: EdgeInsets.all(5.0),
//                       width: MediaQuery.of(context).size.width - 130,
//                       height: 100.0,
//                       child: Text(
//                         translate("Find_new_course") + " " * 30,
//                         style: TextStyle(
//                           color: Colors.grey.withOpacity(0.7),
//                           fontSize: 16.0,
//                           fontFamily: 'Mada',
//                         ),
//                       ),
//                     ),
//                     onTap: () {
//                       // showSearch(context: context, delegate: Search(list));
//                     },
//                   ),
//                   InkWell(
//                     onTap: () {
//                       // showSearch(context: context, delegate: Search(list));
//                     },
//                     hoverColor: Colors.red,
//                     child: Container(
//                       height: 63,
//                       width: 60,
//                       decoration: BoxDecoration(
//                           color: Color(0xffF44A4A),
//                           borderRadius: BorderRadius.circular(10.0),
//                           boxShadow: [
//                             BoxShadow(
//                                 color: Color(0xffE3E6ED).withOpacity(0.20),
//                                 blurRadius: 10,
//                                 spreadRadius: 1,
//                                 offset: Offset(0, 4))
//                           ]),
//                       child: Icon(
//                         Icons.search,
//                         size: 37,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         : SliverToBoxAdapter(
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 18.0),
//               height:
//                   MediaQuery.of(context).orientation == Orientation.landscape
//                       ? 70
//                       : MediaQuery.of(context).size.height / 11,
//               child: Shimmer.fromColors(
//                 baseColor: Color(0xFFd3d7de),
//                 highlightColor: Color(0xFFe2e4e9),
//                 child: Card(
//                   elevation: 0.0,
//                   color: Color.fromRGBO(45, 45, 45, 1.0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     ),
//                   ),
//                   clipBehavior: Clip.antiAliasWithSaveLayer,
//                   child: Container(
//                     margin: EdgeInsets.symmetric(horizontal: 18.0),
//                     height: MediaQuery.of(context).orientation ==
//                             Orientation.landscape
//                         ? 70
//                         : MediaQuery.of(context).size.height / 11,
//                   ),
//                 ),
//               ),
//             ),
//           );
//   }

//   Widget scaffoldView(
//     UserProfile user,
//     CoursesProvider course,
//     T.Theme mode,
//     List<BundleCourses>? bundleCourses,
//   ) {
//     List<Course> featuredCoursesList = course.getFeaturedCourses();
//     var zoomMeetingList =
//         Provider.of<HomeDataProvider>(context).zoomMeetingList;
//     var testimonialList =
//         Provider.of<HomeDataProvider>(context).testimonialList;
//     var trustedList = Provider.of<HomeDataProvider>(context).trustedList;
//     var factSliderList = Provider.of<HomeDataProvider>(context).sliderFactList;
//     var sliderList = Provider.of<HomeDataProvider>(context).sliderList;
//     var newCourses =
//         Provider.of<RecentCourseProvider>(context).recentCourseList;
//     return CustomScrollView(
//       slivers: [
//         SliverToBoxAdapter(
//           child: Container(
//             width: double.infinity,
//             margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
//             child: Column(
//               children: [
//                 welcomeText(user.profileInstance.fname,
//                     user.profileInstance.userImg, context),
//               ],
//             ),
//           ),
//         ),

//         searchBar(context),

//         SliverPadding(padding: EdgeInsets.only(bottom: 25.0)),
//         sliderList!.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : ImageSwiper(_visible),

//         SliverPadding(padding: EdgeInsets.only(bottom: 5.0)),
//         factSliderList!.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : FactSlider(_visible),

//         newCourses!.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : HeadingTitle(translate("NEW_COURSES"), _visible),
//         newCourses.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : NewCoursesList(_visible),

//         course.studyingList.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : HeadingTitle(translate("STUDYING_"), _visible),
//         course.studyingList.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : StudyingList(_visible),

//         HeadingTitle(translate("FEATURED_CATEGORIES"), _visible),
//         FeaturedCategoryList(_visible),
//         //Featured Courses
//         featuredCoursesList.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : HeadingTitle(translate("FEATURED_COURSES"), _visible),
//         featuredCoursesList.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : FeaturedCoursesList(featuredCoursesList, _visible),

//         SliverToBoxAdapter(
//           child: showBannerAd_(),
//         ),

//         bundleCourses!.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : HeadingTitle(translate("BUNDLE_COURSES"), _visible),
//         bundleCourses.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : BundleCoursesList(bundleCourses, _visible),

//         // Institute Slider
//         if (Provider.of<InstituteProvider>(context).instituteModel != null) ...{
//           Provider.of<InstituteProvider>(context).instituteModel!.institute!.length == 0
//               ? SliverToBoxAdapter(
//                   child: SizedBox.shrink(),
//                 )
//               : HeadingTitle(translate("INSTITUTES_"), _visible),
//           Provider.of<InstituteProvider>(context).instituteModel!.institute!.length == 0
//               ? SliverToBoxAdapter(
//                   child: SizedBox.shrink(),
//                 )
//               : InstituteImageSwiper(_visible),
//           SliverPadding(padding: EdgeInsets.only(bottom: 10.0)),
//         },

//         zoomMeetingList!.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : HeadingTitle(translate("ZOOM_MEETINGS"), _visible),
//         zoomMeetingList.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : ZoomMeetingList(_visible),

//         testimonialList!.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : HeadingTitle(
//                 translate("WHAT_OUR_STUDENTS_HAVE_TO_STAY"), _visible),
//         testimonialList.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : TestimonialList(_visible),

//         SliverToBoxAdapter(
//           child: Container(
//             height: 40.0,
//           ),
//         ),

//         //companies
//         trustedList!.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : SliverToBoxAdapter(
//                 child: Container(
//                   margin: EdgeInsets.only(top: 5.0),
//                   alignment: Alignment.center,
//                   child: Text(
//                     translate("Trusted_by_companies_of_all_sizes"),
//                     style: TextStyle(
//                       color: Color(0xFF545B67),
//                       fontSize: 14.0,
//                     ),
//                   ),
//                 ),
//               ),

//         trustedList.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : TrustedList(_visible),

//         SliverToBoxAdapter(
//           child: SizedBox(
//             height: 20.0,
//           ),
//         ),

//         SliverToBoxAdapter(
//           child: showNativeAd_(),
//         ),

//         SliverToBoxAdapter(
//           child: SizedBox(
//             height: 20.0,
//           ),
//         )
//       ],
//     );
//   }

//   Future<Null> getHomePageData() async {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       Visible visiblePro = Provider.of<Visible>(context, listen: false);
//       Timer(Duration(milliseconds: 10), () {
//         visiblePro.toggleVisible(false);
//       });
      
//       // Load all providers with dummy data
//       CoursesProvider coursesProvider =
//           Provider.of<CoursesProvider>(context, listen: false);
//       HomeDataProvider homeDataProvider =
//           Provider.of<HomeDataProvider>(context, listen: false);
//       RecentCourseProvider recentCourseProvider =
//           Provider.of<RecentCourseProvider>(context, listen: false);
//       BundleCourseProvider bundleCourseProvider =
//           Provider.of<BundleCourseProvider>(context, listen: false);
//       UserProfile userProfile =
//           Provider.of<UserProfile>(context, listen: false);
//       InstituteProvider instituteProvider =
//           Provider.of<InstituteProvider>(context, listen: false);
//       CompareCourseProvider compareCourseProvider =
//           Provider.of<CompareCourseProvider>(context, listen: false);
//       WalletDetailsProvider walletDetailsProvider =
//           Provider.of<WalletDetailsProvider>(context, listen: false);
//       CurrenciesProvider currenciesProvider =
//           Provider.of<CurrenciesProvider>(context, listen: false);

//       try {
//         await Future.wait([
//           coursesProvider.getAllCourse(context),
//           homeDataProvider.getHomeDetails(context),
//           recentCourseProvider.fetchRecentCourse(context),
//           coursesProvider.initPurchasedCourses(context),
//           bundleCourseProvider.getbundles(context),
//           userProfile.fetchUserProfile(),
//           instituteProvider.fetchData(),
//           compareCourseProvider.fetchData(),
//           walletDetailsProvider.fetchData(),
//           currenciesProvider.fetchData(),
//         ]);
//       } catch (e) {
//         print("Exception : $e");
//       }

//       // Show UI after a short delay
//       Timer(Duration(milliseconds: 1000), () {
//         visiblePro.toggleVisible(true);
//       });
//     });
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     T.Theme mode = Provider.of<T.Theme>(context, listen: false);
//     UserProfile user = Provider.of<UserProfile>(context, listen: false);
//     CoursesProvider course =
//         Provider.of<CoursesProvider>(context, listen: false);
//     List<BundleCourses>? bundleCourses =
//         Provider.of<BundleCourseProvider>(context, listen: false).bundleCourses;
    
//     _visible = Provider.of<Visible>(context).globalVisible;

//     return RefreshIndicator(
//       child: Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: mode.bgcolor,
//         body: scaffoldView(user, course, mode, bundleCourses),
//       ),
//       onRefresh: getHomePageData,
//     );
//   }
// }

// final Shader linearGradient = LinearGradient(
//   colors: <Color>[
//     Color(0xff790055),
//     Color(0xffF81D46),
//     Color(0xffF81D46),
//     Color(0xffFA4E62)
//   ],
// ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));






// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:kloncept/provider/home_data_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var homeData = Provider.of<HomeDataProvider>(context);

    if (homeData.homeModel == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: ListView(
        children: [
          // Display Slider
          if (homeData.sliderList != null)
            ...homeData.sliderList!.map((slider) => ListTile(
                  title: Text(slider.heading ?? ''),
                  subtitle: Text(slider.subHeading ?? ''),
                  leading: Image.network(slider.image ?? ''),
                )),

          // Display Slider Facts
          if (homeData.sliderFactList != null)
            ...homeData.sliderFactList!.map((fact) => ListTile(
                  title: Text(fact.heading ?? ''),
                  subtitle: Text(fact.subHeading ?? ''),
                  leading: Image.network(fact.icon ?? ''),
                )),

          // Display Testimonials
          if (homeData.testimonialList != null)
            ...homeData.testimonialList!.map((testimonial) => ListTile(
                  title: Text(testimonial.clientName ?? ''),
                  subtitle: Text(testimonial.details ?? ''),
                  leading: Image.network(testimonial.image ?? ''),
                )),

          // Display Trusted
          if (homeData.trustedList != null)
            ...homeData.trustedList!.map((trusted) => ListTile(
                  title: Text(trusted.url ?? ''),
                  leading: Image.network(trusted.image ?? ''),
                )),

          // Display Featured Categories
          if (homeData.featuredCategoryList != null)
            ...homeData.featuredCategoryList!.map((category) => ListTile(
                  title: Text(category.title ?? ''),
                  leading: Image.network(category.icon ?? ''),
                )),

          // Display Categories
          if (homeData.categoryList != null)
            ...homeData.categoryList!.map((category) => ListTile(
                  title: Text(category.title ?? ''),
                  leading: Image.network(category.icon ?? ''),
                )),

          // Display Subcategories
          if (homeData.subCategoryList != null)
            ...homeData.subCategoryList!.map((subCategory) => ListTile(
                  title: Text(subCategory.title ?? ''),
                  leading: Image.network(subCategory.icon ?? ''),
                )),

          // Display Child Categories
          if (homeData.childCategoryList != null)
            ...homeData.childCategoryList!.map((childCategory) => ListTile(
                  title: Text(childCategory.title ?? ''),
                  leading: Image.network(childCategory.icon ?? ''),
                )),

          // Display Zoom Meetings
          if (homeData.zoomMeetingList != null)
            ...homeData.zoomMeetingList!.map((meeting) => ListTile(
                  title: Text(meeting.meetingTitle ?? ''),
                  subtitle: Text(meeting.agenda ?? ''),
                  leading: Image.network(meeting.image ?? ''),
                )),
        ],
      ),
    );
  }
}
