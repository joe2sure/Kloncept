import 'dart:convert';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/model/watchlist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistProvider extends ChangeNotifier {
  WatchlistModel? watchlistModel;
  bool isRemoving = false;

  Future<void> loadData({int delayInSeconds = 0}) async {
    String url = APIData.getAllWatchlist + APIData.secretKey;

    await Future.delayed(Duration(seconds: delayInSeconds));
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );
    if (response.statusCode == 200) {
      String data = response.body;
      print('Watchlist Response :-> $data');
      watchlistModel = WatchlistModel.fromJson(await jsonDecode(data));
    } else {
      print('Watchlist Response Code :-> ${response.statusCode}');
    }
  }

  Future<void> addToWatchList({int? courseId}) async {
    String url = APIData.addToWatchlist + APIData.secretKey;

    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
      body: {
        "course_id": courseId.toString(),
      },
    );

    if (response.statusCode == 200) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("courseId", courseId.toString());
      print("Added to WatchList");
      await loadData();
    } else {
      print("Didn't add to WatchList");
    }
  }

  Future<void> removeFromWatchList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey("courseId") || true) {
      isRemoving = true;

      String courseId = sharedPreferences.getString("courseId") ?? "1";

      String url = APIData.deleteFromWatchlist + APIData.secretKey;

      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: {
          "course_id": courseId,
        },
      );

      if (response.statusCode == 200) {
        await sharedPreferences.remove("courseId");
        print("Removed from WatchList");
        await loadData();
      } else {
        print("Didn't remove from WatchList");
      }

      isRemoving = false;
    }
  }

  bool isWatching(int? courseId) {
    return false;
  }
}
