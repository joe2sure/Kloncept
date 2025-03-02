import 'package:cached_network_image/cached_network_image.dart';
import 'package:kloncept/common/global.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../common/apidata.dart';
import '../model/bundle_courses_model.dart';
import '../provider/courses_provider.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import '../common/theme.dart' as T;
import 'package:provider/provider.dart';

class BundleCourseItem extends StatelessWidget {
  final BundleCourses bundleCoursesDetail;

  BundleCourseItem(this.bundleCoursesDetail);

  Widget showImage() {
    return bundleCoursesDetail.previewImage == null
        ? Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            image: DecorationImage(
              image: AssetImage("assets/placeholder/bundle_place_holder.png"),
              fit: BoxFit.cover,
            ),
          ))
        : CachedNetworkImage(
            imageUrl:
                "${APIData.bundleImages}${bundleCoursesDetail.previewImage}",
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
                decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              image: DecorationImage(
                image: AssetImage("assets/placeholder/bundle_place_holder.png"),
                fit: BoxFit.cover,
              ),
            )),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image:
                      AssetImage("assets/placeholder/bundle_place_holder.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
  }

  Widget tileDetails(BuildContext context, T.Theme mode, String? category,
      String? currency, bool purchased) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0.0, 18.0, 0.0),
      width: MediaQuery.of(context).orientation == Orientation.landscape
          ? 260
          : MediaQuery.of(context).size.width / 1.6,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 15.0,
              offset: Offset(-13.0, 20.5),
              spreadRadius: -15.0)
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          child: Column(
            children: [
              Container(
                height: 100,
                child: showImage(),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        category != "null"
                            ? Text(
                                category.toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()..shader = linearGradient,
                                ),
                              )
                            : SizedBox.shrink(),
                        // ignore: unrelated_type_equality_checks
                        bundleCoursesDetail.type != 1 &&
                                bundleCoursesDetail.type != "1"
                            ? Column(
                                children: [
                                  Text(translate("Free_"),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0,
                                          color: Colors.red))
                                ],
                              )
                            : Column(
                                children: [
                                  (bundleCoursesDetail.discountPrice != null &&
                                          !purchased)
                                      ? Text(
                                          "${currencySymbol(selectedCurrency)} ${(num.tryParse(bundleCoursesDetail.discountPrice.toString())! * selectedCurrencyRate)}",
                                          style: TextStyle(
                                              color: mode.txtcolor,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : (bundleCoursesDetail.price != null &&
                                              !purchased)
                                          ? Text(
                                              "${currencySymbol(selectedCurrency)} ${(num.tryParse(bundleCoursesDetail.price.toString())! * selectedCurrencyRate)}",
                                              style: TextStyle(
                                                  color: mode.txtcolor,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(translate("Free_"),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18.0,
                                                  color: Colors.red))
                                ],
                              ),
                      ],
                    ),
                    // ignore: unrelated_type_equality_checks
                    bundleCoursesDetail.type != 1 &&
                            bundleCoursesDetail.type != "1"
                        ? SizedBox.shrink()
                        : Align(
                            alignment: Alignment.topRight,
                            child: (bundleCoursesDetail.price != null &&
                                    !purchased)
                                ? (bundleCoursesDetail.discountPrice != null &&
                                        !purchased)
                                    ? Text(
                                        "${currencySymbol(selectedCurrency)} ${(num.tryParse(bundleCoursesDetail.price.toString())! * selectedCurrencyRate)}",
                                        style: TextStyle(
                                            decoration: bundleCoursesDetail
                                                        .discountPrice !=
                                                    null
                                                ? TextDecoration.lineThrough
                                                : null,
                                            fontSize: bundleCoursesDetail
                                                        .discountPrice !=
                                                    null
                                                ? 12.0
                                                : 18.0,
                                            color: bundleCoursesDetail
                                                        .discountPrice !=
                                                    null
                                                ? Colors.grey
                                                : mode.txtcolor,
                                            fontWeight: bundleCoursesDetail
                                                        .discountPrice !=
                                                    null
                                                ? null
                                                : FontWeight.bold),
                                      )
                                    : SizedBox.shrink()
                                : SizedBox.shrink()),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            bundleCoursesDetail.title.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: mode.txtcolor,
                                fontWeight: FontWeight.w700,
                                fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "${bundleCoursesDetail.detail}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              color: mode.shortTextColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          onTap: () {
            Navigator.of(context).pushNamed("/bundleCourseDetail",
                arguments: bundleCoursesDetail);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool purchased = Provider.of<CoursesProvider>(context)
        .isBundlePurchased(bundleCoursesDetail.id);
    print("object: ${bundleCoursesDetail.courseId![0]}");
    // String? category =
    //     Provider.of<HomeDataProvider>(context).getCategoryName("4");
    dynamic category = Provider.of<HomeDataProvider>(context)
        .getCategoryName(bundleCoursesDetail.courseId![0]);

    dynamic currency =
        Provider.of<HomeDataProvider>(context).homeModel!.currency!.currency;
    print("object22: $category");
    T.Theme mode = Provider.of<T.Theme>(context);
    return
        // Container(
        //   child: Text("ss"),
        // );
        tileDetails(context, mode, category, currency, purchased);
  }
}

final Shader linearGradient = LinearGradient(
  colors: <Color>[Color(0xff790055), Color(0xffF81D46), Color(0xffFA4E62)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
