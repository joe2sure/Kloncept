import 'dart:convert';
import '../common/apidata.dart';
import '../model/bundle_courses_model.dart';
import '../model/cart_model.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class BundleCourseProvider with ChangeNotifier {
  List<BundleCourses>? bundleCourses = [];

  late BundleCourses ans;
  BundleCourses getBundleDetails(CartModel bundle) {
    bundleCourses!.forEach((element) {
      if (element.id.toString() == bundle.bundleId.toString()) ans = element;
    });

    return ans;
  }

  getDealData(context) async {
    // loading = true;
    try {
      bundleCourses = (await getbundles(context));
    } catch (e) {
      // loading = true;
    }

    notifyListeners();
    return bundleCourses;
  }

  Future<List<BundleCourses>> getbundles(context) async {
    String url = "${APIData.bundleCourses}";

    http.Response res = await http.get(Uri.parse(url));
    List<BundleCourses> courses = [];
    print("Bundle Course API22 :-> $url");
    if (res.statusCode == 200) {
      var json = jsonDecode(res.body)["Bundle"];
      // json.forEach((v) {
      //   courses.add(new BundleCourses.fromJson(v));
      // });
      print("Bundle Course API200 :-> ${json.length}");
      for (int i = 0; i < json.length; i++) {
        courses.add(BundleCourses(
          id: json[i]["id"],
          userId: json[i]["user_id"],
          courseId: List<String>.from(json[i]["course_id"].map((x) => x)),
          title: json[i]["title"],
          detail: json[i]["detail"],
          price: json[i]["price"],
          discountPrice: json[i]["discount_price"],
          type: json[i]["type"],
          slug: json[i]["slug"],
          status: json[i]["status"].toString(),
          featured: json[i]["featured"],
          previewImage: json[i]["preview_image"] == null
              ? "null"
              : json[i]["preview_image"],
          createdAt: json[i]["created_at"],
          updatedAt: json[i]["updated_at"],
        ));
      }
      this.bundleCourses = courses;
    } else {
      print("Bundle Course API :-> $url");
      print("Bundle Course Status Code :-> ${res.statusCode}");
      print("Bundle Course Body :-> ${res.statusCode}");
      throw "err";
    }
    notifyListeners();
    return courses;
  }
}
