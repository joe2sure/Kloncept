// File: lib/model/dummy/payment_models.dart
import 'package:flutter/material.dart';
import 'package:kloncept/model/dummy/dummy_model.dart';
import 'package:kloncept/screens/payment_gateway.dart';

// PaymentGatewayModel (already exists but needs to be recreated for completeness)
class PaymentGatewayModel {
  final int id;
  final String name;
  final String walletImage;
  final String status;

  PaymentGatewayModel(this.id, this.name, this.walletImage, this.status);
}

// Dummy Payment API model
class DummyPaymentApi {
  final DummySettings? settings;
  final DummyBankDetails? bankDetails;
  final String? stripePublishableKey;
  final String? paypalClientId;
  final String? razorpayKey;
  final String? paystackPublicKey;

  DummyPaymentApi({
    this.settings,
    this.bankDetails,
    this.stripePublishableKey,
    this.paypalClientId,
    this.razorpayKey,
    this.paystackPublicKey,
  });
}
// Dummy Settings model for payment settings
class DummySettings {
  final String? stripeEnable;
  final String? paypalEnable;
  final String? paystackEnable;
  final String? razorpayEnable;
  final String? instamojoEnable;
  final String? paytmEnable;
  final String? enablePayhere;
  final String? enableRave;
  final String? enablePayu;
  final String? enableCashfree;
  final DummyCurrency? currency;

  DummySettings({
    this.stripeEnable,
    this.paypalEnable,
    this.paystackEnable,
    this.razorpayEnable,
    this.instamojoEnable,
    this.paytmEnable,
    this.enablePayhere,
    this.enableRave,
    this.enablePayu,
    this.enableCashfree,
    this.currency,
  });
}
// Dummy Bank Details model
class DummyBankDetails {
  final int? bankEnable;
  final String? accountName;
  final String? accountNumber;
  final String? bankName;
  final String? swift;

  DummyBankDetails({
    this.bankEnable,
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.swift,
  });
}

// Dummy UPI Details model
class DummyUpiDetailsModel {
  final DummyUpi? upi;

  DummyUpiDetailsModel({this.upi});
}

class DummyUpi {
  final String? status;
  final String? name;
  final String? upiId;

  DummyUpi({this.status, this.name, this.upiId});
}
// Dummy Wallet model
class DummyWalletModel {
  final DummyWallet? wallet;

  DummyWalletModel({this.wallet});
}

class DummyWallet {
  final double? balance;
  final String? currency;

  DummyWallet({this.balance, this.currency});
}

class DummyHomeModel {
  final List<DummySlider>? sliders;
  final List<DummyFactSlider>? facts;
  final List<DummyTestimonial>? testimonials;
  final List<DummyTrustedCompany>? trustedCompanies;
  final DummyCurrency? currency;
  final DummySettings? settings;
  final List<DummyCategory>? categories;
  List<PaymentGateway>? paymentGateways;

  DummyHomeModel({
    this.sliders,
    this.facts,
    this.testimonials,
    this.trustedCompanies,
    this.currency,
    this.settings,
    this.categories,
    this.paymentGateways,
  });
}

// Dummy Manual Payment model
class DummyManualPaymentModel {
  final List<DummyManualPayment>? manualPayment;

  DummyManualPaymentModel({this.manualPayment});
}

class DummyManualPayment {
  final int id;
  final String name;
  final String image;
  final String description;

  DummyManualPayment({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });
}

// Dummy User Profile Model (enhancing the existing one)
class DummyUserProfileModel {
  final String firstName;
  final String lastName;
  final String userImg;
  final String email;
  
  // Additional fields needed for payment flow
  final String fname;
  final String lname;

  DummyUserProfileModel({
    required this.firstName,
    required this.lastName,
    required this.userImg,
    required this.email,
    this.fname = '',
    this.lname = '',
  });
}


// DummyHomeModel (enhancing the existing one)
// class DummyHomeModel {
//   final DummySettings? settings;
//   final DummyCurrency? currency;

//   DummyHomeModel({this.settings, this.currency});
// }