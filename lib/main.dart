import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'common/global.dart';
import 'my_app.dart';
import 'services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  // await Firebase.initializeApp();

  // try {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  // set observer
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
  // } catch (e) {
  //   print("Failed to initialize Firebase: $e");
  // }
  WidgetsFlutterBinding.ensureInitialized();
  authToken = await storage.read(key: "token");

  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en',
      supportedLocales: ['en', 'ar', 'ur', 'hi', 'fr', 'es']);

  HttpOverrides.global = new MyHttpOverrides();

  runApp(LocalizedApp(delegate, MyApp(authToken, observer)));
}

//Solutions For : HandshakeException: Handshake error in client (CERTIFICATE_VERIFY_FAILED: certificate has expired)

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return host == "example.com" ? true : false;
      };
  }
}