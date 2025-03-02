import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../model/UpiDetailsModel.dart';
import '../model/payment_api_model.dart';
import 'package:http/http.dart';

class PaymentAPIProvider with ChangeNotifier {
  PaymentApi paymentApi = PaymentApi();

  Future<PaymentApi> fetchPaymentAPI(BuildContext context) async {
    Response res = await get(
        Uri.parse("${APIData.paymentGatewayKeys}${APIData.secretKey}"));
    print(res.statusCode);
    if (res.statusCode == 200) {
      paymentApi = PaymentApi.fromJson(json.decode(res.body));
    } else {
      throw "Can't get payment API keys";
    }

    await fetchUPIDetails();

    notifyListeners();
    return paymentApi;
  }

  UpiDetailsModel upiDetailsModel = UpiDetailsModel();

  Future<void> fetchUPIDetails() async {
    Response response = await get(
      Uri.parse("${APIData.upiDetails}"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );
    print("UPI Details API Status Code :-> ${response.statusCode}");
    log("UPI Details API Response :-> ${response.body}");
    if (response.statusCode == 200) {
      upiDetailsModel = upiDetailsModelFromJson(response.body);
    }
  }
}
