import 'package:flutter_translate/flutter_translate.dart';
import '../Widgets/appbar.dart';
import 'about_us_view.dart';
import '../common/theme.dart' as T;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
      appBar: customAppBar(context, translate("About_Us")),
      backgroundColor: mode.bgcolor,
      body: AboutUsView(),
    );
  }
}
