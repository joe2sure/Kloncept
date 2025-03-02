import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kloncept/player/audio_player.dart';
import 'package:kloncept/player/downloader.dart';
import 'package:kloncept/provider/watchlist_provider.dart';
import 'package:kloncept/screens/pdf_viewer.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../Screens/no_videos_screen.dart';
import '../Test/model_test.dart';
import '../Widgets/custom_expansion_tile.dart';
import '../Widgets/html_text.dart';
import '../Widgets/utils.dart';
import '../player/clips.dart';
import '../provider/full_course_detail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kloncept/player/playlist_screen.dart';
import 'package:kloncept/common/apidata.dart';

import '../screens/playlist.dart';

class Lessons extends StatefulWidget {
  final FullCourse? details;
  final bool purchased;
  final List<String>? progress;
  final DateTime? purchaseDate;
  final bool isCourseFree;
  Lessons(this.details, this.purchased, this.progress, this.isCourseFree,
      this.purchaseDate);

  @override
  _LessonsState createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  List<VideoClip> _allClips = [];
  int counter = 0;

  // ignore: missing_return
  bool? checkDrip({String? dripType, String? dripDays, String? dripDate}) {
    if (dripType == "date") {
      if (dripDate != null)
        return DateTime.parse(dripDate).millisecondsSinceEpoch <=
            DateTime.now().millisecondsSinceEpoch;
      else
        return false;
    } else if (dripType == "days") {
      if (dripDays != null) {
        return widget.purchaseDate!
                .add(Duration(days: int.parse(dripDays)))
                .millisecondsSinceEpoch <
            DateTime.now().millisecondsSinceEpoch;
      } else
        return false;
    } else if (dripType == null) return true;
    return null;
  }

  List<Chapter> dripFilteredChapters = [];
  List<CourseClass> dripFilteredClasses = [];
  void dripFilter() {
    bool isDripEnabled = widget.details!.course!.dripEnable == "1";
    print("isDripEnabled : $isDripEnabled");

    var courseChapterData = widget.details!.course!.chapter;

    for (Chapter element in courseChapterData!) {
      if (isDripEnabled) {
        bool? isDrip = checkDrip(
            dripType: element.dripType,
            dripDate: element.dripDate,
            dripDays: element.dripDays);
        print("isDrip : $isDrip");
        if (isDrip as bool) {
          dripFilteredChapters.add(element);
          print("Chapter : ${element.chapterName}");
        }
      } else {
        dripFilteredChapters.add(element);
        print("Chapter : ${element.chapterName}");
      }
    }

    var courseClassData = widget.details!.course!.courseclass;

    for (CourseClass element in courseClassData!) {
      if (isDripEnabled) {
        bool? isDrip = checkDrip(
            dripType: element.dripType,
            dripDate: element.dripDate,
            dripDays: element.dripDays);
        print("isDrip : $isDrip");
        if (isDrip as bool) {
          dripFilteredClasses.add(element);
          print("Class : ${element.title}");
        }
      } else {
        dripFilteredClasses.add(element);
        print("Class : ${element.title}");
      }
    }
  }

  List<VideoClip> getClips(List<CourseClass> allLessons) {
    List<VideoClip> clips = [];
    allLessons.forEach((element) {
      if (element.type == "video") {
        if (element.url != null) {
          clips.add(
            VideoClip(
              element.title,
              "lecture",
              "images/ForBiggerFun.jpg",
              100,
              element.url,
              element.id,
              element.user,
              element.dateTime,
              null,
            ),
          );
        } else {
          if (element.iframeUrl != null) {
            clips.add(
              VideoClip(
                element.title,
                "lecture",
                "images/ForBiggerFun.jpg",
                100,
                element.iframeUrl,
                element.id,
                element.user,
                element.dateTime,
                null,
                isIframe: true,
              ),
            );
          } else {
            clips.add(VideoClip(
              element.title,
              "lecture",
              "images/ForBiggerFun.jpg",
              100,
              APIData.videoLink + element.video.toString(),
              element.id,
              element.user,
              element.dateTime,
              null,
            ));
          }
        }
      }
    });
    return clips;
  }

  List<VideoClip> getLessons(Chapter chap, List<CourseClass> allLessons) {
    List<CourseClass> less = [];

    allLessons.forEach((element) {
      if (chap.id.toString() == element.coursechapterId &&
          element.url != null) {
        less.add(element);
      } else if (chap.id.toString() == element.coursechapterId &&
          element.video != null) {
        less.add(element);
      } else if (chap.id.toString() == element.coursechapterId &&
          element.iframeUrl != null) {
        less.add(element);
      }
    });

    if (less.length == 0) return [];
    return getClips(less);
  }

  int findIndToResume(List<Section> sections, List<String> markedSecs) {
    int idx = 0;
    for (int i = 0; i < sections.length; i++) {
      if (markedSecs.contains(sections[i].sectionDetails!.id.toString())) {
        idx += sections[i].sectionLessons!.length;
      } else {
        break;
      }
    }
    return idx;
  }

  List<Section> generateSections(
      List<Chapter>? sections, List<CourseClass>? allLessons) {
    List<Section> sectionList = [];

    sections!.forEach((element) {
      List<VideoClip> lessons = getLessons(element, allLessons!);
      if (lessons.length > 0) {
        sectionList.add(Section(element, lessons));
        _allClips.addAll(lessons);
      }
    });
    if (sectionList.length == 0) return [];
    return sectionList;
  }

  List<CourseClass> getlessons(List<CourseClass>? lessons, Chapter? chap) {
    List<CourseClass> ans = [];

    lessons!.forEach((element) {
      if (element.coursechapterId == chap!.id.toString()) ans.add(element);
    });
    return ans;
  }

  List<CourseClass> getChapterLessons(
      List<CourseClass> allLessons, String chpid) {
    List<CourseClass> ans = [];
    allLessons.forEach((element) {
      if (element.coursechapterId == chpid) ans.add(element);
    });
    return ans;
  }

  List<Section> removeLockedSections(List<Section>? allsections,
      List<Chapter>? allChapters, int? allowedToWatch) {
    List<Section> newSections = [];

    List<int> allowedChapterIds = [];

    for (int i = 0; i < allowedToWatch! + 1; i++) {
      allowedChapterIds.add(allChapters![i].id as int);
    }

    allsections!.forEach((element) {
      if (allowedChapterIds.contains(element.sectionDetails!.id))
        newSections.add(element);
    });

    return newSections;
  }

  Widget lessonTile(int idx, List<CourseClass> cc, List<Section> sections,
      bool isProgressEmpty, int canViewForFree, isSectionViewed) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: idx == 0 &&
                idx ==
                    (!widget.purchased
                        ? widget.details!.course!.chapter!.length - 1
                        : dripFilteredChapters.length - 1)
            ? BorderRadius.circular(15.0)
            : idx == 0
                ? BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0))
                : (idx ==
                        (!widget.purchased
                            ? widget.details!.course!.chapter!.length - 1
                            : dripFilteredChapters.length - 1)
                    ? BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0))
                    : BorderRadius.zero),
      ),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!, width: 1),
            borderRadius: BorderRadius.circular(15.0)),
        child: CustomExpansionTile(
          childrenPadding: EdgeInsets.only(left: 25.00),
          children: cc.length > 0
              ? _buildexpandablewidget(
                  cc,
                  idx + 1,
                  context,
                  sections,
                  isProgressEmpty,
                  widget.purchased,
                  widget.isCourseFree ? idx <= canViewForFree : false,
                  isSectionViewed,
                )
              : [],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //play icon button before course lessons
              Expanded(
                flex: 1,
                child: widget.purchased || widget.isCourseFree
                    ? (isProgressEmpty
                        ? Center(
                            child: playIcon(
                                [],
                                sections,
                                (!widget.purchased
                                    ? widget.details!.course!.chapter![idx].id
                                    : (dripFilteredChapters[idx].id))),
                          )
                        : (isSectionViewed)
                            ? Center(
                                child: doneicon(
                                    widget.progress,
                                    sections,
                                    (!widget.purchased
                                        ? widget
                                            .details!.course!.chapter![idx].id
                                        : dripFilteredChapters[idx].id)),
                              )
                            : Center(
                                child: playIcon(
                                    widget.progress,
                                    sections,
                                    (!widget.purchased
                                        ? widget
                                            .details!.course!.chapter![idx].id
                                        : dripFilteredChapters[idx].id)),
                              ))
                    : Center(child: lockIcon()),
              ),
              SizedBox(
                width: 10,
              ),

              //lessons name
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (idx + 1).toString() +
                          ". " +
                          (!widget.purchased
                              ? widget
                                  .details!.course!.chapter![idx].chapterName
                                  .toString()
                              : dripFilteredChapters[idx]
                                  .chapterName
                                  .toString()),
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    Text(
                      "${cc.length} ${translate("classes_")}",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget whenEmptyCourse() {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          child: Text(
            translate("No_Lessons_To_Show"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget playIcon(
      List<String>? marksSecs, List<Section>? sections, int? chpId) {
    bool haveVideos = false;
    sections!.forEach((element) {
      if (element.sectionDetails!.id == chpId) {
        haveVideos = true;
      }
    });
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
          if (_allClips.length > 0 && haveVideos) {
            bool isWatching =
                Provider.of<WatchlistProvider>(context, listen: false)
                    .isWatching(widget.details!.course!.id);
            if (!isWatching) {
              print("object3");
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        VideoDetail(detail: youtubeData[0], sections: sections)

                    // PlayListScreen(
                    //   markedSec: marksSecs,
                    //   clips: _allClips,
                    //   sections: sections,
                    //   defaultIndex: idxToStart,
                    //   courseDetails: widget.details,
                    // ),
                    ),
              );
            } else {
              Fluttertoast.showToast(
                  msg: translate("Already_watching_from_another_device"),
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          } else if (haveVideos == false) {
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EmptyVideosPage()));
          }
        },
        child: Container(
          height: 35.0,
          width: 35.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.black, width: 2)),
          child: Icon(
            Icons.play_arrow,
            color: Colors.black,
            size: 25,
          ),
        ),
      ),
    );
  }

  Widget doneicon(
      List<String>? marksSecs, List<Section>? sections, int? chpId) {
    bool haveVideos = false;
    int idxToStart = 0;
    int total = 0;
    sections!.forEach((element) {
      if (element.sectionDetails!.id == chpId) {
        haveVideos = true;
        idxToStart = total;
      }
      total += element.sectionLessons!.length;
    });
    return InkWell(
      onTap: () {
        if (_allClips.length > 0 && haveVideos) {
          bool isWatching =
              Provider.of<WatchlistProvider>(context, listen: false)
                  .isWatching(widget.details!.course!.id);
          if (!isWatching) {
            print("object4");
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlayListScreen(
                      markedSec: marksSecs,
                      clips: _allClips,
                      sections: sections,
                      defaultIndex: idxToStart,
                      courseDetails: widget.details,
                    )));
          } else {
            Fluttertoast.showToast(
                msg: translate("Already_watching_from_another_device"),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else if (haveVideos == false) {
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => EmptyVideosPage()));
        }
      },
      child: Container(
        height: 35.0,
        width: 35.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Color(0xff66deb5)),
        child: Icon(
          Icons.done,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  List<Widget> _buildexpandablewidget(
    List<CourseClass>? lessons,
    int? a,
    BuildContext context,
    List<Section>? sections,
    bool isProgressEmpty,
    bool? purchased,
    bool? canView,
    bool isSectionViewed,
  ) {
    List<Widget> ret = [];

    // play video lessons
    playVideo(idx) {
      int idxToStart = 0, i = 0;
      _allClips.forEach((element) {
        if (element.id == lessons![idx].id) {
          idxToStart = i;
        }
        i++;
      });
      bool isWatching = Provider.of<WatchlistProvider>(context, listen: false)
          .isWatching(widget.details!.course!.id);
      if (!isWatching) {
        print("object5");
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              PlayListScreen(
            sections: sections,
            clips: _allClips,
            defaultIndex: idxToStart,
            markedSec: isProgressEmpty ? [] : widget.progress,
            courseDetails: widget.details,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ));
      } else {
        Fluttertoast.showToast(
            msg: translate("Already_watching_from_another_device"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    // play audio lessons
    playAudio(url) {
      return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: PlayAudio(
                url: url,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ),
            ),
          ]),
        ),
      );
    }

    //download learning material
    download(idx) async {
      Downloader downloader = Downloader();
      final hasPermission = await downloader.checkPermission();
      if (hasPermission) {
        final fileName =
            "${DateTime.now().millisecondsSinceEpoch}_${lessons![idx].file}";
        final directory = await getApplicationDocumentsDirectory();
        final savePath = "${directory.path}/$fileName";

        try {
          BuildContext? dialogContext;

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              dialogContext = context;
              return AlertDialog(
                content: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 30),
                    Text(translate("Downloading__")),
                  ],
                ),
              );
            },
          );

          await Dio().download(
            "${APIData.domainLink}files/class/material/${lessons[idx].file}",
            savePath,
            options: Options(
              headers: {HttpHeaders.acceptEncodingHeader: "*"},
            ),
            onReceiveProgress: (received, total) {},
          );

          await File(savePath).copy('/storage/emulated/0/Download/' + fileName);
          await File(savePath).delete();

          Navigator.pop(dialogContext!);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(translate(
                  "Download_finished__See_Download_folder_of_your_device")),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${translate("Download_failed_")}\nException - $e"),
            ),
          );
        }
      } else {
        print("Permission Denied!");
      }
    }

    for (int i = 0; i < 2 * lessons!.length - 1; i++) {
      if (i % 2 == 0) {
        int idx = i == 0 ? 0 : (i ~/ 2).toInt();
        ret.add(
          CustomExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topCenter,

                  //icon button before classes
                  child: IconButton(
                    onPressed: () {
                      print('${lessons[idx].type}  on tap');
                      if ((purchased! || canView!) &&
                          lessons[idx].type == "video" &&
                          lessons[idx].url != null) {
                        print('video url');
                        playVideo(idx);
                      } else if ((purchased || canView!) &&
                          lessons[idx].type == "video" &&
                          lessons[idx].video != null) {
                        print('video');
                        playVideo(idx);
                      } else if ((purchased || canView!) &&
                          lessons[idx].type == "video" &&
                          lessons[idx].iframeUrl != null) {
                        print('video iframe url');
                        playVideo(idx);
                      } else if ((purchased || canView!) &&
                          lessons[idx].type == "audio" &&
                          lessons[idx].url != null) {
                        print(lessons[idx].type);
                        playAudio(lessons[idx].url);
                      } else if ((purchased || canView!) &&
                          lessons[idx].type == "audio" &&
                          lessons[idx].audio != null) {
                        print("xyz : ${lessons[idx].audio}");
                        playAudio(
                            "${APIData.domainLink}files/audio/${lessons[idx].audio}");
                      } else {
                        return;
                      }
                    },
                    icon: isSectionViewed
                        ? Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Color(0xff66deb5),
                                borderRadius: BorderRadius.circular(15)),
                            child: Icon(
                              Icons.done,
                              size: 20,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            lessons[idx].type == "video"
                                ? (Icons.play_circle_filled)
                                : lessons[idx].type == "audio"
                                    ? Icons.play_arrow
                                    : Icons.insert_drive_file,
                            color: Colors.black,
                          ),
                  ),
                ),
                SizedBox(
                  width: 4.0,
                ),
                Expanded(
                  child: Text(
                    (a).toString() +
                        "." +
                        (idx + 1).toString() +
                        " " +
                        lessons[idx].title.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0),
                  ),
                ),
              ],
            ),
            childrenPadding: EdgeInsets.only(bottom: 10),
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 150,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: lessons[idx].detail == null
                        ? SizedBox.shrink()
                        : html(lessons[idx].detail, Colors.grey[600]!, 14),
                  ),
                  lessons[idx].file != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              color: Color(0xff0083A4),
                              iconSize: 18,
                              icon: Icon(FontAwesomeIcons.fileArrowDown),
                              onPressed: () async {
                                setState(() {
                                  counter = counter + 1;
                                });
                                print('you tap on download button');
                                !lessons[idx].file.toString().endsWith(".pdf")
                                    ? download(idx)
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PdfViewer(
                                            filePath:
                                                "${APIData.domainLink}files/class/material/${lessons[idx].file}",
                                          ),
                                        ),
                                      );
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              translate("Learning_materials"),
                              style: TextStyle(
                                  color: Color(0xff0083A4),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                      : SizedBox.shrink()
                ]),
              )
            ],
          ),
        );
      } else
        ret.add(
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 30.0),
            child: cusDivider(Colors.grey.withOpacity(0.5)),
          ),
        );
    }

    return ret;
  }

  @override
  void initState() {
    super.initState();
    dripFilter();
  }

  @override
  Widget build(BuildContext context) {
    int canViewForFree = (widget.details!.course!.chapter!.length ~/ 2) - 1;
    canViewForFree = canViewForFree == 0 ? 1 : canViewForFree;

    bool isProgressEmpty = false;
    _allClips.clear();
    if (widget.progress == null) {
      isProgressEmpty = true;
    }

    if (!widget.purchased) {
      List<Section> sections = generateSections(
          widget.details!.course!.chapter, widget.details!.course!.courseclass);

      sections = removeLockedSections(
          sections, widget.details!.course!.chapter, canViewForFree);

      return widget.details!.course!.chapter!.length == 0
          ? whenEmptyCourse()
          : SliverList(
              delegate: SliverChildBuilderDelegate((context, idx) {
              List<CourseClass> cc = getlessons(
                  widget.details!.course!.courseclass,
                  widget.details!.course!.chapter![idx]);

              bool isSectionViewed = false;

              if (!isProgressEmpty)
                isSectionViewed = widget.progress!.contains(
                    widget.details!.course!.chapter![idx].id.toString());
              //lesson tiles
              return lessonTile(idx, cc, sections, isProgressEmpty,
                  canViewForFree, isSectionViewed);
            }, childCount: widget.details!.course!.chapter!.length));
    } else {
      List<Section> sections =
          generateSections(dripFilteredChapters, dripFilteredClasses);
      return dripFilteredChapters.length == 0
          ? whenEmptyCourse()
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, idx) {
                  List<CourseClass> cc = getlessons(
                      dripFilteredClasses, dripFilteredChapters[idx]);

                  bool isSectionViewed = false;

                  if (!isProgressEmpty)
                    isSectionViewed = widget.progress!
                        .contains(dripFilteredChapters[idx].id.toString());
                  //lesson tiles
                  return lessonTile(idx, cc, sections, isProgressEmpty,
                      canViewForFree, isSectionViewed);
                },
                childCount: dripFilteredChapters.length,
              ),
            );
    }
  }
}

Widget lockIcon() {
  return Container(
    height: 40.0,
    width: 40.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0), color: Colors.grey[100]),
    child: Icon(
      FontAwesomeIcons.lock,
      color: Color(0x99b4bac6),
      size: 18,
    ),
  );
}
