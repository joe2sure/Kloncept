// File: lib/provider/dummy_payment_providers.dart
import 'package:flutter/material.dart';
import 'package:kloncept/model/dummy/dummy_model.dart';
// import 'package:kloncept/model/dummy/dummy_model.dart';
import 'package:kloncept/model/dummy/dummy_payment_gateway_model.dart';
import 'package:kloncept/model/user_profile_model.dart';


// Payment API Provider
class DummyPaymentAPIProvider with ChangeNotifier {
  late DummyPaymentApi _paymentApi;
  late DummyUpiDetailsModel _upiDetailsModel;

  DummyPaymentApi get paymentApi => _paymentApi;
  DummyUpiDetailsModel get upiDetailsModel => _upiDetailsModel;

  Future<void> fetchPaymentAPI(BuildContext context) async {
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 800));
    
    // Create dummy payment settings
    _paymentApi = DummyPaymentApi(
      settings: DummySettings(
        stripeEnable: "1",
        paypalEnable: "1",
        paystackEnable: "1",
        razorpayEnable: "1",
        instamojoEnable: "1",
        paytmEnable: "1",
        enablePayhere: "1",
        enableRave: "1",
        enablePayu: "1",
        enableCashfree: "1",
        currency: DummyCurrency(
          id: 1,
          name: "US Dollar",
          symbol: "\$",
          rate: 1.0,
          currency: "USD",
        ),
      ),
      bankDetails: DummyBankDetails(
        bankEnable: 1,
        accountName: "Demo Account",
        accountNumber: "123456789",
        bankName: "Demo Bank",
        swift: "DEMOSWIFT",
      ),
      stripePublishableKey: "pk_test_demo123456789",
      paypalClientId: "client_id_demo123456789",
      razorpayKey: "rzp_test_demo123456789",
      paystackPublicKey: "pk_test_demo123456789",
    );

    // Create dummy UPI details
    _upiDetailsModel = DummyUpiDetailsModel(
      upi: DummyUpi(
        status: "1",
        name: "UPI Payment",
        upiId: "demouser@upi",
      ),
    );

    notifyListeners();
  }
}

// Enhanced User Profile Provider (based on existing DummyUserProfile)
class DummyUserProvider with ChangeNotifier {
  late UserProfileModel _profileInstance;

  UserProfileModel get profileInstance => _profileInstance;

  void loadDummyUserProfile() {
    _profileInstance = UserProfileModel(
      userImg: "https://via.placeholder.com/150",
      email: "john.doe@example.com",
      fname: "John",
      lname: "Doe",
    );
    notifyListeners();
  }
}

// Wallet Details Provider
class DummyWalletDetailsProvider with ChangeNotifier {
  DummyWalletModel? _walletModel;

  DummyWalletModel? get walletModel => _walletModel;

  Future<void> fetchWalletDetails() async {
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 800));
    
    _walletModel = DummyWalletModel(
      wallet: DummyWallet(
        balance: 500.0,
        currency: "USD",
      ),
    );
    
    notifyListeners();
  }
}

// Manual Payment Provider
class DummyManualPaymentProvider with ChangeNotifier {
  DummyManualPaymentModel? _manualPaymentModel;

  DummyManualPaymentModel? get manualPaymentModel => _manualPaymentModel;

  Future<void> fetchData() async {
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 800));
    
    _manualPaymentModel = DummyManualPaymentModel(
      manualPayment: List.generate(
        2,
        (index) => DummyManualPayment(
          id: index + 1,
          name: "Manual Payment Option ${index + 1}",
          image: "assets/placeholder/manualpayment.png",
          description: "Instructions for Manual Payment Option ${index + 1}",
        ),
      ),
    );
    
    notifyListeners();
  }
}

// Enhanced Home Data Provider
class DummyEnhancedHomeDataProvider with ChangeNotifier {
  late DummyHomeModel _homeModel;

  DummyHomeModel get homeModel => _homeModel;

  Future<void> loadEnhancedHomeData() async {
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 800));
    
    _homeModel = DummyHomeModel(
      settings: DummySettings(
        stripeEnable: "1",
        paypalEnable: "1",
        paystackEnable: "1",
        razorpayEnable: "1",
        instamojoEnable: "1",
        paytmEnable: "1",
        enablePayhere: "1",
        enableRave: "1",
        enablePayu: "1",
        enableCashfree: "1",
        currency: DummyCurrency(
          id: 1,
          name: "US Dollar",
          symbol: "\$",
          rate: 1.0,
          currency: "USD",
        ),
      ),
      currency: DummyCurrency(
        id: 1,
        name: "US Dollar",
        symbol: "\$",
        rate: 1.0,
        currency: "USD",
      ),
    );
    
    notifyListeners();
  }
}