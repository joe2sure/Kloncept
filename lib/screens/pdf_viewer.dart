import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:kloncept/localization/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  PdfViewer({
    this.filePath,
    this.isLocal = false,
    this.isCertificate = false,
    this.isInvoice = false,
    this.isPreviousPaper = false,
  });

  final String? filePath;
  final bool isLocal;
  final bool isCertificate;
  final bool isInvoice;
  final bool isPreviousPaper;

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  TargetPlatform? platform;
  LanguageProvider? languageProvider;
  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;
    languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isCertificate
              ? translate("Certificate_")
              : widget.isInvoice
                  ? translate("Invoice_")
                  : widget.isPreviousPaper
                      ? translate("Previous_Papers")
                      : translate("PDF_File_Viewer"),
        ),
        actions: [
          if ((widget.isCertificate ||
                  widget.isInvoice ||
                  widget.isPreviousPaper) &&
              platform == TargetPlatform.android)
            IconButton(
              icon: Icon(
                Icons.download_sharp,
                size: 25.0,
                color: Colors.white,
              ),
              onPressed: () async {
                bool permitted = await checkPermission();
                if (permitted) {
                  try {
                    if (widget.isCertificate) {
                      await File(widget.filePath.toString()).copy(
                          '/storage/emulated/0/Download/Certificate_' +
                              DateTime.now().millisecondsSinceEpoch.toString() +
                              '.pdf');
                    } else if (widget.isInvoice) {
                      await File(widget.filePath.toString()).copy(
                          '/storage/emulated/0/Download/Invoice_' +
                              DateTime.now().millisecondsSinceEpoch.toString() +
                              '.pdf');
                    } else {
                      await File(widget.filePath.toString()).copy(
                          '/storage/emulated/0/Download/Previous_Paper_' +
                              DateTime.now().millisecondsSinceEpoch.toString() +
                              '.pdf');
                    }
                    await File(widget.filePath.toString()).delete();
                    Fluttertoast.showToast(
                        msg: widget.isCertificate
                            ? translate("Certificate_Saved_in_Download_Folder")
                            : widget.isInvoice
                                ? translate("Invoice_Saved_in_Download_Folder")
                                : translate(
                                    "Previous_Paper_Saved_in_Download_Folder"),
                        backgroundColor: Colors.green,
                        textColor: Colors.white);
                  } catch (e) {
                    Fluttertoast.showToast(
                        msg: translate("Already_Saved_in_Download_Folder"),
                        backgroundColor: Colors.red,
                        textColor: Colors.white);
                  }
                }
              },
            ),
        ],
      ),
      body: Container(
        child: widget.isLocal
            ? SfPdfViewer.file(File(widget.filePath.toString()))
            : SfPdfViewer.network(widget.filePath.toString()),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    if (widget.isCertificate || widget.isInvoice || widget.isPreviousPaper) {
      try {
        await File(widget.filePath.toString()).delete();
        widget.isCertificate
            ? print('Certificate Deleted.')
            : widget.isInvoice
                ? print('Invoice Deleted.')
                : print('Previous Paper Deleted.');
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool> checkPermission() async {
    if (platform == TargetPlatform.android) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 29) {
        return true;
      }
      final status1 = await Permission.storage.status;
      if (status1 != PermissionStatus.granted) {
        final result1 = await Permission.storage.request();
        if (result1 == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
}
