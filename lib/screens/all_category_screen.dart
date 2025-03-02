import 'package:cached_network_image/cached_network_image.dart';
import 'package:kloncept/common/apidata.dart';
import '../model/home_model.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class AllCategoryScreen extends StatefulWidget {
  @override
  _AllCategoryScreenState createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<bool> expanded = [false, false, false, false, false];
  var category, subCategory, childCategory;
  int selected = -1;

  List<Widget> childCatItemList(int? subCatId, String? catId, List<ChildCategory>? ccList) {
    List<Widget> ccWidgetList = [];
    ccList!.forEach(
      (element) {
        if (element.subcategoryId.toString() == subCatId.toString() &&
            element.categoryId.toString() == catId.toString())
          ccWidgetList.add(
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: ListTile(
                title: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, top: 15, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              element.title.toString(),
                              maxLines: 1,
                              style: TextStyle(
                                color: Color(0xFF3F4654),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/childCategory', arguments: element);
                    },
                  ),
                ),
              ),
            ),
          );
      },
    );
    return ccWidgetList;
  }

  List<Widget> subCategoryItemList(
      int? id, List<SubCategory>? scList, Color clr) {
    var homeData = Provider.of<HomeDataProvider>(context, listen: false);
    List<Widget> scItems = [];
    scList!.forEach(
      (element) {
        if (element.categoryId == id.toString()) {
          scItems.add(
            ExpansionTile(
              trailing: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/subCategory', arguments: element);
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Color(0xFF3F4654).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25.00),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Color(0xFF3F4654).withOpacity(0.6),
                    ),
                  ),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 54.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        element.title.toString(),
                        maxLines: 1,
                        style: TextStyle(
                          color: Color(0xFF3F4654),
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              children: childCatItemList(
                  element.id, element.categoryId, homeData.childCategoryList),
            ),
          );
        }
      },
    );
    return scItems;
  }

  Widget parentTile(HomeDataProvider? homeData, int idx, Color? bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 8.0,
              offset: Offset(0.0, 10.0),
              spreadRadius: -15.0)
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.only(bottom: 10.0),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        onExpansionChanged: ((newState) {
          if (newState)
            setState(() {
              selected = idx;
            });
          else
            setState(() {
              selected = -1;
            });
        }),
        trailing: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed('/category', arguments: homeData!.categoryList![idx]);
          },
          child: Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
                color: Color(0xFF3F4654).withOpacity(0.1),
                borderRadius: BorderRadius.circular(25.00)),
            child: Center(
              child: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Color(0xFF3F4654).withOpacity(0.6),
              ),
            ),
          ),
        ),
        initiallyExpanded: idx == selected ? true : false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 18.0, 0.0),
              child: CachedNetworkImage(
                imageUrl:
                    "${APIData.categoryImages}${homeData!.categoryList![idx].catImage}",
                imageBuilder: (context, imageProvider) => Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(47.5),
                    border: Border.all(color: Colors.white, width: 3),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Color(0xFF3F4654).withOpacity(0.4),
                          BlendMode.colorBurn),
                    ),
                  ),
                ),
                placeholder: (context, url) => Image.asset(
                  "assets/images/cat.png",
                  height: 40,
                  width: 40,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  "assets/images/cat.png",
                  height: 40,
                  width: 40,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                homeData.categoryList![idx].title.toString(),
                style: TextStyle(
                  color: Color(0xFF3F4654),
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        children: subCategoryItemList(
            homeData.categoryList![idx].id, homeData.subCategoryList, bgColor!),
      ),
    );
  }

  Widget scaffoldView(homeData, mode) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 144,
            child: ListView.builder(
              key: Key('builder ${selected.toString()}'),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              itemBuilder: (context, idx) {
                return parentTile(homeData, idx, mode.bgcolor);
              },
              itemCount: homeData.categoryList.length,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context, listen: false);
    var homeData = Provider.of<HomeDataProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: mode.bgcolor,
      key: scaffoldKey,
      body: scaffoldView(homeData, mode),
    );
  }
}
