import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:in_app_update/in_app_update.dart';

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> checkForUpdate(BuildContext context) async {
  InAppUpdate.checkForUpdate().then((appUpdateInfo) {
    if (appUpdateInfo.updateAvailability ==
        UpdateAvailability.updateAvailable) {
      InAppUpdate.startFlexibleUpdate().then((_) {
        InAppUpdate.completeFlexibleUpdate().then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(translate("App_updated_successfully")),
            ),
          );
        }).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        });
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translate("App_is_already_up_to_date")),
        ),
      );
    }
  }).catchError((e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  });
}
