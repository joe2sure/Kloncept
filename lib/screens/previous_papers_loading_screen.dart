import 'dart:io';
import 'dart:typed_data';
import 'package:kloncept/Screens/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PreviousPapersLoadingScreen extends StatefulWidget {
  PreviousPapersLoadingScreen({this.fileURL});

  final String? fileURL;

  @override
  _PreviousPapersLoadingScreenState createState() =>
      _PreviousPapersLoadingScreenState();
}

class _PreviousPapersLoadingScreenState
    extends State<PreviousPapersLoadingScreen> {
  Future<void> loadData() async {
    String url = widget.fileURL.toString();

    http.Response response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File(
          "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
      await file.writeAsBytes(bytes);
      var filePath = file.path;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewer(
            filePath: filePath,
            isLocal: true,
            isPreviousPaper: true,
          ),
        ),
      );
    } else {
      print('Previous Paper is not loading!');
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
          Text(
            'Loading',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20.0,
            ),
          ),
        ],
      )),
    );
  }
}
