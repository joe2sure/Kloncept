// File: lib/provider/courses_provider.dart
import 'package:flutter/material.dart';
import 'package:kloncept/model/course.dart';
import 'package:kloncept/model/bundle_courses_model.dart';
import 'package:kloncept/model/dummy/dummy_model.dart';

class CoursesProvider with ChangeNotifier {
  List<Course> _courses = [];
  List<BundleCourses> _bundleCourses = [];
  List<int> _bundlePurchasedListIds = [];
    List<DummyCourse> _studyingList = [];
  List<int> _purchasedCourseIds = [];

  // Getters
  List<Course> get allCourses => _courses;
  List<BundleCourses> get bundleCourses => _bundleCourses;
  List<int>? get bundlePurchasedListIds => _bundlePurchasedListIds;
    List<DummyCourse> get studyingList => _studyingList;
  List<int> get purchasedCourseIds => _purchasedCourseIds;

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
}