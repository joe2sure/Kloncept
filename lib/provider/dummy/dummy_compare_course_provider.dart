import 'package:flutter/material.dart';
import 'package:kloncept/model/dummy/dummy_compare_course_model.dart';
import 'package:kloncept/model/dummy/dummy_model.dart' show DummyCourse;

class DummyCompareCourseProvider with ChangeNotifier {
  DummyCompareCourseModel? _compareCourseModel;

  DummyCompareCourseModel? get compareCourseModel => _compareCourseModel;

  // Initialize with empty data to prevent null errors
  DummyCompareCourseProvider() {
    _compareCourseModel = DummyCompareCourseModel(compare: []);
  }

  Future<void> loadDummyData() async {
    try {
      // Call fetchData to populate the model
      await fetchData();
      print("DummyCompareCourseProvider loaded successfully");
    } catch (e) {
      print("Error loading DummyCompareCourseProvider: $e");
      // Initialize with empty data if fetch fails
      _compareCourseModel = DummyCompareCourseModel(compare: []);
    }
  }

  Future<void> fetchData() async {
    // Simulate API delay
    await Future.delayed(Duration(seconds: 1));

    // Generate dummy data
    _compareCourseModel = DummyCompareCourseModel(
      compare: List.generate(
        3,
        (index) => DummyCompareCourse(
          id: index + 1,
          userId: index + 100,
          courseId: index + 1,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          compares: DummyCourse(
            id: index + 1,
            userId: index + 100,
            categoryId: index + 10,
            subcategoryId: index + 20,
            childcategoryId: index + 30,
            languageId: index + 5,
            title: "Course ${index + 1}",
            shortDetail: "Short description for Course ${index + 1}",
            detail: "Long detailed description for Course ${index + 1}",
            requirement: "Requirements for Course ${index + 1}",
            price: 29.99 + (index * 5),
            discountPrice: 19.99 + (index * 3),
            day: "${index + 1}0 days",
            video: "video${index + 1}.mp4",
            url: "https://example.com/course/${index + 1}",
            featured: index % 2 == 0,
            slug: "course-${index + 1}",
            status: "active",
            previewImage:
                "https://via.placeholder.com/300x200?text=Course+${index + 1}",
            videoUrl: "https://example.com/videos/course${index + 1}.mp4",
            previewType: index % 2 == 0 ? "video" : "image",
            type: index % 3 == 0 ? "premium" : "free",
            duration: "${1 + index} hours",
            lastActive: DateTime.now().subtract(Duration(days: index)).toString(),
            createdAt:
                DateTime.now().subtract(Duration(days: index + 30)).toString(),
            updatedAt: DateTime.now().subtract(Duration(days: index)).toString(),
            include: "What's included in Course ${index + 1}",
            whatlearns: "What you'll learn in Course ${index + 1}",
            mainReview: 4.0 + (index % 3) * 0.5,
            description: "Description for Course ${index + 1}",
            imageUrl:
                "https://via.placeholder.com/300x200?text=Course+${index + 1}",
            categoryName: "Category ${index + 1}",
            isFeatured: index % 2 == 0,
            isEnrolled: false,
            instructorName: "Instructor ${index + 1}",
            instructorImage:
                "https://via.placeholder.com/100?text=Instructor+${index + 1}",
            rating: 4.0 + (index % 3) * 0.5,
            ratingCount: 10 + index * 2,
            totalLessons: 5 + index,
          ),
        ),
      ),
    );

    notifyListeners();
  }
}





// import 'package:flutter/material.dart';
// import 'package:kloncept/model/dummy/dummy_compare_course_model.dart';
// import 'package:kloncept/model/dummy/dummy_model.dart' show DummyCourse;


// class DummyCompareCourseProvider with ChangeNotifier {
//   DummyCompareCourseModel? _compareCourseModel;

//   DummyCompareCourseModel? get compareCourseModel => _compareCourseModel;

//   Future<void> fetchData() async {
//     // Simulate API delay
//     await Future.delayed(Duration(seconds: 2));

//     // Generate dummy data
//     _compareCourseModel = DummyCompareCourseModel(
//       compare: List.generate(
//         3,
//         (index) => DummyCompareCourse(
//           id: index + 1,
//           userId: index + 100,
//           courseId: index + 1,
//           createdAt: DateTime.now().toString(),
//           updatedAt: DateTime.now().toString(),
//           compares: DummyCourse(
//             id: index + 1,
//             userId: index + 100,
//             categoryId: index + 10,
//             subcategoryId: index + 20,
//             childcategoryId: index + 30,
//             languageId: index + 5,
//             title: "Course ${index + 1}",
//             shortDetail: "Short description for Course ${index + 1}",
//             detail: "Long detailed description for Course ${index + 1}",
//             requirement: "Requirements for Course ${index + 1}",
//             price: 29.99 + (index * 5),
//             discountPrice: 19.99 + (index * 3),
//             day: "${index + 1}0 days",
//             video: "video${index + 1}.mp4",
//             url: "https://example.com/course/${index + 1}",
//             featured: index % 2 == 0,
//             slug: "course-${index + 1}",
//             status: "active",
//             previewImage:
//                 "https://via.placeholder.com/300x200?text=Course+${index + 1}",
//             videoUrl: "https://example.com/videos/course${index + 1}.mp4",
//             previewType: index % 2 == 0 ? "video" : "image",
//             type: index % 3 == 0 ? "premium" : "free",
//             duration: "${1 + index} hours",
//             lastActive: DateTime.now().subtract(Duration(days: index)).toString(),
//             createdAt:
//                 DateTime.now().subtract(Duration(days: index + 30)).toString(),
//             updatedAt: DateTime.now().subtract(Duration(days: index)).toString(),
//             include: "What's included in Course ${index + 1}",
//             whatlearns: "What you'll learn in Course ${index + 1}",
//             mainReview: 4.0 + (index % 3) * 0.5,
//             description: "Description for Course ${index + 1}",
//             imageUrl:
//                 "https://via.placeholder.com/300x200?text=Course+${index + 1}",
//             categoryName: "Category ${index + 1}",
//             isFeatured: index % 2 == 0,
//             isEnrolled: false,
//             instructorName: "Instructor ${index + 1}",
//             instructorImage:
//                 "https://via.placeholder.com/100?text=Instructor+${index + 1}",
//             rating: 4.0 + (index % 3) * 0.5,
//             ratingCount: 10 + index * 2,
//             totalLessons: 5 + index,
//           ),
//         ),
//       ),
//     );

//     notifyListeners();
//   }

//   Future<void> addToCompareCourse(int userId, int courseId) async {
//     // Simulate API delay
//     await Future.delayed(Duration(seconds: 1));

//     // Add dummy course to compare list
//     _compareCourseModel!.compare.add(
//       DummyCompareCourse(
//         id: _compareCourseModel!.compare.length + 1,
//         userId: userId,
//         courseId: courseId,
//         createdAt: DateTime.now().toString(),
//         updatedAt: DateTime.now().toString(),
//         compares: DummyCourse(
//           id: courseId,
//           userId: userId,
//           categoryId: 1,
//           subcategoryId: 1,
//           childcategoryId: 1,
//           languageId: 1,
//           title: "New Course",
//           shortDetail: "Short description for New Course",
//           detail: "Long detailed description for New Course",
//           requirement: "Requirements for New Course",
//           price: 49.99,
//           discountPrice: 39.99,
//           day: "30 days",
//           video: "video.mp4",
//           url: "https://example.com/course/new",
//           featured: true,
//           slug: "new-course",
//           status: "active",
//           previewImage: "https://via.placeholder.com/300x200?text=New+Course",
//           videoUrl: "https://example.com/videos/new.mp4",
//           previewType: "video",
//           type: "premium",
//           duration: "10 hours",
//           lastActive: DateTime.now().toString(),
//           createdAt: DateTime.now().toString(),
//           updatedAt: DateTime.now().toString(),
//           include: "What's included in New Course",
//           whatlearns: "What you'll learn in New Course",
//           mainReview: 4.5,
//           description: "Description for New Course",
//           imageUrl: "https://via.placeholder.com/300x200?text=New+Course",
//           categoryName: "Category 1",
//           isFeatured: true,
//           isEnrolled: false,
//           instructorName: "Instructor 1",
//           instructorImage: "https://via.placeholder.com/100?text=Instructor+1",
//           rating: 4.5,
//           ratingCount: 10,
//           totalLessons: 10,
//         ),
//       ),
//     );

//     notifyListeners();
//   }

//   Future<void> removeFromCompareCourse(int compareCourseId) async {
//     // Simulate API delay
//     await Future.delayed(Duration(seconds: 1));

//     // Remove course from compare list
//     _compareCourseModel!.compare
//         .removeWhere((course) => course.id == compareCourseId);

//     notifyListeners();
//   }
// }