import 'dart:developer';
import 'package:kloncept/common/apidata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/InstituteDetailsModel.dart';

class InstituteDetailsProvider with ChangeNotifier {

  InstituteDetailsModel? instituteDetailsModel;

  Future<InstituteDetailsModel?> fetchData(int? instituteId, String? slug) async {
    http.Response response = await http.get(
      Uri.parse(
          "${APIData.instituteDetailsPrefix}$instituteId/$slug${APIData.instituteDetailsPostfix}"),
    );

    print("Institute Details API Status Code :-> ${response.statusCode}");
    if (response.statusCode == 200) {
      log("Institute Details API Response :-> ${response.body}");
      instituteDetailsModel = instituteDetailsModelFromJson(response.body);
    }
    return instituteDetailsModel;
  }
}
