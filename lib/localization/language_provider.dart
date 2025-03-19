import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kloncept/localization/language_model.dart';
import 'package:kloncept/localization/language_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  LanguageModel? languageModel;

  Future<void> loadData(BuildContext context, {bool loadScreen = true}) async {
    try {
      // Use dummy data instead of API call
      languageModel = LanguageModel.fromJson({
        "language": [
          {"name": "English", "local": "en"},
          {"name": "Spanish", "local": "es"},
          {"name": "French", "local": "fr"},
          {"name": "German", "local": "de"},
          {"name": "Hindi", "local": "hi"},
        ]
      });

      // Load Language Code from SharedPreferences
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      languageCode = sharedPreferences.getString('languageCode');
      languageCode = languageCode == null ? 'en' : languageCode;

      print('Dummy Language Data Loaded: ${languageModel!.language}');
      print('Current Language Code: $languageCode');

      // Navigate to LanguageScreen if required
      if (loadScreen) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LanguageScreen()),
        );
      }
    } catch (e) {
      print('Error in loadData: $e');
    }
  }

  String? languageCode;
  String chooselanguage = 'English';

  Future<void> changeLanguageCode({
    required String language,
    required BuildContext context,
  }) async {
    var lngModel = languageModel!.language;

    // Find the selected language
    for (Language _language in lngModel!) {
      if (_language.name == language) {
        languageCode = _language.local;
        chooselanguage = _language.name!;
        break;
      }
    }

    // Save the selected language code to SharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('languageCode', languageCode!);

    // Change the app locale
    await changeLocale(context, languageCode);

    // Show a toast message
    await Fluttertoast.showToast(
      msg: translate("Language_Changed_Successfully"),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // Notify listeners to update the UI
    notifyListeners();
  }
}

// class LanguageModel {
//   List<Language>? language;

//   LanguageModel({this.language});

//   LanguageModel.fromJson(Map<String, dynamic> json) {
//     if (json['language'] != null) {
//       language = <Language>[];
//       json['language'].forEach((v) {
//         language!.add(Language.fromJson(v));
//       });
//     }
//   }
// }

// class Language {
//   String? name;
//   String? local;

//   Language({this.name, this.local});

//   Language.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     local = json['local'];
//   }
// }


// import 'dart:convert';

// import 'package:kloncept/localization/language_model.dart';
// import 'package:kloncept/localization/language_screen.dart';
// import 'package:kloncept/common/apidata.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:translator/translator.dart';

// class LanguageProvider extends ChangeNotifier {
//   LanguageModel? languageModel;

//   Future<void> loadData(BuildContext context, {bool loadScreen = true}) async {
//     String url = APIData.language + APIData.secretKey;
//     print('me$url');
//     http.Response response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       String data = response.body;
//       print('Language List Response :-> $data');
//       languageModel = LanguageModel.fromJson(await jsonDecode(data));
//       // Load Language Code
//       SharedPreferences sharedPreferences =
//           await SharedPreferences.getInstance();
//       languageCode = sharedPreferences.getString('languageCode');
//       languageCode = languageCode == null ? 'en' : languageCode;
//       if (loadScreen)
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => LanguageScreen()));
//     } else {
//       print('Language Response Code :-> ${response.statusCode}');
//     }
//   }

//   String? languageCode;
//   String chooselanguage = 'English';

//   Future<void> changeLanguageCode(
//       {required String language, required BuildContext context}) async {
//     var lngModel = languageModel!.language;

//     //After
//     for (Language _language in lngModel!) {
//       if (_language.name == language) {
//         languageCode = _language.local;
//         chooselanguage = _language.name;
//         break;
//       }
//     }

//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     sharedPreferences.setString('languageCode', languageCode!);
//     await changeLocale(context, languageCode);
//     await Fluttertoast.showToast(
//         msg: translate("Language_Changed_Successfully"),
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.CENTER,
//         backgroundColor: Colors.blue,
//         textColor: Colors.white,
//         fontSize: 16.0);
//     notifyListeners();
//   }

//   Future<String?> translateString({String? text, String? langCode}) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     if (langCode == null) {
//       languageCode = sharedPreferences.getString('languageCode')!;
//       languageCode = languageCode == null ? 'en' : languageCode;
//     } else {
//       languageCode = langCode;
//     }

//     String? translatedString = '';
//     if (sharedPreferences.containsKey('$languageCode-$text') == false) {
//       final translator = GoogleTranslator();
//       var translation =
//           await translator.translate(text!, to: languageCode.toString());
//       translatedString = translation.text;
//       sharedPreferences.setString('$languageCode-$text', translatedString);
//     } else {
//       translatedString = sharedPreferences.getString('$languageCode-$text');
//     }
//     return translatedString;
//   }
// }