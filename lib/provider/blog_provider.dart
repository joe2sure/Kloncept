import 'dart:convert';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/model/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BlogProvider extends ChangeNotifier{
  BlogModel? blogModel;

  Future<BlogModel?> fetchBlogList(context) async {
    String url = "${APIData.blog}${APIData.secretKey}";
    http.Response res = await http.get(Uri.parse(url),
        headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }
    );
    print(res.statusCode);
    print(res.body);
    if(res.statusCode == 200){
      blogModel = BlogModel.fromJson(json.decode(res.body));
    }else{
      throw "Can't fetch blog";
    }
    return blogModel;
  }
}