import 'dart:convert';
import 'dart:developer';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/model/content_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class ContentProvider extends ChangeNotifier {
  ContentModel? contentModel;

  Future<ContentModel?> getContent(BuildContext context, int? id) async {
    String url =
        APIData.courseContent + id.toString() + "?secret=${APIData.secretKey}";
    print('abhi1$url');
    Response res = await get(Uri.parse(url));
    log("Course Content API Status Code :-> ${res.statusCode}");
    if (res.statusCode == 200) {
      log("Course Content API Response :-> ${res.body}");
      contentModel = ContentModel.fromJson(json.decode(res.body));
    } else {
      throw "Can't get content";
    }

    notifyListeners();
    return contentModel;
  }
}
