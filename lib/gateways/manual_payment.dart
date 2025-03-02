import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kloncept/model/manual_payment_model.dart';
import 'package:kloncept/provider/manual_payment_provider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/bottom_navigation_screen.dart';
import '../Widgets/appbar.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ManualPayment extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final Manual_payment? manual_payment;

  // ignore: non_constant_identifier_names
  ManualPayment({this.manual_payment});

  @override
  _ManualPaymentState createState() => _ManualPaymentState();
}

class _ManualPaymentState extends State<ManualPayment> {
  ManualPaymentProvider? manualPaymentProvider;

  Widget _buildCard() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.manual_payment!.name!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 18.0,
                    letterSpacing: 1.0,
                  ),
                ),
                Divider(
                  height: 10,
                ),
                Text(
                  "Detail",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                HtmlWidget(
                  widget.manual_payment!.detail.toString(),
                  textStyle: TextStyle(
                    fontSize: 16.0,
                  ),
                  customStylesBuilder: (element) {
                    return {
                      'font-weight': '600',
                      'font-size': '16',
                      'align': 'justify'
                    };
                  },
                ),
                Divider(
                  height: 10,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Image.network(
                widget.manual_payment!.imagePath.toString(),
                fit: BoxFit.fitWidth,
                errorBuilder: (_, __, ___) {
                  return SizedBox.shrink();
                },
              ),
              proofPicker(),
              submitButton()
            ],
          ),
        ],
      );

  // final _form
  bool submitLoading = false;

  goToDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            height: 300.0,
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Request Sent!",
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "We have received you request ! we will check and update the details in few hours !",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyBottomNavigationBar(
                          pageInd: 0,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      onPressed: () async {
        if (proofCtrl.text.length > 0) {
          setState(() {
            submitLoading = true;
          });
          bool x = await sendDetails();

          if (x) {
            goToDialog();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Something went wrong! Try Again later."),
              ),
            );
          }
        }
        setState(() {
          submitLoading = false;
        });
      },
      child: Container(
        padding: EdgeInsets.all(submitLoading ? 5 : 0),
        height: 50,
        width: 120,
        alignment: Alignment.center,
        child: submitLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Center(
                child: Text(
                  "Submit",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
      ),
    );
  }

  File? _proof;

  String extractName(String path) {
    int i;
    for (i = path.length - 1; i >= 0; i--) {
      if (path[i] == "/") break;
    }
    return path.substring(i + 1);
  }

  Future<bool> sendDetails() async {
    String _proofName = _proof!.path.split('/').last;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey("topUpWallet")) {
      Fluttertoast.showToast(msg: "N/A", backgroundColor: Colors.red);
      return false;
    } else if (!sharedPreferences.containsKey("giftUserId")) {
      String url = APIData.payStore + APIData.secretKey;
      var _body = FormData.fromMap({
        "payment_method": "${widget.manual_payment!.name}",
        "pay_status": "1",
        "proof":
            await MultipartFile.fromFile(_proof!.path, filename: _proofName),
        "transaction_id": "null"
      });
      Response response;
      try {
        response = await Dio().post(
          url,
          data: _body,
          options: Options(
            method: 'POST',
            headers: {
              HttpHeaders.authorizationHeader: "Bearer " + authToken,
              "Accept": "application/json"
            },
          ),
        );
        print('Manual Payment Response -> $response');
        if (response.statusCode == 200) {
          return true;
        } else
          return false;
      } catch (e) {
        print('Manual Payment Error -> $e');
        return false;
      }
    } else {
      int? giftUserId = sharedPreferences.getInt("giftUserId");
      int? giftCourseId = sharedPreferences.getInt("giftCourseId");

      String url = APIData.giftCheckout + APIData.secretKey;
      var body = FormData.fromMap({
        "gift_user_id": giftUserId,
        "course_id": giftCourseId,
        "payment_method": "${widget.manual_payment!.name}",
        "txn_id": "null",
        "pay_status": "1",
        "file":
            await MultipartFile.fromFile(_proof!.path, filename: _proofName),
      });
      Response response;
      try {
        response = await Dio().post(
          url,
          data: body,
        );
        print('Gift Manual Payment Response -> $response');
        if (response.statusCode == 200) {
          await sharedPreferences.remove("giftUserId");
          await sharedPreferences.remove("giftCourseId");
          return true;
        } else
          return false;
      } catch (e) {
        print('Gift Manual Payment Error -> $e');
        return false;
      }
    }
  }

  String prooftxt = "Upload Proof here";

  TextEditingController proofCtrl =
      new TextEditingController(text: "Upload proof Here!");

  Widget proofPicker() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[500]!,
        ),
      ),
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(18),
      child: TextFormField(
        validator: (value) {
          if (value == "")
            return 'Please upload your resume here!';
          else
            return null;
        },
        controller: proofCtrl,
        readOnly: true,
        style: TextStyle(
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.normal),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              FontAwesomeIcons.upload,
              color: Colors.grey,
            ),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom, allowedExtensions: ["pdf", "doc"]);

              if (result != null) {
                _proof = File(result.files.single.path.toString());
                setState(
                  () {
                    proofCtrl.text = extractName(_proof!.path);
                  },
                );
              }
            },
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget whenNull() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/serverError.png",
          height: 180,
          width: 180,
        ),
        Text(
          "No details available ",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(
            "Looks like there is no details enter for bank payment",
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.7)),
          ),
        ),
      ],
    );
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: customAppBar(context, "Manual Payment"),
      backgroundColor: Color(0xFFF1F3F8),
      body: widget.manual_payment == null
          ? whenNull()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: _buildCard(),
                  )
                ],
              ),
            ),
    );
  }
}
