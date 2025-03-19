import 'dart:convert';
import 'dart:developer';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/services/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/localization/language_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../provider/home_data_provider.dart';
import '../services/internetStatus.dart';
import 'bottom_navigation_screen.dart';
import '../Widgets/email_field.dart';
import '../Widgets/password_field.dart';
import '../provider/user_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../services/http_services.dart';
import 'dart:async';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int? _duration;
  bool _visible = false;
  Animation<double>? animation;
  AnimationController? animationController;
  var squareScaleB = 1.0;
  AnimationController? _controllerB;
  final HttpService httpService = HttpService();
  bool isLoggedIn = false;
  var profileData;
  bool isShowing = false;
  bool canPopNow = false;

  @override
  void dispose() {
    super.dispose();
    animationController?.dispose();
    cancelInternetStatus();
  }

  @override
  void initState() {
    listenInternetStatus(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black.withAlpha(0.3 as int),
        statusBarIconBrightness: Brightness.light
    ));
    
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      HomeDataProvider homeData =
          Provider.of<HomeDataProvider>(context, listen: false);
      await homeData.getHomeDetails(context);

      // Set currency
      if (await storage.containsKey(key: 'selectedCurrency') &&
          await storage.containsKey(key: 'selectedCurrencyRate')) {
        selectedCurrency = await storage.read(key: 'selectedCurrency');
        selectedCurrencyRate =
            int.tryParse(await storage.read(key: 'selectedCurrencyRate') ?? "1");
      } else {
        selectedCurrency = homeData.homeModel!.currency!.currency;
        selectedCurrencyRate = 1;
      }

      // Loading Languages
      LanguageProvider languageProvider =
          Provider.of<LanguageProvider>(context, listen: false);
      await languageProvider.loadData(context, loadScreen: false);
      changeLocale(context, languageProvider.languageCode);

      Timer(Duration(milliseconds: 500), () {
        setState(() {
          _visible = true;
        });
      });
    });

    _duration = 1200;

    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: _duration!));

    animation = Tween<double>(begin: 0, end: -165)
        .animate(animationController!)
      ..addListener(() {
        setState(() {});
      });
      
    _controllerB = AnimationController(
        vsync: this,
        lowerBound: 1.0,
        upperBound: 1.20,
        duration: Duration(milliseconds: 3000));

    _controllerB!.addListener(() {
      setState(() {
        squareScaleB = _controllerB!.value;
      });
    });

    Timer(Duration(milliseconds: 500), () {
      animationController!.forward();
      _controllerB!.forward(from: 0.0);
    });
    super.initState();
  }

  // Alert dialog after clicking on login button
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Signing In ...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Logo on login page
  Widget logo(String? img) {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
      child: AnimatedOpacity(
        opacity: _visible == true ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Image.asset(
          "assets/images/logologin.png",
          scale: 1.5,
        ),
      ),
    );
  }

  Widget signInButton(width, scaffoldKey) {
    var userDetails = Provider.of<UserDetailsProvider>(context, listen: false);
    return Container(
      width: width - 50,
      child: ButtonTheme(
        minWidth: width - 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            padding: EdgeInsets.all(10.0),
            backgroundColor: Colors.white,
            disabledBackgroundColor: Colors.white.withOpacity(0.5),
          ),
          child: Text(
            "Sign In",
            style: TextStyle(
                fontFamily: "Mada", fontSize: 22.0, color: Color(0xFF181632)),
          ),
          onPressed: userDetails.getSignInEmail
              ? () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  showLoaderDialog(context);
                  // bool login = await httpService.login(
                  //     userDetails.getEmail.value,
                  //     userDetails.getPass.value,
                  //     context,
                  //     scaffoldKey);
                  // Navigator.pop(context);
                  // if (login) {
                  //   userDetails.destroyLoginValues();
                  //   Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => MyBottomNavigationBar(
                  //         pageInd: 0,
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   return;
                  // }
                }
              : null,
        ),
      ),
    );
  }

  void initiateFacebookLogin() async {
    // Using dummy login for Facebook since we're using static data
    setState(() {
      isShowing = true;
    });
    
    var name = "Facebook User";
    var email = "facebook_user@example.com";
    var code = "fb_123456789";
    var password = "password";

    print("++Facebook SignIn++");
    print("Name : " + name);
    print("Email : " + email);
    print("ID : " + code);

    goToDialog();
    
    // Simulate successful login after a delay
    Timer(Duration(seconds: 2), () {
      setState(() {
        isShowing = false;
      });
      
      // Set dummy auth token
      authToken = "dummy_facebook_token";
      storage.write(key: "token", value: authToken);
      
      Navigator.pop(context); // Close dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyBottomNavigationBar(
            pageInd: 0,
          ),
        ),
      );
    });
  }

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  Future<String?> socialLogin(url, email, password, code, name, uid) async {
    // Simulate successful login with dummy data
    authToken = "dummy_social_token";
    await storage.write(key: "token", value: authToken);
    await storage.write(key: "refreshToken", value: authToken);
    
    // Navigate to home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyBottomNavigationBar(
          pageInd: 0,
        ),
      ),
    );
    
    return null;
  }

  goToDialog() {
    if (isShowing == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.background),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    "Loading ..",
                    style: TextStyle(color: Colors.black.withOpacity(0.7)),
                  )
                ],
              ),
            ),
            onWillPop: () async => false),
      );
    } else {
      Navigator.pop(context);
    }
  }

  Widget googleLoginButton(width, scaffoldKey) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: ButtonTheme(
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.all(10.0),
                ),
                icon: Icon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                ),
                onPressed: () async {
                  // Simulate Google sign in with dummy data
                  setState(() {
                    isShowing = true;
                  });
                  
                  var email = "google_user@example.com";
                  var password = "password";
                  var code = "google_123456789";
                  var name = "Google User";

                  print("++Google SignIn++");
                  print("Name : " + name);
                  print("Email : " + email);
                  print("ID : " + code);

                  goToDialog();
                  
                  // Simulate successful login after a delay
                  Timer(Duration(seconds: 2), () {
                    setState(() {
                      isShowing = false;
                    });
                    
                    // Set dummy auth token
                    authToken = "dummy_google_token";
                    storage.write(key: "token", value: authToken);
                    
                    Navigator.pop(context); // Close dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyBottomNavigationBar(
                          pageInd: 0,
                        ),
                      ),
                    );
                  });
                },
                label: Text(
                  "Sign in with Google",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget guestLoginButton(width, scaffoldKey) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: ButtonTheme(
              height: 52,
              child: ElevatedButton.icon(
                icon: Icon(
                  FontAwesomeIcons.user,
                  color: Colors.black54,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.all(10.0),
                ),
                onPressed: () async {
                  // Simulate guest login with dummy data
                  setState(() {
                    isShowing = true;
                  });
                  
                  var email = 'guest_user@example.com';
                  var password = "password";
                  var code = "guest_123456789";
                  var name = 'Guest User';

                  print("++Guest SignIn++");
                  print("Name : " + name);
                  print("Email : " + email);
                  print("ID : " + code);

                  goToDialog();
                  
                  // Simulate successful login after a delay
                  Timer(Duration(seconds: 2), () {
                    setState(() {
                      isShowing = false;
                    });
                    
                    // Set dummy auth token
                    authToken = "dummy_guest_token";
                    storage.write(key: "token", value: authToken);
                    
                    Navigator.pop(context); // Close dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyBottomNavigationBar(
                          pageInd: 0,
                        ),
                      ),
                    );
                  });
                },
                label: Text(
                  "Sign in as Guest",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget fbLoginButton(width, scaffoldKey) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: ButtonTheme(
              height: 52.0,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4267B2),
                  padding: EdgeInsets.all(10.0),
                ),
                icon: Icon(
                  FontAwesomeIcons.facebook,
                  color: Colors.white,
                ),
                label: Text(
                  "Sign in with Facebook",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                onPressed: () async {
                  initiateFacebookLogin();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  Sign up row
  Widget signUpRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Don't have an account ?",
          style: TextStyle(
            fontFamily: "Mada",
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Container(
          padding: EdgeInsets.only(
            bottom: 3, // space between underline and text
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white, // Text colour here
                width: 1.0, // Underline width
              ),
            ),
          ),
          child: InkWell(
            child: Text(
              "Sign Up",
              style: TextStyle(
                fontFamily: "Mada",
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/signUp');
            },
          ),
        ),
      ],
    );
  }

  //  Login View
  Widget loginFields(homeAPIData, scaffoldKey) {
    var width = MediaQuery.of(context).size.width;
    var fb = Provider.of<HomeDataProvider>(context, listen: false)
        .homeModel!
        .settings!
        .fbLoginEnable;
    var googleLogin = Provider.of<HomeDataProvider>(context, listen: false)
        .homeModel!
        .settings!
        .googleLoginEnable;
    var guestLogin = Provider.of<HomeDataProvider>(context, listen: false)
        .homeModel!
        .settings!
        .guestEnable;
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            logo(homeAPIData.homeModel!.settings!.logo),
            SizedBox(
              height: 30,
            ),
            EmailField(),
            SizedBox(
              height: 30.0,
            ),
            PasswordField(),
            SizedBox(
              height: 30.0,
            ),
            signInButton(width, scaffoldKey),
            SizedBox(
              height: 50,
            ),
            "$googleLogin" == "1"
                ? googleLoginButton(width, scaffoldKey)
                : SizedBox.shrink(),
            SizedBox(
              height: 15,
            ),
            "$fb" == "1"
                ? fbLoginButton(width, scaffoldKey)
                : SizedBox.shrink(),
            SizedBox(
              height: 15.0,
            ),
            guestLogin == "1"
                ? guestLoginButton(width, scaffoldKey)
                : SizedBox.shrink(),
            SizedBox(
              height: 30.0,
            ),
            signUpRow(),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.only(
                  bottom: 3, // space between underline and text
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white, // Text colour here
                      width: 1.0, // Underline width
                    ),
                  ),
                ),
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          fontFamily: "Mada",
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/forgotPassword");
                  },
                )),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(25.0),
                child: Text(
                  homeAPIData.homeModel!.settings!.cpyTxt ?? "© 2023 Kloncept. All rights reserved.",
                  style: TextStyle(
                      fontFamily: "Mada",
                      color: Colors.white.withOpacity(0.5),
                      height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget backgroundView(width) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: IntrinsicHeight(
          child: Stack(children: <Widget>[
            Transform.translate(
              offset: Offset(0, animation!.value),
              child: Transform.scale(
                scale: squareScaleB,
                child: Container(
                  width: width,
                  child: Image.asset(
                    'assets/images/loginbgscroll.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: FractionalOffset.bottomCenter,
                    stops: [
                      0.0,
                      0.20,
                      0.28,
                      0.60
                    ],
                    colors: [
                      Color(0xFF181632).withOpacity(0.3),
                      Color(0xFF181632).withOpacity(0.7),
                      Color(0xFF181632).withOpacity(0.9),
                      Color(0xFF181632)
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // All Login field logo, text fields, text, social icons, copyright text, sign up text
  Widget loginView(width, homeAPIData, scaffoldKey) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).orientation == Orientation.landscape
            ? 1.6 * MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16),
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: loginFields(homeAPIData, scaffoldKey),
        ),
      ),
    );
  }

  Widget scaffoldView(width, homeAPIData, scaffoldKey) {
    return Stack(
      children: <Widget>[
        backgroundView(width),
        loginView(width, homeAPIData, scaffoldKey),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var homeData = Provider.of<HomeDataProvider>(context);
    return PopScope(
        canPop: canPopNow,
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          body: homeData.homeModel == null
              ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/logo.png"),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFF44A4A),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : scaffoldView(width, homeData, scaffoldKey),
        ),
        onPopInvokedWithResult: (didPop, dynamic) async {
          canPopNow = await onBackPressed();
          if (canPopNow == true) {
            canPopNow = true;
          }
        });
  }

  Future<bool> onBackPressed() {
    bool value = true;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        contentPadding: EdgeInsets.only(top: 5.0, left: 20.0, bottom: 0.0),
        title: Text(
          'Confirm Exit',
          textAlign: TextAlign.start,
          style: TextStyle(
              fontFamily: 'Mada',
              fontWeight: FontWeight.w700,
              color: Color(0xFF0284A2)),
        ),
        content: Text(
          'Are you sure that you want to exit',
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
              "Cancel".toUpperCase(),
              style: TextStyle(
                color: Color(0xFF0284A2),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              cancelInternetStatus();
              SystemNavigator.pop();
              Navigator.pop(context);
            },
            child: Text(
              "Yes".toUpperCase(),
              style: TextStyle(
                color: Color(0xFF0284A2),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return new Future.value(value);
  }
}





// import 'dart:convert';
// import 'dart:developer';
// import 'package:kloncept/common/apidata.dart';
// import 'package:kloncept/common/global.dart';
// import 'package:kloncept/localization/language_provider.dart';
// import 'package:kloncept/services/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../provider/home_data_provider.dart';
// import '../services/internetStatus.dart';
// import 'bottom_navigation_screen.dart';
// import '../Widgets/email_field.dart';
// import '../Widgets/password_field.dart';
// import '../provider/user_details_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import '../services/http_services.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';

// class SignInScreen extends StatefulWidget {
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen>
//     with TickerProviderStateMixin {
//   final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
//   int? _duration;
//   bool _visible = false;
//   Animation<double>? animation;
//   AnimationController? animationController;
//   var squareScaleB = 1.0;
//   AnimationController? _controllerB;
//   final HttpService httpService = HttpService();
//   bool isLoggedIn = false;
//   var profileData;
//   bool isShowing = false;
//   bool canPopNow = false;

//   @override
//   void dispose() {
//     super.dispose();
//     animationController?.dispose();
//     cancelInternetStatus();
//   }

//   @override
//   void initState() {
//     listenInternetStatus(context);
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//         // systemNavigationBarColor: Colors.blue, // navigation bar color
//         statusBarColor: Colors.black.withValues(alpha: 0.3),
//         statusBarIconBrightness: Brightness.light
//         // status bar color
//         ));
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       HomeDataProvider homeData =
//           Provider.of<HomeDataProvider>(context, listen: false);
//       await homeData.getHomeDetails(context);

//       if (await storage.containsKey(key: 'selectedCurrency') &&
//           await storage.containsKey(key: 'selectedCurrencyRate')) {
//         selectedCurrency = await storage.read(key: 'selectedCurrency');
//         selectedCurrencyRate =
//             int.tryParse(storage.read(key: 'selectedCurrencyRate').toString());
//       } else {
//         selectedCurrency = homeData.homeModel!.currency!.currency;
//         selectedCurrencyRate = 1;
//       }

//       // Loading Languages
//       LanguageProvider languageProvider =
//           Provider.of<LanguageProvider>(context, listen: false);
//       await languageProvider.loadData(context, loadScreen: false);
//       changeLocale(context, languageProvider.languageCode);

//       Timer(Duration(milliseconds: 500), () {
//         setState(() {
//           _visible = true;
//         });
//       });
//     });

//     _duration = 1200;

//     animationController = AnimationController(
//         vsync: this, duration: Duration(milliseconds: _duration as int));

//     animation = Tween<double>(begin: 0, end: -165)
//         .animate(animationController as AnimationController)
//       ..addListener(() {
//         setState(() {});
//       });
//     _controllerB = AnimationController(
//         vsync: this,
//         lowerBound: 1.0,
//         upperBound: 1.20,
//         duration: Duration(milliseconds: 3000));

//     _controllerB!.addListener(() {
//       setState(() {
//         squareScaleB = _controllerB!.value;
//       });
//     });

//     Timer(Duration(milliseconds: 500), () {
//       animationController!.forward();
//       _controllerB!.forward(from: 0.0);
//     });
//     super.initState();
//   }

// // Alert dialog after clicking on login button
//   showLoaderDialog(BuildContext context) {
//     AlertDialog alert = AlertDialog(
//       content: new Row(
//         children: [
//           CircularProgressIndicator(),
//           Container(
//               margin: EdgeInsets.only(left: 7), child: Text("Signing In ...")),
//         ],
//       ),
//     );
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

// // Logo on login page
//   Widget logo(String img) {
//     return Container(
//       margin: EdgeInsets.only(top: 50.0),
//       padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
//       child: AnimatedOpacity(
//         opacity: _visible == true ? 1.0 : 0.0,
//         duration: Duration(milliseconds: 500),
//         child: Image.asset(
//           "assets/images/logologin.png",
//           scale: 1.5,
//         ),
//       ),
//     );
//   }

//   Widget signInButton(width, scaffoldKey) {
//     var userDetails = Provider.of<UserDetailsProvider>(context, listen: false);
//     return Container(
//       width: width - 50,
//       child: ButtonTheme(
//         minWidth: width - 50,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(3),
//             ),
//             padding: EdgeInsets.all(10.0),
//             backgroundColor: Colors.white,
//             disabledBackgroundColor: Colors.white.withOpacity(0.5),
//           ),
//           child: Text(
//             "Sign In",
//             style: TextStyle(
//                 fontFamily: "Mada", fontSize: 22.0, color: Color(0xFF181632)),
//           ),
//           onPressed: userDetails.getSignInEmail
//               ? () async {
//                   FocusScope.of(context).requestFocus(FocusNode());
//                   showLoaderDialog(context);
//                   bool login = await httpService.login(
//                       userDetails.getEmail.value,
//                       userDetails.getPass.value,
//                       context,
//                       scaffoldKey);
//                   Navigator.pop(context);
//                   if (login) {
//                     userDetails.destroyLoginValues();
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => MyBottomNavigationBar(
//                           pageInd: 0,
//                         ),
//                       ),
//                     );
//                   } else {
//                     return;
//                   }
//                 }
//               : null,
//         ),
//       ),
//     );
//   }

//   void initiateFacebookLogin() async {
//     final LoginResult result = await FacebookAuth.instance.login();

//     if (result.status == LoginStatus.success) {
//       final AccessToken? accessToken = result.accessToken;

//       var graphResponse = await http.get(Uri.parse(
//           'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${accessToken!.tokenString}'));

//       var profile = json.decode(graphResponse.body);
//       setState(() {
//         isShowing = true;
//       });
//       var name = profile['name'];
//       var email = profile['email'];
//       var code = profile['id'];
//       var password = "password";

//       print("++Facebook SignIn++");
//       print("Name : " + name);
//       print("Email : " + email);
//       print("ID : " + code);

//       goToDialog();
//       socialLogin(APIData.fbLoginAPI, email, password, code, name, "code");

//       onLoginStatusChanged(true, profileData: profile);
//     } else {
//       print(result.status);
//       print(result.message);
//     }
//   }

//   void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
//     setState(() {
//       this.isLoggedIn = isLoggedIn;
//       this.profileData = profileData;
//     });
//   }

//   Future<String?> socialLogin(url, email, password, code, name, uid) async {
//     final res = await http.post(Uri.parse(url), body: {
//       "email": email,
//       "password": password,
//       "$uid": code,
//       "name": name,
//     });
//     print("Social Login API Status Code : ${res.statusCode}");
//     log("Social Login API Response : ${res.body}");
//     if (res.statusCode == 200) {
//       var body = jsonDecode(res.body);
//       authToken = body["access_token"];
//       var refreshToken = body["access_token"];
//       await storage.write(key: "token", value: "$authToken");
//       await storage.write(key: "refreshToken", value: "$refreshToken");
//       authToken = await storage.read(key: "token");
//       HomeDataProvider homeData =
//           Provider.of<HomeDataProvider>(context, listen: false);
//       await homeData.getHomeDetails(context);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => MyBottomNavigationBar(
//             pageInd: 0,
//           ),
//         ),
//       );
//     } else {
//       setState(() {
//         isShowing = false;
//       });
//       Navigator.pop(context);
//       Fluttertoast.showToast(msg: "Error in login");
//     }
//     return null;
//   }

//   goToDialog() {
//     if (isShowing == true) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => WillPopScope(
//             child: AlertDialog(
//               backgroundColor: Colors.white,
//               title: Row(
//                 children: [
//                   CircularProgressIndicator(
//                     valueColor: new AlwaysStoppedAnimation<Color>(
//                         Theme.of(context).colorScheme.background),
//                   ),
//                   SizedBox(
//                     width: 15.0,
//                   ),
//                   Text(
//                     "Loading ..",
//                     style: TextStyle(color: Colors.black.withOpacity(0.7)),
//                   )
//                 ],
//               ),
//             ),
//             onWillPop: () async => false),
//       );
//     } else {
//       Navigator.pop(context);
//     }
//   }

//   Widget googleLoginButton(width, scaffoldKey) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: ButtonTheme(
//               height: 52,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   padding: EdgeInsets.all(10.0),
//                 ),
//                 icon: Icon(
//                   FontAwesomeIcons.google,
//                   color: Colors.red,
//                 ),
//                 onPressed: () async {
//                   signInWithGoogle().then((result) {
//                     if (result != null) {
//                       setState(() {
//                         isShowing = true;
//                       });
//                       var email = result.email;
//                       var password = "password";
//                       var code = result.uid;
//                       var name = result.displayName;

//                       print("++Google SignIn++");
//                       print("Name : " + name.toString());
//                       print("Email : " + email.toString());
//                       print("ID : " + code);

//                       goToDialog();
//                       socialLogin(APIData.googleLoginApi, email, password, code,
//                           name, "uid");
//                     }
//                   });
//                 },
//                 label: Text(
//                   "Sign in with Google",
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     color: Colors.black.withOpacity(0.7),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget guestLoginButton(width, scaffoldKey) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: ButtonTheme(
//               height: 52,
//               child: ElevatedButton.icon(
//                 icon: Icon(
//                   FontAwesomeIcons.user,
//                   color: Colors.black54,
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   padding: EdgeInsets.all(10.0),
//                 ),
//                 onPressed: () async {
//                   signInAnonymously().then((result) {
//                     if (result != null) {
//                       setState(() {
//                         isShowing = true;
//                       });
//                       var email = 'guest_${result.uid}@gmail.com';
//                       var password = "password";
//                       var code = result.uid;
//                       var name = 'Guest User';

//                       print("++Guest SignIn++");
//                       print("Name : " + name);
//                       print("Email : " + email);
//                       print("ID : " + code);

//                       goToDialog();
//                       socialLogin(APIData.googleLoginApi, email, password, code,
//                           name, "uid");
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('Guest Sign-in failed!'),
//                           backgroundColor: Colors.red,
//                           duration: Duration(seconds: 5),
//                         ),
//                       );
//                     }
//                   });
//                 },
//                 label: Text(
//                   "Sign in as Guest",
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     color: Colors.black.withOpacity(0.7),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget fbLoginButton(width, scaffoldKey) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: ButtonTheme(
//               height: 52.0,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF4267B2),
//                   padding: EdgeInsets.all(10.0),
//                 ),
//                 icon: Icon(
//                   FontAwesomeIcons.facebook,
//                   color: Colors.white,
//                 ),
//                 label: Text(
//                   "Sign in with Facebook",
//                   style: TextStyle(color: Colors.white, fontSize: 18.0),
//                 ),
//                 onPressed: () async {
//                   initiateFacebookLogin();
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   //  Sign up row
//   Widget signUpRow() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Text(
//           "Don't have an account ?",
//           style: TextStyle(
//             fontFamily: "Mada",
//             fontSize: 16,
//             color: Colors.white,
//           ),
//         ),
//         SizedBox(
//           width: 10.0,
//         ),
//         Container(
//           padding: EdgeInsets.only(
//             bottom: 3, // space between underline and text
//           ),
//           decoration: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(
//                 color: Colors.white, // Text colour here
//                 width: 1.0, // Underline width
//               ),
//             ),
//           ),
//           child: InkWell(
//             child: Text(
//               "Sign Up",
//               style: TextStyle(
//                 fontFamily: "Mada",
//                 fontSize: 16,
//                 color: Colors.white,
//               ),
//             ),
//             onTap: () {
//               Navigator.of(context).pushNamed('/signUp');
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   //  Login View
//   Widget loginFields(homeAPIData, scaffoldKey) {
//     var width = MediaQuery.of(context).size.width;
//     var fb = Provider.of<HomeDataProvider>(context, listen: false)
//         .homeModel!
//         .settings!
//         .fbLoginEnable;
//     var googleLogin = Provider.of<HomeDataProvider>(context, listen: false)
//         .homeModel!
//         .settings!
//         .googleLoginEnable;
//     var guestLogin = Provider.of<HomeDataProvider>(context, listen: false)
//         .homeModel!
//         .settings!
//         .guestEnable;
//     return Container(
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             logo(homeAPIData.homeModel.settings.logo),
//             SizedBox(
//               height: 30,
//             ),
//             EmailField(),
//             SizedBox(
//               height: 30.0,
//             ),
//             PasswordField(),
//             SizedBox(
//               height: 30.0,
//             ),
//             signInButton(width, scaffoldKey),
//             SizedBox(
//               height: 50,
//             ),
//             "$googleLogin" == "1"
//                 ? googleLoginButton(width, scaffoldKey)
//                 : SizedBox.shrink(),
//             SizedBox(
//               height: 15,
//             ),
//             "$fb" == "1"
//                 ? fbLoginButton(width, scaffoldKey)
//                 : SizedBox.shrink(),
//             SizedBox(
//               height: 15.0,
//             ),
//             guestLogin == "1"
//                 ? guestLoginButton(width, scaffoldKey)
//                 : SizedBox.shrink(),
//             SizedBox(
//               height: 30.0,
//             ),
//             signUpRow(),
//             SizedBox(
//               height: 10,
//             ),
//             Container(
//                 padding: EdgeInsets.only(
//                   bottom: 3, // space between underline and text
//                 ),
//                 decoration: BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(
//                       color: Colors.white, // Text colour here
//                       width: 1.0, // Underline width
//                     ),
//                   ),
//                 ),
//                 child: InkWell(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       "Forgot Password?",
//                       style: TextStyle(
//                           fontFamily: "Mada",
//                           fontSize: 14,
//                           color: Colors.white),
//                     ),
//                   ),
//                   onTap: () {
//                     Navigator.pushNamed(context, "/forgotPassword");
//                   },
//                 )),
//             Align(
//               alignment: FractionalOffset.bottomCenter,
//               child: Container(
//                 padding: EdgeInsets.all(25.0),
//                 child: Text(
//                   homeAPIData.homeModel.settings.cpyTxt,
//                   style: TextStyle(
//                       fontFamily: "Mada",
//                       color: Colors.white.withOpacity(0.5),
//                       height: 1.5),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget backgroundView(width) {
//     return SingleChildScrollView(
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           minWidth: MediaQuery.of(context).size.width,
//           minHeight: MediaQuery.of(context).size.height,
//         ),
//         child: IntrinsicHeight(
//           child: Stack(children: <Widget>[
//             Transform.translate(
//               offset: Offset(0, animation!.value),
//               child: Transform.scale(
//                 scale: squareScaleB,
//                 child: Container(
//                   width: width,
//                   child: Image.asset(
//                     'assets/images/loginbgscroll.png',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: FractionalOffset.bottomCenter,
//                     stops: [
//                       0.0,
//                       0.20,
//                       0.28,
//                       0.60
//                     ],
//                     colors: [
//                       Color(0xFF181632).withOpacity(0.3),
//                       Color(0xFF181632).withOpacity(0.7),
//                       Color(0xFF181632).withOpacity(0.9),
//                       Color(0xFF181632)
//                     ]),
//               ),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }

//   // All Login field logo, text fields, text, social icons, copyright text, sign up text
//   Widget loginView(width, homeAPIData, scaffoldKey) {
//     return SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       child: Container(
//         height: MediaQuery.of(context).orientation == Orientation.landscape
//             ? 1.6 * MediaQuery.of(context).size.height
//             : MediaQuery.of(context).size.height,
//         padding: EdgeInsets.all(16),
//         child: Align(
//           alignment: FractionalOffset.bottomCenter,
//           child: loginFields(homeAPIData, scaffoldKey),
//         ),
//       ),
//     );
//   }

//   Widget scaffoldView(width, homeAPIData, scaffoldKey) {
//     return Stack(
//       children: <Widget>[
//         backgroundView(width),
//         loginView(width, homeAPIData, scaffoldKey),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var homeData = Provider.of<HomeDataProvider>(context);
//     return PopScope(
//         canPop: canPopNow,
//         child: Scaffold(
//           key: scaffoldKey,
//           resizeToAvoidBottomInset: false,
//           body: homeData.homeModel == null
//               ? Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset("assets/images/logo.png"),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Color(0xFFF44A4A),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 )
//               : scaffoldView(width, homeData, scaffoldKey),
//         ),
//         onPopInvokedWithResult: (didPop, dynamic) async {
//           canPopNow = await onBackPressed();
//           if (canPopNow == true) {
//             canPopNow = true;
//           }
//           // return result;
//         });
//   }

//   Future<bool> onBackPressed() {
//     bool value = true;
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//         contentPadding: EdgeInsets.only(top: 5.0, left: 20.0, bottom: 0.0),
//         title: Text(
//           'Confirm Exit',
//           textAlign: TextAlign.start,
//           style: TextStyle(
//               fontFamily: 'Mada',
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF0284A2)),
//         ),
//         content: Text(
//           'Are you sure that you want to exit',
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
//               "Cancel".toUpperCase(),
//               style: TextStyle(
//                 color: Color(0xFF0284A2),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               cancelInternetStatus();
//               SystemNavigator.pop();
//               Navigator.pop(context);
//             },
//             child: Text(
//               "Yes".toUpperCase(),
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
// }