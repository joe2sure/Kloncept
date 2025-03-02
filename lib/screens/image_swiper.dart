import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../common/apidata.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_swiper/flutter_swiper.dart';
//import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class ImageSwiper extends StatelessWidget {
  bool _visible;
  ImageSwiper(this._visible);

  Widget detailsOnImage(String? heading, String? subHeading) {
    return Positioned(
      child: Container(
        padding: EdgeInsets.only(bottom: 25.0, top: 5.0, left: 15, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                heading.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Flexible(
              child: Text(
                subHeading.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showShimmer(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 250,
        padding: EdgeInsets.only(bottom: 23.0, top: 5.0),
        margin: EdgeInsets.symmetric(horizontal: 18.0),
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
            child: Container(
              height:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 70
                      : MediaQuery.of(context).size.height / 11,
            ),
          ),
        ),
      ),
    );
  }

  Widget showImage(Orientation orientation, String? image) {
    return AspectRatio(
      aspectRatio: orientation == Orientation.portrait ? 17 / 9 : 20.2 / 6,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: APIData.sliderImages + image.toString(),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
                decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: AssetImage('assets/placeholder/slider.png'),
                fit: BoxFit.cover,
              ),
            )),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [
                    0.0,
                    0.6
                  ],
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.0),
                  ]),
            ),
          )
        ],
      ),
    );
  }

  Widget showSlider(Orientation orientation, HomeDataProvider slider) {
    return SliverToBoxAdapter(
      child: Container(
        // height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 25.0,
              offset: Offset(0.0, 20.0),
              spreadRadius: -25.0,
            )
          ],
        ),
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 10),
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              // Add any additional logic here for page change events
            },
          ),
          items: slider.sliderList!.map((item) {
            return Padding(
              padding:
                  EdgeInsets.only(bottom: 15.0, top: 5.0, left: 15, right: 15),
              child: Stack(
                children: [
                  showImage(orientation, item.image),
                  detailsOnImage(item.heading, item.subHeading),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var slider = Provider.of<HomeDataProvider>(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    return _visible == true
        ? showSlider(orientation, slider)
        : showShimmer(context);
  }
}
