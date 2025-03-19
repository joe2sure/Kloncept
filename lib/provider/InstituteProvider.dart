
import 'package:flutter/material.dart';
import '../model/InstituteModel.dart';

class InstituteProvider with ChangeNotifier {
  InstituteModel? instituteModel;

  Future<void> fetchData() async {
    // Create dummy institute data
    instituteModel = InstituteModel(
      institute: [
        Institute(
          id: 1,
          title: "Tech Academy",
          detail: "Leading technology education provider",
          userId: "1",
          image: null,
          status: "1",
          verified: "1",
          skill: "Programming, Web Development",
          email: "info@techacademy.com",
          mobile: "1234567890",
          affilatedBy: "Industry Partners",
          address: "123 Tech Street",
          slug: "tech-academy",
        ),
        Institute(
          id: 2,
          title: "Design Institute",
          detail: "Creative design education",
          userId: "1",
          image: null,
          status: "1",
          verified: "1",
          skill: "UI/UX, Graphic Design",
          email: "info@designinstitute.com",
          mobile: "0987654321",
          affilatedBy: "Design Association",
          address: "456 Design Avenue",
          slug: "design-institute",
        ),
      ],
    );
    
    notifyListeners();
  }
}

// class Institute {
//   int? id;
//   String? title;
//   String? detail;
//   String? userId;
//   String? image;
//   String? status;
//   String? verified;
//   String? skill;
//   String? email;
//   String? mobile;
//   String? affilatedBy;
//   String? address;
//   String? slug;

//   Institute({
//     this.id,
//     this.title,
//     this.detail,
//     this.userId,
//     this.image,
//     this.status,
//     this.verified,
//     this.skill,
//     this.email,
//     this.mobile,
//     this.affilatedBy,
//     this.address,
//     this.slug,
//   });

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['title'] = title;
//     map['detail'] = detail;
//     map['user_id'] = userId;
//     map['image'] = image;
//     map['status'] = status;
//     map['verified'] = verified;
//     map['skill'] = skill;
//     map['email'] = email;
//     map['mobile'] = mobile;
//     map['affilated_by'] = affilatedBy;
//     map['address'] = address;
//     map['slug'] = slug;
//     return map;
//   }
// }





// import 'dart:developer';
// import 'package:kloncept/common/apidata.dart';
// import 'package:flutter/material.dart';
// import '../model/InstituteModel.dart';
// import 'package:http/http.dart' as http;

// class InstituteProvider with ChangeNotifier {
//   InstituteModel? instituteModel;

//   Future<void> fetchData() async {
//     http.Response response = await http.get(
//       Uri.parse("${APIData.institutes}${APIData.secretKey}"),
//     );

//     print("Institutes API Status Code :-> ${response.statusCode}");
//     if (response.statusCode == 200) {
//       log("Institutes API Response :-> ${response.body}");
//       instituteModel = instituteModelFromJson(response.body);
//     }
//   }
// }
