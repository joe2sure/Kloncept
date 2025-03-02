import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/model/content_model.dart';
import 'package:kloncept/provider/content_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;
import 'package:intl/intl.dart';
import 'jitsi_meet.dart';

class JitsiMeetScreen extends StatefulWidget {
  const JitsiMeetScreen({Key? key}) : super(key: key);

  @override
  _JitsiMeetScreenState createState() => _JitsiMeetScreenState();
}

class _JitsiMeetScreenState extends State<JitsiMeetScreen> {
  Widget showImage(int index) {
    return jitsiMeetList![index].image == null
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
          ))
        : CachedNetworkImage(
            imageUrl: "${APIData.jitsiMeetImage}${jitsiMeetList![index].image}",
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
            )),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image:
                      AssetImage("assets/placeholder/bundle_place_holder.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  List<JitsiMeeting>? jitsiMeetList;

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);

    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);

    jitsiMeetList = contentProvider.contentModel != null
        ? contentProvider.contentModel!.jitsiMeeting
        : [];

    return Scaffold(
      key: scaffoldKey,
      appBar: customAppBar(context, translate("Jitsi_Meet")),
      backgroundColor: Color(0xFFF1F3F8),
      body: jitsiMeetList!.length > 0
          ? ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                String dateTime;
                try {
                  dateTime =
                      "${DateFormat('dd-MM-yyyy | hh:mm aa').format(DateTime.parse("${jitsiMeetList![index].startTime}"))}";
                } catch (e) {
                  dateTime = "${jitsiMeetList![index].startTime}";
                }
                return Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Container(
                    padding: EdgeInsets.all(0.0),
                    width: MediaQuery.of(context).size.width / 1.0,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 100,
                          child: showImage(index),
                        ),
                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "${jitsiMeetList![index].meetingTitle}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: mode.txtcolor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              jitsiMeetList![index].agenda == null
                                  ? SizedBox.shrink()
                                  : Text(
                                      "${jitsiMeetList![index].agenda}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: mode.txtcolor,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    translate("Starts_at"),
                                    style: TextStyle(
                                        color: mode.txtcolor,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    dateTime,
                                    style: TextStyle(
                                        color: mode.easternBlueColor,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600),
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
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      backgroundColor: mode.easternBlueColor,
                                    ),
                                    onPressed: () async {
                                      liveClassAttendance(
                                        meetingType: "3",
                                        meetingId: jitsiMeetList![index].id,
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              JitsiMeetingJoin(
                                            jitsiMeeting: jitsiMeetList![index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      translate("Join_Meeting"),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
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
              itemCount: jitsiMeetList!.length,
            )
          : Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 40),
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(),
                        child: Image.asset("assets/images/emptycategory.png"),
                      ),
                    ),
                    Container(
                      height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            translate("Meeting_is_not_available"),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            width: 200,
                            child: Text(
                              translate("There_is_no_Meeting_to_be_shown"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> liveClassAttendance({String? meetingType, int? meetingId}) async {
    final res = await post(
        Uri.parse("${APIData.liveClassAttendance}${APIData.secretKey}"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $authToken",
          "Accept": "application/json"
        },
        body: {
          "meeting_type": meetingType,
          "meeting_id": meetingId,
        });

    if (res.statusCode == 200) {
      print("Attendance Done!");
    } else {
      print("Attendance Status :-> ${res.statusCode}");
    }
  }
}
