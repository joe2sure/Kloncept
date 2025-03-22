// File: lib/provider/dummy_watchlist_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kloncept/model/dummy/dummy_watchlist_model.dart';

class DummyWatchlistProvider extends ChangeNotifier {
  DummyWatchlistModel? watchlistModel;
  bool isRemoving = false;
  
  // Initialize with some dummy data
  DummyWatchlistProvider() {
    // Initialize with empty watchlist
    watchlistModel = DummyWatchlistModel(watchlist: []);
  }

  Future<void> loadData({int delayInSeconds = 0}) async {
    // Simulate API delay
    await Future.delayed(Duration(seconds: delayInSeconds));
    
    // Create some dummy watchlist items
    watchlistModel = DummyWatchlistModel(
      watchlist: List.generate(
        3,
        (index) => DummyWatchlist(
          id: index + 1,
          userId: "user${index + 1}",
          courseId: "${index + 1}",
          startTime: DateTime.now().subtract(Duration(days: index)).toString(),
          active: "1",
          createdAt: DateTime.now().subtract(Duration(days: index + 5)).toString(),
          updatedAt: DateTime.now().toString(),
        ),
      ),
    );
    
    notifyListeners();
  }

  Future<void> addToWatchList({int? courseId}) async {
    // Simulate API delay
    await Future.delayed(Duration(milliseconds: 500));
    
    // Store course ID in SharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("courseId", courseId.toString());
    
    // Add course to watchlist
    if (watchlistModel != null && watchlistModel!.watchlist != null) {
      // Check if course already exists in watchlist
      bool exists = watchlistModel!.watchlist!.any(
        (item) => item.courseId == courseId.toString()
      );
      
      if (!exists) {
        // Add new item to watchlist
        watchlistModel!.watchlist!.add(
          DummyWatchlist(
            id: watchlistModel!.watchlist!.length + 1,
            userId: "current_user",
            courseId: courseId.toString(),
            startTime: DateTime.now().toString(),
            active: "1",
            createdAt: DateTime.now().toString(),
            updatedAt: DateTime.now().toString(),
          ),
        );
        
        print("Added to WatchList");
      }
    } else {
      // Initialize watchlist if it doesn't exist
      watchlistModel = DummyWatchlistModel(
        watchlist: [
          DummyWatchlist(
            id: 1,
            userId: "current_user",
            courseId: courseId.toString(),
            startTime: DateTime.now().toString(),
            active: "1",
            createdAt: DateTime.now().toString(),
            updatedAt: DateTime.now().toString(),
          ),
        ],
      );
      
      print("Created new WatchList and added course");
    }
    
    notifyListeners();
  }

  Future<void> removeFromWatchList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    
    if (sharedPreferences.containsKey("courseId") || true) {
      isRemoving = true;
      notifyListeners();
      
      String courseId = sharedPreferences.getString("courseId") ?? "1";
      
      // Simulate API delay
      await Future.delayed(Duration(milliseconds: 500));
      
      // Remove course from watchlist
      if (watchlistModel != null && watchlistModel!.watchlist != null) {
        watchlistModel!.watchlist!.removeWhere(
          (item) => item.courseId == courseId
        );
        
        await sharedPreferences.remove("courseId");
        print("Removed from WatchList");
      }
      
      isRemoving = false;
      notifyListeners();
    }
  }

  bool isWatching(int? courseId) {
    if (watchlistModel == null || watchlistModel!.watchlist == null) {
      return false;
    }
    
    return watchlistModel!.watchlist!.any(
      (item) => item.courseId == courseId.toString()
    );
  }
}