import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

String countryName = "###";

Future<void> getCountry() async {
  String apiKey = "ENTER_API_KEY_HERE";
  String url = "https://api.ipgeolocation.io/ipgeo?apiKey=$apiKey";
  http.Response response = await http.get(
    Uri.parse(url),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  );
  print("Country API Status Code : ${response.statusCode}");
  log("Country API Response : ${response.body}");
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    countryName = body["country_name"];
    print("Country : $countryName");
  } else {
    print("Country : ${response.body}");
  }
}
