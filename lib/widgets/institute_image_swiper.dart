import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kloncept/provider/dummy/dummy_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../screens/institute_profile_screen.dart';

// ignore: must_be_immutable
class InstituteImageSwiper extends StatelessWidget {
  bool _visible;
  InstituteImageSwiper(this._visible);

  Widget detailsOnImage(String? heading, String? subHeading) {
    return Positioned(
      child: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  heading.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  subHeading ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
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
      aspectRatio: orientation == Orientation.portrait ? 5 / 2 : 15.5 / 3,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: image.toString(),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
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
              ),
            ),
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

  Widget showSlider(Orientation orientation, DummyInstituteProvider slider) {
    // Add null checks
    if (slider.instituteModel == null ||
        slider.instituteModel!.institutes.isEmpty) {
      return SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [/*...*/],
        ),
        child: CarouselSlider(
          options: CarouselOptions(/*...*/),
          items: slider.instituteModel!.institutes.map((institute) {
            return Padding(
              padding:
                  EdgeInsets.only(bottom: 5.0, top: 5.0, left: 18, right: 18),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    // Explicitly cast context as BuildContext
                    context as BuildContext,
                    MaterialPageRoute(
                      builder: (context) => InstituteProfileScreen(
                        instituteId: institute.id,
                        slug: institute.name,
                      ),
                    ),
                  );
                },
                child: Container(
                  child: Stack(
                    children: [
                      showImage(orientation, institute.imageUrl),
                      detailsOnImage(institute.name, institute.description),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Change from InstituteProvider to DummyInstituteProvider
    var slider = Provider.of<DummyInstituteProvider>(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    return _visible == true
        ? showSlider(orientation, slider)
        : showShimmer(context);
  }
}


// In institute_image_swiper.dart, modify showSlider:
// Widget showSlider(Orientation orientation, DummyInstituteProvider slider) {
//   // Add null checks
//   if (slider.instituteModel == null || 
//       slider.instituteModel!.institutes.isEmpty) {
//     return SliverToBoxAdapter(child: SizedBox.shrink());
//   }

//   return SliverToBoxAdapter(
//     child: Container(
//       height: 160,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15.0),
//         boxShadow: [/*...*/],
//       ),
//       child: CarouselSlider(
//         options: CarouselOptions(/*...*/),
//         items: slider.instituteModel!.institutes.map((institute) {
//           return Padding(
//             padding: EdgeInsets.only(bottom: 5.0, top: 5.0, left: 18, right: 18),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => InstituteProfileScreen(
//                       instituteId: institute.id ?? 0,
//                       slug: institute.slug ?? '',
//                     ),
//                   ),
//                 );
//               },
//               child: Container(
//                 child: Stack(
//                   children: [
//                     showImage(orientation, institute.image ?? ''),
//                     detailsOnImage(institute.title ?? 'No title', institute.skill),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     ),
//   );
// }

  // @override
  // Widget build(BuildContext context) {
  //   var slider = Provider.of<InstituteProvider>(context);
  //   Orientation orientation = MediaQuery.of(context).orientation;
  //   return _visible == true
  //       ? showSlider(orientation, slider)
  //       : showShimmer(context);
  // }


  // Widget showSlider(Orientation orientation, InstituteProvider slider) {
  //   return SliverToBoxAdapter(
  //     child: Container(
  //         height: 160,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(15.0),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Color(0x1c2464).withOpacity(0.30),
  //               blurRadius: 25.0,
  //               offset: Offset(0.0, 20.0),
  //               spreadRadius: -25.0,
  //             )
  //           ],
  //         ),
  //         child: CarouselSlider(
  //           options: CarouselOptions(
  //             scrollDirection: Axis.horizontal,
  //             autoPlay: true,
  //             autoPlayInterval: Duration(milliseconds: 5000),
  //             enlargeCenterPage: false,
  //             aspectRatio: 16 / 9,
  //             viewportFraction: 1.0,
  //             initialPage: 0,
  //             onPageChanged: (index, reason) {
  //               // Add any additional logic here when the page changes
  //             },
  //           ),
  //           items: List.generate(slider.instituteModel!.institute!.length,
  //               (index) {
  //             return Padding(
  //               padding:
  //                   EdgeInsets.only(bottom: 5.0, top: 5.0, left: 18, right: 18),
  //               child: GestureDetector(
  //                 onTap: () {
  //                   Navigator.push(
  //                     context as BuildContext,
  //                     MaterialPageRoute(
  //                       builder: (context) => InstituteProfileScreen(
  //                         instituteId: slider
  //                             .instituteModel!.institute![index].id as int,
  //                         slug: slider.instituteModel!.institute![index].slug,
  //                       ),
  //                     ),
  //                   );
  //                 },
  //                 child: Container(
  //                   child: Stack(
  //                     children: [
  //                       showImage(orientation,
  //                           slider.instituteModel!.institute![index].image),
  //                       detailsOnImage(
  //                           slider.instituteModel!.institute![index].title,
  //                           slider.instituteModel!.institute![index].skill),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }),
  //         )),
  //   );
  // }
