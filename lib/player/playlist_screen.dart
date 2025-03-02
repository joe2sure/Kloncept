import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:chewie/chewie.dart';
import 'package:kloncept/Screens/more_screen.dart';
import 'package:kloncept/Screens/pdf_viewer.dart';
import 'package:kloncept/player/iframe_player.dart';
import 'package:kloncept/player/offline/offline_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/model/recieved_progress.dart';
import 'package:kloncept/model/zoom_meeting.dart';
import 'package:kloncept/player/clips.dart';
import 'package:kloncept/provider/courses_provider.dart';
import 'package:kloncept/provider/full_course_detail.dart';
import 'package:kloncept/provider/home_data_provider.dart';
import 'package:kloncept/zoom/join_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../common/theme.dart' as T;
import '../widgets/sliding_appbar.dart';
import 'audio_player.dart';
import 'downloader.dart';
// import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:kloncept/provider/watchlist_provider.dart';

import 'vimeo_flutter.dart';

class PlayListScreen extends StatefulWidget {
  PlayListScreen(
      {Key? key,
      this.clips,
      this.sections,
      this.markedSec,
      this.defaultIndex,
      this.courseDetails})
      : super(key: key);

  final List<Section>? sections;
  final List<VideoClip>? clips;
  final List<String>? markedSec;
  final int? defaultIndex;
  final FullCourse? courseDetails;

  @override
  _PlayListScreenState createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool showBottomNavigation = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  AnimationController? animationController;
  TabController? tabController;
  var newIndex = 0;
  var _playingIndex = -1;
  var _isFullScreen = false;
  bool isLoadingMark = false;
  List<String>? selectedSecs = [];
  String urlType = '';
  String playURL = '';
  YoutubePlayerController? _controller;
  var _betterPlayerController;

  VideoPlayerController? vcontroller2;
  ChewieController? _chewieController;

  int? bufferDelay;
  var betterPlayerConfiguration;
  var gUrl;
  bool iconType = false;
  var vimeo = '';

  // Downloader
  Downloader downloader = Downloader();
  List<Map<String, String>> videos = [];

  SharedPreferences? sharedPreferences;

  Future<RecievedProgress> updateProgress(List<String> checked) async {
    String url = "${APIData.updateProgress}${APIData.secretKey}";
    Response res = await post(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }, body: {
      "course_id": widget.sections![0].sectionDetails!.courseId,
      "checked": checked.toString()
    });

    if (res.statusCode == 200) {
      return RecievedProgress.fromJson(jsonDecode(res.body));
    } else {
      return RecievedProgress();
    }
  }

  Future<bool> updateProgressBool(List<String> checked) async {
    String url = "${APIData.updateProgress}${APIData.secretKey}";

    Response res = await post(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }, body: {
      "course_id": widget.sections![0].sectionDetails!.courseId,
      "checked": getStringFromList(checked)
    });

    return res.statusCode == 200;
  }

  String getStringFromList(List<String> checked) {
    String res = "[";
    for (int i = 0; i < checked.length; i++) {
      res += "\"${checked[i]}\"";
      if (i != checked.length - 1) {
        res += ",";
      }
    }
    res += "]";
    return res;
  }

  bool isDataDownloadable(String url) {
    if (url.length >= 25) {
      var fileType = url.split(".").last;
      if (fileType == "mp4" ||
          fileType == "mpd" ||
          fileType == "webm" ||
          fileType == "mkv" ||
          fileType == "m3u8" ||
          fileType == "ogg" ||
          fileType == "wav" ||
          fileType == "mp3" ||
          fileType == 'pdf') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Widget _listViewt() {
    for (Section section in widget.sections!) {
      for (VideoClip videoClip in section.sectionLessons!) {
        videos.add({'name': videoClip.title!, 'link': videoClip.parent!});
        print(
            'Course Content :- name : ${videoClip.title}, link : ${videoClip.parent}');
      }
    }
    if (videos.length > 0) {
      // Downloader
      downloader.videos = videos;
    }
    var zoomMeeting = Provider.of<HomeDataProvider>(context).zoomMeetingList;
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: _buildSections(widget.sections!),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: zoomMeetingList(zoomMeeting!),
          ),
        ],
      ),
    );
  }

  Widget buildSection(Chapter secDetails) {
    T.Theme mode = Provider.of<T.Theme>(context);
    String chpId = secDetails.id.toString();
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (!selectedSecs!.contains(chpId)) {
                  selectedSecs!.add(chpId.toString());
                  if (selectedSecs!.length == 1 || selectedSecs!.length > 0) {
                    setState(() {
                      showBottomNavigation = true;
                    });
                  }
                } else {
                  selectedSecs!.remove(chpId);
                  if (selectedSecs!.length > 0) {
                    setState(() {
                      showBottomNavigation = true;
                    });
                  }
                  if (selectedSecs!.length == 0) {
                    setState(() {
                      showBottomNavigation = false;
                    });
                  }
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 15.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedSecs!.contains(chpId)
                      ? Colors.greenAccent
                      : Colors.transparent,
                  border: selectedSecs!.contains(chpId)
                      ? Border.all(color: Colors.transparent, width: 2.0)
                      : Border.all(
                          color: Colors.blueGrey,
                          width: 2.0,
                        )),
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: selectedSecs!.contains(chpId)
                      ? Icon(
                          Icons.check,
                          size: 15.0,
                          color: Colors.white,
                        )
                      : Container(
                          width: 15.0,
                          height: 15.0,
                        )),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              secDetails.chapterName!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: mode.titleTextColor),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSections(List<Section> _sections) {
    List<Widget> sectionWidget = [];

    sectionWidget.add(SizedBox(
      height: 15,
    ));

    int ind = 0;
    _sections.forEach((element) {
      sectionWidget.add(buildSection(element.sectionDetails!));
      sectionWidget.add(SizedBox(
        height: 7,
      ));

      try {
        element.sectionLessons!.forEach((element) {
          sectionWidget.add(buildLesson(element, ind));
          ind++;
        });
      } catch (e) {
        print('Exception in line no. 296 $e');
      }
    });

    return sectionWidget;
  }

  Widget buildLesson(VideoClip element, int index) {
    return Column(
      children: [
        _buildCard(index, element),
      ],
    );
  }

  DbHandler dbHandler = DbHandler();
  Widget _buildCard(int index, VideoClip lessClip) {
    String? downloadBtnTxt;
    int? progress;
    // Downloader
    if (isDataDownloadable(lessClip.parent!)) {
      if (downloader.items[index].task!.status ==
              DownloadTaskStatus.undefined ||
          downloader.items[index].task!.status == DownloadTaskStatus.canceled ||
          downloader.items[index].task!.status == DownloadTaskStatus.failed) {
        downloadBtnTxt = 'Download';
        // Remove from offline_data.db
        dbHandler.delete(lessClip.parent!);
      } else if (downloader.items[index].task!.status ==
          DownloadTaskStatus.running) {
        downloadBtnTxt = 'Cancel Download';
        progress = downloader.items[index].task!.progress!;
      } else if (downloader.items[index].task!.status ==
          DownloadTaskStatus.paused) {
        downloadBtnTxt = 'Resume Download';
      } else if (downloader.items[index].task!.status ==
          DownloadTaskStatus.complete) {
        downloadBtnTxt = 'Delete Download';
        progress = downloader.items[index].task!.progress!;
        // Add to offline_data.db
        dbHandler.insert(
          Item(
            course_name: widget.courseDetails!.course!.title,
            lesson: lessClip.title,
            link: lessClip.parent,
            save_dir: downloader.items[index].task!.savedDir,
            file_name: downloader.items[index].task!.fileName,
            task_id: downloader.items[index].task!.taskId,
          ),
        );
      }
    } else {
      downloadBtnTxt = '';
    }

    Widget btnIcon;

    if (downloadBtnTxt == 'Download')
      btnIcon = Icon(
        Icons.file_download,
        color: Colors.green,
        size: 30.0,
      );
    else if (downloadBtnTxt == 'Cancel Download')
      btnIcon = Icon(
        Icons.clear,
        color: Colors.red,
        size: 30.0,
      );
    else if (downloadBtnTxt == 'Resume Download')
      btnIcon = Icon(
        Icons.play_arrow_sharp,
        color: Colors.blue,
        size: 30.0,
      );
    else if (downloadBtnTxt == 'Delete Download')
      btnIcon = Icon(
        Icons.delete,
        color: Colors.red,
        size: 28.0,
      );
    else
      btnIcon = SizedBox.shrink();

    T.Theme mode = Provider.of<T.Theme>(context);
    var currentVideo;

    if (lessClip.dateTime != null) {
      if (lessClip.dateTime!.millisecondsSinceEpoch <=
          DateTime.now().millisecondsSinceEpoch) {
        currentVideo = (index == _playingIndex);
      } else {
        currentVideo = false;
      }
    } else {
      currentVideo = (index == _playingIndex);
    }

    if (currentVideo) {
      storage.write(
          key: 'courseId : ${widget.courseDetails!.course!.id}',
          value: '$index');
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
      alignment: Alignment.topLeft,
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text("${lessClip.title}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 19,
                              color: mode.titleTextColor,
                              fontWeight: currentVideo
                                  ? FontWeight.w800
                                  : FontWeight.w400)),
                    ),
                    currentVideo
                        ? Icon(
                            Icons.play_arrow,
                            size: 40,
                            color: Colors.blue,
                          )
                        : Icon(
                            Icons.play_arrow,
                            size: 40,
                            color: mode.titleTextColor,
                          ),
                    Visibility(
                      visible: downloadBtnTxt == '' ? false : true,
                      child: TextButton(
                        onPressed: () async {
                          if (isDataDownloadable(lessClip.parent!)) {
                            // Downloader
                            downloader.retryRequestPermission();
                            if (downloadBtnTxt == 'Download') {
                              downloader.requestDownload(
                                  downloader.items[index].task);
                            } else if (downloadBtnTxt == 'Cancel Download') {
                              downloader
                                  .cancelDownload(downloader.items[index].task);
                            } else if (downloadBtnTxt == 'Resume Download') {
                              downloader
                                  .resumeDownload(downloader.items[index].task);
                            } else if (downloadBtnTxt == 'Delete Download') {
                              // show the delete dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      translate("Are_you_sure"),
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    content: Text(translate(
                                        "Do_you_want_to_delete_download")),
                                    actions: [
                                      // ignore: deprecated_member_use
                                      TextButton(
                                        child: Text(translate("OK_")),
                                        onPressed: () {
                                          downloader.delete(
                                              downloader.items[index].task);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(translate("Cancel_")),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: btnIcon,
                      ),
                    ),
                  ],
                ),
                if (lessClip.instructor != null)
                  Text(
                    "  By ${lessClip.instructor}",
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (downloadBtnTxt == 'Cancel Download' ||
                        downloadBtnTxt == 'Delete Download')
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 110,
                        lineHeight: 10.0,
                        barRadius: Radius.circular(5.0),
                        percent: double.parse(progress.toString()) / 100.0,
                        backgroundColor: Color(0xFFF1F3F8),
                        progressColor: Color(0xff0284A2),
                        trailing: Text(
                          '$progress%',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            if (lessClip.dateTime != null) {
              if (lessClip.dateTime!.millisecondsSinceEpoch <=
                  DateTime.now().millisecondsSinceEpoch) {
                setState(() {
                  _playingIndex = index;
                });
              } else {}
            } else {
              setState(() {
                _playingIndex = index;
              });
            }

            if (downloadBtnTxt == 'Delete Download' &&
                downloader.items[index].task!.fileName != null) {
              String theFile = downloader.items[index].task!.savedDir! +
                  Platform.pathSeparator +
                  downloader.items[index].task!.fileName!;

              if (theFile.split(".").last == 'pdf') {
                print('PDF File : $theFile');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PdfViewer(filePath: theFile, isLocal: true)));
              } else if (lessClip.parent!.split(".").last == 'wav' ||
                  lessClip.parent!.split(".").last == 'mp3') {
                print('Audio File : $theFile');
                playAudio(theFile);
              } else {
                print('Video File : $theFile');
                offlineVideoPlayer(videoFile: theFile);
              }
            } else if (downloadBtnTxt == '') {
              if (lessClip.dateTime != null) {
                if (lessClip.dateTime!.millisecondsSinceEpoch <=
                    DateTime.now().millisecondsSinceEpoch) {
                  onlineVideoPlayer(lessClip.parent!,
                      isIframe: lessClip.isIframe!);
                } else {
                  Fluttertoast.showToast(
                      msg: translate("Starts_at") +
                          " " +
                          DateFormat("dd/MM/yyyy hh:mm a")
                              .format(lessClip.dateTime!),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              } else {
                onlineVideoPlayer(lessClip.parent!,
                    isIframe: lessClip.isIframe!);
              }
            } else {
              if (lessClip.parent!.split(".").last == 'pdf') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PdfViewer(filePath: lessClip.parent)));
              } else if (lessClip.parent!.split(".").last == 'wav' ||
                  lessClip.parent!.split(".").last == 'mp3') {
                playAudio(lessClip.parent);
              } else {
                onlineVideoPlayer(lessClip.parent!,
                    isIframe: lessClip.isIframe!);
              }
            }
          },
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1c2464).withOpacity(0.30),
            blurRadius: 25.0,
            offset: Offset(0.0, 20.0),
            spreadRadius: -15.0,
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  pauseVideo(String url) {
    var checkUrl = url.split(".").last;
    if (url.startsWith("https://vimeo.com/")) {
    } else if (url.startsWith('https://www.youtube.com')) {
      _controller!.pause();
    } else if (url.startsWith('https://drive.google.com')) {
      _betterPlayerController!.pause();
    } else if (checkUrl == "mp4" ||
        checkUrl == "mpd" ||
        checkUrl == "webm" ||
        checkUrl == "mkv" ||
        checkUrl == "m3u8" ||
        checkUrl == "ogg" ||
        checkUrl == "wav") {
      print("Pause");
      _betterPlayerController!.pause();
    }
  }

  playVideo(String url) {
    var checkUrl = url.split(".").last;
    if (url.startsWith("https://vimeo.com/")) {
    } else if (url.startsWith('https://www.youtube.com')) {
      _controller!.play();
    } else if (url.startsWith('https://drive.google.com')) {
      _betterPlayerController!.play();
    } else if (checkUrl == "mp4" ||
        checkUrl == "mpd" ||
        checkUrl == "webm" ||
        checkUrl == "mkv" ||
        checkUrl == "m3u8" ||
        checkUrl == "ogg" ||
        checkUrl == "wav") {
      _betterPlayerController!.play();
    }
  }

  var urlData;
  onlineVideoPlayer(String url, {bool isIframe = false}) async {
    print("URL: $url");
    print("object5");
    // Select Subtitle
    // ignore: unused_local_variable
    String? subtitle;
    if (isSubtitle) {
      widget.clips!.forEach((element) {
        if (element.parent == url) {
          subtitle = element.subtitle!;
        }
      });
    }

    var checkUrl = url.split(".").last;
    if (isIframe) {
      print('Iframe Video');

      if (_controller != null) {
        _controller!.pause();
        _controller!.reset();
        _controller = null;
      }

      if (_betterPlayerController != null) {
        print("object4");
        if (_betterPlayerController!.isPlaying()!) {
          _betterPlayerController!.pause();
        }
        _betterPlayerController!.clearCache();
      }

      await Future.delayed(Duration(seconds: 2));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IFramePlayerScreen(url),
        ),
      );
    } else if (url.startsWith("https://vimeo.com/") ||
        url.startsWith("https://player.vimeo.com/")) {
      print("Vimeo Video");

      if (_controller != null) {
        _controller!.pause();
        _controller!.reset();
        _controller = null;
      }

      if (_betterPlayerController != null) {
        print("object3");
        if (_betterPlayerController!.isPlaying()!) {
          _betterPlayerController!.pause();
        }
        _betterPlayerController!.clearCache();
      }

      setState(() {
        urlType = "VIMEO";
        vimeo = '$url';
      });
    } else if (url.startsWith('https://www.youtube.com') ||
        url.startsWith('https://youtu.be/')) {
      print("YouTube Video");

      var youId;
      if (url.length >= 30 &&
          url.startsWith('https://www.youtube.com/embed/')) {
        youId = url.split("/").last;
      } else if (url.startsWith('https://www.youtube.com')) {
        youId = url.split("v=").last;
      } else {
        youId = url.split("/").last;
      }

      print('Youtube Video ID : $youId');

      // For playing youtube videos
      setState(() {
        urlType = "YOUTUBE";
      });

      if (_betterPlayerController != null) {
        print("object2");
        if (_betterPlayerController!.isPlaying()!) {
          _betterPlayerController!.pause();
        }
        _betterPlayerController!.clearCache();
      }

      if (_controller != null) {
        _controller!.pause();
        _controller!.reset();
        _controller = null;
      }
      await Future.delayed(Duration(seconds: 1));
      _controller = YoutubePlayerController(
        initialVideoId: '$youId',
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      );
      setState(() {});
    } else if (url.startsWith('https://drive.google.com')) {
      print("Google Drive Video");

      setState(() {
        urlType = "CUSTOM";
      });

      if (_controller != null) {
        _controller!.pause();
        _controller!.reset();
        _controller = null;
      }

      if (_betterPlayerController != null) {
        print("object1");
        if (_betterPlayerController!.isPlaying()!) {
          _betterPlayerController!.pause();
        }
        _betterPlayerController!.clearCache();
      }

      if (_betterPlayerController == null) {
        print("object");
        // For playing google drive videos
        if (url.startsWith('https://drive.google.com')) {
          var rep = url.split('/d/').last;
          rep = rep.split('/preview').first;
          gUrl =
              "https://www.googleapis.com/drive/v3/files/$rep?alt=media&key=${APIData.googleDriveApi}";
        }
        // This player supports all format mentioned in following URL
        // https://exoplayer.dev/supported-formats.html
        var dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          "$gUrl",
          subtitles: BetterPlayerSubtitlesSource.single(
              type: BetterPlayerSubtitlesSourceType.network,
              url: subtitle ??
                  "http://www.storiesinflight.com/js_videosub/jellies.srt"),
        );
        betterPlayerConfiguration = BetterPlayerConfiguration(
          autoPlay: true,
          looping: isLoop,
          fullScreenByDefault: false,
          aspectRatio: 16 / 9,
          subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
              fontSize: 20,
              fontColor: Colors.white,
              backgroundColor: Colors.black),
          controlsConfiguration: BetterPlayerControlsConfiguration(
            textColor: Colors.white,
            iconsColor: Colors.white,
          ),
        );
        _betterPlayerController = BetterPlayerController(
          betterPlayerConfiguration,
          betterPlayerDataSource: dataSource,
        );
        _betterPlayerController!.play();

        vcontroller2 = VideoPlayerController.networkUrl(Uri.parse('$gUrl'))
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });

        _chewieController = ChewieController(
          videoPlayerController: vcontroller2!,
          autoPlay: true,
          looping: true,
          allowFullScreen: true,
          progressIndicatorDelay:
              bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
          hideControlsTimer: const Duration(seconds: 1),
        );
      } else {
        // For playing google drive videos
        if (url.startsWith('https://drive.google.com')) {
          var rep = url.split('/d/').last;
          rep = rep.split('/preview').first;
          gUrl =
              "https://www.googleapis.com/drive/v3/files/$rep?alt=media&key=${APIData.googleDriveApi}";
        }

        // This player supports all format mentioned in following URL
        // https://exoplayer.dev/supported-formats.html
        var dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          "$gUrl",
          subtitles: BetterPlayerSubtitlesSource.single(
              type: BetterPlayerSubtitlesSourceType.network,
              url: subtitle ??
                  "http://www.storiesinflight.com/js_videosub/jellies.srt"),
        );
        betterPlayerConfiguration = BetterPlayerConfiguration(
          autoPlay: true,
          looping: isLoop,
          fullScreenByDefault: false,
          aspectRatio: 16 / 9,
          subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
              fontSize: 20,
              fontColor: Colors.white,
              backgroundColor: Colors.black),
          controlsConfiguration: BetterPlayerControlsConfiguration(
            textColor: Colors.white,
            iconsColor: Colors.white,
          ),
        );
        _betterPlayerController = BetterPlayerController(
          betterPlayerConfiguration,
          betterPlayerDataSource: dataSource,
        );
        _betterPlayerController!.play();

        vcontroller2 = VideoPlayerController.networkUrl(Uri.parse('$gUrl'))
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });

        _chewieController = ChewieController(
          videoPlayerController: vcontroller2!,
          autoPlay: true,
          looping: true,
          progressIndicatorDelay:
              bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
          hideControlsTimer: const Duration(seconds: 1),
        );
      }
    } else if (checkUrl == "mp4" ||
        checkUrl == "mpd" ||
        checkUrl == "webm" ||
        checkUrl == "mkv" ||
        checkUrl == "m3u8" ||
        checkUrl == "ogg" ||
        checkUrl == "wav") {
      print("Custom Video");

      setState(() {
        urlType = "CUSTOM";
      });

      if (_controller != null) {
        _controller!.reset();
        _controller = null;
      }

      if (_betterPlayerController != null) {
        print("object6");
        if (_betterPlayerController!.isPlaying()!) {
          _betterPlayerController!.pause();
        }
        _betterPlayerController!.clearCache();
      }

      if (vcontroller2 == null) {
        print("object7");
        setState(() {
          urlData = url;
        });
        vcontroller2 = VideoPlayerController.networkUrl(Uri.parse('$url'))
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });

        _chewieController = ChewieController(
          videoPlayerController: vcontroller2!,
          autoPlay: true,
          looping: true,
          progressIndicatorDelay:
              bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
          hideControlsTimer: const Duration(seconds: 1),
        );
        BetterPlayerConfiguration betterPlayerConfiguration =
            BetterPlayerConfiguration(
          aspectRatio: 16 / 9,
          fit: BoxFit.contain,
          autoPlay: true,
          looping: true,
          deviceOrientationsAfterFullScreen: [
            // DeviceOrientation.portraitDown,
            // DeviceOrientation.portraitUp
          ],
        );
        final _betterPlayerDataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          "https://mostqbalk.com/video/class/video_course_1686714153.webm",
        );
        _betterPlayerController =
            BetterPlayerController(betterPlayerConfiguration);
        _betterPlayerController!.setupDataSource(_betterPlayerDataSource);
        var dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          "$url",
          subtitles: BetterPlayerSubtitlesSource.single(
              type: BetterPlayerSubtitlesSourceType.network,
              url: subtitle ??
                  "http://www.storiesinflight.com/js_videosub/jellies.srt"),
        );
        betterPlayerConfiguration = BetterPlayerConfiguration(
          autoPlay: true,
          looping: isLoop,
          fullScreenByDefault: false,
          aspectRatio: 16 / 9,
          subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
              fontSize: 20,
              fontColor: Colors.white,
              backgroundColor: Colors.black),
          controlsConfiguration: BetterPlayerControlsConfiguration(
            textColor: Colors.white,
            iconsColor: Colors.white,
          ),
        );
        _betterPlayerController = BetterPlayerController(
          betterPlayerConfiguration,
          betterPlayerDataSource: dataSource,
        );
        _betterPlayerController!.play();
      } else {
        print("object8");
        setState(() {
          urlData = url;
        });
        vcontroller2 = VideoPlayerController.networkUrl(Uri.parse('$url'))
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
        _chewieController = ChewieController(
          videoPlayerController: vcontroller2!,
          autoPlay: true,
          looping: true,
          progressIndicatorDelay:
              bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
          hideControlsTimer: const Duration(seconds: 1),
        );
        vcontroller2!.play();
        BetterPlayerConfiguration betterPlayerConfiguration =
            BetterPlayerConfiguration(
          aspectRatio: 16 / 9,
          fit: BoxFit.contain,
          autoPlay: true,
          looping: true,
          deviceOrientationsAfterFullScreen: [
            // DeviceOrientation.portraitDown,
            // DeviceOrientation.portraitUp
          ],
        );
        final _betterPlayerDataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          "https://mostqbalk.com/video/class/video_course_1686714153.webm",
        );
        _betterPlayerController =
            BetterPlayerController(betterPlayerConfiguration);
        _betterPlayerController!.setupDataSource(_betterPlayerDataSource);
        var dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          "$url",
          // subtitles: BetterPlayerSubtitlesSource.single(
          //     type: BetterPlayerSubtitlesSourceType.network,
          //     url: subtitle ??
          //         "http://www.storiesinflight.com/js_videosub/jellies.srt"),
        );
        betterPlayerConfiguration = BetterPlayerConfiguration(
          autoPlay: true,
          looping: isLoop,
          fullScreenByDefault: false,
          aspectRatio: 16 / 9,
          subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
              fontSize: 20,
              fontColor: Colors.white,
              backgroundColor: Colors.black),
          controlsConfiguration: BetterPlayerControlsConfiguration(
            textColor: Colors.white,
            iconsColor: Colors.white,
          ),
        );
        _betterPlayerController = BetterPlayerController(
          betterPlayerConfiguration,
          betterPlayerDataSource: dataSource,
        );
        _betterPlayerController!.play();
      }
    }
  }

  offlineVideoPlayer({String? videoFile}) {
    setState(() {
      urlType = "CUSTOM";
    });

    if (_controller != null) {
      _controller!.reset();
      _controller = null;
    }

    if (_betterPlayerController != null) {
      if (_betterPlayerController!.isPlaying()!) {
        _betterPlayerController!.pause();
      }
      _betterPlayerController!.clearCache();
    }

    if (_betterPlayerController == null) {
      //This player supports all format mentioned in following URL
      //  https://exoplayer.dev/supported-formats.html
      var dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        "$videoFile",
      );
      betterPlayerConfiguration = BetterPlayerConfiguration(
        autoPlay: true,
        looping: isLoop,
        fullScreenByDefault: false,
        aspectRatio: 16 / 9,
        subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
            fontSize: 20,
            fontColor: Colors.white,
            backgroundColor: Colors.black),
        controlsConfiguration: BetterPlayerControlsConfiguration(
          textColor: Colors.white,
          iconsColor: Colors.white,
        ),
      );
      _betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: dataSource,
      );
      _betterPlayerController!.play();
    } else {
      // This player supports all format mentioned in following URL
      // https://exoplayer.dev/supported-formats.html
      _betterPlayerController!.pause();
      _betterPlayerController = null;
      var dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        "$videoFile",
      );
      betterPlayerConfiguration = BetterPlayerConfiguration(
        autoPlay: true,
        looping: isLoop,
        fullScreenByDefault: false,
        aspectRatio: 16 / 9,
        subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
            fontSize: 20,
            fontColor: Colors.white,
            backgroundColor: Colors.black),
        controlsConfiguration: BetterPlayerControlsConfiguration(
          textColor: Colors.white,
          iconsColor: Colors.white,
        ),
      );
      _betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: dataSource,
      );
      _betterPlayerController!.play();
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

  var youId = '';
  fetchURLType(String url, {bool isIframe = false}) {
    // Select Subtitle
    if (isSubtitle) {
      widget.clips!.forEach((element) {
        if (element.parent == url) {}
      });
    }

    var checkUrl = url.split(".").last;

    String search = 'https://youtu.be';
    String str = url;
    RegExp exp = new RegExp(
      search,
      caseSensitive: false,
    );
    bool containe = exp.hasMatch(str);
    print(containe);

    if (isIframe) {
      print('Iframe Video');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IFramePlayerScreen(url),
        ),
      );
    } else if (url.startsWith("https://vimeo.com/") ||
        url.startsWith("https://player.vimeo.com/")) {
      print('Vimeo URL : $url');

      setState(() {
        urlType = "VIMEO";
        vimeo = '$url';
      });
    } else if (url.startsWith('https://www.youtube.com') || containe == true) {
      if (containe == true) {
        var pos = url.lastIndexOf('/');
        String result = (pos != -1) ? url.substring(0, pos) : url;
        setState(() {
          youId = url.replaceAll('$result/', '');
        });
      } else if (url.startsWith('https://www.youtube.com/embed/')) {
        setState(() {
          youId = url.split("/").last;
        });
      } else {
        setState(() {
          youId = url.split("v=").last;
        });
      }
      setState(() {
        urlType = "YOUTUBE";
      });

      _controller = YoutubePlayerController(
        initialVideoId: '$youId',
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      );
    } else if (url.startsWith('https://drive.google.com')) {
      setState(() {
        urlType = "CUSTOM";
      });
      // For playing google drive videos
      if (url.startsWith('https://drive.google.com')) {
        var rep = url.split('/d/').last;
        rep = rep.split('/preview').first;
        gUrl =
            "https://www.googleapis.com/drive/v3/files/$rep?alt=media&key=${APIData.googleDriveApi}";
      }

      // This player supports all format mentioned in following URL
      //  https://exoplayer.dev/supported-formats.html

      vcontroller2 = VideoPlayerController.networkUrl(Uri.parse('$gUrl'))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
      _chewieController = ChewieController(
        videoPlayerController: vcontroller2!,
        autoPlay: true,
        looping: true,
        progressIndicatorDelay:
            bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
        hideControlsTimer: const Duration(seconds: 1),
      );

      var dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        "$gUrl",
        // subtitles: BetterPlayerSubtitlesSource.single(
        //     type: BetterPlayerSubtitlesSourceType.network,
        //     url: subtitle2 ??
        //         "http://www.storiesinflight.com/js_videosub/jellies.srt"),
      );
      betterPlayerConfiguration = BetterPlayerConfiguration(
        autoPlay: false,
        looping: isLoop,
        fullScreenByDefault: false,
        aspectRatio: 16 / 9,
        subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
            fontSize: 20,
            fontColor: Colors.white,
            backgroundColor: Colors.black),
        controlsConfiguration: BetterPlayerControlsConfiguration(
          textColor: Colors.white,
          iconsColor: Colors.white,
        ),
      );
      _betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: dataSource,
      );
    } else if (checkUrl == "mp4" ||
        checkUrl == "mpd" ||
        checkUrl == "webm" ||
        checkUrl == "mkv" ||
        checkUrl == "m3u8" ||
        checkUrl == "ogg" ||
        checkUrl == "wav") {
      setState(() {
        urlType = "CUSTOM";
      });
      vcontroller2 = VideoPlayerController.networkUrl(Uri.parse('$url'))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
      _chewieController = ChewieController(
        videoPlayerController: vcontroller2!,
        autoPlay: true,
        looping: true,
        progressIndicatorDelay:
            bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
        hideControlsTimer: const Duration(seconds: 1),
      );
      var dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        "$url",
        // subtitles: BetterPlayerSubtitlesSource.single(
        //     type: BetterPlayerSubtitlesSourceType.network,
        //     url:
        //         "http://www.storiesinflight.com/js_videosub/jellies.srt"),
      );
      betterPlayerConfiguration = BetterPlayerConfiguration(
        autoPlay: false,
        looping: isLoop,
        fullScreenByDefault: false,
        aspectRatio: 16 / 9,
        subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
            fontSize: 20,
            fontColor: Colors.white,
            backgroundColor: Colors.black),
        controlsConfiguration: BetterPlayerControlsConfiguration(
          textColor: Colors.white,
          iconsColor: Colors.white,
        ),
      );
      _betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: dataSource,
      );
    }
  }

  List<Widget> zoomMeetingList(List<ZoomMeeting> zoomMeetings) {
    T.Theme mode = Provider.of<T.Theme>(context);
    List<Widget> list = [];
    for (int i = 0; i < zoomMeetings.length; i++) {
      if ("${zoomMeetings[i].courseId}" ==
          "${widget.courseDetails!.course!.id}") {
        list.add(Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10.0),
                child: Row(
                  children: [
                    Text(
                      translate("Zoom_Meeting"),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              InkWell(
                child: Container(
                  height: 120,
                  padding: EdgeInsets.all(15.0),
                  margin:
                      EdgeInsets.only(right: 15.0, bottom: 10.0, left: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x1c2464).withOpacity(0.30),
                          blurRadius: 25.0,
                          offset: Offset(0.0, 20.0),
                          spreadRadius: -15.0)
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${zoomMeetings[i].meetingTitle}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: mode.titleTextColor,
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  child: Text(
                                    translate("Starts_at"),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color:
                                          mode.titleTextColor.withOpacity(0.8),
                                    ),
                                  ),
                                  padding: EdgeInsets.only(top: 3),
                                ),
                                Padding(
                                  child: Text(
                                      "${DateFormat('dd-MM-yyyy | hh:mm aa').format(zoomMeetings[i].startTime!)}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: mode.titleTextColor
                                            .withOpacity(0.8),
                                      )),
                                  padding: EdgeInsets.only(top: 3),
                                ),
                              ],
                            ),
                          ]),
                    ],
                  ),
                ),
                onTap: () {
                  liveClassAttendance(
                      meetingType: "1", meetingId: zoomMeetings[i].id!);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinWidget(
                        meetingId: zoomMeetings[i].meetingId,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
      }
    }
    return list;
  }

  Future<void> liveClassAttendance(
      {String? meetingType, int? meetingId}) async {
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

  Future<void> initClass() async {
    if (widget.defaultIndex == 0) {
      print("ssss2: $newIndex");
      if (await storage.containsKey(
          key: 'courseId : ${widget.courseDetails!.course!.id}')) {
        var z = (await storage.read(
            key: 'courseId : ${widget.courseDetails!.course!.id}'));
        newIndex = int.parse(z!);
      } else {
        newIndex = widget.defaultIndex!;
      }
    } else {
      newIndex = widget.defaultIndex!;
    }
    _playingIndex = newIndex;
    fetchURLType(widget.clips![newIndex].parent!,
        isIframe: widget.clips![newIndex].isIframe!);
  }

  bool isLoop = false;
  Future<void> initLoop() async {
    if (await storage.containsKey(key: 'isLoop')) {
      isLoop = await storage.read(key: 'isLoop') == 'true' ? true : false;
      setState(() {});
    }
  }

  bool isSubtitle = false;
  Future<void> initSubtitle() async {
    if (await storage.containsKey(key: 'isSubtitle')) {
      isSubtitle =
          await storage.read(key: 'isSubtitle') == 'true' ? true : false;
      setState(() {});
    }
  }

  AnimationController? anicontroller;

  @override
  void initState() {
    super.initState();

    initClass();
    initLoop();
    initSubtitle();
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    anicontroller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    // Downloader
    downloader.initStates(context);
    downloader.setStateFn = setStateCallback;
    WidgetsBinding.instance.addObserver(this);
    WatchlistProvider()
        .addToWatchList(courseId: widget.courseDetails!.course!.id);
    dbHandler.openDB();
  }

  // Downloader
  void setStateCallback(Function() fn) {
    setState(fn);
  }

  ScrollController? controller2;

  bool isYTFullScreen = false;
  var p;
  @override
  Widget build(BuildContext context) {
    // Download
    downloader.platform = Theme.of(context).platform;

    selectedSecs = widget.markedSec;

    T.Theme mode = Provider.of<T.Theme>(context);
    bool firstTime = Provider.of<CoursesProvider>(context, listen: false)
        .checkPurchaedProgressStatus(
            "${widget.sections![0].sectionDetails!.courseId}");
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: SlidingAppBar(
        controller: anicontroller,
        visible: !isYTFullScreen,
        child: AppBar(
          toolbarHeight: !isYTFullScreen ? kToolbarHeight : 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          centerTitle: true,
          automaticallyImplyLeading: true,
          backgroundColor: Color(0xFFF1F3F8),
          title: Text(
            translate("Playlist_"),
            style: TextStyle(
                fontSize: 18.0,
                color: mode.notificationIconColor,
                fontWeight: FontWeight.w600),
          ),
          actions: [],
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                pinned: true,
                forceElevated: innerBoxIsScrolled,
                bottom: PreferredSize(
                  preferredSize: urlType == "CUSTOM"
                      ? Size.fromHeight(212.0)
                      : MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? Size.fromHeight(230.0)
                          : Size.fromHeight(350.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (urlType == "CUSTOM")
                        Container(
                          height: 220.0,
                          color: Colors.black,
                          child: vcontroller2 != null
                              ? vcontroller2!.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          vcontroller2!.value.aspectRatio,
                                      child: Chewie(
                                        controller: _chewieController!,
                                      )
                                      //  VideoPlayer(vcontroller2!)
                                      // VideoPlayer(vcontroller2!),
                                      )
                                  : Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Please Wait...",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    )
                              // Container(
                              //     alignment: Alignment.center,
                              //     child: Text("sss: $vcontroller2"),
                              //   )
                              // CustomPlayer(vcontroller2!)
                              : Container(
                                  alignment: Alignment.center,
                                  child: Text("Somthing went wrong"),
                                ),
                        ),
                      if (urlType == "VIMEO")
                        Container(
                          height: 300.0,
                          child: VimeoPlayer(
                            videoId: vimeo.split("/").last,
                          ),
                        ),
                      if (urlType == "YOUTUBE")
                        Container(
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? MediaQuery.of(context).size.width * 0.56999
                              : MediaQuery.of(context).size.height,
                          alignment: Alignment.topCenter,
                          child: _controller != null
                              // ? YoutubePlayerScreen(_controller)
                              ? YoutubePlayerBuilder(
                                  onEnterFullScreen: () {
                                    SystemChrome.setPreferredOrientations([
                                      DeviceOrientation.landscapeRight,
                                      DeviceOrientation.landscapeLeft,
                                    ]);
                                    setState(() {
                                      isYTFullScreen = true;

                                      // p = _controller!.value.position;
                                    });

                                    _controller!.seekTo(p);
                                  },
                                  onExitFullScreen: () {
                                    SystemChrome.setPreferredOrientations([
                                      DeviceOrientation.landscapeRight,
                                      DeviceOrientation.landscapeLeft,
                                      DeviceOrientation.portraitDown,
                                      DeviceOrientation.portraitUp,
                                    ]);
                                    setState(() {
                                      isYTFullScreen = false;
                                    });

                                    _controller!.seekTo(p);
                                  },
                                  player: YoutubePlayer(
                                    controller: _controller!,
                                    // onReady: () {
                                    //   _controller!.seekTo(p);
                                    // },
                                  ),
                                  builder: (context, player) => Container(
                                    child: ListView(
                                      children: [player],
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      // if (!isYTFullScreen)
                      isYTFullScreen == false
                          ? TabBar(
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.green,
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                              labelColor: Colors.black,
                              tabs: [
                                Tab(
                                  text: translate("Course_"),
                                ),
                                Tab(
                                  text: translate("More_"),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Scaffold(
                backgroundColor: mode.backgroundColor,
                floatingActionButton: _isFullScreen
                    ? SizedBox.shrink()
                    : showBottomNavigation
                        ? FloatingActionButton.extended(
                            backgroundColor: Color(0xffF44A4A),
                            onPressed: () async {
                              setState(() {
                                isLoadingMark = true;
                              });
                              List<String> fChecked = selectedSecs!;
                              RecievedProgress? x;
                              bool res = false;
                              if (firstTime)
                                x = await updateProgress(fChecked);
                              else
                                res = await updateProgressBool(fChecked);
                              if (x != null || res) {
                                Provider.of<CoursesProvider>(context,
                                        listen: false)
                                    .setProgress(
                                        int.tryParse(widget.sections![0]
                                            .sectionDetails!.courseId!),
                                        fChecked,
                                        x);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      translate("Sections_Marking_Completed"),
                                    ),
                                  ),
                                );
                                setState(() {
                                  showBottomNavigation = false;
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      translate("Sections_Marking_Failed"),
                                    ),
                                  ),
                                );
                              }
                              setState(() {
                                isLoadingMark = false;
                              });
                            },
                            label: Text(
                              translate("Mark_As_Complete"),
                            ),
                          )
                        : SizedBox.shrink(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                body: _listViewt(),
              ),
              MoreScreen(widget.courseDetails),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_betterPlayerController != null) {
      _betterPlayerController!.dispose();
    }
    if (_chewieController != null) {
      _chewieController!.dispose();
    }

    // Downloader
    downloader.disposes();

    WidgetsBinding.instance.removeObserver(this);
    WatchlistProvider().removeFromWatchList();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        log("Inactive App"); // Called when app minimized.
        break;
      case AppLifecycleState.paused:
        log("Paused App"); // Called when app minimized.
        WatchlistProvider().removeFromWatchList();
        break;
      case AppLifecycleState.resumed:
        log("Resumed App"); // Called when app maximized.
        WatchlistProvider()
            .addToWatchList(courseId: widget.courseDetails!.course!.id);
        break;
      case AppLifecycleState.detached:
        log("Detached App");
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
