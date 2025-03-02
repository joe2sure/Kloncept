import 'password_reset_screen.dart';
import '../Widgets/utils.dart';
import 'package:provider/provider.dart';
import '../services/http_services.dart';
import 'package:flutter/material.dart';
import '../common/theme.dart' as T;

class Codereset extends StatefulWidget {
  final String email;
  Codereset(this.email);
  @override
  _CoderesetState createState() => _CoderesetState();
}

class _CoderesetState extends State<Codereset> {
  TextEditingController codeCtrl = new TextEditingController();
  Widget scaffoldBody() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextField(
                controller: codeCtrl,
                decoration: InputDecoration(
                    hintText: "Check your email & enter code here.."),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  if (codeCtrl.text.isNotEmpty) {
                    setState(() {
                      isloading = true;
                    });
                    bool x = await HttpService()
                        .verifyCode(widget.email, codeCtrl.text);
                    if (x) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PasswordReset(0, widget.email),
                        ),
                      );
                    } else
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Invalid code"),
                        ),
                      );
                    setState(() {
                      isloading = false;
                    });
                  }
                },
                child: isloading
                    ? Container(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        "Submit",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
              )
            ],
          )),
    );
  }

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
      backgroundColor: mode.bgcolor,
      appBar: secondaryAppBar(
          mode.notificationIconColor, mode.bgcolor, context, "Forgot Password"),
      body: scaffoldBody(),
    );
  }
}
