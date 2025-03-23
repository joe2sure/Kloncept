

import 'package:kloncept/model/dummy/dummy_model.dart';

class DummyCompareCourseModel {
  final List<DummyCompareCourse> compare;

  DummyCompareCourseModel({required this.compare});

  factory DummyCompareCourseModel.fromJson(Map<String, dynamic> json) {
    return DummyCompareCourseModel(
      compare: List<DummyCompareCourse>.from(
        json['compare'].map((x) => DummyCompareCourse.fromJson(x)),
      ),
    );
  }
}

class DummyCompareCourse {
  final int id;
  final int userId;
  final int courseId;
  final String createdAt;
  final String updatedAt;
  final DummyCourse compares;

  DummyCompareCourse({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.createdAt,
    required this.updatedAt,
    required this.compares,
  });

  factory DummyCompareCourse.fromJson(Map<String, dynamic> json) {
    return DummyCompareCourse(
      id: json['id'],
      userId: json['user_id'],
      courseId: json['course_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      compares: DummyCourse.fromJson(json['compares']),
    );
  }
}