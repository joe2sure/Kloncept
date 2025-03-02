import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/provider/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kloncept/common/theme.dart' as T;

class BlogScreen extends StatefulWidget {
  BlogScreen(this.index);
  final int index;

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  HtmlUnescape htmlUnescape = HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var blog = Provider.of<BlogProvider>(context).blogModel!.blog![widget.index];
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              "${APIData.blogImage}${blog.image}",
              fit: BoxFit.cover,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: customAppBar(context, ""),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.2,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: mode.backgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(35.0),
                            topRight: Radius.circular(35.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                bottom: 15.0,
                                top: 30.0,
                              ),
                              child: Text(
                                htmlUnescape
                                    .convert('${blog.heading}')
                                    .replaceAll(
                                        RegExp(r"<[^>]*>",
                                            multiLine: true,
                                            caseSensitive: true),
                                        ""),
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: mode.titleTextColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: Text(
                                'by Admin',
                                softWrap: false,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: mode.titleTextColor.withOpacity(0.6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: Text(
                                DateFormat.yMd().format(blog.updatedAt as DateTime),
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: mode.titleTextColor.withOpacity(0.6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Text(
                                htmlUnescape
                                    .convert('${blog.detail}')
                                    .replaceAll(
                                        RegExp(r"<[^>]*>",
                                            multiLine: true,
                                            caseSensitive: true),
                                        ""),
                                style: TextStyle(
                                  color: mode.titleTextColor,
                                  fontSize: 16.0,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
