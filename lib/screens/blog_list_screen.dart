import 'package:kloncept/Screens/blog_screen.dart';
import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/localization/language_provider.dart';
import 'package:kloncept/provider/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kloncept/common/theme.dart' as T;
import 'package:html_unescape/html_unescape.dart';

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  bool _visible = false;

  LanguageProvider? languageProvider;

  HtmlUnescape htmlUnescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
    languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final blogs = Provider.of<BlogProvider>(context, listen: false);
      await blogs.fetchBlogList(context);
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var blogModel = Provider.of<BlogProvider>(context).blogModel;
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
      appBar: customAppBar(context, translate("Blogs_")),
      backgroundColor: mode.backgroundColor,
      body: _visible == true
          ? ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              itemCount: blogModel!.blog!.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 335,
                  margin: EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              child: Image.network(
                                "${APIData.blogImage}${blogModel.blog![index].image}",
                                height: 200,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                alignment: Alignment.center,
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                htmlUnescape
                                    .convert("${blogModel.blog![index].heading}")
                                    .replaceAll(
                                        RegExp(r"<[^>]*>",
                                            multiLine: true,
                                            caseSensitive: true),
                                        ""),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: mode.titleTextColor,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                DateFormat.yMMMd().format(
                                  DateTime.parse(
                                      "${blogModel.blog![index].updatedAt}"),
                                ),
                                style: TextStyle(
                                  color: mode.titleTextColor.withOpacity(0.5),
                                  fontSize: 13.0,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                htmlUnescape
                                    .convert("${blogModel.blog![index].detail}")
                                    .replaceAll(
                                        RegExp(r"<[^>]*>",
                                            multiLine: true,
                                            caseSensitive: true),
                                        ""),
                                style: TextStyle(
                                  color: mode.titleTextColor.withOpacity(0.7),
                                  fontSize: 13.0,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlogScreen(index),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
