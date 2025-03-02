import 'package:flutter_translate/flutter_translate.dart';
import '../Widgets/appbar.dart';
import '../services/http_services.dart';
import 'package:flutter/material.dart';
import 'instructor_faq_view.dart';

// ignore: must_be_immutable
class InstructorFaqScreen extends StatelessWidget {
  HttpService httpService = new HttpService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, translate("Instructor_FAQ")),
      backgroundColor: Color(0xFFF1F3F8),
      body: InstructorFaqView(),
    );
  }
}
