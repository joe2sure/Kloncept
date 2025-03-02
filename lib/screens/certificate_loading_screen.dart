import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:kloncept/Screens/pdf_viewer.dart';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/model/course_with_progress.dart';
import 'package:kloncept/provider/full_course_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CertificateLoadingScreen extends StatefulWidget {
  CertificateLoadingScreen(this.courseDetails);

  final FullCourse? courseDetails;

  @override
  _CertificateLoadingScreenState createState() =>
      _CertificateLoadingScreenState();
}

class _CertificateLoadingScreenState extends State<CertificateLoadingScreen> {

  Future<void> loadData() async {
    int? progressId = await getProgressId(widget.courseDetails!.course!.id as int);

    String url = APIData.certificate +
        progressId.toString() +
        "?secret=${APIData.secretKey}";

    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
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
            isCertificate: true,
          ),
        ),
      );
    } else if (response.statusCode == 400) {
      await Fluttertoast.showToast(
          msg: translate("Please_Complete_your_course_to_get_certificate"),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context);
    } else {
      print("Certificate API Status Code :-> ${response.statusCode}");
      print('Certificate is not loading!');
      Navigator.pop(context);
    }
  }

  Future<int?> getProgressId(int courseId) async {
    String url = "${APIData.courseProgress}${APIData.secretKey}";
    http.Response res = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken",
      },
      body: {"course_id": courseId.toString()},
    );
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body)["progress"];
      if (body == null) return 0;
      Progress progress = Progress.fromJson(body);
      return progress.id;
    } else {
      return 0;
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
