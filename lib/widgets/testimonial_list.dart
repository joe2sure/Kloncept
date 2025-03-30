import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kloncept/provider/dummy/dummy_provider.dart';
import 'package:kloncept/model/dummy/dummy_model.dart';
import '../common/theme.dart' as T;

class TestimonialList extends StatefulWidget {
  final bool dataLoaded;

  TestimonialList(this.dataLoaded);

  @override
  _TestimonialListState createState() => _TestimonialListState();
}

class _TestimonialListState extends State<TestimonialList> {
  String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? translate("year_") : translate("years_")} ${translate("ago_")}";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? translate("month_") : translate("months_")} ${translate("ago_")}";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? translate("week_") : translate("weeks_")} ${translate("ago_")}";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "d" : "d"} ${translate("ago_")}";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "h" : "h"} ${translate("ago_")}";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "m" : "m"} ${translate("ago_")}";
    return "just now";
  }

  // Build carousel with dummy testimonial data
  Widget _buildCarousel(Color bgcolor, Color txtcolor, bool th, Color spcl, List<DummyTestimonial> testimonials, T.Theme mode) {
    List<Widget> list = [];
    
    for (int i = 0; i < testimonials.length; i++) {
      // Create date for each testimonial (current date minus random days)
      final updatedDate = DateTime.now().subtract(Duration(days: i * 3 + 2));
      
      list.add(
        Container(
          margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 25, top: 5),
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: bgcolor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Color(0x1c2464).withOpacity(0.30),
                  blurRadius: 15.0,
                  offset: Offset(0.0, 15.0),
                  spreadRadius: -15.0)
            ],
          ),
          child: Row(children: [
            Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                radius: 35,
                backgroundImage: testimonials[i].imageUrl == null
                    ? AssetImage("assets/placeholder/avatar.png") as ImageProvider
                    : CachedNetworkImageProvider(testimonials[i].imageUrl),
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        testimonials[i].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3F4654)),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 5.0),
                        child: Column(
                          children: [
                            Text(
                              testimonials[i].testimonial,
                              textAlign: TextAlign.justify,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                color: txtcolor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  child: Text(
                                    translate("Read_More"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                        color: mode.easternBlueColor),
                                  ),
                                  onTap: () {
                                    showPopup(
                                        context,
                                        _popupBody(testimonials[i], updatedDate),
                                        "${testimonials[i].name}");
                                  },
                                )
                              ],
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        timeAgo(updatedDate),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: th ? Color(0xffA8ABAF) : spcl),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      );
    }

    return CarouselSlider.builder(
      unlimitedMode: true,
      slideBuilder: (index) {
        return list[index];
      },
      slideIndicator: CircularSlideIndicator(
        indicatorBorderColor: Colors.lightBlue,
      ),
      itemCount: list.length,
      initialPage: 0,
      enableAutoSlider: true,
    );
  }

  Widget showShimmer() {
    return Container(
      height: 190,
      margin: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 16, top: 5),
      child: Shimmer.fromColors(
          baseColor: Color(0xFFd3d7de),
          highlightColor: Color(0xFFe2e4e9),
          child: Card(
            elevation: 0.0,
            color: Color.fromRGBO(45, 45, 45, 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          )),
    );
  }

  showPopup(BuildContext context, Widget widget, String title, {BuildContext? popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 180,
        left: 30,
        right: 30,
        bottom: 180,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Color(0xFFF44A4A),
              actions: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        try {
                          Navigator.pop(context); //close the popup
                        } catch (e) {}
                      },
                    );
                  },
                ),
              ],
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            resizeToAvoidBottomInset: false,
            body: widget,
          ),
        ),
      ),
    );
  }

  Widget _popupBody(DummyTestimonial testimonial, DateTime date) {
    return Container(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          ListTile(
            leading: Container(
              height: 70,
              child: CircleAvatar(
                radius: 35.0,
                backgroundColor: Color(0xFFF44A4A),
                backgroundImage: testimonial.imageUrl == null
                    ? AssetImage("assets/placeholder/avatar.png") as ImageProvider
                    : CachedNetworkImageProvider(testimonial.imageUrl),
              ),
            ),
            title: Text(
              testimonial.name,
              style: TextStyle(
                  color: Color(0xFF3F4654),
                  fontWeight: FontWeight.w700,
                  fontSize: 22),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Text(
                timeAgo(date),
                style: TextStyle(
                    color: Color(0xFF3F4654).withOpacity(0.7), fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
            child: Text(
              testimonial.testimonial,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF586474),
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 5.0),
            child: Text(
              "Designation: ${testimonial.designation}",
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xFF586474).withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 5.0),
            child: Row(
              children: [
                Text(
                  "Rating: ",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF586474).withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ...List.generate(
                  5,
                  (index) => Icon(
                    index < testimonial.rating.floor()
                        ? Icons.star
                        : (index == testimonial.rating.floor() && 
                           testimonial.rating % 1 > 0)
                            ? Icons.star_half
                            : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "(${testimonial.rating.toStringAsFixed(1)})",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF586474).withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var homeProvider = Provider.of<DummyHomeDataProvider>(context);
    var testimonialList = homeProvider.testimonialList;

    return SliverToBoxAdapter(
      child: widget.dataLoaded
          ? Container(
              height: 190,
              child: _buildCarousel(
                mode.tilecolor, 
                mode.testimonialTextColor,
                mode.lighttheme, 
                Color(0xffA8ABAF), 
                testimonialList, 
                mode
              ),
            )
          : showShimmer(),
    );
  }
}

// Keep the PopupLayout and PopupContent classes from the original code
class PopupLayout extends ModalRoute {
  double? top;
  double? bottom;
  double? left;
  double? right;
  Color? bgColor;
  final Widget child;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor =>
      bgColor == null ? Colors.black.withOpacity(0.5) : bgColor;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => false;

  PopupLayout(
      {Key? key,
      this.bgColor,
      required this.child,
      this.top,
      this.bottom,
      this.left,
      this.right});

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    if (top == null) this.top = 10;
    if (bottom == null) this.bottom = 20;
    if (left == null) this.left = 20;
    if (right == null) this.right = 20;

    return GestureDetector(
      onTap: () {
        // call this method here to hide soft keyboard
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Material(
        // This makes sure that text and other content follows the material style
        type: MaterialType.transparency,
        // make sure that the overlay content is not cut off
        child: SafeArea(
          bottom: true,
          child: _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: this.bottom!,
        left: this.left!,
        right: this.right!,
        top: this.top!,
      ),
      child: child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class PopupContent extends StatefulWidget {
  final Widget? content;

  PopupContent({
    Key? key,
    this.content,
  }) : super(key: key);

  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.content,
    );
  }
}



// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:kloncept/localization/language_provider.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_carousel_slider/carousel_slider.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import '../common/apidata.dart';
// import '../common/global.dart';
// import '../model/home_model.dart';
// import '../provider/home_data_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// import '../common/theme.dart' as T;
// import 'package:html_unescape/html_unescape.dart';

// // ignore: must_be_immutable
// class TestimonialList extends StatefulWidget {
//   bool _visible;

//   TestimonialList(this._visible);

//   @override
//   _TestimonialListState createState() => _TestimonialListState();
// }

// class _TestimonialListState extends State<TestimonialList> {
//   HtmlUnescape htmlUnescape = HtmlUnescape();

//   String timeAgo(DateTime d) {
//     Duration diff = DateTime.now().difference(d);
//     if (diff.inDays > 365)
//       return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? translate("year_") : translate("years_")} ${translate("ago_")}";
//     if (diff.inDays > 30)
//       return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? translate("month_") : translate("months_")} ${translate("ago_")}";
//     if (diff.inDays > 7)
//       return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? translate("week_") : translate("weeks_")} ${translate("ago_")}";
//     if (diff.inDays > 0)
//       return "${diff.inDays} ${diff.inDays == 1 ? "d" : "d"} ${translate("ago_")}";
//     if (diff.inHours > 0)
//       return "${diff.inHours} ${diff.inHours == 1 ? "h" : "h"} ${translate("ago_")}";
//     if (diff.inMinutes > 0)
//       return "${diff.inMinutes} ${diff.inMinutes == 1 ? "m" : "m"} ${translate("ago_")}";
//     return "just now";
//   }

//   // ignore: non_constant_identifier_names
//   Widget _BuildCarousel(Color bgcolor, Color txtcolor, bool th, Color spcl,
//       List<Testimonial>? testimonials, mode) {
//     List<Widget> list = [];
//     for (int i = 0; i < testimonials!.length; i++) {
//       list.add(
//         Container(
//           margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 25, top: 5),
//           padding: EdgeInsets.all(15.0),
//           decoration: BoxDecoration(
//             color: bgcolor,
//             borderRadius: BorderRadius.circular(10.0),
//             boxShadow: [
//               BoxShadow(
//                   color: Color(0x1c2464).withOpacity(0.30),
//                   blurRadius: 15.0,
//                   offset: Offset(0.0, 15.0),
//                   spreadRadius: -15.0)
//             ],
//           ),
//           child: Row(children: [
//             Align(
//               alignment: Alignment.topCenter,
//               child: CircleAvatar(
//                 radius: 35,
//                 backgroundImage: testimonials[i].image == null
//                     ? AssetImage("assets/placeholder/avatar.png")
//                         as ImageProvider
//                     : CachedNetworkImageProvider(
//                         "${APIData.testimonialImages}" +
//                             testimonials[i].image.toString()),
//               ),
//             ),
//             SizedBox(
//               width: 8.0,
//             ),
//             Expanded(
//               flex: 1,
//               child: Container(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       child: Text(
//                         htmlUnescape
//                             .convert(testimonials[i].clientName.toString()),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF3F4654)),
//                       ),
//                     ),
//                     Padding(
//                         padding: EdgeInsets.only(left: 8.0, top: 5.0),
//                         child: Column(
//                           children: [
//                             Text(
//                               htmlUnescape
//                                   .convert(testimonials[i].details.toString()),
//                               textAlign: TextAlign.justify,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontSize: 17,
//                                 color: txtcolor,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 InkWell(
//                                   child: Text(
//                                     translate("Read_More"),
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 16.0,
//                                         color: mode.easternBlueColor),
//                                   ),
//                                   onTap: () {
//                                     showPopup(
//                                         context,
//                                         _popupBody(
//                                             testimonials[i],
//                                             testimonials[i].updatedAt == null
//                                                 ? null
//                                                 : testimonials[i].updatedAt),
//                                         "${testimonials[i].clientName}");
//                                   },
//                                 )
//                               ],
//                             ),
//                           ],
//                         )),
//                     SizedBox(
//                       height: 2,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 8),
//                       child: Text(
//                         testimonials[i].updatedAt == null
//                             ? ""
//                             : timeAgo(
//                                 DateTime.parse(testimonials[i].updatedAt)),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: th ? Color(0xffA8ABAF) : spcl),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ]),
//         ),
//       );
//     }

//     return CarouselSlider.builder(
//       unlimitedMode: true,
//       slideBuilder: (index) {
//         return list[index];
//       },
//       slideIndicator: CircularSlideIndicator(
//         indicatorBorderColor: Colors.lightBlue,
//       ),
//       itemCount: list.length,
//       initialPage: 0,
//       enableAutoSlider: true,
//     );
//   }

//   Widget showShimmer() {
//     return Container(
//       height: 190,
//       margin: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 16, top: 5),
//       child: Shimmer.fromColors(
//           baseColor: Color(0xFFd3d7de),
//           highlightColor: Color(0xFFe2e4e9),
//           child: Card(
//             elevation: 0.0,
//             color: Color.fromRGBO(45, 45, 45, 1.0),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(
//                 Radius.circular(10),
//               ),
//             ),
//             clipBehavior: Clip.antiAliasWithSaveLayer,
//           )),
//     );
//   }

//   showPopup(BuildContext context, Widget widget, String title,
//       {BuildContext? popupContext}) {
//     Navigator.push(
//       context,
//       PopupLayout(
//         top: 180,
//         left: 30,
//         right: 30,
//         bottom: 180,
//         child: PopupContent(
//           content: Scaffold(
//             appBar: AppBar(
//               automaticallyImplyLeading: false,
//               backgroundColor: Color(0xFFF44A4A),
//               actions: [
//                 Builder(
//                   builder: (context) {
//                     return IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () {
//                         try {
//                           Navigator.pop(context); //close the popup
//                         } catch (e) {}
//                       },
//                     );
//                   },
//                 ),
//               ],
//               systemOverlayStyle: SystemUiOverlayStyle.dark,
//             ),
//             resizeToAvoidBottomInset: false,
//             body: widget,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _popupBody(testimonial, date) {
//     return Container(
//       child: ListView(
//         scrollDirection: Axis.vertical,
//         shrinkWrap: true,
//         physics: ClampingScrollPhysics(),
//         children: [
//           ListTile(
//             leading: Container(
//               height: 70,
//               child: CircleAvatar(
//                 radius: 35.0,
//                 backgroundColor: Color(0xFFF44A4A),
//                 backgroundImage: testimonial.image == null
//                     ? AssetImage("assets/placeholder/avatar.png")
//                         as ImageProvider
//                     : CachedNetworkImageProvider(
//                         "${APIData.testimonialImages}" + testimonial.image),
//               ),
//             ),
//             title: Text(
//               htmlUnescape.convert(testimonial.clientName),
//               style: TextStyle(
//                   color: Color(0xFF3F4654),
//                   fontWeight: FontWeight.w700,
//                   fontSize: 22),
//             ),
//             subtitle: Padding(
//               padding: EdgeInsets.only(left: 4.0),
//               child: Text(
//                 date == null ? "" : timeAgo(DateTime.parse(date)),
//                 style: TextStyle(
//                     color: Color(0xFF3F4654).withOpacity(0.7), fontSize: 14),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
//             child: html1(testimonial.details, Color(0xFF586474), 16.0),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget html1(htmlContent, Color clr, double size) {
//     return Text(
//       htmlUnescape.convert(htmlContent),
//       textAlign: TextAlign.justify,
//       style: TextStyle(
//         fontSize: size,
//         color: clr,
//         fontWeight: FontWeight.w500,
//         height: 1.5,
//       ),
//     );
//   }

//   late LanguageProvider languageProvider;

//   @override
//   Widget build(BuildContext context) {
//     T.Theme mode = Provider.of<T.Theme>(context);
//     var testimonialList =
//         Provider.of<HomeDataProvider>(context).testimonialList;

//     languageProvider = Provider.of<LanguageProvider>(context, listen: false);

//     return SliverToBoxAdapter(
//       child: widget._visible == true
//           ? Container(
//               height: 190,
//               child: _BuildCarousel(mode.tilecolor, mode.testimonialTextColor,
//                   mode.lighttheme, spcl, testimonialList, mode),
//             )
//           : showShimmer(),
//     );
//   }
// }

// class PopupLayout extends ModalRoute {
//   double? top;
//   double? bottom;
//   double? left;
//   double? right;
//   Color? bgColor;
//   final Widget child;

//   @override
//   Duration get transitionDuration => Duration(milliseconds: 300);

//   @override
//   bool get opaque => false;

//   @override
//   bool get barrierDismissible => false;

//   @override
//   Color? get barrierColor =>
//       bgColor == null ? Colors.black.withOpacity(0.5) : bgColor;

//   @override
//   String? get barrierLabel => null;

//   @override
//   bool get maintainState => false;

//   PopupLayout(
//       {Key? key,
//       this.bgColor,
//       required this.child,
//       this.top,
//       this.bottom,
//       this.left,
//       this.right});

//   @override
//   Widget buildPage(
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//   ) {
//     if (top == null) this.top = 10;
//     if (bottom == null) this.bottom = 20;
//     if (left == null) this.left = 20;
//     if (right == null) this.right = 20;

//     return GestureDetector(
//       onTap: () {
//         // call this method here to hide soft keyboard
//         SystemChannels.textInput.invokeMethod('TextInput.hide');
//       },
//       child: Material(
//         // This makes sure that text and other content follows the material style
//         type: MaterialType.transparency,
//         // make sure that the overlay content is not cut off
//         child: SafeArea(
//           bottom: true,
//           child: _buildOverlayContent(context),
//         ),
//       ),
//     );
//   }

//   Widget _buildOverlayContent(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(
//         bottom: this.bottom!,
//         left: this.left!,
//         right: this.right!,
//         top: this.top!,
//       ),
//       child: child,
//     );
//   }

//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     // You can add your own animations for the overlay content
//     return FadeTransition(
//       opacity: animation,
//       child: ScaleTransition(
//         scale: animation,
//         child: child,
//       ),
//     );
//   }
// }

// class PopupContent extends StatefulWidget {
//   final Widget? content;

//   PopupContent({
//     Key? key,
//     this.content,
//   }) : super(key: key);

//   _PopupContentState createState() => _PopupContentState();
// }

// class _PopupContentState extends State<PopupContent> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: widget.content,
//     );
//   }
// }
