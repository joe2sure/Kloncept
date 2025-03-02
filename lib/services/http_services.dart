import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../model/faq_model.dart';
import '../model/about_us_model.dart';
import '../model/coupon_model.dart';
import '../model/purchase_history_model.dart';
import '../provider/home_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert' as convert;

class Access with ChangeNotifier {
  String accessToken = '';
  String secretKey = '';

  void updateAt(String at) {
    this.accessToken = at;
  }

  void updateSk(String sk) {
    this.secretKey = sk;
  }
}

class HttpService {
  Future<List<FaqElement>> fetchUserFaq() async {
    var response =
        await http.get(Uri.parse("${APIData.userFaq}${APIData.secretKey}"));
    var jsonResponse = (convert.jsonDecode(response.body)['faq']) as List;
    return jsonResponse.map((faq) => FaqElement.fromJson(faq)).toList();
  }

  Future<List<FaqElement>> fetchInstructorFaq() async {
    var response = await http
        .get(Uri.parse("${APIData.instructorFaq}${APIData.secretKey}"));
    var jsonResponse = (convert.jsonDecode(response.body)['faq']) as List;
    return jsonResponse.map((faq) => FaqElement.fromJson(faq)).toList();
  }

  Future<bool> resetPassword(String newPass, String email) async {
    String url = APIData.restPassword;

    http.Response res = await http.post(
      Uri.parse(url),
      body: {
        "email": email,
        "password": newPass,
      },
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );

    return res.statusCode == 200;
  }

  Future<bool> forgotEmailReq(String _email) async {
    String url = APIData.forgotPassword;

    http.Response res =
        await http.post(Uri.parse(url), body: {"email": _email});
    if (res.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<bool> verifyCode(String email, String code) async {
    String url = APIData.forgotPassword;

    http.Response res =
        await http.post(Uri.parse(url), body: {"email": email, "code": code});
    if (res.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<bool> login(
      String? email, String? pass, BuildContext context, _scaffoldKey) async {
    http.Response res = await http.post(Uri.parse(APIData.login), body: {
      "email": email,
      "password": pass
    }, headers: {
      "Accept": "application/json",
    });
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      authToken = body["access_token"];
      var refreshToken = body["access_token"];
      await storage.write(key: "token", value: "$authToken");
      await storage.write(key: "refreshToken", value: "$refreshToken");
      authToken = await storage.read(key: "token");
      HomeDataProvider homeData =
          Provider.of<HomeDataProvider>(context, listen: false);
      await homeData.getHomeDetails(context);
    }
    print("Login API Status Code : ${res.statusCode}");
    log("Login API Response : ${res.body}");
    if (res.statusCode == 200) {
      return true;
    } else {
      if (res.statusCode == 402) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verify email to continue."),
            action: SnackBarAction(label: "Ok", onPressed: () {}),
          ),
        );
        return false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Failed!"),
            action: SnackBarAction(label: "Ok", onPressed: () {}),
          ),
        );
        return false;
      }
    }
  }

  Future<bool> signUp(String name, String email, String password, String mobile,
      BuildContext context, _scaffoldKey) async {
    print(name);
    print(email);
    print(password);
    print(mobile);

    print("Register Url ${APIData.register}");

    http.Response res = await http.post(
      Uri.parse(APIData.register),
      body: {
        "name": name,
        "email": email,
        "password": password,
        "mobile": mobile,
      },
      headers: {
        "Accept": "application/json",
      },
    );

    print('Sign-Up API Status Code :-> ${res.statusCode}');
    print("Sign-Up API Response :-> ${res.body}");
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      authToken = body["access_token"];
      var refreshToken = body["access_token"];
      await storage.write(key: "token", value: "$authToken");
      await storage.write(key: "refreshToken", value: "$refreshToken");
      authToken = await storage.read(key: "token");
      HomeDataProvider homeData =
          Provider.of<HomeDataProvider>(context, listen: false);
      await homeData.getHomeDetails(context);
      return true;
    } else {
      if (res.statusCode == 402) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verification email sent verify to continue."),
            action: SnackBarAction(
              label: "Ok",
              onPressed: () {
                Navigator.of(context).pushNamed('/SignIn');
              },
            ),
          ),
        );
        return false;
      } else if (res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verification email can't be sent."),
            action: SnackBarAction(
              label: "Ok",
              onPressed: () {
                Navigator.of(context).pushNamed('/SignIn');
              },
            ),
          ),
        );
        return false;
      } else if (res.statusCode == 422) {
        Fluttertoast.showToast(
          msg: "An account with same email already exists.",
          toastLength: Toast.LENGTH_LONG,
        );
        return false;
      } else {
        Fluttertoast.showToast(msg: "Registration Failed!");
        return false;
      }
    }
  }

  Future<List<About>> fetchAboutUs() async {
    var response =
        await http.get(Uri.parse(APIData.aboutUs + "${APIData.secretKey}"));
    var jsonResponse = (convert.jsonDecode(response.body)['about']) as List;
    return jsonResponse.map((employee) => About.fromJson(employee)).toList();
  }

  Future<bool> logout() async {
    String url = APIData.logOut;
    http.Response res = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );

    print("logout: ${res.body}");
    log("logout2: $authToken");
    if (res.statusCode == 200) {
      authToken = null;
      await storage.deleteAll();
      return true;
    } else
      return false;
  }

  Future<List<CouponModel>> getCartCouponData() async {
    String url = APIData.coupon + APIData.secretKey;

    http.Response res = await http.get(Uri.parse(url));
    List<CouponModel> couponList = [];
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body)["coupon"] as List;
      couponList = body.map((e) => CouponModel.fromJson(e)).toList();
    } else {
      throw "err";
    }
    return couponList;
  }

  Future<List<Orderhistory>> fetchPurchaseHistory() async {
    print('123${APIData.purchaseHistory}' + "${APIData.secretKey}");
    var response = await http.get(
      Uri.parse(APIData.purchaseHistory + "${APIData.secretKey}"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $authToken",
        HttpHeaders.acceptHeader: "application/json",
      },
    );
    print('Respnse Ststus Code${response.statusCode}');
    print('Respnse Ststus Code${response.body}');
    if (response.statusCode != 200) {
      return [];
    }
    PurchaseHistory jsonResponse =
        PurchaseHistory.fromJson(convert.jsonDecode(response.body));
    return jsonResponse.orderhistory!;
  }
}
