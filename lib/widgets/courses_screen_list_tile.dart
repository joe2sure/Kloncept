import 'package:cached_network_image/cached_network_image.dart';
import 'package:kloncept/common/global.dart';
import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../model/course.dart';
import '../provider/courses_provider.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpCoursesListItem extends StatelessWidget {
  final Color txtColor;
  final Course courseDetail;
  final bool isPurchased;

  ExpCoursesListItem(this.courseDetail, this.isPurchased, this.txtColor, {required List children});

  Widget showImage(String? img) {
    return Expanded(
      flex: 1,
      child: Container(
        child: new ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              topLeft: Radius.circular(10.0)),
          child: img == "null" || img == null
              ? Image.asset(
                  "assets/placeholder/exp_course_placeholder.png",
                  height: 140.0,
                  width: 220.0,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: 140,
                  imageUrl: "${APIData.courseImages}$img",
                  placeholder: (context, x) => Image.asset(
                      "assets/placeholder/exp_course_placeholder.png"),
                ),
        ),
      ),
    );
  }

  Widget showDetails(BuildContext context, String category) {
    double? progress;
    if (isPurchased) {
      // progress =
      //     Provider.of<CoursesProvider>(context).getProgress(courseDetail.id);
    }
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Text(
            courseDetail.title.toString(),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: 18.0,
              color: txtColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            courseDetail.shortDetail.toString(),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 16.0,
              color: txtColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15.0),
          if (isPurchased)
            SizedBox.shrink()
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                courseDetail.duration == null
                    ? Text(
                        "Full Time Access",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Color(0xFF3f4654),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600),
                      )
                    : Text(
                        courseDetail.durationType == "m"
                            ? courseDetail.duration.toString() + ' Months'
                            : courseDetail.duration.toString() + ' Days',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Color(0xFF3f4654),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600),
                      ),
                Text(
                  courseDetail.type == "0"
                      ? "Free"
                      : courseDetail.discountPrice != null
                          ? "${currencySymbol(selectedCurrency)} ${(num.tryParse(courseDetail.discountPrice.toString())! * selectedCurrencyRate)}"
                          : "${currencySymbol(selectedCurrency)} ${(num.tryParse(courseDetail.price.toString())! * selectedCurrencyRate)}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Color(0xFF3f4654),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          SizedBox(
            height: 8.0,
          ),
          if (isPurchased)
            cusprogressbar(MediaQuery.of(context).size.width - 180, progress!)
          else
            SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String category = Provider.of<HomeDataProvider>(context)
        .getCategoryName(courseDetail.categoryId);

    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Image Container
          showImage(courseDetail.previewImage),
          SizedBox(width: 10.0),
          showDetails(context, category),
          SizedBox(width: 15.0),
        ],
      ),
    );
  }
}
