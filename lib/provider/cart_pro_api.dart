import '../common/apidata.dart';
import '../common/global.dart';
import '../model/cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:kloncept/model/bundle_courses_model.dart';

class CartProducts with ChangeNotifier {
  List<CartModel>? cartContentsCourses = [];
  List<int>? courseIds = [];
  List<int>? bundleIds = [];

  bool checkBundle(int? id) {
    bool ans = false;
    bundleIds!.forEach((element) {
      if (id == element) ans = true;
    });
    return ans;
  }

  int? checkDataType(dynamic x) {
    if (x is int)
      return 0;
    else
      return 1;
  }

  int? get cartTotal {
    int? tPrice = 0;
    cartContentsCourses!.forEach((element) {
      if (element.offerPrice == null)
        //tPrice += 0;
      tPrice = 0;
      else if (checkDataType(element.offerPrice) == 0)
       // tPrice += element.offerPrice;
        tPrice =(tPrice!+ int.parse(element.offerPrice));
      else
      //  tPrice += int.parse(element.offerPrice);
        tPrice =(tPrice!+ int.parse(element.offerPrice));
    });
    return tPrice;
  }

  bool inCart(int? id) {
    for (int i = 0; i < courseIds!.length; i++) {
      if (id == courseIds![i]) return true;
    }
    return false;
  }
}

class CartApiCall {
  List<CartModel> cartList = [];

  Future<bool> removeFromCart(dynamic id, BuildContext ctx) async {
    authToken = await storage.read(key: "token");
    String url = "${APIData.removeFromCart}" + APIData.secretKey;
    http.Response res = await http.post(Uri.parse(url), body: {
      "course_id": id.toString()
    }, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    checkDataType(id);
    if (res.statusCode == 200) {
      return true;
    } else
      return false;
  }

  Future<bool> removeBundleFromCart(
      String bundleId, BuildContext ctx, BundleCourses detail) async {
    authToken = await storage.read(key: "token");
    String url = "${APIData.removeBundleCourseFromCart}" + APIData.secretKey;
    http.Response res = await http.post(Uri.parse(url), body: {
      "bundle_id": bundleId
    }, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });

    if (res.statusCode == 200) {
      return true;
    } else
      return false;
  }

  Future<bool> addtocart(String id, BuildContext ctx) async {
    authToken = await storage.read(key: "token");
    String url = APIData.addToCart + "${APIData.secretKey}";
    http.Response res = await http.post(Uri.parse(url), body: {
      "course_id": id
    }, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    if (res.statusCode == 200) {
      return true;
    } else
      return false;
  }

  int checkDataType(dynamic x) {
    if (x is int)
      return 0;
    else
      return 1;
  }

  Future<bool> addToCartBundle(String bundleId, BuildContext ctx) async {
    authToken = await storage.read(key: "token");
    String url = APIData.addBundleToCart + "${APIData.secretKey}";
    http.Response res = await http.post(Uri.parse(url), body: {
      "bundle_id": bundleId
    }, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    if (res.statusCode == 200) {
      return true;
    } else
      return false;
  }
}
