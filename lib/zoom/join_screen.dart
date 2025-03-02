import 'package:kloncept/Widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class JoinWidget extends StatefulWidget {
  JoinWidget({this.meetingId});
  final String? meetingId;
  @override
  _JoinWidgetState createState() => _JoinWidgetState();
}

class _JoinWidgetState extends State<JoinWidget> {
  TextEditingController meetingIdController = TextEditingController();
  TextEditingController meetingPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    meetingIdController.text = widget.meetingId!;
    return Scaffold(
      appBar: customAppBar(context, translate("Join_Meeting")),
      backgroundColor: mode.backgroundColor,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  readOnly: true,
                  obscureText: true,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: meetingIdController,
                  decoration: InputDecoration(
                    labelText: translate("Meeting_ID"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: meetingPasswordController,
                  decoration: InputDecoration(
                    labelText: translate("Meeting_Password"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    // The basic Material Design action button.
                    return SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          backgroundColor: mode.easternBlueColor,
                        ),
                        onPressed: () async {
                          if (meetingPasswordController.text.isNotEmpty) {
                            final status1 = await Permission.phone.request();
                            final status2 = await Permission.camera.request();
                            final status3 =
                                await Permission.bluetooth.request();
                            if (status1.isGranted &&
                                status2.isGranted &&
                                status3.isGranted) {
                              joinMeeting(context);
                            }
                          } else {
                            await Fluttertoast.showToast(
                              msg: translate("Please_enter_Meeting_Password"),
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG,
                            );
                          }
                        },
                        child: Text(
                          translate("Join_Meeting"),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  joinMeeting(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("N/A"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
