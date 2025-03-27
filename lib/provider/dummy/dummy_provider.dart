import 'package:flutter/material.dart';
import 'package:kloncept/model/dummy/dummy_model.dart';
import 'package:kloncept/model/dummy/dummy_payment_gateway_model.dart' show DummyHomeModel;

// Visibility Provider - Controls loading states
class DummyVisibleProvider with ChangeNotifier {
  bool _globalVisible = false;

  bool get globalVisible => _globalVisible;

  void toggleVisible(bool value) {
    _globalVisible = value;
    notifyListeners();
  }
}

// User Profile Provider
class DummyUserProfile with ChangeNotifier {
  late DummyUserProfileModel profile;

  void loadDummyProfile() {
    profile = DummyUserProfileModel(
      firstName: "John",
      lastName: "Doe",
      userImg: "https://via.placeholder.com/150",
      email: "john.doe@example.com",
    );
    notifyListeners();
  }
}

class DummyHomeDataProvider with ChangeNotifier {
  bool dataLoaded = false;
  List<DummySlider> _sliderList = [];
  List<DummyFactSlider> _sliderFactList = [];
  List<DummyTestimonial> _testimonialList = [];
  List<DummyTrustedCompany> _trustedList = [];
  List<DummyZoomMeeting> _zoomMeetingList = [];
  DummyCurrency? _currencies;
    DummyHomeModel? _homeModel;
     List<DummyCategory> _categories = [];

  List<DummySlider> get sliderList => _sliderList;
  List<DummyFactSlider> get sliderFactList => _sliderFactList;
  List<DummyTestimonial> get testimonialList => _testimonialList;
  List<DummyTrustedCompany> get trustedList => _trustedList;
  List<DummyZoomMeeting> get zoomMeetingList => _zoomMeetingList;
  DummyCurrency? get currencies => _currencies;

  Future<void> loadDummyHomeData() async {
    // Simulate a delay to mimic an API call
    await Future.delayed(Duration(seconds: 2));

    // Create dummy sliders
    _sliderList = List.generate(
      5,
      (index) => DummySlider(
        id: index + 1,
        imageUrl:
            "https://via.placeholder.com/1200x600?text=Slider+${index + 1}",
        heading: "Slider ${index + 1} Heading",
        subHeading: "Slider ${index + 1} Subheading",
        buttonText: "Button ${index + 1}",
      ),
    );

    // Create dummy fact sliders
    _sliderFactList = List.generate(
      3,
      (index) => DummyFactSlider(
        id: index + 1,
        icon: "https://via.placeholder.com/50?text=Icon+${index + 1}",
        title: "Fact ${index + 1}",
        description: "Description for Fact ${index + 1}",
      ),
    );

    // Create dummy testimonials
    _testimonialList = List.generate(
      4,
      (index) => DummyTestimonial(
        id: index + 1,
        name: "Testimonial ${index + 1}",
        designation: "Designation ${index + 1}",
        imageUrl:
            "https://via.placeholder.com/100?text=Testimonial+${index + 1}",
        testimonial: "This is a testimonial from ${index + 1}",
        rating: 4.0 + (index % 3) * 0.5,
      ),
    );

    // Create dummy trusted companies
    _trustedList = List.generate(
      6,
      (index) => DummyTrustedCompany(
        id: index + 1,
        name: "Company ${index + 1}",
        imageUrl: "https://via.placeholder.com/150?text=Company+${index + 1}",
      ),
    );

    // Create dummy zoom meetings
    _zoomMeetingList = List.generate(
      3,
      (index) => DummyZoomMeeting(
        id: index + 1,
        title: "Meeting ${index + 1}",
        description: "Description for Meeting ${index + 1}",
        startTime: "2023-10-0${index + 1}T10:00:00",
        duration: "1 hour",
        meetingId: "123456789${index + 1}",
        password: "password${index + 1}",
        hostName: "Host ${index + 1}",
        imageUrl: "https://via.placeholder.com/150?text=Meeting+${index + 1}",
      ),
    );


    _currencies = DummyCurrency(
      id: 1,
      name: "USD",
      symbol: "\$",
      rate: 1.0,
    );


     // Create dummy home model with currency and payment gateways
    _homeModel = DummyHomeModel(
      currency: DummyCurrency(
        id: 1,
        name: 'USD',
        symbol: '\$',
        position: 'left',
        format: '1,0.00',
      ),
    );

        dataLoaded = true;
    
    print("Dummy home data loaded successfully");
    print("Current currency: ${_homeModel?.currency?.name}");

    notifyListeners();
  }
}

// Recent Course Provider
class DummyRecentCourseProvider with ChangeNotifier {
  List<DummyCourse> _recentCourseList = [];

  List<DummyCourse> get recentCourseList => _recentCourseList;

  Future<List<DummyCourse>> fetchRecentCourse(BuildContext context) async {
    // Simulate API call
    await Future.delayed(Duration(milliseconds: 800));

    loadRecentCourses();
    return _recentCourseList;
  }

  void loadRecentCourses() {
    _recentCourseList = List.generate(
      5,
      (index) => DummyCourse(
        id: index + 1,
        userId: index + 100,
        categoryId: index + 10,
        subcategoryId: index + 20,
        childcategoryId: index + 30,
        languageId: index + 5,
        title: "Recent Course ${index + 1}",
        shortDetail: "Short description for Recent Course ${index + 1}",
        detail: "Long detailed description for Recent Course ${index + 1}",
        requirement: "Requirements for Recent Course ${index + 1}",
        price: 29.99 + (index * 5),
        discountPrice: 19.99 + (index * 3),
        day: "${index + 1}0 days",
        video: "video${index + 1}.mp4",
        url: "https://example.com/course/${index + 1}",
        featured: index % 2 == 0,
        slug: "recent-course-${index + 1}",
        status: index % 3 == 0 ? "active" : "pending",
        previewImage:
            "https://via.placeholder.com/300x200?text=Recent+Course+${index + 1}",
        videoUrl: "https://example.com/videos/course${index + 1}.mp4",
        previewType: index % 2 == 0 ? "video" : "image",
        type: index % 3 == 0 ? "premium" : "free",
        duration: "${1 + index} hours",
        lastActive: DateTime.now().subtract(Duration(days: index)).toString(),
        createdAt:
            DateTime.now().subtract(Duration(days: index + 30)).toString(),
        updatedAt: DateTime.now().subtract(Duration(days: index)).toString(),
        include: "What's included in Recent Course ${index + 1}",
        whatlearns: "What you'll learn in Recent Course ${index + 1}",
        mainReview: 4.0 + (index % 3) * 0.5,
        // Additional fields already in DummyCourse
        description: "Description for Recent Course ${index + 1}",
        imageUrl:
            "https://via.placeholder.com/300x200?text=Recent+Course+${index + 1}",
        categoryName: "Category ${index + 1}",
        isFeatured: index % 2 == 0,
        isEnrolled: false,
        instructorName: "Instructor ${index + 1}",
        instructorImage:
            "https://via.placeholder.com/100?text=Instructor+${index + 1}",
        ratingCount: 10 + index * 2,
        totalLessons: 5 + index, rating: 5,
      ),
    );

    notifyListeners();
  }
}

// Bundle Course Provider
class DummyBundleCourseProvider with ChangeNotifier {
  List<DummyBundleCourse> _bundleCourses = [];

  List<DummyBundleCourse> get bundleCourses => _bundleCourses;

  void loadDummyBundles() {
    _bundleCourses = List.generate(
      3,
      (index) => DummyBundleCourse(
        id: index + 1,
        title: "Bundle Course ${index + 1}",
        description: "Description for Bundle Course ${index + 1}",
        imageUrl:
            "https://via.placeholder.com/300x200?text=Bundle+Course+${index + 1}",
        price: 99.99 + (index * 20),
        discountPrice: 79.99 + (index * 15),
        courses: List.generate(
          3,
          (i) => DummyCourse(
            id: i + 1,
            title: "Course ${i + 1} in Bundle ${index + 1}",
            description:
                "Description for Course ${i + 1} in Bundle ${index + 1}",
            imageUrl:
                "https://via.placeholder.com/300x200?text=Course+${i + 1}+Bundle+${index + 1}",
            categoryName: "Category ${i + 1}",
            price: 29.99 + (i * 5),
            discountPrice: 19.99 + (i * 3),
            isFeatured: i % 2 == 0,
            isEnrolled: false,
            instructorName: "Instructor ${i + 1}",
            instructorImage:
                "https://via.placeholder.com/100?text=Instructor+${i + 1}",
            rating: 4.0 + (i % 3) * 0.5,
            ratingCount: 10 + i * 2,
            totalLessons: 5 + i,
            duration: "${1 + i} hours",
          ),
        ),
        instructorName: "Instructor ${index + 1}",
      ),
    );

    notifyListeners();
  }
}

// Institute Provider
class DummyInstituteProvider with ChangeNotifier {
  DummyInstituteModel? _instituteModel;

  DummyInstituteModel? get instituteModel => _instituteModel;

  void loadDummyInstitutes() {
    _instituteModel = DummyInstituteModel(
      institutes: List.generate(
        4,
        (index) => DummyInstitute(
          id: index + 1,
          name: "Institute ${index + 1}",
          description: "Description for Institute ${index + 1}",
          imageUrl:
              "https://via.placeholder.com/300x200?text=Institute+${index + 1}",
          address: "Address for Institute ${index + 1}",
          email: "institute${index + 1}@example.com",
        ),
      ),
    );

    notifyListeners();
  }
}

// Compare Course Provider
class DummyCompareCourseProvider with ChangeNotifier {
  DummyCompareCourse? _compareCourse;

  DummyCompareCourse? get compareCourse => _compareCourse;

  void loadDummyData() {
    _compareCourse = DummyCompareCourse(
      courses: List.generate(
        3,
        (index) => DummyCourse(
          id: index + 1,
          title: "Course ${index + 1}",
          description: "Description for Course ${index + 1}",
          imageUrl:
              "https://via.placeholder.com/300x200?text=Course+${index + 1}",
          categoryName: "Category ${index + 1}",
          price: 29.99 + (index * 5),
          discountPrice: 19.99 + (index * 3),
          isFeatured: index % 2 == 0,
          isEnrolled: false,
          instructorName: "Instructor ${index + 1}",
          instructorImage:
              "https://via.placeholder.com/100?text=Instructor+${index + 1}",
          rating: 4.0 + (index % 3) * 0.5,
          ratingCount: 10 + index * 2,
          totalLessons: 5 + index,
          duration: "${1 + index} hours",
        ),
      ),
    );

    notifyListeners();
  }
}

// Wallet Details Provider
class DummyWalletDetailsProvider with ChangeNotifier {
  DummyWalletDetail? _walletDetail;

  DummyWalletDetail? get walletDetail => _walletDetail;

  void loadDummyData() {
    _walletDetail = DummyWalletDetail(
      balance: 1000.0,
      transactions: List.generate(
        5,
        (index) => DummyTransaction(
          id: index + 1,
          type: ["Credit", "Debit"][index % 2],
          amount: 100.0 + (index * 50),
          date: "2023-10-0${index + 1}",
          description: "Transaction ${index + 1}",
        ),
      ),
    );

    notifyListeners();
  }
}

// Currencies Provider
class DummyCurrenciesProvider with ChangeNotifier {
  List<DummyCurrency> _currencies = [];

  List<DummyCurrency> get currencies => _currencies;

  void loadDummyData() {
    _currencies = List.generate(
      3,
      (index) => DummyCurrency(
        id: index + 1,
        name: "Currency ${index + 1}",
        symbol: "\$",
        rate: 1.0 + (index * 0.5),
      ),
    );

    notifyListeners();
  }
}


      // paymentGateways: List.generate(
      //   5,
      //   (index) => RealPaymentGatewayModel(
      //     id: index + 1,
      //     name: ["Wallet", "PayPal", "Stripe", "Bank Transfer", "Apple Pay"][index],
      //     image: "https://via.placeholder.com/100?text=Payment+${index + 1}",
      //     description: "Payment gateway ${index + 1} description",
      //     isActive: true,
      //     detail: "Details for payment gateway ${index + 1}",
      //   ),
      // ),


// Courses Provider
// class DummyCoursesProvider with ChangeNotifier {
//   List<DummyCourse> _allCourses = [];
//   List<DummyCourse> _studyingList = [];

//   List<DummyCourse> get allCourses => _allCourses;
//   List<DummyCourse> get studyingList => _studyingList;

//   void loadDummyCourses() {
//     // Create dummy courses
//     _allCourses = List.generate(
//       15,
//       (index) => DummyCourse(
//         id: index + 1,
//         title: "Course ${index + 1}: Complete Flutter Development",
//         description: "Learn to build beautiful mobile apps with Flutter",
//         imageUrl:
//             "https://via.placeholder.com/300x200?text=Course+${index + 1}",
//         categoryName: [
//           "Flutter",
//           "React Native",
//           "iOS Development",
//           "Android Development"
//         ][index % 4],
//         price: 49.99 + (index * 10),
//         discountPrice: 39.99 + (index * 5),
//         isFeatured: index % 3 == 0,
//         isEnrolled: index % 5 == 0,
//         instructorName:
//             "Professor ${index % 4 == 0 ? 'Smith' : index % 3 == 0 ? 'Johnson' : index % 2 == 0 ? 'Williams' : 'Brown'}",
//         instructorImage:
//             "https://via.placeholder.com/100?text=Instructor+${index + 1}",
//         rating: 3.5 + (index % 3) * 0.5,
//         ratingCount: 10 + index * 5,
//         totalLessons: 10 + index * 2,
//         duration: "${5 + index} hours",
//       ),
//     );

//     // Create dummy enrolled courses
//     _studyingList = _allCourses.where((course) => course.isEnrolled).toList();

//     notifyListeners();
//   }

//   List<DummyCourse> getFeaturedCourses() {
//     return _allCourses.where((course) => course.isFeatured).toList();
//   }
// }

// Home Data Provider
// File: lib/provider/dummy_providers.dart