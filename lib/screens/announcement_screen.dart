import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/provider/content_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kloncept/common/theme.dart' as T;

class AnnouncementScreen extends StatefulWidget {
  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var content =
        Provider.of<ContentProvider>(context, listen: false).contentModel;
    return Scaffold(
      appBar: customAppBar(context, translate("Announcement_")),
      backgroundColor: mode.backgroundColor,
      body: content != null && content.announcement!.length == 0
          ? Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 40),
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(),
                        child: Image.asset("assets/images/emptycategory.png"),
                      ),
                    ),
                    Container(
                      height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            translate("Announcement_is_not_available"),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            width: 200,
                            child: Text(
                              translate("There_is_no_Announcement_to_be_shown"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: content != null ? content.announcement!.length : 0,
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              itemBuilder: (BuildContext context, int i) {
                return DescriptionTextWidget(
                  text: "${content!.announcement![i].detail}",
                  index: i,
                );
              },
            ),
    );
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String? text;
  final int index;

  DescriptionTextWidget({@required this.text, required this.index});

  @override
  _DescriptionTextWidgetState createState() =>
      new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String? firstHalf;
  String? secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text!.length > 130) {
      firstHalf = widget.text!.substring(0, 130);
      secondHalf = widget.text!.substring(130, widget.text!.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var content =
        Provider.of<ContentProvider>(context, listen: false).contentModel;
    return Container(
      padding: new EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 25.0,
              offset: Offset(0.0, 20.0),
              spreadRadius: -15.0)
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: secondHalf!.isEmpty
          ? new Text(firstHalf!)
          : new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${translate("By_")} ${content!.announcement![widget.index].user}",
                      style: new TextStyle(
                          color: mode.titleTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      DateFormat.yMMMd().add_jm().format(content
                          .announcement![widget.index].updatedAt as DateTime),
                      style: new TextStyle(
                          color: mode.titleTextColor.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                new Text(
                  flag
                      ? (firstHalf! + "...")
                      : (firstHalf! + secondHalf.toString()),
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16.0, color: mode.titleTextColor),
                ),
                new InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                        flag ? translate("Read_more") : translate("Read_Less"),
                        style: new TextStyle(
                            color: mode.easternBlueColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
