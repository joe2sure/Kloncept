// File: lib/screens/compare_course_screen.dart
import 'package:flutter/material.dart';
import 'package:kloncept/provider/dummy/dummy_compare_course_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';


import 'package:kloncept/widgets/appbar.dart';

class CompareCourseScreen extends StatefulWidget {
  const CompareCourseScreen({Key? key}) : super(key: key);

  @override
  State<CompareCourseScreen> createState() => _CompareCourseScreenState();
}

class _CompareCourseScreenState extends State<CompareCourseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DummyCompareCourseProvider>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Compare Courses"),
      body: Consumer<DummyCompareCourseProvider>(
        builder: (_, provider, __) {
          if (provider.compareCourseModel == null) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: DataTable(
                  dataRowMinHeight: 50,
                  dataRowMaxHeight: 150.0,
                  headingRowColor: MaterialStateProperty.all(Colors.black45),
                  headingTextStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  columns: [
                    DataColumn(label: Text("Course")),
                    DataColumn(label: Text("Price")),
                    DataColumn(label: Text("Discount Price")),
                    DataColumn(label: Text("Language")),
                    DataColumn(label: Text("Last Updated at")),
                    DataColumn(label: Text("Duration End Time")),
                    DataColumn(label: Text("Requirements")),
                    DataColumn(label: Text("Short Details")),
                    DataColumn(label: Text("Category")),
                    DataColumn(label: Text("Sub Category")),
                    DataColumn(label: Text("Certificate")),
                    DataColumn(label: Text("Appointment")),
                    DataColumn(label: Text("Assignment")),
                    DataColumn(label: Text("Remove")),
                  ],
                  rows: dataRows(provider),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> dataRows(DummyCompareCourseProvider provider) {
    String currency = "USD"; // Dummy currency
    List<DataRow> dataRowList = [];

    provider.compareCourseModel!.compare.forEach((compareCourse) {
      dataRowList.add(
        DataRow(
          cells: [
            DataCell(
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to course details
                        },
                        child: Container(
                          height: 300,
                          width: 200,
                          child: CachedNetworkImage(
                            imageUrl: compareCourse.compares.previewImage ??
                                "https://via.placeholder.com/300x200",
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/placeholder/featured.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/placeholder/featured.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        child: Container(
                          padding: EdgeInsets.all(2.0),
                          color: Colors.white,
                          width: 200,
                          child: Text(
                            compareCourse.compares.title ?? "Course Title",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              foreground: Paint()..shader = linearGradient,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  "\$ ${compareCourse.compares.price}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  "\$ ${compareCourse.compares.discountPrice}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  "English", // Dummy language
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  DateTime.tryParse(compareCourse.updatedAt)!.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    "Lifetime",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            DataCell(
              Container(
                width: 160,
                child: Text(
                  compareCourse.compares.requirement ?? "Requirements",
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            DataCell(
              Container(
                width: 160,
                child: Text(
                  compareCourse.compares.shortDetail ?? "Short Details",
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  compareCourse.compares.categoryName ?? "Category",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  "Sub Category", // Dummy subcategory
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Icon(
                  Icons.check_circle_sharp,
                  color: Colors.green,
                ),
              ),
            ),
            DataCell(
              Center(
                child: Icon(
                  Icons.check_circle_sharp,
                  color: Colors.green,
                ),
              ),
            ),
            DataCell(
              Center(
                child: Icon(
                  Icons.check_circle_sharp,
                  color: Colors.green,
                ),
              ),
            ),
            DataCell(
              Center(
                child: GestureDetector(
                  onDoubleTap: () {
                    provider.removeFromCompareCourse(compareCourse.id);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 2.0),
                        Text(
                          "Remove",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });

    return dataRowList;
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xff790055), Color(0xffF81D46), Color(0xffFA4E62)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 400.0, 80.0));
}





// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:kloncept/widgets/appbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import 'package:provider/provider.dart';
// import '../Widgets/utils.dart';
// import '../common/apidata.dart';
// import '../common/global.dart';
// import '../localization/language_provider.dart';
// import '../provider/compareCourseProvider.dart';
// import '../provider/courses_provider.dart';
// import '../provider/home_data_provider.dart';

// class CompareCourseScreen extends StatefulWidget {
//   const CompareCourseScreen({Key? key}) : super(key: key);

//   @override
//   State<CompareCourseScreen> createState() => _CompareCourseScreenState();
// }

// class _CompareCourseScreenState extends State<CompareCourseScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: customAppBar(context, translate("Compare_Course")),
//       body: Consumer<CompareCourseProvider>(
//         builder: (_, provider, __) {
//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Padding(
//                 padding: EdgeInsets.all(10.0),
//                 child: DataTable(
//                   dataRowMinHeight: 50,
//                   dataRowMaxHeight: 150.0,
//                   headingRowColor: MaterialStateProperty.all(Colors.black45),
//                   headingTextStyle: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   columns: [
//                     DataColumn(
//                       label: Container(
//                         width: 200,
//                         child: Text(
//                           "Course",
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Container(
//                         width: 80,
//                         child: Text(
//                           "Price",
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     DataColumn(label: Text("Discount Price")),
//                     DataColumn(label: Text("Language")),
//                     DataColumn(label: Text("Last Updated at")),
//                     DataColumn(label: Text("Duration End Time")),
//                     DataColumn(
//                       label: Container(
//                         width: 160,
//                         child: Text(
//                           "Requirements",
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Container(
//                         width: 160,
//                         child: Text(
//                           "Short Details",
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     DataColumn(label: Text("Category")),
//                     DataColumn(label: Text("Sub Category")),
//                     DataColumn(label: Text("Certificate")),
//                     DataColumn(label: Text("Appointment")),
//                     DataColumn(label: Text("Assignment")),
//                     DataColumn(label: Text("Remove")),
//                   ],
//                   rows: dataRows(provider),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   List<DataRow> dataRows(CompareCourseProvider? provider) {
//     String? currency =
//         Provider.of<HomeDataProvider>(context).homeModel!.currency!.currency;

//     List<DataRow> dataRowList = [];

//     provider!.compareCourseModel!.compare!.forEach((compareCourse) {
//       // bool isPurchased = Provider.of<CoursesProvider>(context)
//       //     .isPurchased(int.tryParse(compareCourse.courseId.toString()));

//       String? category = Provider.of<HomeDataProvider>(context)
//           .getCategoryName(compareCourse.compares!.first.categoryId);

//       // String? subCategory = Provider.of<HomeDataProvider>(context)
//       //     .getSubCategoryName(compareCourse.compares!.first.subcategoryId);
//       // if (subCategory == null) subCategory = "N/A";

//       String? languageName;

//       Provider.of<LanguageProvider>(context)
//           .languageModel!
//           .language!
//           .forEach((language) {
//         if (language.id.toString() ==
//             "${compareCourse.compares!.first.languageId}")
//           languageName = language.name;
//       });

//       dataRowList.add(
//         DataRow(
//           cells: [
//             DataCell(
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: Stack(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).pushNamed(
//                             "/courseDetails",
//                             // arguments: DataSend(
//                             //   compareCourse.compares!.first.userId,
//                             //   isPurchased,
//                             //   compareCourse.compares!.first.id as dynamic,
//                             //   compareCourse.compares!.first.categoryId,
//                             //   compareCourse.compares!.first.type,
//                             // ),
//                           );
//                         },
//                         child: Container(
//                           height: 300,
//                           width: 200,
//                           child:
//                               compareCourse.compares!.first.previewImage == null
//                                   ? Container(
//                                       decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                           image: AssetImage(
//                                             'assets/placeholder/featured.png',
//                                           ),
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     )
//                                   : CachedNetworkImage(
//                                       imageUrl:
//                                           "${APIData.courseImages}${compareCourse.compares!.first.previewImage}",
//                                       imageBuilder: (context, imageProvider) =>
//                                           Container(
//                                         decoration: BoxDecoration(
//                                           image: DecorationImage(
//                                             image: imageProvider,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                       placeholder: (context, url) => Container(
//                                         decoration: BoxDecoration(
//                                           image: DecorationImage(
//                                             image: AssetImage(
//                                               'assets/placeholder/featured.png',
//                                             ),
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                       errorWidget: (context, url, error) =>
//                                           Container(
//                                         decoration: BoxDecoration(
//                                           image: DecorationImage(
//                                             image: AssetImage(
//                                               'assets/placeholder/featured.png',
//                                             ),
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0.0,
//                         child: Container(
//                           padding: EdgeInsets.all(2.0),
//                           color: Colors.white,
//                           width: 200,
//                           child: Text(
//                             "${compareCourse.compares!.first.title}",
//                             textAlign: TextAlign.center,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.w600,
//                               foreground: Paint()..shader = linearGradient,
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             DataCell(
//               Center(
//                 child: Text(
//                   "${currencySymbol(currency!)} ${compareCourse.compares!.first.price}",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//             DataCell(
//               Center(
//                 child: Text(
//                   "${currencySymbol(currency)} ${compareCourse.compares!.first.discountPrice}",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//             DataCell(
//               Center(
//                 child: Text(
//                   languageName.toString(),
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//             DataCell(
//               Center(
//                 child: Text(
//                   DateTime.tryParse(
//                               "${compareCourse.compares!.first.updatedAt}")!
//                           .day
//                           .toString() +
//                       "/" +
//                       DateTime.tryParse(
//                               "${compareCourse.compares!.first.updatedAt}")!
//                           .month
//                           .toString() +
//                       "/" +
//                       DateTime.tryParse(
//                               "${compareCourse.compares!.first.updatedAt}")!
//                           .year
//                           .toString(),
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//             DataCell(
//               Center(
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   child: Text(
//                     "${compareCourse.compares!.first.durationType}" == "m"
//                         ? "Life Time"
//                         : "",
//                     style: TextStyle(
//                       fontSize: 16.0,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             DataCell(
//               Container(
//                 width: 160,
//                 child: Text(
//                   "${compareCourse.compares!.first.requirement}",
//                   maxLines: 8,
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//             DataCell(
//               Container(
//                 width: 160,
//                 child: Text(
//                   "${compareCourse.compares!.first.shortDetail}",
//                   maxLines: 8,
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//             DataCell(
//               Center(
//                 child: Text(
//                   category,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//             DataCell(
//               Center(
//                 child: Text(
//                   // subCategory
//                   'subCategory',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//             DataCell(
//               Center(
//                 child: Icon(
//                   "${compareCourse.compares!.first.certificateEnable}" == "1"
//                       ? Icons.check_circle_sharp
//                       : Icons.cancel_rounded,
//                   color: "${compareCourse.compares!.first.certificateEnable}" ==
//                           "1"
//                       ? Colors.green
//                       : Colors.red,
//                 ),
//               ),
//             ),
//             DataCell(
//               Center(
//                 child: Icon(
//                   "${compareCourse.compares!.first.appointmentEnable}" == "1"
//                       ? Icons.check_circle_sharp
//                       : Icons.cancel_rounded,
//                   color: "${compareCourse.compares!.first.appointmentEnable}" ==
//                           "1"
//                       ? Colors.green
//                       : Colors.red,
//                 ),
//               ),
//             ),
//             DataCell(
//               Center(
//                 child: Icon(
//                   "${compareCourse.compares!.first.assignmentEnable}" == "1"
//                       ? Icons.check_circle_sharp
//                       : Icons.cancel_rounded,
//                   color:
//                       "${compareCourse.compares!.first.assignmentEnable}" == "1"
//                           ? Colors.green
//                           : Colors.red,
//                 ),
//               ),
//             ),
//             DataCell(
//               Center(
//                 child: GestureDetector(
//                   onDoubleTap: () {
//                     provider.removeFromCompareCourse(compareCourse.id as int);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.cancel_outlined,
//                           color: Colors.white,
//                         ),
//                         SizedBox(width: 2.0),
//                         Text(
//                           "Remove",
//                           style: TextStyle(
//                             fontSize: 16.0,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     });

//     return dataRowList;
//   }

//   final Shader linearGradient = LinearGradient(
//     colors: <Color>[Color(0xff790055), Color(0xffF81D46), Color(0xffFA4E62)],
//   ).createShader(Rect.fromLTWH(0.0, 0.0, 400.0, 80.0));
// }
