import 'dart:io';
import 'dart:typed_data';
import 'package:kloncept/Screens/pdf_viewer.dart';
import 'package:kloncept/common/apidata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

class InvoiceLoadingScreen extends StatefulWidget {
  InvoiceLoadingScreen(this.purchaseId);

  final int? purchaseId;

  @override
  _InvoiceLoadingScreenState createState() => _InvoiceLoadingScreenState();
}

class _InvoiceLoadingScreenState extends State<InvoiceLoadingScreen> {
  Future<void> loadData() async {
    final storage = new FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'token');

    String url = APIData.purchaseInvoice +
        widget.purchaseId.toString() +
        '?secret=' +
        APIData.secretKey;

    http.Response response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken",
    });

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
            isInvoice: true,
          ),
        ),
      );
    } else {
      print('Invoice is not loading! - Status Code :-> ${response.statusCode}');
      Navigator.pop(context);
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
