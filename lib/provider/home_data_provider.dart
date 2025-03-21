
import 'package:flutter/material.dart';
import 'package:kloncept/common/dummy_data.dart';
import 'package:kloncept/model/home_model.dart';
import 'package:kloncept/model/zoom_meeting.dart';

class HomeDataProvider with ChangeNotifier {
  HomeModel? homeModel;
  List<SliderFact>? sliderFactList = [];
  List<MySlider>? sliderList = [];
  List<Testimonial>? testimonialList = [];
  List<Trusted>? trustedList = [];
  List<MyCategory>? featuredCategoryList = [];
  List<SubCategory>? subCategoryList = [];
  List<MyCategory>? categoryList = [];
  List<ChildCategory>? childCategoryList = [];
  List<ZoomMeeting>? zoomMeetingList = [];
  Map categoryMap = {};


Future<HomeModel?> getHomeDetails(BuildContext context) async {
  try {
    print("Loading dummy data...");
    homeModel = HomeModel.fromJson(DummyData.homeData);
    print("HomeModel loaded successfully: ${homeModel != null}");
    generateLists(homeModel, context);
    notifyListeners();
    return homeModel;
  } catch (e) {
    print("Error in getHomeDetails: $e");
    throw e;
  }
}

  void generateLists(HomeModel? homeData, BuildContext context) {
    generateSliderFactList(homeData!.sliderfacts);
    generateSliderList(homeData.slider);
    generateTestimonialList(homeData);
    generateTrustedList(homeData);
    generateFeaturedCategoryList(homeData);
    generateCategoryList(homeData);
    generateSubCateList(homeData);
    generateChildCateList(homeData);
    generateMeetingList(homeData.zoomMeeting);
  }

  void generateSliderFactList(List<SliderFact>? sliderfacts) {
    sliderFactList = List.generate(
      sliderfacts!.length,
      (index) => SliderFact(
        id: sliderfacts[index].id,
        icon: sliderfacts[index].icon,
        heading: sliderfacts[index].heading,
        subHeading: sliderfacts[index].subHeading,
        status: sliderfacts[index].status,
        image: sliderfacts[index].image,
        detail: sliderfacts[index].detail,
        createdAt: sliderfacts[index].createdAt,
        updatedAt: sliderfacts[index].updatedAt,
      ),
    );
  }

  void generateSliderList(List<MySlider>? slider) {
    sliderList = List.generate(
      slider!.length,
      (index) => MySlider(
        id: slider[index].id,
        heading: slider[index].heading,
        subHeading: slider[index].subHeading,
        searchText: slider[index].searchText,
        detail: slider[index].detail,
        status: slider[index].status,
        image: slider[index].image,
        position: slider[index].position,
        createdAt: slider[index].createdAt,
        updatedAt: slider[index].updatedAt,
      ),
    );
  }

  void generateTestimonialList(HomeModel? homeModels) {
    testimonialList = List.generate(
      homeModels!.testimonial!.length,
      (index) => Testimonial(
        id: homeModels.testimonial![index].id,
        clientName: homeModels.testimonial![index].clientName,
        details: homeModels.testimonial![index].details,
        status: homeModels.testimonial![index].status,
        image: homeModels.testimonial![index].image,
        createdAt: homeModels.testimonial![index].createdAt,
        updatedAt: homeModels.testimonial![index].updatedAt,
      ),
    );
    testimonialList!.removeWhere((element) => element.status == "0");
  }

  void generateTrustedList(HomeModel? homeModels) {
    trustedList = List.generate(
      homeModels!.trusted!.length,
      (index) => Trusted(
        id: homeModels.trusted![index].id,
        url: homeModels.trusted![index].url,
        image: homeModels.trusted![index].image,
        status: homeModels.trusted![index].status,
        createdAt: homeModels.trusted![index].createdAt,
        updatedAt: homeModels.trusted![index].updatedAt,
      ),
    );
  }

  void generateFeaturedCategoryList(HomeModel? homeModels) {
    featuredCategoryList = List.generate(
      homeModels!.featuredCate!.length,
      (index) => MyCategory(
        id: homeModels.featuredCate![index].id,
        title: homeModels.featuredCate![index].title,
        icon: homeModels.featuredCate![index].icon,
        slug: homeModels.featuredCate![index].slug,
        featured: homeModels.featuredCate![index].featured,
        status: homeModels.featuredCate![index].status,
        position: homeModels.featuredCate![index].position,
        createdAt: homeModels.featuredCate![index].createdAt,
        updatedAt: homeModels.featuredCate![index].updatedAt,
        catImage: homeModels.featuredCate![index].catImage,
      ),
    );
    featuredCategoryList!.removeWhere((element) => element.status == "0");
  }

  void generateCategoryList(HomeModel? homeModels) {
    categoryList = List.generate(
      homeModels!.category!.length,
      (index) => MyCategory(
        id: homeModels.category![index].id,
        title: homeModels.category![index].title,
        icon: homeModels.category![index].icon,
        slug: homeModels.category![index].slug,
        featured: homeModels.category![index].featured,
        status: homeModels.category![index].status,
        position: homeModels.category![index].position,
        createdAt: homeModels.category![index].createdAt,
        updatedAt: homeModels.category![index].updatedAt,
        catImage: homeModels.category![index].catImage,
      ),
    );
    categoryList!.removeWhere((element) => element.status == "0");
  }

  void generateSubCateList(HomeModel? homeModels) {
    subCategoryList = List.generate(
      homeModels!.subcategory!.length,
      (index) => SubCategory(
        id: homeModels.subcategory![index].id,
        categoryId: homeModels.subcategory![index].categoryId,
        title: homeModels.subcategory![index].title,
        icon: homeModels.subcategory![index].icon,
        slug: homeModels.subcategory![index].slug,
        status: homeModels.subcategory![index].status,
        createdAt: homeModels.subcategory![index].createdAt,
        updatedAt: homeModels.subcategory![index].updatedAt,
      ),
    );
    subCategoryList!.removeWhere((element) => element.status == "0");
  }

  void generateChildCateList(HomeModel? homeModels) {
    childCategoryList = List.generate(
      homeModels!.childcategory!.length,
      (index) => ChildCategory(
        id: homeModels.childcategory![index].id,
        categoryId: homeModels.childcategory![index].categoryId,
        subcategoryId: homeModels.childcategory![index].subcategoryId,
        title: homeModels.childcategory![index].title,
        icon: homeModels.childcategory![index].icon,
        slug: homeModels.childcategory![index].slug,
        status: homeModels.childcategory![index].status,
        createdAt: homeModels.childcategory![index].createdAt,
        updatedAt: homeModels.childcategory![index].updatedAt,
      ),
    );
    childCategoryList!.removeWhere((element) => element.status == "0");
  }

  void generateMeetingList(List<ZoomMeeting>? zoomMeeting) {
    zoomMeetingList = List.generate(
      zoomMeeting!.length,
      (index) => ZoomMeeting(
        id: zoomMeeting[index].id,
        courseId: zoomMeeting[index].courseId,
        meetingId: zoomMeeting[index].meetingId,
        meetingTitle: zoomMeeting[index].meetingTitle,
        startTime: zoomMeeting[index].startTime,
        zoomUrl: zoomMeeting[index].zoomUrl,
        userId: zoomMeeting[index].userId,
        agenda: zoomMeeting[index].agenda,
        createdAt: zoomMeeting[index].createdAt,
        updatedAt: zoomMeeting[index].updatedAt,
        type: zoomMeeting[index].type,
        linkBy: zoomMeeting[index].linkBy,
        ownerId: zoomMeeting[index].ownerId,
        image: zoomMeeting[index].image,
      ),
    );
  }

  String getCategoryName(dynamic id) {
    if (id == null) {
      return '';
    }
    if (categoryMap[int.tryParse(id)] != null) {
      return categoryMap[int.tryParse(id)];
    }
    return "null";
  }

  String? getSubCategoryName(String? id) {
    String? subCategoryName;
    subCategoryList!.forEach((subCategory) {
      if (subCategory.id.toString() == id) {
        subCategoryName = subCategory.title.toString();
      }
    });
    return subCategoryName;
  }
}


// import 'dart:convert';
// import 'dart:developer';
// import 'package:kloncept/model/zoom_meeting.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../common/apidata.dart';
// import '../model/course.dart';
// import '../model/home_model.dart';
// import 'package:http/http.dart' as http;
// import 'courses_provider.dart';

// class HomeDataProvider with ChangeNotifier {
//   HomeModel? homeModel;
//   List<SliderFact>? sliderFactList = [];
//   List<MySlider>? sliderList = [];
//   List<Testimonial>? testimonialList = [];
//   List<Trusted>? trustedList = [];
//   List<MyCategory>? featuredCategoryList = [];
//   List<SubCategory>? subCategoryList = [];
//   List<MyCategory>? categoryList = [];
//   List<ChildCategory>? childCategoryList = [];
//   List<ZoomMeeting>? zoomMeetingList = [];
//   Map categoryMap = {};

//   void generateLists(HomeModel? homeData, BuildContext context) {
//     CoursesProvider? courses =
//         Provider.of<CoursesProvider>(context, listen: false);
//     List<Course>? allCourses = courses.allCourses;

//     generateSliderFactList(homeData!.sliderfacts);
//     generateSliderList(homeData.slider);
//     generateTestimonialList(homeData);
//     generateTrustedList(homeData);
//     generateFeaturedCategoryList(homeData, allCourses);
//     generateCategoryList(homeData, allCourses);
//     generateSubCateList(homeData, allCourses);
//     generateChildCateList(homeData, allCourses);
//     generateMeetingList(homeData.zoomMeeting);
//   }

//   Future<HomeModel?> getHomeDetails(context) async {
//     String url = "${APIData.home}${APIData.secretKey}";
//     print(url);
//     http.Response res = await http.get(Uri.parse(url));
//     log("Home API Status Code :-> ${res.statusCode}");
//     log("Home API Response :-> ${res.body}");
//     if (res.statusCode == 200) {
//       homeModel = HomeModel.fromJson(json.decode(res.body));
//       generateLists(homeModel, context);
//       for (int i = 0; i < homeModel!.category!.length; i++) {
//         categoryMap[homeModel!.category![i].id] = homeModel!.category![i].title;
//       }
//     } else {
//       throw "Can't get home data";
//     }
//     notifyListeners();
//     return homeModel;
//   }

//   void generateMeetingList(List<ZoomMeeting>? zoomMeeting) {
//     zoomMeetingList = List.generate(
//       zoomMeeting!.length,
//       (index) => ZoomMeeting(
//         id: zoomMeeting[index].id,
//         courseId: zoomMeeting[index].courseId,
//         meetingId: zoomMeeting[index].meetingId,
//         meetingTitle: zoomMeeting[index].meetingTitle,
//         startTime: zoomMeeting[index].startTime,
//         zoomUrl: zoomMeeting[index].zoomUrl,
//         userId: zoomMeeting[index].userId,
//         agenda: zoomMeeting[index].agenda,
//         createdAt: zoomMeeting[index].createdAt,
//         updatedAt: zoomMeeting[index].updatedAt,
//         type: zoomMeeting[index].type,
//         linkBy: zoomMeeting[index].linkBy,
//         ownerId: zoomMeeting[index].ownerId,
//         image: zoomMeeting[index].image,
//       ),
//     );
//   }

//   void generateSliderFactList(List<SliderFact>? sliderfacts) {
//     sliderFactList = List.generate(
//       sliderfacts!.length,
//       (index) => SliderFact(
//         id: sliderfacts[index].id,
//         icon: sliderfacts[index].icon,
//         heading: sliderfacts[index].heading,
//         subHeading: sliderfacts[index].subHeading,
//         createdAt: sliderfacts[index].createdAt,
//         updatedAt: sliderfacts[index].updatedAt,
//       ),
//     );
//   }

//   void generateSliderList(List<MySlider>? slider) {
//     sliderList = List.generate(
//       slider == null ? 0 : slider.length,
//       (index) {
//         return MySlider(
//           id: slider![index].id,
//           image: slider[index].image,
//           heading: slider[index].heading,
//           subHeading: slider[index].subHeading,
//           detail: slider[index].detail,
//           searchText: slider[index].searchText,
//           position: slider[index].position,
//           status: slider[index].status,
//           createdAt: slider[index].createdAt,
//           updatedAt: slider[index].updatedAt,
//         );
//       },
//     );
//   }

//   void generateTestimonialList(HomeModel? homeModels) {
//     testimonialList = List.generate(
//       homeModels!.testimonial!.length,
//       (index) => Testimonial(
//         id: homeModels.testimonial![index].id,
//         clientName: homeModels.testimonial![index].clientName,
//         image: homeModels.testimonial![index].image,
//         status: homeModels.testimonial![index].status,
//         details: homeModels.testimonial![index].details,
//         createdAt: homeModels.testimonial![index].createdAt,
//         updatedAt: homeModels.testimonial![index].updatedAt,
//       ),
//     );
//     testimonialList!.removeWhere((element) => element.status == "0");
//   }

//   void generateTrustedList(HomeModel? homeModels) {
//     trustedList = List.generate(
//       homeModels!.trusted!.length,
//       (index) => Trusted(
//         id: homeModels.trusted![index].id,
//         url: homeModels.trusted![index].url,
//         image: homeModels.trusted![index].image,
//         status: homeModels.trusted![index].status,
//         createdAt: homeModels.trusted![index].createdAt,
//         updatedAt: homeModels.trusted![index].updatedAt,
//       ),
//     );
//   }

//   void generateFeaturedCategoryList(
//       HomeModel? homeModels, List<Course>? allCourses) {
//     featuredCategoryList = List.generate(
//       homeModels!.featuredCate!.length,
//       (index) => MyCategory(
//         id: homeModels.featuredCate![index].id,
//         slug: homeModels.featuredCate![index].slug,
//         icon: homeModels.featuredCate![index].icon,
//         title: homeModels.featuredCate![index].title,
//         status: homeModels.featuredCate![index].status,
//         featured: homeModels.featuredCate![index].featured,
//         position: homeModels.featuredCate![index].position,
//         updatedAt: homeModels.featuredCate![index].updatedAt,
//         createdAt: homeModels.featuredCate![index].createdAt,
//         catImage: homeModels.featuredCate![index].catImage,
//       ),
//     );
//     featuredCategoryList!.removeWhere((element) => element.status == "0");

//     List<int>? removeIds = [];

//     featuredCategoryList!.forEach((featuredCategory) {
//       bool isIdFound = false;
//       allCourses!.forEach((course) {
//         if (featuredCategory.id.toString() == course.categoryId) {
//           isIdFound = true;
//         }
//       });
//       if (!isIdFound) {
//         removeIds.add(featuredCategory.id as int);
//       }
//     });

//     if (removeIds.isNotEmpty) {
//       removeIds.forEach((id) {
//         featuredCategoryList!.removeWhere((element) => element.id == id);
//       });
//     }
//   }

//   void generateCategoryList(HomeModel? homeModels, List<Course>? allCourses) {
//     categoryList = List.generate(
//       homeModels!.category!.length,
//       (index) => MyCategory(
//         id: homeModels.category![index].id,
//         title: homeModels.category![index].title,
//         icon: homeModels.category![index].icon,
//         slug: homeModels.category![index].slug,
//         featured: homeModels.category![index].featured,
//         status: homeModels.category![index].status,
//         position: homeModels.category![index].position,
//         createdAt: homeModels.category![index].createdAt,
//         updatedAt: homeModels.category![index].updatedAt,
//         catImage: homeModels.category![index].catImage,
//       ),
//     );
//     categoryList!.removeWhere((element) => element.status == "0");

//     List<int> removeIds = [];

//     categoryList!.forEach((category) {
//       bool isIdFound = false;
//       allCourses!.forEach((course) {
//         if (category.id.toString() == course.categoryId) {
//           isIdFound = true;
//         }
//       });
//       if (!isIdFound) {
//         removeIds.add(category.id as int);
//       }
//     });

//     if (removeIds.isNotEmpty) {
//       removeIds.forEach((id) {
//         categoryList!.removeWhere((element) => element.id == id);
//       });
//     }
//   }

//   void generateSubCateList(HomeModel? homeModels, List<Course>? allCourses) {
//     subCategoryList = List.generate(
//       homeModels!.subcategory!.length,
//       (index) => SubCategory(
//         id: homeModels.subcategory![index].id,
//         icon: homeModels.subcategory![index].icon,
//         categoryId: homeModels.subcategory![index].categoryId,
//         status: homeModels.subcategory![index].status,
//         slug: homeModels.subcategory![index].slug,
//         title: homeModels.subcategory![index].title,
//         createdAt: homeModels.subcategory![index].createdAt,
//         updatedAt: homeModels.subcategory![index].updatedAt,
//       ),
//     );
//     subCategoryList!.removeWhere((element) => element.status == "0");

//     List<int> removeIds = [];

//     subCategoryList!.forEach((subCategory) {
//       bool isIdFound = false;
//       allCourses!.forEach((course) {
//         if (subCategory.id.toString() == course.subcategoryId) {
//           isIdFound = true;
//         }
//       });
//       if (!isIdFound) {
//         removeIds.add(subCategory.id as int);
//       }
//     });

//     if (removeIds.isNotEmpty) {
//       removeIds.forEach((id) {
//         subCategoryList!.removeWhere((element) => element.id == id);
//       });
//     }
//   }

//   void generateChildCateList(HomeModel? homeModels, List<Course>? allCourses) {
//     childCategoryList = List.generate(
//       homeModels!.childcategory!.length,
//       (index) => ChildCategory(
//         id: homeModels.childcategory![index].id,
//         status: homeModels.childcategory![index].status,
//         title: homeModels.childcategory![index].title,
//         slug: homeModels.childcategory![index].slug,
//         icon: homeModels.childcategory![index].icon,
//         subcategoryId: homeModels.childcategory![index].subcategoryId,
//         categoryId: homeModels.childcategory![index].categoryId,
//         createdAt: homeModels.childcategory![index].createdAt,
//         updatedAt: homeModels.childcategory![index].updatedAt,
//       ),
//     );
//     childCategoryList!.removeWhere((element) => element.status == "0");

//     List<int> removeIds = [];

//     childCategoryList!.forEach((childCategory) {
//       bool isIdFound = false;
//       allCourses!.forEach((course) {
//         if (childCategory.id.toString() == course.childcategoryId) {
//           isIdFound = true;
//         }
//       });
//       if (!isIdFound) {
//         removeIds.add(childCategory.id as int);
//       }
//     });

//     if (removeIds.isNotEmpty) {
//       removeIds.forEach((id) {
//         childCategoryList!.removeWhere((element) => element.id == id);
//       });
//     }
//   }

//   String getCategoryName(dynamic id) {
//     if (id == null) {
//       return '';
//     }
//     if (categoryMap[int.tryParse(id)] != null) {
//       return categoryMap[int.tryParse(id)];
//     }
//     return "null";
//   }

//   String? getSubCategoryName(String? id) {
//     String? subCategoryName;
//     subCategoryList!.forEach((subCategory) {
//       if (subCategory.id.toString() == id) {
//         subCategoryName = subCategory.title.toString();
//       }
//     });
//     return subCategoryName;
//   }
// }
