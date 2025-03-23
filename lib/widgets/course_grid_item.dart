import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kloncept/provider/dummy/dummy_home_data_provider.dart';
import 'package:kloncept/provider/dummy/dummy_provider.dart';
import '../Widgets/rating_star.dart';
import '../common/apidata.dart';
import '../common/theme.dart' as T;
import '../model/course.dart';
import '../model/review.dart';
import '../provider/courses_provider.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/dummy_utils.dart';
import './utils.dart';

// ignore: must_be_immutable
class CourseGridItem extends StatelessWidget {
  Course? courseDetail;
  int? idx;
  CourseGridItem(this.courseDetail, this.idx);
  EdgeInsets? edgeInsets;

  int checkDatatype(dynamic x) {
    if (x is int)
      return 0;
    else
      return 1;
  }

  String getRating(List<Review>? data) {
    if (data == null || data.isEmpty) return "0";
    
    double ans = 0.0;
    bool calcAsInt = true;
    if (data.length > 0)
      calcAsInt = checkDatatype(data[0].learn) == 0 ? true : false;

    data.forEach((element) {
      if (!calcAsInt) {
        // Handle String type ratings
        ans += (int.tryParse(element.price.toString() ?? "0")! +
                int.tryParse(element.value.toString() ?? "0")! +
                int.tryParse(element.learn.toString() ?? "0")!)
                .toDouble() / 3.0;
      } else {
        // Handle int/double type ratings
        var priceVal = element.price ?? 0;
        var valueVal = element.value ?? 0;
        var learnVal = element.learn ?? 0;
        ans += (priceVal + valueVal + learnVal) / 3.0;
      }
    });
    if (ans == 0.0) return "0";
    return (ans / data.length).toStringAsPrecision(2);
  }

  Widget itemDetails(BuildContext context, bool isPurchased, String? currency,
      String? rating, String? category) {
    return Material(
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          // onTap: () {
          //   Course? details = courseDetail;
          //   Navigator.of(context).pushNamed("/courseDetails",
          //       arguments: DataSend(details!.userId, isPurchased, details.id,
          //           details.categoryId, details.type));
          // },
          child: Container(
            height: 360,
            width: MediaQuery.of(context).size.width / 3.5,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: courseDetail!.previewImage == null
                        ? Image.asset(
                            "assets/placeholder/featured.png",
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: courseDetail!.previewImage!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10.0)),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Image.asset(
                              "assets/placeholder/featured.png",
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/placeholder/featured.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 70,
                              child: Text(
                                category != null ? category : "Uncategorized",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()..shader = linearGradient,
                                ),
                              ),
                            ),
                            if (courseDetail!.discountPrice != null &&
                                courseDetail!.discountPrice.toString() != "null")
                              Text(
                                "${currencySymbol(selectedCurrency)} ${(num.tryParse(courseDetail!.discountPrice.toString())! * selectedCurrencyRate)}",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              )
                            else
                              SizedBox.shrink(),
                          ],
                        ),
                        if (courseDetail!.price != null &&
                            courseDetail!.price.toString() != "null")
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "${currencySymbol(selectedCurrency)} ${(num.tryParse(courseDetail!.price.toString())! * selectedCurrencyRate)}",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 12.0,
                                  color: Colors.grey),
                            ),
                          )
                        else
                          SizedBox(
                            height: 15,
                          ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          courseDetail!.title.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Text(
                          courseDetail!.shortDetail != null 
                            ? courseDetail!.shortDetail.toString()
                            : "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13.0),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate("by_admin"),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            StarRating(
                              rating: double.tryParse(rating!) ?? 0.0,
                              size: 12.0,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Object currency = Provider.of<DummyCurrenciesProvider>(context).currencies ?? "USD";
    String? category = Provider.of<HomeDataProvider>(context)
        .getCategoryName(courseDetail?.categoryId);

    bool isPurchased =
        Provider.of<CoursesProvider>(context).isPurchased(courseDetail?.id);
    T.Theme mode = Provider.of<T.Theme>(context);
    if (idx! % 2 == 0)
      edgeInsets = EdgeInsets.only(left: 8.0);
    else
      edgeInsets = EdgeInsets.only(right: 8.0);
    String rating = getRating(courseDetail?.review);
    return Container(
      margin: edgeInsets,
      decoration: BoxDecoration(
        color: mode.tilecolor,
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 16.0,
              offset: Offset(-13.0, 20.5),
              spreadRadius: -15.0)
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: itemDetails(context, isPurchased, currency as String?, rating, category),
    );
  }
}

final Shader linearGradient = LinearGradient(
  colors: <Color>[Color(0xff790055), Color(0xffF81D46), Color(0xffFA4E62)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));





// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:kloncept/common/global.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import '../Widgets/rating_star.dart';
// import '../common/apidata.dart';
// import '../common/theme.dart' as T;
// import '../model/course.dart';
// import '../model/review.dart';
// import '../provider/courses_provider.dart';
// import '../provider/home_data_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import './utils.dart';

// // ignore: must_be_immutable
// class CourseGridItem extends StatelessWidget {
//   Course? courseDetail;
//   int? idx;
//   CourseGridItem(this.courseDetail, this.idx);
//   EdgeInsets? edgeInsets;

//   int checkDatatype(dynamic x) {
//     if (x is int)
//       return 0;
//     else
//       return 1;
//   }

//   String getRating(List<Review>? data) {
//     double ans = 0.0;
//     bool calcAsInt = true;
//     if (data!.length > 0)
//       calcAsInt = checkDatatype(data[0].learn) == 0 ? true : false;

//     data.forEach((element) {
//       if (!calcAsInt)
//         ans += (int.tryParse(element.price)! +
//                     int.parse(element.value) +
//                     int.parse(element.learn))
//                 .toDouble() /
//             3.0;
//       else {
//         ans += (element.price + element.value + element.learn) / 3.0;
//       }
//     });
//     if (ans == 0.0) return 0.toString();
//     return (ans / data.length).toStringAsPrecision(2);
//   }

//   Widget itemDetails(BuildContext context, bool isPurchased, String? currency,
//       String? rating, String? category) {
//     return Material(
//         borderRadius: BorderRadius.circular(10.0),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(10.0),
//           onTap: () {
//             Course? details = courseDetail;
//             Navigator.of(context).pushNamed("/courseDetails",
//                 arguments: DataSend(details!.userId, isPurchased, details.id,
//                     details.categoryId, details.type));
//           },
//           child: Container(
//             height: 360,
//             width: MediaQuery.of(context).size.width / 3.5,
//             decoration:
//                 BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
//             child: Column(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     child: courseDetail!.previewImage == null
//                         ? Image.asset(
//                             "assets/placeholder/featured.png",
//                             fit: BoxFit.cover,
//                           )
//                         : CachedNetworkImage(
//                             imageUrl:
//                                 "${APIData.courseImages}${courseDetail!.previewImage}",
//                             imageBuilder: (context, imageProvider) => Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.vertical(
//                                     top: Radius.circular(10.0)),
//                                 image: DecorationImage(
//                                   image: imageProvider,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             placeholder: (context, url) => Image.asset(
//                               "assets/placeholder/featured.png",
//                               fit: BoxFit.cover,
//                             ),
//                             errorWidget: (context, url, error) => Image.asset(
//                               "assets/placeholder/featured.png",
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     padding:
//                         EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                               width: 70,
//                               child: Text(
//                                 category.toString(),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: 12.0,
//                                   fontWeight: FontWeight.bold,
//                                   foreground: Paint()..shader = linearGradient,
//                                 ),
//                               ),
//                             ),
//                             if (courseDetail!.discountPrice !=
//                                     null.toString() &&
//                                 courseDetail!.discountPrice != null)
//                               Text(
//                                 "${currencySymbol(selectedCurrency)} ${(num.tryParse(courseDetail!.discountPrice.toString())! * selectedCurrencyRate)}",
//                                 style: TextStyle(
//                                     fontSize: 15.0,
//                                     fontWeight: FontWeight.bold),
//                               )
//                             else
//                               SizedBox.shrink(),
//                           ],
//                         ),
//                         if (courseDetail!.price != null.toString() &&
//                             courseDetail!.price != null)
//                           Align(
//                             alignment: Alignment.topRight,
//                             child: Text(
//                               "${currencySymbol(selectedCurrency)} ${(num.tryParse(courseDetail!.price.toString())! * selectedCurrencyRate)}",
//                               style: TextStyle(
//                                   decoration: TextDecoration.lineThrough,
//                                   fontSize: 12.0,
//                                   color: Colors.grey),
//                             ),
//                           )
//                         else
//                           SizedBox(
//                             height: 15,
//                           ),
//                         SizedBox(
//                           height: 3.0,
//                         ),
//                         Text(
//                           courseDetail!.title.toString(),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 2.0,
//                         ),
//                         Text(
//                           courseDetail!.shortDetail.toString(),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(fontSize: 13.0),
//                         ),
//                         SizedBox(
//                           height: 5.0,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               translate("by_admin"),
//                               style: TextStyle(
//                                 fontSize: 12.0,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             StarRating(
//                               rating: double.parse(rating!),
//                               size: 12.0,
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     String? currency =
//         Provider.of<HomeDataProvider>(context).homeModel!.currency!.currency;
//     String? category = Provider.of<HomeDataProvider>(context)
//         .getCategoryName(courseDetail!.categoryId);

//     // bool? isPurchased =
//     //     Provider.of<CoursesProvider>(context).isPurchased(courseDetail!.id);
//     T.Theme mode = Provider.of<T.Theme>(context);
//     if (idx! % 2 == 0)
//       edgeInsets = EdgeInsets.only(left: 8.0);
//     else
//       edgeInsets = EdgeInsets.only(right: 8.0);
//     String? rating = getRating(courseDetail?.review);
//     return Container(
//       margin: edgeInsets,
//       decoration: BoxDecoration(
//         color: mode.tilecolor,
//         boxShadow: [
//           BoxShadow(
//               color: Color(0x1c2464).withOpacity(0.30),
//               blurRadius: 16.0,
//               offset: Offset(-13.0, 20.5),
//               spreadRadius: -15.0)
//         ],
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       // child: itemDetails(context, isPurchased, currency, rating, category),
//     );
//   }
// }

// final Shader linearGradient = LinearGradient(
//   colors: <Color>[Color(0xff790055), Color(0xffF81D46), Color(0xffFA4E62)],
// ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
