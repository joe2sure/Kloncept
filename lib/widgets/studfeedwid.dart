import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:kloncept/common/global.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Widgets/rating_star.dart';
import '../common/apidata.dart';
import '../provider/full_course_detail.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Studentfeedback extends StatelessWidget {

  String tomonth(String x) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sept",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[int.tryParse(x)! - 1];
  }

  int checkDatatype(dynamic x) {
    if (x is int)
      return 0;
    else
      return 1;
  }

  String getRating(Review data) {
    double ans = 0.0;
    bool calcAsInt = true;
    calcAsInt = checkDatatype(data.learn) == 0 ? true : false;

    if (!calcAsInt)
      ans += (int.tryParse(data.price)! +
                  int.parse(data.value) +
                  int.parse(data.learn))
              .toDouble() /
          3.0;
    else
      ans += (int.parse(data.price) +
              int.parse(data.value) +
              int.parse(data.learn)) /
          3.0;

    if (ans == 0.0) return 0.toString();
    return ans.toString();
  }

  String convertDate(String x) {
    String ans = x.substring(0, 4);
    ans = x.substring(8, 10) + " " + tomonth(x.substring(5, 7)) + " " + ans;
    return ans;
  }

  final Review? review;
  final int? courseId;

  Studentfeedback(this.review, this.courseId);

  Widget showImage() {
    return CircleAvatar(
      radius: 30,
      backgroundImage: review!.userimage == null
          ? AssetImage(
              "assets/placeholder/avatar.png",
            ) as ImageProvider
          : CachedNetworkImageProvider(APIData.userImage + review!.userimage,
            ),
    );
  }

  Widget showName() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${review!.fname.toString()} ${review!.lname}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                children: [
                  StarRating(
                    rating: double.parse(review!.value),
                    size: 14.0,
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  String numberToKMB({dynamic value}) {
    if (value > 999 && value < 99999) {
      return "${(value / 1000).toStringAsFixed(1)}K";
    } else if (value >= 99999 && value < 999999) {
      return "${(value / 1000).toStringAsFixed(0)}K";
    } else if (value >= 999999 && value < 999999999) {
      return "${(value / 1000000).toStringAsFixed(1)}M";
    } else if (value >= 999999999) {
      return "${(value / 1000000000).toStringAsFixed(1)}B";
    } else {
      return value.toString();
    }
  }

  likeDislike() {
    if (like == "1") {
      print("Liked!");
    } else if (dislike == "1") {
      print("Disliked!");
    }
    addLikeDislike();
  }

  Future<void> addLikeDislike() async {
    Dio dio = new Dio();
    String url = APIData.likeDislikeReview +
        review!.id.toString() +
        "?secret=" +
        APIData.secretKey;

    var body = FormData.fromMap({
      "review_like": int.tryParse(like),
      "review_dislike": int.tryParse(dislike),
      "course_id": courseId,
    });

    Response? response;
    try {
      response = await dio.post(
        url,
        data: body,
        options: Options(
          method: 'POST',
          headers: {
            HttpHeaders.authorizationHeader: "Bearer " + authToken,
            HttpHeaders.acceptHeader: "Application/json",
          },
        ),
      );
    } catch (e) {
      print('Exception : $e');
      Fluttertoast.showToast(
          msg: translate("Failed_"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    if (response!.statusCode == 200) {
      Fluttertoast.showToast(
          msg: translate("Review_Submitted_Successfully"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: translate("Failed_"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  String like = "0", dislike = "0";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      width: MediaQuery.of(context).size.width / 1.2,
      child: Column(
        children: [
          Row(
            children: [
              showImage(),
              SizedBox(
                width: 10.0,
              ),
              showName(),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 12.0),
            child: Text(
              review!.reviews != null ? review!.reviews.toString() : "",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    like = "1";
                    dislike = "0";
                    likeDislike();
                  },
                  icon: Icon(
                    FontAwesomeIcons.thumbsUp,
                    size: 18.0,
                  ),
                ),
                Text(
                  numberToKMB(value: review!.likeCount),
                ),
                SizedBox(
                  width: 10.0,
                ),
                IconButton(
                  onPressed: () {
                    like = "0";
                    dislike = "1";
                    likeDislike();
                  },
                  icon: Icon(
                    FontAwesomeIcons.thumbsDown,
                    size: 18.0,
                  ),
                ),
                Text(
                  numberToKMB(value: review!.dislikeCount),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
