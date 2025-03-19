// This file contains all the static dummy data for the app
import 'package:kloncept/model/bundle_courses_model.dart';
import 'package:kloncept/model/course.dart';
import 'package:kloncept/model/home_model.dart';
import 'package:kloncept/model/include.dart';
import 'package:kloncept/model/recent_course_model.dart';
import 'package:kloncept/model/review.dart';

class DummyData {
  // Dummy user profile data
  static Map<String, dynamic> userProfileData = {
    "fname": "John",
    "lname": "Doe",
    "userImg": null, // Will use placeholder image
    "email": "john.doe@example.com",
  };

  // Dummy courses
  static List<Course> courses = [
    Course(
      id: 1,
      title: "Flutter Development Masterclass",
      shortDetail: "Learn Flutter from scratch",
      detail: "Comprehensive Flutter course covering all aspects of app development",
      price: "99.99",
      discountPrice: "79.99",
      featured: "1",
      status: "1",
      previewImage: null, // Will use placeholder image
      type: "1", // Paid course
      categoryId: "1", // Mobile Development
      userId: "1",
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      updatedAt: DateTime.now(),
      include: [
        Include(id: 1, courseId: "1", icon: "fa fa-file", detail: "10 Lessons", status: "1"),
        Include(id: 2, courseId: "1", icon: "fa fa-clock", detail: "5 Hours", status: "1"),
      ],
      whatlearns: [
        Include(id: 3, courseId: "1", icon: "", detail: "Build real-world apps", status: "1"),
        Include(id: 4, courseId: "1", icon: "", detail: "Master Dart programming", status: "1"),
      ],
      review: [
        Review(
          id: 1,
          courseId: "1",
          userId: "2",
          learn: 5,
          price: 5,
          value: 5,
          status: "1",
          createdAt: DateTime.now().subtract(Duration(days: 5)),
          updatedAt: DateTime.now().subtract(Duration(days: 5)),
          userName: "Sarah Johnson",
          userImage: null,
          comment: "Great course, highly recommended!",
        ),
      ],
    ),
    Course(
      id: 2,
      title: "Web Development with React",
      shortDetail: "Modern web development",
      detail: "Learn to build modern web applications with React",
      price: "89.99",
      discountPrice: "69.99",
      featured: "1",
      status: "1",
      previewImage: null,
      type: "1", // Paid course
      categoryId: "2", // Web Development
      userId: "1",
      createdAt: DateTime.now().subtract(Duration(days: 45)),
      updatedAt: DateTime.now(),
      include: [
        Include(id: 5, courseId: "2", icon: "fa fa-file", detail: "12 Lessons", status: "1"),
        Include(id: 6, courseId: "2", icon: "fa fa-clock", detail: "6 Hours", status: "1"),
      ],
      whatlearns: [
        Include(id: 7, courseId: "2", icon: "", detail: "Build React applications", status: "1"),
        Include(id: 8, courseId: "2", icon: "", detail: "Master JavaScript", status: "1"),
      ],
      review: [
        Review(
          id: 2,
          courseId: "2",
          userId: "3",
          learn: 4,
          price: 5,
          value: 4,
          status: "1",
          createdAt: DateTime.now().subtract(Duration(days: 10)),
          updatedAt: DateTime.now().subtract(Duration(days: 10)),
          userName: "Michael Brown",
          userImage: null,
          comment: "Very informative content!",
        ),
      ],
    ),
    Course(
      id: 3,
      title: "Python for Data Science",
      shortDetail: "Data analysis with Python",
      detail: "Learn Python for data analysis and machine learning",
      price: "0",
      discountPrice: null,
      featured: "1",
      status: "1",
      previewImage: null,
      type: "0", // Free course
      categoryId: "3", // Data Science
      userId: "1",
      createdAt: DateTime.now().subtract(Duration(days: 15)),
      updatedAt: DateTime.now(),
      include: [
        Include(id: 9, courseId: "3", icon: "fa fa-file", detail: "8 Lessons", status: "1"),
        Include(id: 10, courseId: "3", icon: "fa fa-clock", detail: "4 Hours", status: "1"),
      ],
      whatlearns: [
        Include(id: 11, courseId: "3", icon: "", detail: "Data analysis techniques", status: "1"),
        Include(id: 12, courseId: "3", icon: "", detail: "Python programming", status: "1"),
      ],
      review: [
        Review(
          id: 3,
          courseId: "3",
          userId: "4",
          learn: 5,
          price: 5,
          value: 5,
          status: "1",
          createdAt: DateTime.now().subtract(Duration(days: 3)),
          updatedAt: DateTime.now().subtract(Duration(days: 3)),
          userName: "Emily Wilson",
          userImage: null,
          comment: "Excellent free course!",
        ),
      ],
    ),
  ];

  // Dummy recent courses
  static RecentCourseModel recentCourses = RecentCourseModel(
    course: [
      Course(
        id: 4,
        title: "iOS Development with Swift",
        shortDetail: "Build iOS apps",
        detail: "Learn to develop iOS applications using Swift",
        price: "99.99",
        discountPrice: "79.99",
        featured: "0",
        status: "1",
        previewImage: null,
        type: "1", // Paid course
        categoryId: "1", // Mobile Development
        userId: "1",
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        updatedAt: DateTime.now(),
        include: [],
        whatlearns: [],
        review: [],
      ),
      Course(
        id: 5,
        title: "Machine Learning Fundamentals",
        shortDetail: "AI and ML basics",
        detail: "Introduction to machine learning concepts and applications",
        price: "129.99",
        discountPrice: "99.99",
        featured: "0",
        status: "1",
        previewImage: null,
        type: "1", // Paid course
        categoryId: "3", // Data Science
        userId: "1",
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        updatedAt: DateTime.now(),
        include: [],
        whatlearns: [],
        review: [],
      ),
    ],
  );

  // Dummy bundle courses
  static List<BundleCourses> bundleCourses = [
    BundleCourses(
      id: 1,
      userId: "1",
      courseId: ["1", "2"],
      title: "Mobile & Web Development Bundle",
      detail: "Complete package for aspiring full-stack developers",
      price: "179.99",
      discountPrice: "149.99",
      type: "1",
      status: "1",
      featured: "1",
      slug: "mobile-web-bundle",
      previewImage: null,
      // createdAt: DateTime.now().subtract(Duration(days: 60)),
      // updatedAt: DateTime.now(),
    ),
    BundleCourses(
      id: 2,
      userId: "1",
      courseId: ["3", "5"],
      title: "Data Science Specialization",
      detail: "Master data analysis and machine learning",
      price: "149.99",
      discountPrice: "119.99",
      type: "1",
      status: "1",
      featured: "1",
      slug: "data-science-bundle",
      previewImage: null,
      // createdAt: DateTime.now().subtract(Duration(days: 45)),
      // updatedAt: DateTime.now(),
    ),
  ];

  // Dummy categories
  static List<Map<String, dynamic>> categories = [
    {
      "id": 1,
      "title": "Mobile Development",
      "icon": "fa fa-mobile",
      "slug": "mobile-dev",
      "status": "1",
      "featured": "1",
      "image": null,
      "position": 1,
    },
    {
      "id": 2,
      "title": "Web Development",
      "icon": "fa fa-globe",
      "slug": "web-dev",
      "status": "1",
      "featured": "1",
      "image": null,
      "position": 2,
    },
    {
      "id": 3,
      "title": "Data Science",
      "icon": "fa fa-database",
      "slug": "data-science",
      "status": "1",
      "featured": "1",
      "image": null,
      "position": 3,
    },
    {
      "id": 4,
      "title": "Design",
      "icon": "fa fa-paint-brush",
      "slug": "design",
      "status": "1",
      "featured": "1",
      "image": null,
      "position": 4,
    },
  ];

  // Dummy testimonials
  static List<Testimonial> testimonials = [
    Testimonial(
      id: 1,
      clientName: "Alex Johnson",
      details: "The courses on this platform have helped me advance my career in software development. Highly recommended!",
      status: "1",
      createdAt: DateTime.now().subtract(Duration(days: 90)),
      updatedAt: DateTime.now().subtract(Duration(days: 90)),
      image: null,
    ),
    Testimonial(
      id: 2,
      clientName: "Maria Garcia",
      details: "I've taken several courses here and the quality of instruction is consistently excellent. Great value for money!",
      status: "1",
      createdAt: DateTime.now().subtract(Duration(days: 60)),
      updatedAt: DateTime.now().subtract(Duration(days: 60)),
      image: null,
    ),
    Testimonial(
      id: 3,
      clientName: "David Kim",
      details: "As a self-taught developer, these courses filled in the gaps in my knowledge. The instructors are knowledgeable and engaging.",
      status: "1",
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      updatedAt: DateTime.now().subtract(Duration(days: 30)),
      image: null,
    ),
  ];

  // Dummy slider facts
  static List<Map<String, dynamic>> sliderFacts = [
    {
      "id": 1,
      "heading": "50+ Courses",
      "sub_heading": "Learn anything you want",
      "status": "1",
    },
    {
      "id": 2,
      "heading": "Expert Instructors",
      "sub_heading": "Learn from industry professionals",
      "status": "1",
    },
    {
      "id": 3,
      "heading": "Lifetime Access",
      "sub_heading": "Learn at your own pace",
      "status": "1",
    },
  ];

  // Dummy slider list
  static List<Map<String, dynamic>> sliderList = [
    {
      "id": 1,
      "heading": "Learn From Anywhere",
      "sub_heading": "Access courses on mobile and desktop",
      "detail": "Our platform is fully responsive and accessible on any device",
      "status": "1",
      "image": null,
    },
    {
      "id": 2,
      "heading": "Skill Up Today",
      "sub_heading": "Advance your career with new skills",
      "detail": "Our courses are designed to help you succeed in today's job market",
      "status": "1",
      "image": null,
    },
  ];

  // Dummy trusted companies
  static List<Trusted> trustedCompanies = [
    Trusted(id: 1, url: "https://example.com", image: null, status: "1"),
    Trusted(id: 2, url: "https://example.com", image: null, status: "1"),
    Trusted(id: 3, url: "https://example.com", image: null, status: "1"),
    Trusted(id: 4, url: "https://example.com", image: null, status: "1"),
  ];

  // Dummy zoom meetings
  static List<Map<String, dynamic>> zoomMeetings = [
    {
      "id": 1,
      "meeting_id": "123456789",
      "meeting_title": "Flutter Development Q&A",
      "agenda": "Discussion about Flutter app architecture",
      "start_time": DateTime.now().add(Duration(days: 2)).toString(),
      "duration": 60,
      "timezone": "UTC",
      "image": null,
    },
    {
      "id": 2,
      "meeting_id": "987654321",
      "meeting_title": "Web Development Workshop",
      "agenda": "Hands-on session on React hooks",
      "start_time": DateTime.now().add(Duration(days: 5)).toString(),
      "duration": 90,
      "timezone": "UTC",
      "image": null,
    },
  ];

  // Dummy home model
  static Map<String, dynamic> homeModel = {
    "settings": {
      "logo": "logo.png",
      "favicon": "favicon.ico",
      "app_name": "Kloncept",
      "currency": {
        "id": 1,
        "icon": "\$",
        "currency": "USD",
        "default": 1,
      },
      "fb_login_enable": "1",
      "google_login_enable": "1",
      "guest_enable": "1",
      "mobile_enable": "1",
      "cpy_txt": "© 2023 Kloncept. All rights reserved.",
    },
    "currency": {
      "id": 1,
      "icon": "\$",
      "currency": "USD",
      "default": 1,
    },
  };

  // Dummy studying list (purchased courses)
  static List<Map<String, dynamic>> studyingList = [
    {
      "course": courses[0],
      "enroll": {
        "id": 1,
        "user_id": "1",
        "course_id": "1",
        "payment_method": "PayPal",
        "created_at": DateTime.now().subtract(Duration(days: 20)).toString(),
        "updated_at": DateTime.now().subtract(Duration(days: 20)).toString(),
      }
    },
  ];
}

