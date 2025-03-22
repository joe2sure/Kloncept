// import 'dart:convert';
// import 'dart:io';
// import 'package:kloncept/common/apidata.dart';
// import 'package:kloncept/common/global.dart';
// import 'package:kloncept/model/my_cart.dart';
// import 'package:kloncept/provider/bundle_course.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'courses_provider.dart';
// import 'package:kloncept/model/course.dart';
// import 'package:kloncept/model/bundle_courses_model.dart';

// class CartProvider extends ChangeNotifier {
//   MyCart? myCart;
//   List<Course>? cartCourseList;
//   List<BundleCourses>? cartBundleList;

//   Future<MyCart?> fetchCart(BuildContext context) async {
//     cartCourseList = [];
//     cartBundleList = [];
//     var coursesList =
//         Provider.of<CoursesProvider>(context, listen: false).allCourses;
//     var bundleList =
//         Provider.of<BundleCourseProvider>(context, listen: false).bundleCourses;
//     final response = await http.post(
//       Uri.parse("${APIData.showCart}${APIData.secretKey}"),
//       headers: {
//         HttpHeaders.authorizationHeader: "Bearer $authToken",
//         HttpHeaders.acceptHeader: "Application/json",
//       },
//     );
//     print("cart response: ${response.body}");
//     if (response.statusCode == 200) {
//       myCart = MyCart.fromJson(json.decode(response.body));
//       for (int i = 0; i < coursesList!.length; i++) {
//         for (int j = 0; j < myCart!.cart!.length; j++) {
//           if ("${coursesList[i].id}" == "${myCart!.cart![j].courseId}") {
//             cartCourseList!.add(Course(
//               id: coursesList[i].id,
//               userId: coursesList[i].userId,
//               categoryId: coursesList[i].categoryId,
//               subcategoryId: coursesList[i].subcategoryId,
//               childcategoryId: coursesList[i].childcategoryId,
//               languageId: coursesList[i].languageId,
//               title: coursesList[i].title,
//               shortDetail: coursesList[i].shortDetail,
//               detail: coursesList[i].detail,
//               requirement: coursesList[i].requirement,
//               price: coursesList[i].price,
//               discountPrice: coursesList[i].discountPrice,
//               day: coursesList[i].day,
//               video: coursesList[i].video,
//               url: coursesList[i].url,
//               featured: coursesList[i].featured,
//               slug: coursesList[i].slug,
//               status: coursesList[i].status,
//               previewImage: coursesList[i].previewImage,
//               videoUrl: coursesList[i].videoUrl,
//               previewType: coursesList[i].previewType,
//               type: coursesList[i].type,
//               duration: coursesList[i].duration,
//               durationType: coursesList[i].durationType,
//               lastActive: coursesList[i].lastActive,
//               createdAt: coursesList[i].createdAt,
//               updatedAt: coursesList[i].updatedAt,
//               include: coursesList[i].include,
//               whatlearns: coursesList[i].whatlearns,
//               review: coursesList[i].review,
//             ));
//           }
//         }
//       }
//       for (int i = 0; i < bundleList!.length; i++) {
//         for (int j = 0; j < myCart!.cart!.length; j++) {
//           if ("${bundleList[i].id}" == "${myCart!.cart![j].bundleId}") {
//             cartBundleList!.add(BundleCourses(
//               id: bundleList[i].id,
//               userId: bundleList[i].userId,
//               courseId: bundleList[i].courseId,
//               title: bundleList[i].title,
//               detail: bundleList[i].detail,
//               price: bundleList[i].price,
//               discountPrice: bundleList[i].discountPrice,
//               type: bundleList[i].type,
//               slug: bundleList[i].slug,
//               status: bundleList[i].status,
//               featured: bundleList[i].featured,
//               previewImage: bundleList[i].previewImage,
//               createdAt: bundleList[i].createdAt,
//             ));
//           }
//         }
//       }

//       cartCourseList!.removeWhere((element) => "${element.status}" == "0");
//     } else {
//       throw "Can't get cart items";
//     }
//     notifyListeners();
//     return myCart;
//   }

//   int get cartTotal {
//     int tPrice = 0;
//     cartCourseList!.forEach((element) {
//       if (element.discountPrice == null)
//         tPrice += num.tryParse(element.price.toString())!.round();
//       else if (checkDataType(element.discountPrice) == 0)
//         tPrice += num.tryParse(element.price.toString())!.round();
//       else
//         tPrice += num.tryParse(element.discountPrice)!.round();
//     });
//     cartBundleList!.forEach((element) {
//       if (element.discountPrice == null)
//         tPrice += num.tryParse(element.price)!.round();
//       else if (checkDataType(element.discountPrice) == 0)
//         tPrice += num.tryParse(element.price)!.round();
//       else
//         tPrice += num.tryParse(element.discountPrice)!.round();
//     });
//     return tPrice;
//   }

//   int checkDataType(dynamic x) {
//     if (x is int)
//       return 0;
//     else
//       return 1;
//   }
// }
