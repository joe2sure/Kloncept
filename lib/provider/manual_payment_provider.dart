import 'dart:convert';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/model/manual_payment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManualPaymentProvider extends ChangeNotifier {
  ManualPaymentModel? manualPaymentModel;
  Future<void> fetchData() async {
    String url = APIData.manualPayments + APIData.secretKey;
    http.Response response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        print("Manual Payment Response :-> $data");
        manualPaymentModel =
            ManualPaymentModel.fromJson(await jsonDecode(data));
      } else {
        print("Manual Payment Response Code :-> ${response.statusCode}");
      }
    } catch (e) {
      print("Manual Payment Exception :-> $e");
    }
  }
}
