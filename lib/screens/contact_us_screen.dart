import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextStyle _labelStyle = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w600, color: Colors.grey[500]);
  TextStyle _mainStyle(Color clr) {
    return TextStyle(color: clr, fontSize: 17);
  }

  UnderlineInputBorder enborder(Color borderClr) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderClr,
        width: 1.0,
      ),
    );
  }

  UnderlineInputBorder foborder(Color borderClr) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderClr,
        width: 2.0,
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  String name = "", email = "", phone = "", message = "";

  Widget heading(String txt) {
    return Container(
      // alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(0.0, 10.0, 15.0, 15.0),
      child: Text(
        txt,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<bool> sendContactDetails(
      String name, String email, String mob, String message) async {
    Response res = await post(
      Uri.parse("${APIData.contactUs}${APIData.secretKey}"),
      headers: {"Accept": "application/json"},
      body: {"fname": name, "email": email, "mobile": mob, "message": message},
    );
    return res.statusCode == 200 ? true : false;
  }

  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextButton submitButton(Color clr) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: clr,
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });
          bool isPassed = await sendContactDetails(name, email, phone, message);
          setState(() {
            isLoading = false;
          });
          if (isPassed) {
            SnackBar snackBar = SnackBar(
              content: Text(
                translate("Form_submitted_successfully"),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (!isPassed) {
            SnackBar snackBar = SnackBar(
              content: Text(
                translate("Form_submission_failed"),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 200,
        height: 50,
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                translate("Submit_"),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget inputField(String label, int idx, Color borderclr) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: idx == 3 ? 150 : 90,
      child: TextFormField(
        validator: (value) {
          if (value == "") {
            return translate("This_field_cannot_be_left_empty");
          } else if (idx == 2) {
            if (!value!.contains('@') || !value.contains('.')) {
              return translate("Invalid_Email");
            }
          }
          return null;
        },
        maxLines: idx == 3 ? 3 : 1,
        onChanged: (value) {
          if (idx == 0) {
            setState(() {
              this.name = value;
            });
          } else if (idx == 1) {
            setState(() {
              this.email = value;
            });
          } else if (idx == 2) {
            setState(() {
              this.phone = value;
            });
          } else if (idx == 3) {
            setState(() {
              this.message = value;
            });
          }
        },
        keyboardType: idx == 1
            ? TextInputType.phone
            : idx == 2
                ? TextInputType.emailAddress
                : idx == 3
                    ? TextInputType.multiline
                    : TextInputType.name,
        cursorColor: Colors.black,
        style: _mainStyle(txtColor!),
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: foborder(borderclr),
          enabledBorder: enborder(borderclr),
          labelStyle: _labelStyle,
        ),
      ),
    );
  }

  Widget form(Color borderClr) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          inputField(translate("Name_"), 0, borderClr),
          inputField(translate("Phone_"), 1, borderClr),
          inputField(translate("Email_"), 2, borderClr),
          inputField(translate("Your_Message"), 3, borderClr),
          submitButton(Color(0xffF44A4A))
        ],
      ),
    );
  }

  Widget leadingOfDetails(IconData icon) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey[300]),
      height: 40,
      width: 40,
      child: Icon(
        icon,
        color: Colors.black,
      ),
    );
  }

  Widget boxContainer(
      String? desc, String? title, IconData icon, Color descColor) {
    return ListTile(
      leading: leadingOfDetails(icon),
      title: Text(
        title.toString(),
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        desc.toString(),
        style: TextStyle(fontSize: 15, color: descColor),
      ),
    );
  }

  GoogleMapController? mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget mapContainer({String? lat, String? lon}) {
    LatLng latLng = LatLng(double.parse(lat!), double.parse(lon!));

    return Center(
      child: Container(
        padding: EdgeInsets.all(5.0),
        height: 200,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: latLng,
            zoom: 12.0,
          ),
        ),
      ),
    );
  }

  Widget companyDetails(Color descColor) {
    var homeData =
        Provider.of<HomeDataProvider>(context, listen: false).homeModel;
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        cusDivider(Colors.grey[300]!),
        boxContainer(homeData!.settings!.defaultAddress.toString(),
            translate("ADDRESS_"), Icons.location_on, descColor),
        if (homeData.settings!.mapLat.toString() != 'null' &&
            homeData.settings!.mapLong.toString() != 'null')
          mapContainer(
              lat: homeData.settings!.mapLat, lon: homeData.settings!.mapLong),
        cusDivider(Colors.grey[300]!),
        boxContainer(homeData.settings!.welEmail, translate("EMAIL_"),
            Icons.mail, descColor),
        cusDivider(Colors.grey[300]!),
        boxContainer(homeData.settings!.defaultPhone, translate("PHONE_"),
            Icons.phone, descColor),
        cusDivider(Colors.grey[300]!),
      ],
    );
  }

  Widget scaffoldBody(Color notificationIconColor) {
    return Container(
      margin: EdgeInsets.all(18.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading(translate("Company_Details")),
            companyDetails(notificationIconColor),
            SizedBox(
              height: 30,
            ),
            heading(translate("Keep_in_touch_with_us")),
            form(notificationIconColor),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Color? txtColor;
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    txtColor = mode.txtcolor;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: mode.bgcolor,
      appBar: secondaryAppBar(mode.notificationIconColor, mode.bgcolor, context,
          translate("Contact_Us")),
      body: scaffoldBody(mode.notificationIconColor),
    );
  }
}
