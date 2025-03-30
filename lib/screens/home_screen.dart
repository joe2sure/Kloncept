import 'package:flutter/material.dart';
import 'package:kloncept/model/dummy/dummy_model.dart';
import 'package:kloncept/screens/fact_slider.dart';
import 'package:kloncept/screens/image_swiper.dart';
import 'package:provider/provider.dart';
import 'package:kloncept/provider/dummy/dummy_provider.dart';

import 'package:kloncept/widgets/new_courses_list.dart';
import 'package:kloncept/widgets/featured_courses_list.dart';
import 'package:kloncept/widgets/bundle_courses_list.dart';
import 'package:kloncept/widgets/institute_image_swiper.dart';
import 'package:kloncept/widgets/zoom_meeting_list.dart';
import 'package:kloncept/widgets/testimonial_list.dart';
import 'package:kloncept/widgets/trusted_list.dart';
import 'package:kloncept/common/theme.dart' as T;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider =
          Provider.of<DummyHomeDataProvider>(context, listen: false);
      if (!homeProvider.dataLoaded) {
        homeProvider.loadDummyHomeData();
      }

      final recentProvider =
          Provider.of<DummyRecentCourseProvider>(context, listen: false);
      if (recentProvider.recentCourseList.isEmpty) {
        recentProvider.loadRecentCourses();
      }

      Provider.of<DummyInstituteProvider>(context, listen: false)
          .loadDummyInstitutes();
      Provider.of<DummyBundleCourseProvider>(context, listen: false)
          .loadDummyBundles();
    });
  }

  Future<void> _refreshData() async {
    await Provider.of<DummyHomeDataProvider>(context, listen: false)
        .loadDummyHomeData();
    await Provider.of<DummyRecentCourseProvider>(context, listen: false)
        .loadRecentCourses();
  }

  Widget _buildWelcomeText() {
    return Consumer<DummyUserProfile>(
      builder: (context, userProfile, _) {
        return Padding(
          padding: EdgeInsets.only(left: 18.0, top: 15.0, bottom: 5.0),
          child: Text(
            "Welcome, ${userProfile.profile.firstName}!",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            hintText: 'Search for courses...',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
          ),
        ),
      ),
    );
  }

  Widget _buildHeadingTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 18.0, top: 15.0, bottom: 5.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<DummyHomeDataProvider>(context);
    final recentProvider = Provider.of<DummyRecentCourseProvider>(context);
    final bundleProvider = Provider.of<DummyBundleCourseProvider>(context);
    final instituteProvider = Provider.of<DummyInstituteProvider>(context);
    final theme = Provider.of<T.Theme>(context);

    final isLoading = homeProvider.isLoading ||
        recentProvider.isLoading ||
        bundleProvider.isLoading ||
        instituteProvider.isLoading;

    List<DummyCourse> _createFeaturedCourses() {
      // Create a list of DummyCourse objects based on slider data
      return homeProvider.sliderList
          .map((slider) => DummyCourse(
                id: slider.id,
                title: slider.heading, // Use heading instead of title
                description:
                    slider.subHeading, // Use subHeading instead of description
                imageUrl: slider.imageUrl,
                price: 0.0, // Default value
                discountPrice: null,
                categoryName: "Featured", // Default category
                rating: 5.0, // Default rating
                isEnrolled: false, // Default value
                isFeatured: true, // All are featured
              ))
          .toList();
    }

    return Scaffold(
      backgroundColor: theme.bgcolor,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: [
            // Welcome Text and Search Bar
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeText(),
                  _buildSearchBar(),
                ],
              ),
            ),

            // Slider Section
            SliverToBoxAdapter(
              child: _buildHeadingTitle("Featured Courses"),
            ),
            ImageSwiper(homeProvider.dataLoaded),

            // Facts Section
            SliverToBoxAdapter(
              child: _buildHeadingTitle("Why Choose Us?"),
            ),
            FactSlider(homeProvider.dataLoaded),

            // New Courses Section
            SliverToBoxAdapter(
              child: _buildHeadingTitle("New Courses"),
            ),
            NewCoursesList(homeProvider.dataLoaded),

            // Featured Courses Section
            SliverToBoxAdapter(
              child: _buildHeadingTitle("Featured Categories"),
            ),
            FeaturedCoursesList(
              _createFeaturedCourses(),
              homeProvider.dataLoaded,
            ),
            // FeaturedCoursesList(
            //   homeProvider.sliderList.where((c) => c.isFeatured).toList(),
            //   homeProvider.dataLoaded,
            // ),

            // Bundle Courses Section
            SliverToBoxAdapter(
              child: _buildHeadingTitle("Course Bundles"),
            ),
            BundleCoursesList(
              bundleProvider.bundleCourses,
              homeProvider.dataLoaded,
            ),

            // Institutes Section
            SliverToBoxAdapter(
              child: _buildHeadingTitle("Featured Institutes"),
            ),
            InstituteImageSwiper(homeProvider.dataLoaded),

            // Zoom Meetings Section
            SliverToBoxAdapter(
              child: _buildHeadingTitle("Upcoming Live Sessions"),
            ),
            ZoomMeetingList(homeProvider.dataLoaded),

            // Testimonials Section
            SliverToBoxAdapter(
              child: _buildHeadingTitle("Student Testimonials"),
            ),
            TestimonialList(homeProvider.dataLoaded),

            // Trusted Partners Section
            SliverToBoxAdapter(
              child: _buildHeadingTitle("Trusted By"),
            ),
            TrustedList(homeProvider.dataLoaded),

            // Bottom Padding
            SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),

            // Loading overlay
            if (isLoading)
              SliverFillRemaining(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}



// import 'dart:async';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:kloncept/model/dummy/dummy_model.dart';
// import 'package:kloncept/provider/dummy/dummy_cart_provider.dart';
// import 'package:kloncept/provider/dummy/dummy_provider.dart';
// import 'package:kloncept/provider/dummy/dummy_courses_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:flutter_translate/flutter_translate.dart';

// // Import widgets and screens
// import 'package:kloncept/Widgets/zoom_meeting_list.dart';
// import 'package:kloncept/widgets/institute_image_swiper.dart';
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
// import '../common/theme.dart' as T;

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   late bool _visible;
//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _visible = false;
//     // Delay provider access until after first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       getHomePageData();
//     });
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
//                           : CachedNetworkImageProvider(imageUrl),
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
//                       // Search functionality
//                     },
//                   ),
//                   InkWell(
//                     onTap: () {
//                       // Search functionality
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
//     DummyUserProfile user,
//     DummyCoursesProvider course,
//     T.Theme mode,
//     List<DummyBundleCourse>? bundleCourses,
//   ) {
//     List<DummyCourse> featuredCoursesList = course.getFeaturedCourses();
//     var zoomMeetingList =
//         Provider.of<DummyHomeDataProvider>(context).zoomMeetingList;
//     var testimonialList =
//         Provider.of<DummyHomeDataProvider>(context).testimonialList;
//     var trustedList = Provider.of<DummyHomeDataProvider>(context).trustedList;
//     var factSliderList = Provider.of<DummyHomeDataProvider>(context).sliderFactList;
//     var sliderList = Provider.of<DummyHomeDataProvider>(context).sliderList;
//     var newCourses =
//         Provider.of<DummyRecentCourseProvider>(context).recentCourseList;
        
//     return CustomScrollView(
//       slivers: [
//         SliverToBoxAdapter(
//           child: Container(
//             width: double.infinity,
//             margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
//             child: Column(
//               children: [
//                 welcomeText(user.profile.firstName,
//                     user.profile.userImg, context),
//               ],
//             ),
//           ),
//         ),

//         searchBar(context),

//         SliverPadding(padding: EdgeInsets.only(bottom: 25.0)),
//         sliderList.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : ImageSwiper(_visible),

//         SliverPadding(padding: EdgeInsets.only(bottom: 5.0)),
//         factSliderList.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : FactSlider(_visible),

//         newCourses.length == 0
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
//           child: Container(), // Placeholder for ad
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
//         if (Provider.of<DummyInstituteProvider>(context).instituteModel != null) ...{
//           Provider.of<DummyInstituteProvider>(context).instituteModel!.institutes.length == 0
//               ? SliverToBoxAdapter(
//                   child: SizedBox.shrink(),
//                 )
//               : HeadingTitle(translate("INSTITUTES_"), _visible),
//           Provider.of<DummyInstituteProvider>(context).instituteModel!.institutes.length == 0
//               ? SliverToBoxAdapter(
//                   child: SizedBox.shrink(),
//                 )
//               : InstituteImageSwiper(_visible),
//           SliverPadding(padding: EdgeInsets.only(bottom: 10.0)),
//         },

//         zoomMeetingList.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : HeadingTitle(translate("ZOOM_MEETINGS"), _visible),
//         zoomMeetingList.length == 0
//             ? SliverToBoxAdapter(
//                 child: SizedBox.shrink(),
//               )
//             : ZoomMeetingList(_visible),

//         testimonialList.length == 0
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

//         trustedList.length == 0
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
//           child: Container(), // Placeholder for native ad
//         ),

//         SliverToBoxAdapter(
//           child: SizedBox(
//             height: 20.0,
//           ),
//         )
//       ],
//     );
//   }

// Future<void> getHomePageData() async {
//   try {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     final visiblePro = Provider.of<DummyVisibleProvider>(context, listen: false);
//     visiblePro.toggleVisible(false);

//     // Convert all operations to Future<void> for consistent typing in Future.wait()
//     await Future.wait<void>([
//       // Wrap void operations in Future.microtask or Future.value
//       Future.microtask(() => Provider.of<DummyCoursesProvider>(context, listen: false).loadDummyExtraCourses()),
//       Future.microtask(() => Provider.of<DummyHomeDataProvider>(context, listen: false).loadDummyHomeData()),
//       Future.microtask(() => Provider.of<DummyBundleCourseProvider>(context, listen: false).loadDummyBundles()),
//       Future.microtask(() => Provider.of<DummyUserProfile>(context, listen: false).loadDummyProfile()),
//       Future.microtask(() => Provider.of<DummyInstituteProvider>(context, listen: false).loadDummyInstitutes()),
//       Future.microtask(() => Provider.of<DummyCompareCourseProvider>(context, listen: false).loadDummyData()),
//       Future.microtask(() => Provider.of<DummyWalletDetailsProvider>(context, listen: false).loadDummyData()),
//       Future.microtask(() => Provider.of<DummyCurrenciesProvider>(context, listen: false).loadDummyData()),
      
//       // Convert Future<List<DummyCourse>> to Future<void>
//       Provider.of<DummyRecentCourseProvider>(context, listen: false).fetchRecentCourse(context).then((_) {}),
      
//       // Convert Future<DummyMyCart?> to Future<void>
//       Provider.of<DummyCartProvider>(context, listen: false).fetchCart(context).then((_) {}),
//     ]);

//     // Make content visible after delay
//     Timer(Duration(milliseconds: 500), () {
//       visiblePro.toggleVisible(true);
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     });
//   } catch (e) {
//     print("Error loading home page data: $e");
//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = "Failed to load data. Please try again.";
//       });
//     }
//   }
// }

// @override
// Widget build(BuildContext context) {
//   if (_isLoading) {
//     return Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }

//   if (_errorMessage != null) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 60, color: Colors.red),
//             SizedBox(height: 20),
//             Text(_errorMessage!, style: TextStyle(fontSize: 18)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: getHomePageData,
//               child: Text("Retry"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Use Consumer to properly scope provider access
//   return Consumer4<T.Theme, DummyUserProfile, DummyCoursesProvider, DummyBundleCourseProvider>(
//     builder: (context, mode, user, course, bundleCourseProvider, _) {
//       final visible = Provider.of<DummyVisibleProvider>(context).globalVisible;
//       final bundleCourses = bundleCourseProvider.bundleCourses;

//       return RefreshIndicator(
//         onRefresh: getHomePageData,
//         child: Scaffold(
//           key: _scaffoldKey,
//           backgroundColor: mode.bgcolor,
//           body: visible ? scaffoldView(user, course, mode, bundleCourses) : _buildShimmerLoader(),
//         ),
//       );
//     },
//   );
// }

// Widget _buildShimmerLoader() {
//   return ListView.builder(
//     itemCount: 10,
//     itemBuilder: (context, index) {
//       return Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[100]!,
//         child: ListTile(
//           leading: Container(width: 48, height: 48, color: Colors.white),
//           title: Container(height: 8, color: Colors.white),
//           subtitle: Container(height: 8, color: Colors.white),
//         ),
//       );
//     },
//   );
// }

// }

// final Shader linearGradient = LinearGradient(
//   colors: <Color>[
//     Color(0xff790055),
//     Color(0xffF81D46),
//     Color(0xffF81D46),
//     Color(0xffFA4E62)
//   ],
// ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

// class ErrorWidgetBuilder extends StatelessWidget {
//   final Widget child;
  
//   const ErrorWidgetBuilder({required this.child});
  
//   @override
//   Widget build(BuildContext context) {
//     try {
//       return child;
//     } catch (e) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.error, size: 50),
//               SizedBox(height: 20),
//               Text('Error loading content'),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // Try to reload
//                   Provider.of<DummyVisibleProvider>(context, listen: false)
//                     .toggleVisible(false);
//                   Future.delayed(Duration(seconds: 1), () {
//                     Provider.of<DummyVisibleProvider>(context, listen: false)
//                       .toggleVisible(true);
//                   });
//                 },
//                 child: Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }
// }




// =============== start of original home screen  ===============


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


//  ============== end of original home screen  ====================


// // lib/screens/home_screen.dart

// import 'package:flutter/material.dart';
// import 'package:kloncept/provider/home_data_provider.dart';
// import 'package:provider/provider.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var homeData = Provider.of<HomeDataProvider>(context);

//     if (homeData.homeModel == null) {
//       return Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       body: ListView(
//         children: [
//           // Display Slider
//           if (homeData.sliderList != null)
//             ...homeData.sliderList!.map((slider) => ListTile(
//                   title: Text(slider.heading ?? ''),
//                   subtitle: Text(slider.subHeading ?? ''),
//                   leading: _buildImage(slider.image),
//                 )),

//           // Display Slider Facts
//           if (homeData.sliderFactList != null)
//             ...homeData.sliderFactList!.map((fact) => ListTile(
//                   title: Text(fact.heading ?? ''),
//                   subtitle: Text(fact.subHeading ?? ''),
//                   leading: _buildImage(fact.icon),
//                 )),

//           // Display Testimonials
//           if (homeData.testimonialList != null)
//             ...homeData.testimonialList!.map((testimonial) => ListTile(
//                   title: Text(testimonial.clientName ?? ''),
//                   subtitle: Text(testimonial.details ?? ''),
//                   leading: _buildImage(testimonial.image),
//                 )),

//           // Display Trusted
//           if (homeData.trustedList != null)
//             ...homeData.trustedList!.map((trusted) => ListTile(
//                   title: Text(trusted.url ?? ''),
//                   leading: _buildImage(trusted.image),
//                 )),

//           // Display Featured Categories
//           if (homeData.featuredCategoryList != null)
//             ...homeData.featuredCategoryList!.map((category) => ListTile(
//                   title: Text(category.title ?? ''),
//                   leading: _buildImage(category.icon),
//                 )),

//           // Display Categories
//           if (homeData.categoryList != null)
//             ...homeData.categoryList!.map((category) => ListTile(
//                   title: Text(category.title ?? ''),
//                   leading: _buildImage(category.icon),
//                 )),

//           // Display Subcategories
//           if (homeData.subCategoryList != null)
//             ...homeData.subCategoryList!.map((subCategory) => ListTile(
//                   title: Text(subCategory.title ?? ''),
//                   leading: _buildImage(subCategory.icon),
//                 )),

//           // Display Child Categories
//           if (homeData.childCategoryList != null)
//             ...homeData.childCategoryList!.map((childCategory) => ListTile(
//                   title: Text(childCategory.title ?? ''),
//                   leading: _buildImage(childCategory.icon),
//                 )),

//           // Display Zoom Meetings
//           if (homeData.zoomMeetingList != null)
//             ...homeData.zoomMeetingList!.map((meeting) => ListTile(
//                   title: Text(meeting.meetingTitle ?? ''),
//                   subtitle: Text(meeting.agenda ?? ''),
//                   leading: _buildImage(meeting.image),
//                 )),
//         ],
//       ),
//     );
//   }

//   // Helper method to handle both asset and network images
//   Widget _buildImage(String? imagePath) {
//     if (imagePath == null || imagePath.isEmpty) {
//       return Icon(Icons.image_not_supported);
//     }
    
//     // Check if the path is for an asset or a network image
//     if (imagePath.startsWith('assets/')) {
//       return Image.asset(
//         imagePath,
//         width: 50,
//         height: 50,
//         errorBuilder: (context, error, stackTrace) {
//           return Icon(Icons.broken_image);
//         },
//       );
//     } else if (imagePath.startsWith('http')) {
//       return Image.network(
//         imagePath,
//         width: 50,
//         height: 50,
//         errorBuilder: (context, error, stackTrace) {
//           return Icon(Icons.broken_image);
//         },
//       );
//     } else {
//       return Icon(Icons.image);
//     }
//   }
// }