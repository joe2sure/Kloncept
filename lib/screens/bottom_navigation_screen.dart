import 'dart:async';
import 'package:kloncept/localization/language_provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kloncept/provider/dummy/dummy_cart_provider.dart';
import 'package:kloncept/provider/dummy/dummy_provider.dart';
import 'package:kloncept/services/internetStatus.dart';
import '../common/facebook_ads.dart';

import 'cart_screen.dart';
import 'courses_screen.dart';
import 'settings_screen.dart';
import '../Widgets/appbar.dart';
import '../Widgets/custom_drawer.dart';
import '../common/theme.dart' as T;
import '../utils/custom-icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'all_category_screen.dart';
import 'home_screen.dart';

// import 'package:kloncept/model/dummy/dummy_model.dart';
// import 'package:kloncept/provider/dummy/dummy_courses_provider.dart';
// import 'package:kloncept/provider/dummy/dummy_watchlist_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/oneSignal.dart';

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({this.pageInd});

  final pageInd;

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  late int _selectedIndex;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CoursesScreen(),
    AllCategoryScreen(),
    CartScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


// In bottom_navigation_screen.dart, modify getHomePageData():
Future<void> getHomePageData() async {
  try {
    // First load all providers that don't return values
    Provider.of<DummyCoursesProvider>(context, listen: false).loadDummyExtraCourses();
    Provider.of<DummyHomeDataProvider>(context, listen: false).loadDummyHomeData();
    Provider.of<DummyBundleCourseProvider>(context, listen: false).loadDummyBundles();
    Provider.of<DummyUserProfile>(context, listen: false).loadDummyProfile();
    Provider.of<DummyInstituteProvider>(context, listen: false).loadDummyInstitutes();
    Provider.of<DummyCompareCourseProvider>(context, listen: false).loadDummyData();
    Provider.of<DummyWalletDetailsProvider>(context, listen: false).fetchWalletDetails();
    Provider.of<DummyCurrenciesProvider>(context, listen: false).fetchDummyCurrenciesData();

    // Then await the async operations
    await Future.wait([
      Provider.of<DummyRecentCourseProvider>(context, listen: false).loadRecentCourses(),
      Provider.of<DummyCartProvider>(context, listen: false).fetchCart(context),
    ]);
  } catch (e) {
    print("Error loading providers: $e");
  }
}

  // getHomePageData() async {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //     // Replace with dummy providers
  //     DummyCoursesProvider coursesProvider =
  //         Provider.of<DummyCoursesProvider>(context, listen: false);
  //     DummyHomeDataProvider homeDataProvider =
  //         Provider.of<DummyHomeDataProvider>(context, listen: false);
  //     DummyRecentCourseProvider recentCourseProvider =
  //         Provider.of<DummyRecentCourseProvider>(context, listen: false);
  //     DummyBundleCourseProvider bundleCourseProvider =
  //         Provider.of<DummyBundleCourseProvider>(context, listen: false);
  //     DummyUserProfile userProfile =
  //         Provider.of<DummyUserProfile>(context, listen: false);
  //     DummyVisibleProvider visiblePro = Provider.of<DummyVisibleProvider>(context, listen: false);
  //     DummyInstituteProvider instituteProvider =
  //         Provider.of<DummyInstituteProvider>(context, listen: false);
  //     DummyCompareCourseProvider compareCourseProvider =
  //         Provider.of<DummyCompareCourseProvider>(context, listen: false);
  //     DummyWalletDetailsProvider walletDetailsProvider =
  //         Provider.of<DummyWalletDetailsProvider>(context, listen: false);
  //     DummyCurrenciesProvider currenciesProvider =
  //         Provider.of<DummyCurrenciesProvider>(context, listen: false);
  //     DummyCartProvider cartProvider =
  //         Provider.of<DummyCartProvider>(context, listen: false);


  //   try {
  //     // Call void methods directly, and keep async methods in Future.wait
  //     coursesProvider.loadDummyExtraCourses();
  //     homeDataProvider.loadDummyHomeData();
  //     bundleCourseProvider.loadDummyBundles();
  //     userProfile.loadDummyProfile();
  //     instituteProvider.loadDummyInstitutes();
  //     compareCourseProvider.loadDummyData();
  //     walletDetailsProvider.loadDummyData();
  //     currenciesProvider.loadDummyData();
      
  //     // Only use Future.wait for methods that actually return Futures
  //     await Future.wait([
  //       recentCourseProvider.fetchRecentCourse(context),
  //       cartProvider.fetchCart(context),
  //     ]);
  //   } catch (e) {
  //     print("Exception : $e");
  //   }

  //     // No need to call getHomeDetails again as we've already loaded the data
  //     initPlatformState();

  //     // Using the dummy watchlist provider
  //     await Provider.of<DummyWatchlistProvider>(context, listen: false)
  //         .removeFromWatchList();

  //     SharedPreferences sharedPreferences =
  //         await SharedPreferences.getInstance();

  //     if (sharedPreferences.containsKey("giftUserId")) {
  //       await sharedPreferences.remove("giftUserId");
  //       await sharedPreferences.remove("giftCourseId");
  //     }

  //     if (sharedPreferences.containsKey("topUpWallet")) {
  //       await sharedPreferences.remove("topUpWallet");
  //     }

  //     Timer(Duration(milliseconds: 100), () {
  //       visiblePro.toggleVisible(true);
  //     });
  //   });
  // }

  LanguageProvider? languageProvider;

  @override
  void dispose() {
    cancelInternetStatus();
    super.dispose();
  }

  void initState() {
    super.initState();

    _selectedIndex = widget.pageInd != null ? widget.pageInd : 0;

    languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getHomePageData();
    });

    initializeFBAd();
  }

  Future<bool> onBackPressed() {
    bool? value;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Text(
          translate("Confirm_Exit"),
          style: TextStyle(
              fontFamily: 'Mada',
              fontWeight: FontWeight.w700,
              color: Color(0xFF0284A2)),
        ),
        content: Text(
          translate("Are_you_sure_that_you_want_to_exit"),
          style: TextStyle(
            fontFamily: 'Mada',
            color: Color(0xFF3F4654),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              translate("Cancel_").toUpperCase(),
              style: TextStyle(
                color: Color(0xFF0284A2),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () {
              cancelInternetStatus();
              SystemNavigator.pop();
              Navigator.pop(context);
            },
            child: Text(
              translate("Yes_").toUpperCase(),
              style: TextStyle(
                color: Color(0xFF0284A2),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return Future.value(value ?? false);
  }

  Widget navigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 25.0,
              offset: Offset(0.0, -10.0),
              spreadRadius: -15.0)
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: BottomNavigationBar(
        elevation: 1.0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(color: const Color(0xFF3F4654)),
        unselectedIconTheme: IconThemeData(color: const Color(0xFFC9D4E2)),
        selectedItemColor: const Color(0xFF3F4654),
        unselectedItemColor: const Color(0xFFC9D4E2),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.home),
            label: translate("Home_"),
            activeIcon: Stack(
              children: [
                Icon(
                  CustomIcons.home,
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                Icon(
                  CustomIcons.home_color,
                  color: Color.fromRGBO(240, 75, 75, 1.0),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.courses),
            label: translate("Courses_"),
            activeIcon: Stack(
              children: [
                Icon(
                  CustomIcons.courses,
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                Icon(
                  CustomIcons.courses_color,
                  color: Color.fromRGBO(240, 75, 75, 1.0),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.categories),
            label: translate("Categories_"),
            activeIcon: Stack(
              children: [
                Icon(
                  CustomIcons.categories,
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                Icon(
                  CustomIcons.categories_color,
                  color: Color.fromRGBO(240, 75, 75, 1.0),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.cart),
            label: translate("Cart_"),
            activeIcon: Stack(
              children: [
                Icon(
                  CustomIcons.cart,
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                Icon(
                  CustomIcons.cart_color,
                  color: Color.fromRGBO(240, 75, 75, 1.0),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.settings),
            activeIcon: Stack(
              children: [
                Icon(
                  CustomIcons.settings,
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                Icon(
                  CustomIcons.settings_color,
                  color: Color.fromRGBO(240, 75, 75, 1.0),
                ),
              ],
            ),
            label: translate("Settings_"),
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedLabelStyle: TextStyle(color: Colors.white),
        onTap: _onItemTapped,
      ),
    );
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return WillPopScope(
      child: Scaffold(
        key: scaffoldKey,
        appBar: appBar(mode.bgcolor, context, scaffoldKey),
        drawer: CustomDrawer(),
        bottomNavigationBar: navigationBar(),
        body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      ),
      onWillPop: onBackPressed,
    );
  }
}


      // try {
      //   await Future.wait([
      //     // Load dummy data instead of fetching from API
      //     Future.value(coursesProvider.loadDummyCourses()),
      //     Future.value(homeDataProvider.loadDummyHomeData()),
      //     recentCourseProvider.fetchRecentCourse(context),
      //     Future.value(bundleCourseProvider.loadDummyBundles()),
      //     Future.value(userProfile.loadDummyProfile()),
      //     Future.value(instituteProvider.loadDummyInstitutes()),
      //     Future.value(compareCourseProvider.loadDummyData()),
      //     Future.value(walletDetailsProvider.loadDummyData()),
      //     Future.value(currenciesProvider.loadDummyData()),
      //     cartProvider.fetchCart(context),
      //   ]);
      // } catch (e) {
      //   print("Exception : $e");
      // }




// import 'dart:async';
// import 'package:kloncept/localization/language_provider.dart';
// import 'package:kloncept/provider/recent_course_provider.dart';
// import 'package:kloncept/provider/watchlist_provider.dart';
// import 'package:kloncept/services/oneSignal.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../common/facebook_ads.dart';
// import '../provider/compareCourseProvider.dart';
// import '../provider/currenciesProvider.dart';
// import '../provider/home_data_provider.dart';
// import '../provider/InstituteProvider.dart';
// import '../provider/walletDetailsProvider.dart';
// import '../services/internetStatus.dart';
// import 'cart_screen.dart';
// import 'courses_screen.dart';
// import 'settings_screen.dart';
// import '../Widgets/appbar.dart';
// import '../Widgets/custom_drawer.dart';
// import '../common/theme.dart' as T;
// import '../provider/bundle_course.dart';
// import '../provider/courses_provider.dart';
// import '../provider/user_profile.dart';
// import '../provider/visible_provider.dart';
// import '../utils/custom-icons.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'all_category_screen.dart';
// import 'home_screen.dart';

// class MyBottomNavigationBar extends StatefulWidget {
//   MyBottomNavigationBar({this.pageInd});

//   final pageInd;

//   @override
//   _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
// }

// class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
//   late int _selectedIndex;

//   static List<Widget> _widgetOptions = <Widget>[
//     HomeScreen(),
//     CoursesScreen(),
//     AllCategoryScreen(),
//     CartScreen(),
//     SettingScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   getHomePageData() async {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
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
//       Visible visiblePro = Provider.of<Visible>(context, listen: false);
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

//       homeDataProvider.getHomeDetails(context);

//       initPlatformState();

//       await Provider.of<WatchlistProvider>(context, listen: false)
//           .removeFromWatchList();

//       SharedPreferences sharedPreferences =
//           await SharedPreferences.getInstance();

//       if (sharedPreferences.containsKey("giftUserId")) {
//         await sharedPreferences.remove("giftUserId");
//         await sharedPreferences.remove("giftCourseId");
//       }

//       if (sharedPreferences.containsKey("topUpWallet")) {
//         await sharedPreferences.remove("topUpWallet");
//       }

//       Timer(Duration(milliseconds: 100), () {
//         visiblePro.toggleVisible(true);
//       });
//     });
//   }

//   LanguageProvider? languageProvider;

//   @override
//   void dispose() {
//     cancelInternetStatus();
//     super.dispose();
//   }

//   void initState() {
//     super.initState();

//     _selectedIndex = widget.pageInd != null ? widget.pageInd : 0;

//     languageProvider = Provider.of<LanguageProvider>(context, listen: false);

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       getHomePageData();
//     });

//     initializeFBAd();
//   }

//   Future<bool> onBackPressed() {
//     bool? value;
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//         title: Text(
//           translate("Confirm_Exit"),
//           style: TextStyle(
//               fontFamily: 'Mada',
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF0284A2)),
//         ),
//         content: Text(
//           translate("Are_you_sure_that_you_want_to_exit"),
//           style: TextStyle(
//             fontFamily: 'Mada',
//             color: Color(0xFF3F4654),
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text(
//               translate("Cancel_").toUpperCase(),
//               style: TextStyle(
//                 color: Color(0xFF0284A2),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           SizedBox(height: 16),
//           TextButton(
//             onPressed: () {
//               cancelInternetStatus();
//               SystemNavigator.pop();
//               Navigator.pop(context);
//             },
//             child: Text(
//               translate("Yes_").toUpperCase(),
//               style: TextStyle(
//                 color: Color(0xFF0284A2),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//     return new Future.value(value);
//   }

//   Widget navigationBar() {
//     return Container(
//       height: 70,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//               color: Color(0x1c2464).withOpacity(0.30),
//               blurRadius: 25.0,
//               offset: Offset(0.0, -10.0),
//               spreadRadius: -15.0)
//         ],
//         borderRadius: BorderRadius.circular(20.0),
//       ),
//       child: BottomNavigationBar(
//         elevation: 1.0,
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedIconTheme: IconThemeData(color: const Color(0xFF3F4654)),
//         unselectedIconTheme: IconThemeData(color: const Color(0xFFC9D4E2)),
//         selectedItemColor: const Color(0xFF3F4654),
//         unselectedItemColor: const Color(0xFFC9D4E2),
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(CustomIcons.home),
//             label: translate("Home_"),
//             activeIcon: Stack(
//               children: [
//                 Icon(
//                   CustomIcons.home,
//                   color: Color.fromRGBO(69, 69, 69, 1.0),
//                 ),
//                 Icon(
//                   CustomIcons.home_color,
//                   color: Color.fromRGBO(240, 75, 75, 1.0),
//                 ),
//               ],
//             ),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(CustomIcons.courses),
//             label: translate("Courses_"),
//             activeIcon: Stack(
//               children: [
//                 Icon(
//                   CustomIcons.courses,
//                   color: Color.fromRGBO(69, 69, 69, 1.0),
//                 ),
//                 Icon(
//                   CustomIcons.courses_color,
//                   color: Color.fromRGBO(240, 75, 75, 1.0),
//                 ),
//               ],
//             ),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(CustomIcons.categories),
//             label: translate("Categories_"),
//             activeIcon: Stack(
//               children: [
//                 Icon(
//                   CustomIcons.categories,
//                   color: Color.fromRGBO(69, 69, 69, 1.0),
//                 ),
//                 Icon(
//                   CustomIcons.categories_color,
//                   color: Color.fromRGBO(240, 75, 75, 1.0),
//                 ),
//               ],
//             ),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(CustomIcons.cart),
//             label: translate("Cart_"),
//             activeIcon: Stack(
//               children: [
//                 Icon(
//                   CustomIcons.cart,
//                   color: Color.fromRGBO(69, 69, 69, 1.0),
//                 ),
//                 Icon(
//                   CustomIcons.cart_color,
//                   color: Color.fromRGBO(240, 75, 75, 1.0),
//                 ),
//               ],
//             ),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(CustomIcons.settings),
//             activeIcon: Stack(
//               children: [
//                 Icon(
//                   CustomIcons.settings,
//                   color: Color.fromRGBO(69, 69, 69, 1.0),
//                 ),
//                 Icon(
//                   CustomIcons.settings_color,
//                   color: Color.fromRGBO(240, 75, 75, 1.0),
//                 ),
//               ],
//             ),
//             label: translate("Settings_"),
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         unselectedLabelStyle: TextStyle(color: Colors.white),
//         onTap: _onItemTapped,
//       ),
//     );
//   }

//   final scaffoldKey = new GlobalKey<ScaffoldState>();
//   @override
//   Widget build(BuildContext context) {
//     T.Theme mode = Provider.of<T.Theme>(context);
//     return WillPopScope(
//       child: Scaffold(
//         key: scaffoldKey,
//         appBar: appBar(mode.bgcolor, context, scaffoldKey),
//         drawer: CustomDrawer(),
//         bottomNavigationBar: navigationBar(),
//         body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
//       ),
//       onWillPop: onBackPressed,
//     );
//   }
// }
