import 'dart:convert';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/model/terms_policy_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class TermsPolicyProvider extends ChangeNotifier {
  TermsPolicyModel? termsPolicyModel;

  Future<void> getData() async {
    String url = APIData.termsPolicy + APIData.secretKey;
    Response res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
      print("Terms Policy Response : ${res.body}");
      termsPolicyModel = TermsPolicyModel.fromJson(json.decode(res.body));
    } else {
      print("Terms Policy Response Code : ${res.statusCode}");
    }
  }
}
