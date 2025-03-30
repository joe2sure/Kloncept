import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kloncept/model/dummy/dummy_model.dart';
import 'package:kloncept/provider/dummy/dummy_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../common/theme.dart' as T;

class ZoomMeetingList extends StatefulWidget {
  final bool _visible;
  
  ZoomMeetingList(this._visible);
  
  @override
  _ZoomMeetingListState createState() => _ZoomMeetingListState();
}

class _ZoomMeetingListState extends State<ZoomMeetingList> {
  Widget showShimmer(BuildContext context) {
    return Container(
      height: 260,
      child: ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.fromLTRB(0, 0.0, 18.0, 0.0),
            width: MediaQuery.of(context).orientation == Orientation.landscape
                ? 260
                : MediaQuery.of(context).size.width / 1.8,
            child: Shimmer.fromColors(
              baseColor: Color(0xFFd3d7de),
              highlightColor: Color(0xFFe2e4e9),
              child: Card(
                elevation: 0.0,
                color: Color.fromRGBO(45, 45, 45, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget showImage(DummyZoomMeeting meeting) {
    return meeting.imageUrl.isEmpty
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              image: DecorationImage(
                image: AssetImage("assets/placeholder/bundle_place_holder.png"),
                fit: BoxFit.cover,
              ),
            ),
          )
        : CachedNetworkImage(
            imageUrl: meeting.imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image: AssetImage("assets/placeholder/bundle_place_holder.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image: AssetImage("assets/placeholder/bundle_place_holder.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    
    // Get data from DummyHomeDataProvider instead of HomeDataProvider
    final homeProvider = Provider.of<DummyHomeDataProvider>(context);
    final zoomMeetingList = homeProvider.zoomMeetingList;

    return SliverToBoxAdapter(
      child: widget._visible == true
          ? (zoomMeetingList.isEmpty)
              ? SizedBox.shrink()
              : Container(
                  height: 300,
                  child: ListView.builder(
                    itemCount: zoomMeetingList.length,
                    padding: EdgeInsets.only(left: 18.0, bottom: 24.0, top: 5.0),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final meeting = zoomMeetingList[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 18.0),
                        child: Container(
                          padding: EdgeInsets.all(0.0),
                          width: MediaQuery.of(context).orientation == Orientation.landscape
                              ? 260
                              : MediaQuery.of(context).size.width / 1.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x1c2464).withOpacity(0.30),
                                  blurRadius: 16.0,
                                  offset: Offset(-13.0, 20.5),
                                  spreadRadius: -15.0)
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 80,
                                child: showImage(meeting),
                              ),
                              Container(
                                padding: EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      meeting.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: mode.txtcolor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    meeting.description.isEmpty
                                        ? SizedBox.shrink()
                                        : Text(
                                            meeting.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: mode.txtcolor,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Starts at",
                                          style: TextStyle(
                                            color: mode.txtcolor,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          " ${DateFormat('dd-MM-yyyy | hh:mm aa').format(DateTime.parse(meeting.startTime))}",
                                          style: TextStyle(
                                            color: mode.easternBlueColor,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.0),
                                            ),
                                            backgroundColor: mode.easternBlueColor,
                                          ),
                                          onPressed: () {
                                            // Show a simple dialog instead of navigating to Zoom
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text("Joining Meeting"),
                                                content: Text(
                                                  "Meeting ID: ${meeting.meetingId}\nPassword: ${meeting.password}\nHost: ${meeting.hostName}",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: Text("Close"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Join Meeting",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
          : showShimmer(context),
    );
  }
}



// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:kloncept/common/apidata.dart';
// import 'package:kloncept/common/global.dart';
// import 'package:kloncept/localization/language_provider.dart';
// import 'package:kloncept/provider/home_data_provider.dart';
// import 'package:kloncept/zoom/join_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import 'package:http/http.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// import '../common/theme.dart' as T;
// import 'package:intl/intl.dart';

// class ZoomMeetingList extends StatefulWidget {
//   ZoomMeetingList(this._visible);
//   final bool _visible;
//   @override
//   _ZoomMeetingListState createState() => _ZoomMeetingListState();
// }

// class _ZoomMeetingListState extends State<ZoomMeetingList> {
//   Widget showShimmer(BuildContext context) {
//     return Container(
//       height: 260,
//       child: ListView.builder(
//         itemCount: 10,
//         padding: EdgeInsets.symmetric(horizontal: 18.0),
//         scrollDirection: Axis.horizontal,
//         shrinkWrap: true,
//         itemBuilder: (BuildContext context, int index) {
//           return Container(
//             margin: EdgeInsets.fromLTRB(0, 0.0, 18.0, 0.0),
//             width: MediaQuery.of(context).orientation == Orientation.landscape
//                 ? 260
//                 : MediaQuery.of(context).size.width / 1.8,
//             child: Shimmer.fromColors(
//               baseColor: Color(0xFFd3d7de),
//               highlightColor: Color(0xFFe2e4e9),
//               child: Card(
//                 elevation: 0.0,
//                 color: Color.fromRGBO(45, 45, 45, 1.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(10),
//                   ),
//                 ),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget showImage(int index) {
//     return zoomMeetingList[index].image == null
//         ? Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(15.0),
//                 topRight: Radius.circular(15.0),
//               ),
//               image: DecorationImage(
//                 image: AssetImage("assets/placeholder/bundle_place_holder.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           )
//         : CachedNetworkImage(
//             imageUrl: "${APIData.zoomImage}${zoomMeetingList[index].image}",
//             imageBuilder: (context, imageProvider) => Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(15.0),
//                   topRight: Radius.circular(15.0),
//                 ),
//                 image: DecorationImage(
//                   image: imageProvider,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             placeholder: (context, url) => Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(15.0),
//                   topRight: Radius.circular(15.0),
//                 ),
//                 image: DecorationImage(
//                   image:
//                       AssetImage("assets/placeholder/bundle_place_holder.png"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             errorWidget: (context, url, error) => Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(15.0),
//                   topRight: Radius.circular(15.0),
//                 ),
//                 image: DecorationImage(
//                   image:
//                       AssetImage("assets/placeholder/bundle_place_holder.png"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           );
//   }

//   LanguageProvider? languageProvider;
//   var zoomMeetingList;

//   @override
//   Widget build(BuildContext context) {
//     T.Theme mode = Provider.of<T.Theme>(context);
//     zoomMeetingList = Provider.of<HomeDataProvider>(context).zoomMeetingList;

//     languageProvider = Provider.of<LanguageProvider>(context, listen: false);

//     return SliverToBoxAdapter(
//       child: widget._visible == true
//           ? zoomMeetingList == null
//               ? SizedBox.shrink()
//               : Container(
//                   height: 300,
//                   child: ListView.builder(
//                     itemCount: zoomMeetingList.length,
//                     padding:
//                         EdgeInsets.only(left: 18.0, bottom: 24.0, top: 5.0),
//                     scrollDirection: Axis.horizontal,
//                     shrinkWrap: true,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Padding(
//                         padding: EdgeInsets.only(right: 18.0),
//                         child: Container(
//                           padding: EdgeInsets.all(0.0),
//                           width: MediaQuery.of(context).orientation ==
//                                   Orientation.landscape
//                               ? 260
//                               : MediaQuery.of(context).size.width / 1.5,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15.0),
//                             boxShadow: [
//                               BoxShadow(
//                                   color: Color(0x1c2464).withOpacity(0.30),
//                                   blurRadius: 16.0,
//                                   offset: Offset(-13.0, 20.5),
//                                   spreadRadius: -15.0)
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 height: 80,
//                                 child: showImage(index),
//                               ),
//                               Container(
//                                 padding: EdgeInsets.all(15.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     Text(
//                                       "${zoomMeetingList[index].meetingTitle}",
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         color: mode.txtcolor,
//                                         fontWeight: FontWeight.w700,
//                                         fontSize: 20,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 5.0,
//                                     ),
//                                     zoomMeetingList[index].agenda == null
//                                         ? SizedBox.shrink()
//                                         : Text(
//                                             "${zoomMeetingList[index].agenda}",
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               color: mode.txtcolor,
//                                               fontSize: 18.0,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                     SizedBox(
//                                       height: 8.0,
//                                     ),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           translate("Starts_at"),
//                                           style: TextStyle(
//                                             color: mode.txtcolor,
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 3,
//                                         ),
//                                         Text(
//                                           " ${DateFormat('dd-MM-yyyy | hh:mm aa').format(DateTime.parse("${zoomMeetingList[index].startTime}"))}",
//                                           style: TextStyle(
//                                             color: mode.easternBlueColor,
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         ElevatedButton(
//                                           style: ElevatedButton.styleFrom(
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(4.0),
//                                             ),
//                                             backgroundColor:
//                                                 mode.easternBlueColor,
//                                           ),
//                                           onPressed: () {
//                                             liveClassAttendance(
//                                                 meetingType: "1",
//                                                 meetingId:
//                                                     zoomMeetingList[index].id);

//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     JoinWidget(
//                                                   meetingId:
//                                                       zoomMeetingList[index]
//                                                           .meetingId,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: Text(
//                                             translate("Join_Meeting"),
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 )
//           : showShimmer(context),
//     );
//   }

//   Future<void> liveClassAttendance({String? meetingType, int? meetingId}) async {
//     final res = await post(
//         Uri.parse("${APIData.liveClassAttendance}${APIData.secretKey}"),
//         headers: {
//           HttpHeaders.authorizationHeader: "Bearer $authToken",
//           "Accept": "application/json"
//         },
//         body: {
//           "meeting_type": meetingType,
//           "meeting_id": meetingId.toString(),
//         });

//     if (res.statusCode == 200) {
//       print("Attendance Done!");
//     } else {
//       print("Attendance Status :-> ${res.statusCode}");
//     }
//   }
// }
