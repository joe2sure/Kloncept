import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

StreamSubscription<List<ConnectivityResult>>? _subscription;
bool noInternet = false;

void listenInternetStatus(BuildContext context) async {
  if (_subscription == null) {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result == ConnectivityResult.none) {
        noInternet = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "No Internet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        if (noInternet) {
          noInternet = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Internet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                ),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    });
  }
}

void cancelInternetStatus() {
  if (_subscription != null) {
    _subscription!.cancel();
  }
}
