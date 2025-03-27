import 'package:flutter/material.dart';
import 'package:kloncept/model/courses_model.dart';

// User Profile Model
class DummyUserProfileModel {
  final String firstName;
  final String lastName;
  final String userImg;
  final String email;

  DummyUserProfileModel({
    required this.firstName,
    required this.lastName,
    required this.userImg,
    required this.email,
  });
}

// Course Model

class DummyRecentCourseModel {
  final List<DummyCourse>? course;

  DummyRecentCourseModel({this.course});
}

// Updated DummyCourse class with all required parameters
class DummyCourse {
  final int? id;
  final int? userId;
  final int? categoryId;
  final int? subcategoryId;
  final int? childcategoryId;
  final int? languageId;
  final String? title;
  final String? shortDetail;
  final String? detail;
  final String? requirement;
  final double? price;
  final double? discountPrice;
  final String? day;
  final String? video;
  final String? url;
  final bool? featured;
  final String? slug;
  final String? status;
  final String? previewImage;
  final String? videoUrl;
  final String? previewType;
  final String? type;
  final String? duration;
  final String? lastActive;
  final String? createdAt;
  final String? updatedAt;
  final String? include;
  final String? whatlearns;
  final double? mainReview;
  final String description;
  final String imageUrl;
  final dynamic categoryName;
  final bool isFeatured;
  final bool isEnrolled;
  final String instructorName;
  final String instructorImage;
  final double rating;
  final int ratingCount;
  final int totalLessons;
  final List<DummyReview>? review;

  DummyCourse({
    this.id,
    this.userId,
    this.categoryId,
    this.subcategoryId,
    this.childcategoryId,
    this.languageId,
    this.title,
    this.shortDetail,
    this.detail,
    this.requirement,
    this.price,
    this.discountPrice,
    this.day,
    this.video,
    this.url,
    this.featured,
    this.slug,
    this.status,
    this.previewImage,
    this.videoUrl,
    this.previewType,
    this.type,
    this.duration,
    this.lastActive,
    this.createdAt,
    this.updatedAt,
    this.include,
    this.whatlearns,
    this.review,
    this.mainReview,
    required this.description,
    required this.imageUrl,
    required this.categoryName,
    required this.isFeatured,
    required this.isEnrolled,
    required this.instructorName,
    required this.instructorImage,
    required this.rating,
    required this.ratingCount,
    required this.totalLessons,
  });

  factory DummyCourse.fromJson(Map<String, dynamic> json) {
    return DummyCourse(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      subcategoryId: json['subcategory_id'],
      childcategoryId: json['childcategory_id'],
      languageId: json['language_id'],
      title: json['title'],
      shortDetail: json['short_detail'],
      detail: json['detail'],
      requirement: json['requirement'],
      price: json['price'],
      discountPrice: json['discount_price'],
      day: json['day'],
      video: json['video'],
      url: json['url'],
      featured: json['featured'],
      slug: json['slug'],
      status: json['status'],
      previewImage: json['preview_image'],
      videoUrl: json['video_url'],
      previewType: json['preview_type'],
      type: json['type'],
      duration: json['duration'],
      lastActive: json['last_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      include: json['include'],
      whatlearns: json['whatlearns'],
      review: json['review'],
      description: json['description'],
      imageUrl: json['image_url'],
      categoryName: json['category_name'],
      isFeatured: json['is_featured'],
      isEnrolled: json['is_enrolled'],
      instructorName: json['instructor_name'],
      instructorImage: json['instructor_image'],
      rating: json['rating'],
      ratingCount: json['rating_count'],
      totalLessons: json['total_lessons'],
    );
  }
}

class DummyReview {
  final int id;
  final int userId;
  final int courseId;
  final dynamic learn;
  final dynamic price;
  final dynamic value;
  final String title;
  final String details;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String userName;
  final String userImage;

  DummyReview({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.learn,
    required this.price,
    required this.value,
    required this.title,
    required this.details,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
    required this.userImage,
  });
}

// Bundle Course Model
class DummyBundleCourse {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final double? discountPrice;
  final List<DummyCourse> courses;
  final String instructorName;

  DummyBundleCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
   this.discountPrice,
    required this.courses,
    required this.instructorName,
  });
}

class DummyCategory {
  final int id;
   final String? name;
  final String? title;
  final String? icon;
  final String? slug;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final bool featured;
   final String? imageUrl;
   final int? courseCount;

  DummyCategory({
    required this.id,
    this.name,
   this.title,
    this.icon,
    this.slug,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.featured = false,
    this.imageUrl,
    this.courseCount
  });
}

// Slider Model
class DummySlider {
  final int id;
  final String imageUrl;
  final String heading;
  final String subHeading;
  final String buttonText;

  DummySlider({
    required this.id,
    required this.imageUrl,
    required this.heading,
    required this.subHeading,
    required this.buttonText,
  });
}
// Fact Slider Model
class DummyFactSlider {
  final int id;
  final String icon;
  final String title;
  final String description;

  DummyFactSlider({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
  });
}
// Testimonial Model
class DummyTestimonial {
  final int id;
  final String name;
  final String designation;
  final String imageUrl;
  final String testimonial;
  final double rating;

  DummyTestimonial({
    required this.id,
    required this.name,
    required this.designation,
    required this.imageUrl,
    required this.testimonial,
    required this.rating,
  });
}
// Trusted Company Model
class DummyTrustedCompany {
  final int id;
  final String name;
  final String imageUrl;

  DummyTrustedCompany({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}
// Zoom Meeting Model
class DummyZoomMeeting {
  final int id;
  final String title;
  final String description;
  final String startTime;
  final String duration;
  final String meetingId;
  final String password;
  final String hostName;
  final String imageUrl;

  DummyZoomMeeting({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.duration,
    required this.meetingId,
    required this.password,
    required this.hostName,
    required this.imageUrl,
  });
}
// Institute Model
class DummyInstitute {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String address;
  final String email;

  DummyInstitute({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.address,
    required this.email,
  });
}
class DummyInstituteModel {
  final List<DummyInstitute> institutes;

  DummyInstituteModel({required this.institutes});
}
// Wallet Details Model
class DummyWalletDetail {
  final double balance;
  final List<DummyTransaction> transactions;

  DummyWalletDetail({
    required this.balance,
    required this.transactions,
  });
}
// Transaction Model
class DummyTransaction {
  final int id;
  final String type;
  final double amount;
  final String date;
  final String description;

  DummyTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
  });
}

class DummyCurrency {
  final int? id;
  final String? name;
  final String? symbol;
  final double? rate;
  final String? code;
  final String? defaultCurrency;
  final String? currency;
  final  String? position;
  final String? format;

  DummyCurrency({
    this.id,
    this.name,
    this.symbol,
    this.rate,
    this.code,
    this.defaultCurrency,
    this.currency, this.position, this.format,
  });
}
// Compare Course Model
class DummyCompareCourse {
  final List<DummyCourse> courses;

  DummyCompareCourse({required this.courses});
}
// Define a dummy cart item model to simulate the cart items in MyCart model
class DummyCartItem {
  final int? id;
  final String? courseId;
  final String? bundleId;
  final String? createdAt;
  final String? updatedAt;

  DummyCartItem({
    this.id,
    this.courseId,
    this.bundleId,
    this.createdAt,
    this.updatedAt,
  });
}
// Define a dummy cart model to simulate the MyCart model
class DummyMyCart {
  final List<DummyCartItem>? cart;  

  DummyMyCart({this.cart});
}


// // File: lib/model/dummy/dummy_models.dart

// import 'package:flutter/material.dart';

// // Dummy User Profile Model
// class DummyUserProfile {
//   final DummyProfile profileInstance;

//   DummyUserProfile({required this.profileInstance});

//   factory DummyUserProfile.createDummy() {
//     return DummyUserProfile(
//       profileInstance: DummyProfile(
//         fname: "John",
//         lname: "Doe",
//         userImg: "user_avatar.png",
//         email: "john.doe@example.com",
//       ),
//     );
//   }

//   Future<void> fetchUserProfile() async {
//     // No actual API call, already populated with dummy data
//     return;
//   }
// }

// class DummyProfile {
//   final String fname;
//   final String lname;
//   final String userImg;
//   final String email;

//   DummyProfile({
//     required this.fname,
//     required this.lname,
//     required this.userImg,
//     required this.email,
//   });
// }

// // Dummy Course Model
// class DummyCourse {
//   final int id;
//   final String title;
//   final String description;
//   final String thumbnail;
//   final double price;
//   final double discountPrice;
//   final String currency;
//   final String instructor;
//   final String category;
//   final double rating;
//   final bool isFeatured;
//   final bool isBestseller;
//   final bool isEnrolled;

//   DummyCourse({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.thumbnail,
//     required this.price,
//     required this.discountPrice,
//     required this.currency,
//     required this.instructor,
//     required this.category,
//     required this.rating,
//     required this.isFeatured,
//     required this.isBestseller,
//     required this.isEnrolled,
//   });

//   static List<DummyCourse> generateDummyCourses(int count, {bool isFeatured = false}) {
//     List<DummyCourse> courses = [];
    
//     final List<String> titles = [
//       "Flutter Complete Course",
//       "Python Programming",
//       "Web Development Bootcamp",
//       "Machine Learning Fundamentals",
//       "UI/UX Design Principles",
//       "JavaScript Masterclass",
//       "Mobile App Development",
//       "Data Science Foundations",
//       "React Native Essentials",
//       "Digital Marketing Strategy",
//     ];
    
//     final List<String> instructors = [
//       "Jane Smith",
//       "Robert Johnson",
//       "Emily Parker",
//       "Michael Brown",
//       "Sarah Wilson",
//     ];
    
//     final List<String> categories = [
//       "Development",
//       "Design",
//       "Marketing",
//       "Business",
//       "Data Science",
//     ];
    
//     for (int i = 0; i < count; i++) {
//       courses.add(
//         DummyCourse(
//           id: i + 1,
//           title: titles[i % titles.length],
//           description: "This is a comprehensive course on ${titles[i % titles.length]}. Learn all the essentials and advanced concepts.",
//           thumbnail: "course_${i + 1}.jpg",
//           price: 49.99 + (i * 10),
//           discountPrice: (49.99 + (i * 10)) * 0.8,
//           currency: "\$",
//           instructor: instructors[i % instructors.length],
//           category: categories[i % categories.length],
//           rating: 4.0 + (i % 10) / 10,
//           isFeatured: isFeatured || i % 3 == 0,
//           isBestseller: i % 4 == 0,
//           isEnrolled: i % 5 == 0,
//         ),
//       );
//     }
    
//     return courses;
//   }
// }

// // Dummy Bundle Course Model
// class DummyBundleCourse {
//   final int id;
//   final String title;
//   final String description;
//   final String thumbnail;
//   final double price;
//   final double discountPrice;
//   final String currency;
//   final List<DummyCourse> courses;

//   DummyBundleCourse({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.thumbnail,
//     required this.price,
//     required this.discountPrice,
//     required this.currency,
//     required this.courses,
//   });

//   static List<DummyBundleCourse> generateDummyBundles(int count) {
//     List<DummyBundleCourse> bundles = [];
    
//     final List<String> titles = [
//       "Web Development Complete Bundle",
//       "Mobile App Development Bundle",
//       "Data Science Ultimate Pack",
//       "Design Essentials Collection",
//       "Full-Stack Developer Toolkit",
//     ];
    
//     for (int i = 0; i < count; i++) {
//       bundles.add(
//         DummyBundleCourse(
//           id: i + 1,
//           title: titles[i % titles.length],
//           description: "This bundle includes multiple courses on ${titles[i % titles.length]}.",
//           thumbnail: "bundle_${i + 1}.jpg",
//           price: 99.99 + (i * 20),
//           discountPrice: (99.99 + (i * 20)) * 0.7,
//           currency: "\$",
//           courses: DummyCourse.generateDummyCourses(3),
//         ),
//       );
//     }
    
//     return bundles;
//   }
// }

// // Dummy Institute Model
// class DummyInstitute {
//   final int id;
//   final String name;
//   final String image;
//   final String description;

//   DummyInstitute({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.description,
//   });
// }

// class DummyInstituteModel {
//   List<DummyInstitute>? institute;

//   DummyInstituteModel({this.institute});

//   factory DummyInstituteModel.generate() {
//     return DummyInstituteModel(
//       institute: List.generate(
//         5,
//         (index) => DummyInstitute(
//           id: index + 1,
//           name: "Institute ${index + 1}",
//           image: "institute_${index + 1}.jpg",
//           description: "This is a leading educational institute focused on quality education.",
//         ),
//       ),
//     );
//   }
// }

// // Dummy Slider Model
// class DummySlider {
//   final int id;
//   final String image;
//   final String heading;
//   final String subHeading;

//   DummySlider({
//     required this.id,
//     required this.image,
//     required this.heading,
//     required this.subHeading,
//   });

//   static List<DummySlider> generateDummySliders(int count) {
//     return List.generate(
//       count,
//       (index) => DummySlider(
//         id: index + 1,
//         image: "slider_${index + 1}.jpg",
//         heading: "Learn Something New",
//         subHeading: "Explore our top courses",
//       ),
//     );
//   }
// }

// // Dummy Fact Slider Model
// class DummyFactSlider {
//   final int id;
//   final String fact;
//   final IconData icon;
//   final Color color;

//   DummyFactSlider({
//     required this.id,
//     required this.fact,
//     required this.icon,
//     required this.color,
//   });

//   static List<DummyFactSlider> generateDummyFactSliders() {
//     return [
//       DummyFactSlider(
//         id: 1,
//         fact: "10,000+ Students",
//         icon: Icons.people,
//         color: Colors.blue,
//       ),
//       DummyFactSlider(
//         id: 2,
//         fact: "500+ Courses",
//         icon: Icons.book,
//         color: Colors.green,
//       ),
//       DummyFactSlider(
//         id: 3,
//         fact: "100+ Expert Instructors",
//         icon: Icons.person,
//         color: Colors.orange,
//       ),
//       DummyFactSlider(
//         id: 4,
//         fact: "95% Success Rate",
//         icon: Icons.star,
//         color: Colors.purple,
//       ),
//     ];
//   }
// }

// // Dummy Testimonial Model
// class DummyTestimonial {
//   final int id;
//   final String name;
//   final String designation;
//   final String testimonial;
//   final String image;

//   DummyTestimonial({
//     required this.id,
//     required this.name,
//     required this.designation,
//     required this.testimonial,
//     required this.image,
//   });

//   static List<DummyTestimonial> generateDummyTestimonials() {
//     return [
//       DummyTestimonial(
//         id: 1,
//         name: "Sarah Johnson",
//         designation: "Software Developer",
//         testimonial: "The courses are well-structured and helped me advance my career. Highly recommended!",
//         image: "testimonial_1.jpg",
//       ),
//       DummyTestimonial(
//         id: 2,
//         name: "Michael Brown",
//         designation: "UI/UX Designer",
//         testimonial: "I learned so much from the design courses. The instructors are top-notch professionals.",
//         image: "testimonial_2.jpg",
//       ),
//       DummyTestimonial(
//         id: 3,
//         name: "Emily Parker",
//         designation: "Marketing Specialist",
//         testimonial: "The digital marketing courses transformed my approach to campaigns. Great investment!",
//         image: "testimonial_3.jpg",
//       ),
//     ];
//   }
// }

// // Dummy Trusted Company Model
// class DummyTrustedCompany {
//   final int id;
//   final String name;
//   final String logo;

//   DummyTrustedCompany({
//     required this.id,
//     required this.name,
//     required this.logo,
//   });

//   static List<DummyTrustedCompany> generateDummyCompanies() {
//     return List.generate(
//       6,
//       (index) => DummyTrustedCompany(
//         id: index + 1,
//         name: "Company ${index + 1}",
//         logo: "company_${index + 1}.png",
//       ),
//     );
//   }
// }

// class DummyZoomMeeting {
//   final int id;
//   final String title;
//   final String description;
//   final String meetingId;
//   final String startTime;
//   final String duration;
//   final String hostName;

//   DummyZoomMeeting({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.meetingId,
//     required this.startTime,
//     required this.duration,
//     required this.hostName,
//   });

//   static List<DummyZoomMeeting> getDummyMeetings() {
//     return [
//       DummyZoomMeeting(
//         id: 1,
//         title: "Flutter Basics",
//         description: "Introduction to Flutter framework and Dart programming.",
//         meetingId: "123-456-789",
//         startTime: "2023-05-15 10:00",
//         duration: "60 minutes",
//         hostName: "John Smith",
//       ),
//       DummyZoomMeeting(
//         id: 2,
//         title: "Advanced Flutter",
//         description: "State management, animations, and best practices in Flutter.",
//         meetingId: "987-654-321",
//         startTime: "2023-05-16 14:00",
//         duration: "90 minutes",
//         hostName: "Jane Doe",
//       ),
//       DummyZoomMeeting(
//         id: 3,
//         title: "Web Development Fundamentals",
//         description: "Introduction to HTML, CSS, and JavaScript.",
//         meetingId: "456-123-789",
//         startTime: "2023-05-17 12:00",
//         duration: "120 minutes",
//         hostName: "Michael Brown",
//       ),
//     ];
//   }
// }
