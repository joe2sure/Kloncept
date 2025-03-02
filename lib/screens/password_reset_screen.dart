import 'dart:async';
import 'package:flutter_translate/flutter_translate.dart';
import '../Widgets/utils.dart';
import '../common/theme.dart' as T;
import '../services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordReset extends StatefulWidget {
  final int? medium;
  final String? email;
  PasswordReset(this.medium, this.email);
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  String pass = "", repass = "", email = "";
  bool _hidepass = true, _hiderepass = true;

  Widget input(int idx, BuildContext context, String label, Color borderclr) {
    return Container(
        width: MediaQuery.of(context).size.width - 30,
        child: Container(
          height: 90,
          child: TextFormField(
            initialValue: idx == 0 ? "${widget.email}" : "",
            readOnly: idx == 0 ? true : false,
            validator: (value) {
              if (value == "") return translate("This_field_cant_left_empty");
              return null;
            },
            obscureText:
                idx == 0 ? false : (idx == 1 ? _hidepass : _hiderepass),
            maxLines: 1,
            decoration: InputDecoration(
              suffixIcon: idx == 0
                  ? SizedBox.shrink()
                  : IconButton(
                      icon: Icon(
                        idx == 1
                            ? (_hidepass
                                ? Icons.visibility_off
                                : Icons.visibility)
                            : (_hiderepass
                                ? Icons.visibility_off
                                : Icons.visibility),
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        if (idx == 1) {
                          setState(() {
                            _hidepass = !_hidepass;
                          });
                        } else {
                          setState(() {
                            _hiderepass = !_hiderepass;
                          });
                        }
                      }),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: borderclr.withOpacity(0.7),
                  width: 2.0,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: borderclr.withOpacity(0.7),
                  width: 1.0,
                ),
              ),
              labelText: label,
              labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500]),
            ),
            onChanged: (value) {
              if (idx == 0)
                setState(() {
                  email = value;
                });
              else if (idx == 1)
                setState(() {
                  pass = value;
                });
              else if (idx == 2)
                setState(() {
                  repass = value;
                });
            },
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
          ),
        ));
  }

  Widget form(Color clr) {
    return Center(
      child: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 18.0),
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              input(0, context, translate("Email_"), clr),
              input(1, context, translate("Enter_New_Password"), clr),
              input(2, context, translate("Reenter_New_Password"), clr),
            ],
          ),
        ),
      ),
    );
  }

  Widget submitButton() {
    email = widget.email!;
    return Container(
      width: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate() && pass == repass) {
            setState(() {
              isLoading = true;
            });

            bool ispassed = await HttpService().resetPassword(pass, email);
            setState(() {
              isLoading = false;
            });
            if (ispassed) {
              SnackBar snackBar = SnackBar(
                content: Text(
                  translate("Password_Reset_Successfully"),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              if (widget.medium == 0) {
                Timer(
                  Duration(seconds: 2),
                  () => Navigator.of(context).pushNamed('/SignIn'),
                );
              }
            } else if (!ispassed) {
              SnackBar snackBar = SnackBar(
                content: Text(
                  translate("Password_Reset_Failed"),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } else if (pass != repass) {
            SnackBar snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(20.0),
              content: Text(
                translate("Password and Re-Entered Password does not match"),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Container(
          height: 50,
          child: Center(
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    translate("Submit_"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget scaffoldBody(Color clr) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          form(clr),
          submitButton(),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: mode.bgcolor,
      appBar: secondaryAppBar(
          Colors.black, mode.bgcolor, context, translate("Change_Password")),
      body: scaffoldBody(mode.notificationIconColor),
    );
  }
}
