// Dummy courses for featured courses
import 'package:kloncept/model/InstituteModel.dart';
import 'package:kloncept/model/WalletModel.dart';
import 'package:kloncept/model/bundle_courses_model.dart';
import 'package:kloncept/model/course.dart';
import 'package:kloncept/model/home_model.dart';
import 'package:kloncept/model/zoom_meeting.dart';

List<Course> getDummyCourses() {
  return List.generate(
    8,
    (index) => Course(
      id: index,
      title: 'Flutter Complete Course $index',
      shortDetail: 'Learn Flutter from basics to advanced concepts',
      detail: 'Comprehensive Flutter course covering widgets, state management, APIs and more',
      price: (index + 1) * 10,
      discountPrice: (index + 1) * 8,
      thumbnail: 'https://picsum.photos/300/200?random=$index',
      videoUrl: 'https://www.youtube.com/watch?v=dummyvideo',
      featured: index % 2 == 0 ? '1' : '0',
      type: index % 3 == 0 ? '1' : '0',
      status: '1',
      instructorName: 'John Doe',
      instructorImage: 'https://i.pravatar.cc/150?img=${index % 10}',
      categoryName: index % 3 == 0 ? 'Development' : (index % 3 == 1 ? 'Design' : 'Marketing'),
      categoryId: (index % 3).toString(),
      rating: (3.5 + (index % 2)).toString(),
    ),
  );
}

// Dummy courses for studying courses
List<Course> getDummyStudyingCourses() {
  return List.generate(
    3,
    (index) => Course(
      id: index + 100,
      title: 'Current Study Course ${index + 1}',
      shortDetail: 'Course you are currently studying',
      detail: 'This is a course you are currently studying with progress',
      price: (index + 1) * 10,
      discountPrice: (index + 1) * 8,
      thumbnail: 'https://picsum.photos/300/200?random=${index + 10}',
      progress: (index + 1) * 25,
      videoUrl: 'https://www.youtube.com/watch?v=dummyvideo',
      featured: '0',
      type: '1',
      status: '1',
      instructorName: 'Jane Smith',
      instructorImage: 'https://i.pravatar.cc/150?img=${index + 10}',
      categoryName: 'Learning',
      categoryId: '4',
      rating: '4.8',
    ),
  );
}

// Dummy data for recent courses
List<Course> getDummyRecentCourses() {
  return List.generate(
    5,
    (index) => Course(
      id: index + 200,
      title: 'New Course ${index + 1}',
      shortDetail: 'Recently added course',
      detail: 'This is a recently added course with new content',
      price: (index + 1) * 10,
      discountPrice: (index + 1) * 8,
      thumbnail: 'https://picsum.photos/300/200?random=${index + 20}',
      videoUrl: 'https://www.youtube.com/watch?v=dummyvideo',
      featured: '0',
      type: '1',
      status: '1',
      instructorName: 'Alex Johnson',
      instructorImage: 'https://i.pravatar.cc/150?img=${index + 20}',
      categoryName: 'Technology',
      categoryId: '5',
      rating: '4.2',
    ),
  );
}

// Dummy data for bundle courses
List<BundleCourses> getDummyBundleCourses() {
  return List.generate(
    3,
    (index) => BundleCourses(
      id: index,
      title: 'Bundle Pack ${index + 1}',
      detail: 'A bundle of related courses at a discount',
      price: ((index + 2) * 30).toString(),
      discountPrice: ((index + 2) * 22).toString(),
      courseId: '1,2,3',
      image: 'https://picsum.photos/300/200?random=${index + 30}',
      instructorId: (index + 1).toString(),
      status: 1,
      createdAt: '2023-01-01',
      updatedAt: '2023-06-30',
      userId: 1,
      courseIncluded: index + 3,
      vendorId: 1,
      isSubscription: 0,
      icon: 'icon-${index}',
      billing: 'monthly',
      priceId: 'price_${index}',
      productId: 'prod_${index}',
      subtitle: 'Bundle ${index + 1} Subtitle',
      buynow: 1,
      organizationId: 1,
      duration: (index + 1).toString(),
      durationId: 0,
      short: 'Short description for bundle ${index + 1}',
      totalRevenue: '2000',
      totalUsers: (index + 3) * 20,
      instructorName: 'Bundle Instructor ${index + 1}',
      instructorImage: 'https://i.pravatar.cc/150?img=${index + 40}',
    ),
  );
}

// Dummy data for slider images
List<MySlider> getDummySliders() {
  return List.generate(
    4,
    (index) => MySlider(
      id: index,
      heading: 'Slider Heading ${index + 1}',
      subHeading: 'Slider SubHeading ${index + 1}',
      detail: 'Slider detail text ${index + 1}',
      image: 'https://picsum.photos/800/400?random=${index + 50}',
      position: index,
      status: "1",
    ),
  );
}

// Dummy data for slider facts
List<SliderFact> getDummySliderFacts() {
  return List.generate(
    3,
    (index) => SliderFact(
      id: index,
      icon: index % 3 == 0 ? 'fas fa-book' : (index % 3 == 1 ? 'fas fa-users' : 'fas fa-clock'),
      heading: 'Fact ${index + 1}',
      subHeading: index % 3 == 0 ? '10K+ Courses' : (index % 3 == 1 ? '200+ Instructors' : '24/7 Support'),
      color: index % 3 == 0 ? '#FF5733' : (index % 3 == 1 ? '#33FF57' : '#3357FF'),
      status: 1,
      createdAt: DateTime.parse('2023-01-01'),  // Convert String to DateTime
      updatedAt: DateTime.parse('2023-06-30'),
    ),
  );
}

// Complete the getDummyTestimonials function
List<Testimonial> getDummyTestimonials() {
  return List.generate(
    5,
    (index) => Testimonial(
      id: index,
      clientName: 'Student ${index + 1}',
      details: 'This platform transformed my learning experience. The courses are comprehensive and well-structured.',
      status: 1,
      createdAt: '2023-01-01',
      updatedAt: '2023-06-30',
      image: 'https://i.pravatar.cc/150?img=${index + 60}',
    ),
  );
}

// Dummy data for trusted companies
List<Trusted> getDummyTrustedCompanies() {
  return List.generate(
    6,
    (index) => Trusted(
      id: index,
      url: '#',
      image: 'https://picsum.photos/150/50?random=${index + 70}',
      status: 1,
      createdAt: DateTime.parse('2023-01-01'),  // Convert String to DateTime
      updatedAt: DateTime.parse('2023-06-30'),
    ),
  );
}

// Dummy data for zoom meetings
List<ZoomMeeting> getDummyZoomMeetings() {
  return List.generate(
    3,
    (index) => ZoomMeeting(
      id: index,
      meetingId: '${8000000000 + index}',
      meetingTitle: 'Zoom Meeting ${index + 1}',
 startTime: DateTime.now().add(Duration(days: index + 1)).toIso8601String(),
      meetingDuration: 60,
      agenda: 'Discussion on topic ${index + 1}',
      zoomUrl: 'https://zoom.us/j/${8000000000 + index}',
      timezone: 'UTC',
      status: 1,
      createdAt: DateTime.parse('2023-01-01'),  // Convert String to DateTime
      updatedAt: DateTime.parse('2023-06-30'),
      hostName: 'Host ${index + 1}',
      hostImage: 'https://i.pravatar.cc/150?img=${index + 80}',
    ),
  );
}

// Dummy data for institutes
InstituteModel getDummyInstitutes() {
  return InstituteModel(
    institute: List.generate(
      4,
      (index) => Institute(
        id: index,
        title: 'Institute ${index + 1}',
        detail: 'Description of Institute ${index + 1}',
        image: 'https://picsum.photos/400/200?random=${index + 90}',
        status: 1,
        verified: 1,
        userId: index + 1,
        createdAt: '2023-01-01',
        updatedAt: '2023-06-30',
        skill: index % 2 == 0 ? 'Technology' : 'Business',
        email: 'institute${index + 1}@example.com',
        mobile: '+1234567890',
        address: '123 Main St, City ${index + 1}',
        affilatedBy: 'affiliate1',
        affiliatePrice: '0',
      ),
    ),
  );
}

// Dummy data for wallet
WalletModel getDummyWalletData() {
  return WalletModel(
    id: 1,
    userId: 1,
    balance: '500.00',
    status: 1,
    createdAt: '2023-01-01',
    updatedAt: '2023-06-30',
    totalTransactions: 15,
    lastTransaction: '25.00',
  );
}

// Dummy data for currencies
List<CurrencyModel> getDummyCurrencies() {
  return [
    CurrencyModel(
      id: 1,
      name: 'USD',
      code: 'USD',
      symbol: '\$',
      rate: '1.00',
      status: 1,
      position: 'l',
      createdAt: '2023-01-01',
      updatedAt: '2023-06-30',
    ),
    CurrencyModel(
      id: 2,
      name: 'Euro',
      code: 'EUR',
      symbol: '€',
      rate: '0.85',
      status: 1,
      position: 'l',
      createdAt: '2023-01-01',
      updatedAt: '2023-06-30',
    ),
    CurrencyModel(
      id: 3,
      name: 'British Pound',
      code: 'GBP',
      symbol: '£',
      rate: '0.75',
      status: 1,
      position: 'l',
      createdAt: '2023-01-01',
      updatedAt: '2023-06-30',
    ),
  ];
}




// ========== start of dummy data ============
// class DummyData {
//   static Map<String, dynamic> homeData = {
//     "settings": {
//       "id": 1,
//       "project_title": "Kloncept",
//       "logo": "assets/placeholder/trusted.png",
//       "cpy_txt": "© 2023 Kloncept. All rights reserved.",
//       "fb_login_enable": "1",
//       "google_login_enable": "1",
//       "guest_enable": "1",
//     },
//     "currency": {
//       "id": 1,
//       "icon": "USD",
//       "currency": "USD",
//       "default": "USD",
//       "created_at": "2023-01-01",
//       "updated_at": "2023-01-01",
//     },
//     "slider": [
//       {
//         "id": 1,
//         "image": "assets/placeholder/trusted.png",
//         "heading": "Welcome to Kloncept",
//         "sub_heading": "Learn and Grow",
//         "detail": "Start your journey with us",
//         "search_text": "Search",
//         "position": 1,
//         "status": "1",
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//       },
//       {
//         "id": 2,
//         "image": "assets/placeholder/trusted.png",
//         "heading": "Explore Courses",
//         "sub_heading": "Expand your knowledge",
//         "detail": "Discover new skills",
//         "search_text": "Search",
//         "position": 2,
//         "status": "1",
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//       }
//     ],
//     "sliderfacts": [
//       {
//         "id": 1,
//         "icon": "assets/placeholder/trusted.png",
//         "heading": "100+ Courses",
//         "sub_heading": "Learn from the best",
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//       },
//       {
//         "id": 2,
//         "icon": "assets/placeholder/trusted.png",
//         "heading": "Expert Instructors",
//         "sub_heading": "Learn from industry experts",
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//       }
//     ],
//     "testimonial": [
//       {
//         "id": 1,
//         "client_name": "John Doe",
//         "image": "assets/placeholder/trusted.png",
//         "status": "1",
//         "details": "Great platform for learning",
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//       },
//       {
//         "id": 2,
//         "client_name": "Jane Smith",
//         "image": "assets/placeholder/trusted.png",
//         "status": "1",
//         "details": "Amazing courses and instructors",
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//       }
//     ],
//     "trusted": [
//       {
//         "id": 1,
//         "url": "https://example.com",
//         "image": "assets/placeholder/trusted.png",
//         "status": "1",
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//       },
//       {
//         "id": 2,
//         "url": "https://example.com",
//         "image": "assets/placeholder/trusted.png",
//         "status": "1",
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//       }
//     ],
//     "featured_cate": [
//       {
//         "id": 1,
//         "slug": "featured-category-1",
//         "icon": "assets/placeholder/trusted.png",
//         "title": "Featured Category 1",
//         "status": "1",
//         "featured": "1",
//         "position": 1,
//         "updated_at": "2023-01-01",
//         "created_at": "2023-01-01",
//         "cat_image": "assets/placeholder/trusted.png",
//       },
//       {
//         "id": 2,
//         "slug": "featured-category-2",
//         "icon": "assets/placeholder/trusted.png",
//         "title": "Featured Category 2",
//         "status": "1",
//         "featured": "1",
//         "position": 2,
//         "updated_at": "2023-01-01",
//         "created_at": "2023-01-01",
//         "cat_image": "assets/placeholder/trusted.png",
//       }
//     ],
//     "category": [
//       {
//         "id": 1,
//         "title": "Category 1",
//         "icon": "assets/placeholder/trusted.png",
//         "slug": "category-1",
//         "featured": "1",
//         "status": "1",
//         "position": 1,
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//         "cat_image": "assets/placeholder/trusted.png",
//       },
//       {
//         "id": 2,
//         "title": "Category 2",
//         "icon": "assets/placeholder/trusted.png",
//         "slug": "category-2",
//         "featured": "1",
//         "status": "1",
//         "position": 2,
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//         "cat_image": "assets/placeholder/trusted.png",
//       }
//     ],
//     "subcategory": [
//       {
//         "id": 1,
//         "icon": "assets/placeholder/trusted.png",
//         "category_id": "1",
//         "status": "1",
//         "slug": "subcategory-1",
//         "title": "Subcategory 1",
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//       },
//       {
//         "id": 2,
//         "icon": "assets/placeholder/trusted.png",
//         "category_id": "2",
//         "status": "1",
//         "slug": "subcategory-2",
//         "title": "Subcategory 2",
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//       }
//     ],
//     "childcategory": [
//       {
//         "id": 1,
//         "status": "1",
//         "title": "Child Category 1",
//         "slug": "child-category-1",
//         "icon": "assets/placeholder/trusted.png",
//         "subcategory_id": "1",
//         "category_id": "1",
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//       },
//       {
//         "id": 2,
//         "status": "1",
//         "title": "Child Category 2",
//         "slug": "child-category-2",
//         "icon": "assets/placeholder/trusted.png",
//         "subcategory_id": "2",
//         "category_id": "2",
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//       }
//     ],
//     "meeting": [
//       {
//         "id": 1,
//         "course_id": "1",
//         "meeting_id": "123456",
//         "meeting_title": "Meeting 1",
//         "start_time": "2023-01-01 10:00:00",
//         "zoom_url": "https://zoom.us/j/123456",
//         "user_id": "1",
//         "agenda": "Discussion on Course 1",
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//         "type": "1",
//         "link_by": "1",
//         "owner_id": "1",
//         "image": "assets/placeholder/trusted.png",
//       }
//     ],
//   };
// }


// ========== end of dummy data ============


// // This file contains all the static dummy data for the app
// import 'package:kloncept/model/bundle_courses_model.dart';
// import 'package:kloncept/model/course.dart';
// import 'package:kloncept/model/home_model.dart';
// import 'package:kloncept/model/include.dart';
// import 'package:kloncept/model/recent_course_model.dart';
// import 'package:kloncept/model/review.dart';

// class DummyData {
//   // Dummy user profile data
//   static Map<String, dynamic> userProfileData = {
//     "fname": "John",
//     "lname": "Doe",
//     "userImg": null, // Will use placeholder image
//     "email": "john.doe@example.com",
//   };

//   // Dummy courses
//   static List<Course> courses = [
//     Course(
//       id: 1,
//       title: "Flutter Development Masterclass",
//       shortDetail: "Learn Flutter from scratch",
//       detail: "Comprehensive Flutter course covering all aspects of app development",
//       price: "99.99",
//       discountPrice: "79.99",
//       featured: "1",
//       status: "1",
//       previewImage: null, // Will use placeholder image
//       type: "1", // Paid course
//       categoryId: "1", // Mobile Development
//       userId: "1",
//       createdAt: DateTime.now().subtract(Duration(days: 30)),
//       updatedAt: DateTime.now(),
//       include: [
//         Include(id: 1, courseId: "1", icon: "fa fa-file", detail: "10 Lessons", status: "1"),
//         Include(id: 2, courseId: "1", icon: "fa fa-clock", detail: "5 Hours", status: "1"),
//       ],
//       whatlearns: [
//         Include(id: 3, courseId: "1", icon: "", detail: "Build real-world apps", status: "1"),
//         Include(id: 4, courseId: "1", icon: "", detail: "Master Dart programming", status: "1"),
//       ],
//       review: [
//         Review(
//           id: 1,
//           courseId: "1",
//           userId: "2",
//           learn: 5,
//           price: 5,
//           value: 5,
//           status: "1",
//           createdAt: DateTime.now().subtract(Duration(days: 5)),
//           updatedAt: DateTime.now().subtract(Duration(days: 5)),
//           userName: "Sarah Johnson",
//           userImage: null,
//           comment: "Great course, highly recommended!",
//         ),
//       ],
//     ),
//     Course(
//       id: 2,
//       title: "Web Development with React",
//       shortDetail: "Modern web development",
//       detail: "Learn to build modern web applications with React",
//       price: "89.99",
//       discountPrice: "69.99",
//       featured: "1",
//       status: "1",
//       previewImage: null,
//       type: "1", // Paid course
//       categoryId: "2", // Web Development
//       userId: "1",
//       createdAt: DateTime.now().subtract(Duration(days: 45)),
//       updatedAt: DateTime.now(),
//       include: [
//         Include(id: 5, courseId: "2", icon: "fa fa-file", detail: "12 Lessons", status: "1"),
//         Include(id: 6, courseId: "2", icon: "fa fa-clock", detail: "6 Hours", status: "1"),
//       ],
//       whatlearns: [
//         Include(id: 7, courseId: "2", icon: "", detail: "Build React applications", status: "1"),
//         Include(id: 8, courseId: "2", icon: "", detail: "Master JavaScript", status: "1"),
//       ],
//       review: [
//         Review(
//           id: 2,
//           courseId: "2",
//           userId: "3",
//           learn: 4,
//           price: 5,
//           value: 4,
//           status: "1",
//           createdAt: DateTime.now().subtract(Duration(days: 10)),
//           updatedAt: DateTime.now().subtract(Duration(days: 10)),
//           userName: "Michael Brown",
//           userImage: null,
//           comment: "Very informative content!",
//         ),
//       ],
//     ),
//     Course(
//       id: 3,
//       title: "Python for Data Science",
//       shortDetail: "Data analysis with Python",
//       detail: "Learn Python for data analysis and machine learning",
//       price: "0",
//       discountPrice: null,
//       featured: "1",
//       status: "1",
//       previewImage: null,
//       type: "0", // Free course
//       categoryId: "3", // Data Science
//       userId: "1",
//       createdAt: DateTime.now().subtract(Duration(days: 15)),
//       updatedAt: DateTime.now(),
//       include: [
//         Include(id: 9, courseId: "3", icon: "fa fa-file", detail: "8 Lessons", status: "1"),
//         Include(id: 10, courseId: "3", icon: "fa fa-clock", detail: "4 Hours", status: "1"),
//       ],
//       whatlearns: [
//         Include(id: 11, courseId: "3", icon: "", detail: "Data analysis techniques", status: "1"),
//         Include(id: 12, courseId: "3", icon: "", detail: "Python programming", status: "1"),
//       ],
//       review: [
//         Review(
//           id: 3,
//           courseId: "3",
//           userId: "4",
//           learn: 5,
//           price: 5,
//           value: 5,
//           status: "1",
//           createdAt: DateTime.now().subtract(Duration(days: 3)),
//           updatedAt: DateTime.now().subtract(Duration(days: 3)),
//           userName: "Emily Wilson",
//           userImage: null,
//           comment: "Excellent free course!",
//         ),
//       ],
//     ),
//   ];

//   // Dummy recent courses
//   static RecentCourseModel recentCourses = RecentCourseModel(
//     course: [
//       Course(
//         id: 4,
//         title: "iOS Development with Swift",
//         shortDetail: "Build iOS apps",
//         detail: "Learn to develop iOS applications using Swift",
//         price: "99.99",
//         discountPrice: "79.99",
//         featured: "0",
//         status: "1",
//         previewImage: null,
//         type: "1", // Paid course
//         categoryId: "1", // Mobile Development
//         userId: "1",
//         createdAt: DateTime.now().subtract(Duration(days: 2)),
//         updatedAt: DateTime.now(),
//         include: [],
//         whatlearns: [],
//         review: [],
//       ),
//       Course(
//         id: 5,
//         title: "Machine Learning Fundamentals",
//         shortDetail: "AI and ML basics",
//         detail: "Introduction to machine learning concepts and applications",
//         price: "129.99",
//         discountPrice: "99.99",
//         featured: "0",
//         status: "1",
//         previewImage: null,
//         type: "1", // Paid course
//         categoryId: "3", // Data Science
//         userId: "1",
//         createdAt: DateTime.now().subtract(Duration(days: 5)),
//         updatedAt: DateTime.now(),
//         include: [],
//         whatlearns: [],
//         review: [],
//       ),
//     ],
//   );

//   // Dummy bundle courses
//   static List<BundleCourses> bundleCourses = [
//     BundleCourses(
//       id: 1,
//       userId: "1",
//       courseId: ["1", "2"],
//       title: "Mobile & Web Development Bundle",
//       detail: "Complete package for aspiring full-stack developers",
//       price: "179.99",
//       discountPrice: "149.99",
//       type: "1",
//       status: "1",
//       featured: "1",
//       slug: "mobile-web-bundle",
//       previewImage: null,
//       // createdAt: DateTime.now().subtract(Duration(days: 60)),
//       // updatedAt: DateTime.now(),
//     ),
//     BundleCourses(
//       id: 2,
//       userId: "1",
//       courseId: ["3", "5"],
//       title: "Data Science Specialization",
//       detail: "Master data analysis and machine learning",
//       price: "149.99",
//       discountPrice: "119.99",
//       type: "1",
//       status: "1",
//       featured: "1",
//       slug: "data-science-bundle",
//       previewImage: null,
//       // createdAt: DateTime.now().subtract(Duration(days: 45)),
//       // updatedAt: DateTime.now(),
//     ),
//   ];

//   // Dummy categories
//   static List<Map<String, dynamic>> categories = [
//     {
//       "id": 1,
//       "title": "Mobile Development",
//       "icon": "fa fa-mobile",
//       "slug": "mobile-dev",
//       "status": "1",
//       "featured": "1",
//       "image": null,
//       "position": 1,
//     },
//     {
//       "id": 2,
//       "title": "Web Development",
//       "icon": "fa fa-globe",
//       "slug": "web-dev",
//       "status": "1",
//       "featured": "1",
//       "image": null,
//       "position": 2,
//     },
//     {
//       "id": 3,
//       "title": "Data Science",
//       "icon": "fa fa-database",
//       "slug": "data-science",
//       "status": "1",
//       "featured": "1",
//       "image": null,
//       "position": 3,
//     },
//     {
//       "id": 4,
//       "title": "Design",
//       "icon": "fa fa-paint-brush",
//       "slug": "design",
//       "status": "1",
//       "featured": "1",
//       "image": null,
//       "position": 4,
//     },
//   ];

//   // Dummy testimonials
//   static List<Testimonial> testimonials = [
//     Testimonial(
//       id: 1,
//       clientName: "Alex Johnson",
//       details: "The courses on this platform have helped me advance my career in software development. Highly recommended!",
//       status: "1",
//       createdAt: DateTime.now().subtract(Duration(days: 90)),
//       updatedAt: DateTime.now().subtract(Duration(days: 90)),
//       image: null,
//     ),
//     Testimonial(
//       id: 2,
//       clientName: "Maria Garcia",
//       details: "I've taken several courses here and the quality of instruction is consistently excellent. Great value for money!",
//       status: "1",
//       createdAt: DateTime.now().subtract(Duration(days: 60)),
//       updatedAt: DateTime.now().subtract(Duration(days: 60)),
//       image: null,
//     ),
//     Testimonial(
//       id: 3,
//       clientName: "David Kim",
//       details: "As a self-taught developer, these courses filled in the gaps in my knowledge. The instructors are knowledgeable and engaging.",
//       status: "1",
//       createdAt: DateTime.now().subtract(Duration(days: 30)),
//       updatedAt: DateTime.now().subtract(Duration(days: 30)),
//       image: null,
//     ),
//   ];

//   // Dummy slider facts
//   static List<Map<String, dynamic>> sliderFacts = [
//     {
//       "id": 1,
//       "heading": "50+ Courses",
//       "sub_heading": "Learn anything you want",
//       "status": "1",
//     },
//     {
//       "id": 2,
//       "heading": "Expert Instructors",
//       "sub_heading": "Learn from industry professionals",
//       "status": "1",
//     },
//     {
//       "id": 3,
//       "heading": "Lifetime Access",
//       "sub_heading": "Learn at your own pace",
//       "status": "1",
//     },
//   ];

//   // Dummy slider list
//   static List<Map<String, dynamic>> sliderList = [
//     {
//       "id": 1,
//       "heading": "Learn From Anywhere",
//       "sub_heading": "Access courses on mobile and desktop",
//       "detail": "Our platform is fully responsive and accessible on any device",
//       "status": "1",
//       "image": null,
//     },
//     {
//       "id": 2,
//       "heading": "Skill Up Today",
//       "sub_heading": "Advance your career with new skills",
//       "detail": "Our courses are designed to help you succeed in today's job market",
//       "status": "1",
//       "image": null,
//     },
//   ];

//   // Dummy trusted companies
//   static List<Trusted> trustedCompanies = [
//     Trusted(id: 1, url: "https://example.com", image: null, status: "1"),
//     Trusted(id: 2, url: "https://example.com", image: null, status: "1"),
//     Trusted(id: 3, url: "https://example.com", image: null, status: "1"),
//     Trusted(id: 4, url: "https://example.com", image: null, status: "1"),
//   ];

//   // Dummy zoom meetings
//   static List<Map<String, dynamic>> zoomMeetings = [
//     {
//       "id": 1,
//       "meeting_id": "123456789",
//       "meeting_title": "Flutter Development Q&A",
//       "agenda": "Discussion about Flutter app architecture",
//       "start_time": DateTime.now().add(Duration(days: 2)).toString(),
//       "duration": 60,
//       "timezone": "UTC",
//       "image": null,
//     },
//     {
//       "id": 2,
//       "meeting_id": "987654321",
//       "meeting_title": "Web Development Workshop",
//       "agenda": "Hands-on session on React hooks",
//       "start_time": DateTime.now().add(Duration(days: 5)).toString(),
//       "duration": 90,
//       "timezone": "UTC",
//       "image": null,
//     },
//   ];

//   // Dummy home model
//   static Map<String, dynamic> homeModel = {
//     "settings": {
//       "logo": "logo.png",
//       "favicon": "favicon.ico",
//       "app_name": "Kloncept",
//       "currency": {
//         "id": 1,
//         "icon": "\$",
//         "currency": "USD",
//         "default": 1,
//       },
//       "fb_login_enable": "1",
//       "google_login_enable": "1",
//       "guest_enable": "1",
//       "mobile_enable": "1",
//       "cpy_txt": "© 2023 Kloncept. All rights reserved.",
//     },
//     "currency": {
//       "id": 1,
//       "icon": "\$",
//       "currency": "USD",
//       "default": 1,
//     },
//   };

//   // Dummy studying list (purchased courses)
//   static List<Map<String, dynamic>> studyingList = [
//     {
//       "course": courses[0],
//       "enroll": {
//         "id": 1,
//         "user_id": "1",
//         "course_id": "1",
//         "payment_method": "PayPal",
//         "created_at": DateTime.now().subtract(Duration(days: 20)).toString(),
//         "updated_at": DateTime.now().subtract(Duration(days: 20)).toString(),
//       }
//     },
//   ];
// }

