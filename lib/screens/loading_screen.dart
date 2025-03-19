import 'dart:async';
import 'package:kloncept/localization/language_provider.dart';
import 'package:kloncept/services/internetStatus.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'bottom_navigation_screen.dart';
import '../common/global.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: must_be_immutable
class LoadingScreen extends StatefulWidget {
  String? token;
  LoadingScreen(this.token);
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}
class _LoadingScreenState extends State<LoadingScreen> {
  bool _visible = false;
  @override
  void initState() {
    super.initState();
    // listenInternetStatus(context); // Disabled for now
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        // Set dummy token if not already set
        if (authToken == null) {
          authToken = "dummy_token";
          await storage.write(key: "token", value: authToken);
        }
        // Load dummy data from providers
        HomeDataProvider homeData =
            Provider.of<HomeDataProvider>(context, listen: false);
        await homeData.getHomeDetails(context);
        // Set currency
        if (await storage.containsKey(key: 'selectedCurrency') &&
            await storage.containsKey(key: 'selectedCurrencyRate')) {
          selectedCurrency = await storage.read(key: 'selectedCurrency');
          selectedCurrencyRate =
              int.tryParse(await storage.read(key: 'selectedCurrencyRate') ?? "1") ?? 1;
        } else {
          selectedCurrency = homeData.homeModel!.currency!.currency;
          selectedCurrencyRate = 1;
        }
        // Load language data using dummy data
        LanguageProvider languageProvider =
            Provider.of<LanguageProvider>(context, listen: false);
        await languageProvider.loadData(context, loadScreen: false);
        // Change locale to the selected language
        changeLocale(context, languageProvider.languageCode);
        // Proceed to main app after a short delay
        Timer(Duration(milliseconds: 1500), () {
          setState(() {
            _visible = true;
          });
        });
      } catch (e) {
        print("Error in LoadingScreen initState: $e");
      }
    });
  }
  Widget logoWidget() {
    return Column(
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
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF44A4A)),
            ),
          ],
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _visible ? MyBottomNavigationBar(pageInd: 0) : logoWidget(),
    );
  }
  @override
  void dispose() {
    cancelInternetStatus();
    super.dispose();
  }
}





// import 'dart:async';
// import 'package:kloncept/localization/language_provider.dart';
// import 'package:kloncept/services/internetStatus.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import 'bottom_navigation_screen.dart';
// import '../common/global.dart';
// import '../provider/home_data_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// // ignore: must_be_immutable
// class LoadingScreen extends StatefulWidget {
//   String? token;
//   LoadingScreen(this.token);
//   @override
//   _LoadingScreenState createState() => _LoadingScreenState();
// }

// class _LoadingScreenState extends State<LoadingScreen> {
//   bool _visible = false;

//   initState() {
//     super.initState();
//     listenInternetStatus(context);
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       var token = await storage.read(key: "token");
//       print('me$token');
//       authToken = token;
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

//       setState(() {
//         authToken = token;
//       });
//       Timer(Duration(milliseconds: 500), () {
//         setState(() {
//           _visible = true;
//         });
//       });
//     });
//   }

//   Widget logoWidget() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset("assets/images/logo.png"),
//           ],
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF44A4A)),
//             ),
//           ],
//         )
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _visible == true ? MyBottomNavigationBar(pageInd: 0) : logoWidget(),
//     );
//   }

//   @override
//   void dispose() {
//     cancelInternetStatus();
//     super.dispose();
//   }
// }
