import 'dart:developer';
import 'package:kloncept/common/apidata.dart';
import 'package:flutter/material.dart';
import '../model/InstituteModel.dart';
import 'package:http/http.dart' as http;

class InstituteProvider with ChangeNotifier {
  InstituteModel? instituteModel;

  Future<void> fetchData() async {
    http.Response response = await http.get(
      Uri.parse("${APIData.institutes}${APIData.secretKey}"),
    );

    print("Institutes API Status Code :-> ${response.statusCode}");
    if (response.statusCode == 200) {
      log("Institutes API Response :-> ${response.body}");
      instituteModel = instituteModelFromJson(response.body);
    }
  }
}
