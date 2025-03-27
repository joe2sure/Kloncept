import 'package:flutter/material.dart';
import 'package:kloncept/model/course.dart';
import 'package:kloncept/model/bundle_courses_model.dart';
import 'package:kloncept/model/dummy/dummy_model.dart';

class DummyCoursesProvider with ChangeNotifier {
  List<Course> _courses = [];
  List<BundleCourses> _bundleCourses = [];
  List<int> _bundlePurchasedListIds = [];
    List<DummyCourse> _studyingList = [];
  List<int> _purchasedCourseIds = [];
  List<DummyCourse> _allDummyCourses = [];


  // Getters
  List<Course> get allCourses => _courses;
  List<BundleCourses> get bundleCourses => _bundleCourses;
  List<int>? get bundlePurchasedListIds => _bundlePurchasedListIds;
    List<DummyCourse> get studyingList => _studyingList;
  List<int> get purchasedCourseIds => _purchasedCourseIds;
  List<DummyCourse> get allDummyCourses => _allDummyCourses;

  // Initialize with dummy data
  void loadDummyCourses(List<DummyCourse> dummyCourses) {
    _courses = dummyCourses.map((dummyCourse) {
      return Course.fromDummyCourse({
        'id': dummyCourse.id,
        'userId': dummyCourse.userId,
        'categoryId': dummyCourse.categoryId,
        'subcategoryId': dummyCourse.subcategoryId,
        'childcategoryId': dummyCourse.childcategoryId,
        'languageId': dummyCourse.languageId,
        'title': dummyCourse.title,
        'shortDetail': dummyCourse.shortDetail,
        'detail': dummyCourse.detail,
        'requirement': dummyCourse.requirement,
        'price': dummyCourse.price,
        'discountPrice': dummyCourse.discountPrice,
        'day': dummyCourse.day,
        'video': dummyCourse.video,
        'url': dummyCourse.url,
        'featured': dummyCourse.featured,
        'slug': dummyCourse.slug,
        'status': dummyCourse.status,
        'previewImage': dummyCourse.previewImage,
        'videoUrl': dummyCourse.videoUrl,
        'previewType': dummyCourse.previewType,
        'type': dummyCourse.type,
        'duration': dummyCourse.duration,
        'lastActive': dummyCourse.lastActive,
        'createdAt': dummyCourse.createdAt,
        'updatedAt': dummyCourse.updatedAt,
        'include': dummyCourse.include,
        'whatlearns': dummyCourse.whatlearns,
        'review': dummyCourse.review,
        'imageUrl': dummyCourse.imageUrl,
        'categoryName': dummyCourse.categoryName,
        'instructorName': dummyCourse.instructorName,
        'instructorImage': dummyCourse.instructorImage,
        'rating': dummyCourse.rating,
        'ratingCount': dummyCourse.ratingCount,
        'totalLessons': dummyCourse.totalLessons,
      });
    }).toList();
    notifyListeners();
  }

  // Load dummy bundle courses
  void loadDummyBundleCourses(List<DummyBundleCourse> dummyBundles) {
  _bundleCourses = dummyBundles.map((dummyBundle) {
    // This is the corrected line
    return BundleCourses.fromDummyBundleCourse({
      'id': dummyBundle.id,
      'title': dummyBundle.title,
      'description': dummyBundle.description,
      'imageUrl': dummyBundle.imageUrl,
      'price': dummyBundle.price,
      'discountPrice': dummyBundle.discountPrice,
      'courses': dummyBundle.courses,
    });
  }).toList();
    
    // Randomly set some bundles as purchased
    _bundlePurchasedListIds = []; // Clear previous IDs
    for (var bundle in _bundleCourses) {
      if (bundle.id! % 3 == 0) { // Every third bundle is purchased
        _bundlePurchasedListIds.add(bundle.id!);
      }
    }
    
    notifyListeners();
  }

  // Get courses by list of courseIds
  List<Course> getCourses(List<String>? courseIds) {
    if (courseIds == null || courseIds.isEmpty) return [];
    
    List<Course> result = [];
    for (var courseId in courseIds) {
      for (var course in _courses) {
        if (course.id.toString() == courseId) {
          result.add(course);
          break;
        }
      }
    }
    return result;
  }


  void loadDummyExtraCourses() {
    // Create dummy courses
    _allDummyCourses = List.generate(
      15,
      (index) => DummyCourse(
        id: index + 1,
        title: "Course ${index + 1}: Complete Flutter Development",
        description: "Learn to build beautiful mobile apps with Flutter",
        imageUrl:
            "https://via.placeholder.com/300x200?text=Course+${index + 1}",
        categoryName: [
          "Flutter",
          "React Native",
          "iOS Development",
          "Android Development"
        ][index % 4],
        price: 49.99 + (index * 10),
        discountPrice: 39.99 + (index * 5),
        isFeatured: index % 3 == 0,
        isEnrolled: index % 5 == 0,
        instructorName:
            "Professor ${index % 4 == 0 ? 'Smith' : index % 3 == 0 ? 'Johnson' : index % 2 == 0 ? 'Williams' : 'Brown'}",
        instructorImage:
            "https://via.placeholder.com/100?text=Instructor+${index + 1}",
        rating: 3.5 + (index % 3) * 0.5,
        ratingCount: 10 + index * 5,
        totalLessons: 10 + index * 2,
        duration: "${5 + index} hours",
      ),
    );

    // Create dummy enrolled courses
    _studyingList = _allDummyCourses.where((course) => course.isEnrolled).toList();

    notifyListeners();
  }

  List<DummyCourse> getFeaturedCourses() {
    return _allDummyCourses.where((course) => course.isFeatured).toList();
  }
}