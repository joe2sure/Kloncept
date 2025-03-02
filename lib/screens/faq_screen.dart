import 'package:flutter_translate/flutter_translate.dart';
import '../Widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'faq_view.dart';

// ignore: must_be_immutable
class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, translate("FAQ_")),
      backgroundColor: Color(0xFFF1F3F8),
      body: FaqView(),
    );
  }
}
