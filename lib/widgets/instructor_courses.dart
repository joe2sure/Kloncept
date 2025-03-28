// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import '../Widgets/utils.dart';
// import '../common/apidata.dart';
// import '../common/theme.dart' as T;
// import '../model/instructor_model.dart';
// import '../provider/courses_provider.dart';
// import '../provider/home_data_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class InstructCourses extends StatelessWidget {
//   final InsCourse cd;
//   InstructCourses(this.cd);

//   Widget showImage(String? img) {
//     return Expanded(
//       flex: 3,
//       child: Container(
//         height: 150.0,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.horizontal(left: Radius.circular(15.0)),
//           image: DecorationImage(
//             fit: BoxFit.cover,
//             image: cd.previewImage == null
//                 ? AssetImage("assets/placeholder/exp_course_placeholder.png")
//                     as ImageProvider
//                 : CachedNetworkImageProvider(
//                     "${APIData.courseImages}${cd.previewImage}",
//                   ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget showDetails(InsCourse cd, BuildContext context, double? progress,
//       T.Theme mode, bool isPurchased, String category) {
//     return Expanded(
//       flex: MediaQuery.of(context).orientation == Orientation.landscape ? 4 : 7,
//       child: Container(
//         padding: EdgeInsets.all(5.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Text(
//                     cd.title.toString(),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: mode.txtcolor,
//                       fontSize: 18,
//                     ),
//                   ),
//                   category == ""
//                       ? SizedBox.shrink()
//                       : Text(
//                           category,
//                           maxLines: 1,
//                           style: TextStyle(
//                             color: mode.txtcolor,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Expanded(
//               child: Padding(
//                 padding:
//                     MediaQuery.of(context).orientation == Orientation.landscape
//                         ? EdgeInsets.only(right: 25)
//                         : EdgeInsets.all(0.0),
//                 child: Text(
//                   cd.duration == null
//                       ? ""
//                       : "${cd.duration}" + " ${translate("hours_")}",
//                   style: TextStyle(fontSize: 14),
//                 ),
//               ),
//             ),
//             if (isPurchased) ...{
//               cusprogressbar(
//                   MediaQuery.of(context).orientation == Orientation.landscape
//                       ? 300
//                       : 215,
//                   progress!),
//               SizedBox(height: 5.0)
//             } else
//               Text(
//                 removeHtmlTags(
//                   cd.detail.toString(),
//                 ),
//                 maxLines: 3,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontStyle: FontStyle.italic,
//                   color: mode.txtcolor,
//                   fontSize: 12,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget courseTileBody(BuildContext context, bool isPurchased,
//       double? progress, T.Theme mode, String category) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
//       margin: EdgeInsets.all(12.0),
//       child: Material(
//         borderRadius: BorderRadius.circular(15.0),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(15.0),
//           onTap: () {
//             InsCourse details = cd;
//             Navigator.of(context).pushNamed(
//               "/courseDetails",
//               arguments: DataSend(
//                 details.userId,
//                 isPurchased,
//                 details.id,
//                 details.categoryId,
//                 details.type,
//               ),
//             );
//           },
//           child: Container(
//             height: 150.0,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15.0),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 showImage(cd.previewImage),
//                 showDetails(cd, context, progress, mode, isPurchased, category)
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isPurchased = Provider.of<CoursesProvider>(context).isPurchased(cd.id);
//     String? category =
//         Provider.of<HomeDataProvider>(context).getCategoryName(cd.categoryId);
//     category = "";
//     double? progress;
//     if (isPurchased) {
//       progress = Provider.of<CoursesProvider>(context).getProgress(cd.id);
//     }
//     T.Theme mode = Provider.of<T.Theme>(context);
//     return courseTileBody(context, isPurchased, progress, mode, category);
//   }

//   String removeHtmlTags(String input) {
//     RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
//     return input.replaceAll(exp, '');
//   }
// }
