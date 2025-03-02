import 'dart:io';
import 'package:kloncept/player/offline/offline_data.dart';
import 'package:kloncept/screens/pdf_viewer.dart';
import 'package:kloncept/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../audio_player.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Item>> loadData() async {
    List<Item> items = await DbHandler().items();
    items.sort((a, b) {
      return a.course_name!.compareTo(b.course_name.toString());
    });
    return items;
  }

  String? courseName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, translate("Downloads_")),
      body: Container(
        child: FutureBuilder(
          future: loadData(),
          builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.length == 0)
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(),
                        child: Image.asset("assets/images/emptycourses.png"),
                      ),
                      Text(
                        translate('No_Downloads'),
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                );

              return ListView.builder(
                itemBuilder: (context, index) {
                  print(snapshot.data![index].toString());

                  String fileType = snapshot.data![index].link!.split(".").last;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (courseName != snapshot.data![index].course_name)
                        Card(
                          elevation: 5,
                          color: Colors.indigo,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Center(
                              child: Text(
                                courseName = snapshot.data![index].course_name
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      GestureDetector(
                        child: Card(
                          elevation: 5.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 5.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data![index].lesson.toString(),
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(fileType.toUpperCase()),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Icon(
                                    Icons.play_circle_outline_sharp,
                                    size: 38.0,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          String theFile = snapshot.data![index].save_dir! +
                              Platform.pathSeparator +
                              snapshot.data![index].file_name.toString();

                          if (theFile.split(".").last == 'pdf') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PdfViewer(filePath: theFile, isLocal: true),
                              ),
                            );
                          } else if (theFile.split(".").last == 'wav' ||
                              theFile.split(".").last == 'mp3') {
                            playAudio(theFile);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SizedBox() // OfflineVideoPlayer(file: theFile),
                                  ),
                            );
                          }
                        },
                      )
                    ],
                  );
                },
                itemCount: snapshot.data!.length,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

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
}
