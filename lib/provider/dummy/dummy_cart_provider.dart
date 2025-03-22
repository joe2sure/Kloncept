import 'package:flutter/material.dart';
import 'package:kloncept/model/dummy/dummy_model.dart';


class DummyCartProvider with ChangeNotifier {
  DummyMyCart? myCart;
  List<DummyCourse>? cartCourseList = [];
  List<DummyBundleCourse>? cartBundleList = [];

  // Simulate fetching cart data
  Future<DummyMyCart?> fetchCart(BuildContext context) async {
    // Reset lists
    cartCourseList = [];
    cartBundleList = [];
    
    // Simulate API delay
    await Future.delayed(Duration(milliseconds: 800));
    
    // Create dummy cart data
    myCart = DummyMyCart(
      cart: List.generate(
        5,
        (index) => DummyCartItem(
          id: index + 1,
          courseId: index % 2 == 0 ? "${index + 1}" : null,
          bundleId: index % 2 != 0 ? "${index + 1}" : null,
          createdAt: DateTime.now().subtract(Duration(days: index)).toString(),
          updatedAt: DateTime.now().toString(),
        ),
      ),
    );
    
    // Simulate retrieving courses from provider
    // In a real implementation, you would use Provider.of to get courses from other providers
    List<DummyCourse> dummyCourses = generateDummyCourses();
    List<DummyBundleCourse> dummyBundles = generateDummyBundles();
    
    // Match cart items with courses
    for (int i = 0; i < dummyCourses.length; i++) {
      for (int j = 0; j < myCart!.cart!.length; j++) {
        if ("${dummyCourses[i].id}" == myCart!.cart![j].courseId) {
          cartCourseList!.add(DummyCourse(
            id: dummyCourses[i].id,
            userId: dummyCourses[i].userId,
            categoryId: dummyCourses[i].categoryId,
            subcategoryId: dummyCourses[i].subcategoryId,
            childcategoryId: dummyCourses[i].childcategoryId,
            languageId: dummyCourses[i].languageId,
            title: dummyCourses[i].title,
            shortDetail: dummyCourses[i].shortDetail,
            detail: dummyCourses[i].detail,
            requirement: dummyCourses[i].requirement,
            price: dummyCourses[i].price,
            discountPrice: dummyCourses[i].discountPrice,
            day: dummyCourses[i].day,
            video: dummyCourses[i].video,
            url: dummyCourses[i].url,
            featured: dummyCourses[i].featured,
            slug: dummyCourses[i].slug,
            status: dummyCourses[i].status,
            previewImage: dummyCourses[i].previewImage,
            videoUrl: dummyCourses[i].videoUrl,
            previewType: dummyCourses[i].previewType,
            type: dummyCourses[i].type,
            duration: dummyCourses[i].duration,
            lastActive: dummyCourses[i].lastActive,
            createdAt: dummyCourses[i].createdAt,
            updatedAt: dummyCourses[i].updatedAt,
            include: dummyCourses[i].include,
            whatlearns: dummyCourses[i].whatlearns,
            review: dummyCourses[i].review,
            description: dummyCourses[i].description,
            imageUrl: dummyCourses[i].imageUrl,
            categoryName: dummyCourses[i].categoryName,
            isFeatured: dummyCourses[i].isFeatured,
            isEnrolled: dummyCourses[i].isEnrolled,
            instructorName: dummyCourses[i].instructorName,
            instructorImage: dummyCourses[i].instructorImage,
            rating: dummyCourses[i].rating,
            ratingCount: dummyCourses[i].ratingCount,
            totalLessons: dummyCourses[i].totalLessons,
          ));
        }
      }
    }
    
    // Match cart items with bundles
    for (int i = 0; i < dummyBundles.length; i++) {
      for (int j = 0; j < myCart!.cart!.length; j++) {
        if ("${dummyBundles[i].id}" == myCart!.cart![j].bundleId) {
          cartBundleList!.add(dummyBundles[i]);
        }
      }
    }
    
    // Filter out inactive courses (similar to original implementation)
    cartCourseList!.removeWhere((element) => "${element.status}" == "0");
    
    notifyListeners();
    return myCart;
  }
  
  // Calculate total cart price
  int get cartTotal {
    int tPrice = 0;
    
    // Add course prices
    cartCourseList?.forEach((element) {
      if (element.discountPrice == null)
        tPrice += num.tryParse(element.price.toString() ?? "0")?.round() ?? 0;
      else if (checkDataType(element.discountPrice) == 0)
        tPrice += num.tryParse(element.price.toString() ?? "0")?.round() ?? 0;
      else
        tPrice += num.tryParse(element.discountPrice.toString() ?? "0")?.round() ?? 0;
    });
    
    // Add bundle prices
    cartBundleList?.forEach((element) {
      if (element.discountPrice == null)
        tPrice += num.tryParse(element.price.toString())!.round();
      else if (checkDataType(element.discountPrice) == 0)
        tPrice += num.tryParse(element.price.toString())!.round();
      else
        tPrice += num.tryParse(element.discountPrice.toString())!.round();
    });
    
    return tPrice;
  }
  
  // Helper method to check data type
  int checkDataType(dynamic x) {
    if (x is int)
      return 0;
    else
      return 1;
  }
  
  // Add a course to cart
  void addToCart(DummyCourse course) {
    // Check if course is already in cart
    bool isInCart = cartCourseList?.any((element) => element.id == course.id) ?? false;
    
    if (!isInCart) {
      // Add course to cart
      cartCourseList?.add(course);
      
      // Add a cart item
      myCart?.cart?.add(
        DummyCartItem(
          id: myCart?.cart?.length ?? 0 + 1,
          courseId: "${course.id}",
          bundleId: null,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        ),
      );
      
      notifyListeners();
    }
  }
  
  // Add a bundle to cart
  void addBundleToCart(DummyBundleCourse bundle) {
    // Check if bundle is already in cart
    bool isInCart = cartBundleList?.any((element) => element.id == bundle.id) ?? false;
    
    if (!isInCart) {
      // Add bundle to cart
      cartBundleList?.add(bundle);
      
      // Add a cart item
      myCart?.cart?.add(
        DummyCartItem(
          id: myCart?.cart?.length ?? 0 + 1,
          courseId: null,
          bundleId: "${bundle.id}",
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        ),
      );
      
      notifyListeners();
    }
  }
  
  // Remove a course from cart
  void removeFromCart(int courseId) {
    // Remove course from cartCourseList
    cartCourseList?.removeWhere((element) => element.id == courseId);
    
    // Remove cart item
    myCart?.cart?.removeWhere((element) => element.courseId == "$courseId");
    
    notifyListeners();
  }
  
  // Remove a bundle from cart
  void removeBundleFromCart(int bundleId) {
    // Remove bundle from cartBundleList
    cartBundleList?.removeWhere((element) => element.id == bundleId);
    
    // Remove cart item
    myCart?.cart?.removeWhere((element) => element.bundleId == "$bundleId");
    
    notifyListeners();
  }
  
  // Clear cart
  void clearCart() {
    cartCourseList = [];
    cartBundleList = [];
    myCart = DummyMyCart(cart: []);
    
    notifyListeners();
  }
  
  // Generate dummy courses for testing
  List<DummyCourse> generateDummyCourses() {
    return List.generate(
      10,
      (index) => DummyCourse(
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
        discountPrice: index % 3 == 0 ? null : (19.99 + (index * 3)),
        day: "${index + 1}0 days",
        video: "video${index + 1}.mp4",
        url: "https://example.com/course/${index + 1}",
        featured: index % 2 == 0,
        slug: "course-${index + 1}",
        status: index % 5 == 0 ? "0" : "1", // Some courses inactive
        previewImage: "https://via.placeholder.com/300x200?text=Course+${index + 1}",
        videoUrl: "https://example.com/videos/course${index + 1}.mp4",
        previewType: index % 2 == 0 ? "video" : "image",
        type: index % 3 == 0 ? "premium" : "free",
        duration: "${1 + index} hours",
        lastActive: DateTime.now().subtract(Duration(days: index)).toString(),
        createdAt: DateTime.now().subtract(Duration(days: index + 30)).toString(),
        updatedAt: DateTime.now().subtract(Duration(days: index)).toString(),
        include: "What's included in Course ${index + 1}",
        whatlearns: "What you'll learn in Course ${index + 1}",
        review: 4.0 + (index % 3) * 0.5,
        description: "Description for Course ${index + 1}",
        imageUrl: "https://via.placeholder.com/300x200?text=Course+${index + 1}",
        categoryName: "Category ${index % 4 + 1}",
        isFeatured: index % 2 == 0,
        isEnrolled: index % 4 == 0,
        instructorName: "Instructor ${index % 5 + 1}",
        instructorImage: "https://via.placeholder.com/100?text=Instructor+${index % 5 + 1}",
        rating: 4.0 + (index % 3) * 0.5,
        ratingCount: 10 + index * 2,
        totalLessons: 5 + index,
      ),
    );
  }
  
  // Generate dummy bundles for testing
  List<DummyBundleCourse> generateDummyBundles() {
    return List.generate(
      5,
      (index) => DummyBundleCourse(
        id: index + 1,
        title: "Bundle Course ${index + 1}",
        description: "Description for Bundle Course ${index + 1}",
        imageUrl: "https://via.placeholder.com/300x200?text=Bundle+Course+${index + 1}",
        price: 99.99 + (index * 20),
        discountPrice: index % 2 == 0 ? (79.99 + (index * 15)) : null,
        courses: List.generate(
          3,
          (i) => DummyCourse(
            id: (index * 3) + i + 1,
            title: "Course ${i + 1} in Bundle ${index + 1}",
            description: "Description for Course ${i + 1} in Bundle ${index + 1}",
            imageUrl: "https://via.placeholder.com/300x200?text=Course+${i + 1}+Bundle+${index + 1}",
            categoryName: "Category ${i + 1}",
            price: 29.99 + (i * 5),
            discountPrice: 19.99 + (i * 3),
            isFeatured: i % 2 == 0,
            isEnrolled: false,
            instructorName: "Instructor ${i + 1}",
            instructorImage: "https://via.placeholder.com/100?text=Instructor+${i + 1}",
            rating: 4.0 + (i % 3) * 0.5,
            ratingCount: 10 + i * 2,
            totalLessons: 5 + i,
            duration: "${1 + i} hours",
          ),
        ),
        instructorName: "Instructor ${index + 1}",
      ),
    );
  }
}