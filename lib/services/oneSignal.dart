import 'dart:developer';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../common/apidata.dart';

String _debugLabelString = "";

// For One Signal notification
Future<void> initPlatformState() async {
  OneSignal.initialize(APIData.oneSignalAppID);
  await OneSignal.Location.requestPermission();
  OneSignal.Notifications.requestPermission(true);
  await OneSignal.Location.setShared(true);
  OneSignal.User.pushSubscription.id;
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.Notifications.addForegroundWillDisplayListener((event) {});
  OneSignal.Notifications.addPermissionObserver((state) {
    //log.i(text: 'Accepted Onesignal permission: $state');
  });
  OneSignal.InAppMessages.addWillDisplayListener((event) {
    //log.i(text: 'inAppMessage ${event.message}');
  });
  OneSignal.Notifications.addClickListener((event) {
    _debugLabelString =
        "Opened Notification : \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    log(_debugLabelString);
  });
}
