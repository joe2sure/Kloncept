import 'package:flutter/material.dart';

class Visible with ChangeNotifier {
  bool _isVisible = false;

  bool get globalVisible => _isVisible;

  void toggleVisible(bool value) {
    _isVisible = value;
    notifyListeners();
  }
}



// import 'package:flutter/material.dart';

// class Visible with ChangeNotifier {
//   bool _visible = false;

//   bool get globalVisible {
//     return _visible;
//   }

//   void toggleVisible(bool vis) {
//     _visible = vis;
//     notifyListeners();
//   }
// }
