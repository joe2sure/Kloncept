// File: lib/provider/dummy_wallet_details_provider.dart
import 'package:flutter/material.dart';
import 'package:kloncept/model/dummy/dummy_wallet_model.dart';

class DummyWalletDetailsProvider with ChangeNotifier {
  DummyWalletModel? _walletModel;

  DummyWalletModel? get walletModel => _walletModel;

  Future<void> fetchWalletDetails() async {
    // Simulate API delay
    await Future.delayed(Duration(milliseconds: 800));
    
    _walletModel = DummyWalletModel(
      wallet: "1250.75",
      path: "https://example.com/referral/user123",
      transactions: List.generate(
        10,
        (index) => DummyWalletTransaction(
          id: index + 1,
          type: index % 2 == 0 ? "credit" : "debit",
          amount: (100.0 + (index * 15)).toString(),
          date: DateTime.now().subtract(Duration(days: index)).toString(),
          description: index % 2 == 0 
              ? "Top-up of ${(100.0 + (index * 15)).toString()}" 
              : "Course purchase: ${['Flutter Basics', 'Advanced React', 'UI/UX Design', 'Web Development', 'Mobile App Dev'][index % 5]}",
          status: "completed"
        ),
      ),
    );
    
    notifyListeners();
  }
  
  // Method to add a transaction to the wallet
  void addTransaction(DummyWalletTransaction transaction) {
    if (_walletModel != null) {
      _walletModel!.transactions?.insert(0, transaction);
      notifyListeners();
    }
  }
  
  // Method to update wallet balance
  void updateBalance(double newBalance) {
    if (_walletModel != null) {
      _walletModel!.wallet = newBalance.toString();
      notifyListeners();
    }
  }
}


// import 'package:flutter/material.dart';
// import 'package:kloncept/model/dummy/dummy_wallet_model.dart';

// class DummyWalletDetailsProvider with ChangeNotifier {
//   DummyWalletModel? _walletModel;

//   DummyWalletModel? get walletModel => _walletModel;

//   Future<void> fetchWalletDetails() async {
//     // Simulate API delay
//     await Future.delayed(Duration(milliseconds: 800));
    
//     _walletModel = DummyWalletModel(
//       wallet: "1250.75",
//       path: "https://example.com/referral/user123",
//       transactions: List.generate(
//         5,
//         (index) => DummyWalletTransaction(
//           id: index + 1,
//           type: index % 2 == 0 ? "credit" : "debit",
//           amount: (100.0 + (index * 50)).toString(),
//           date: DateTime.now().subtract(Duration(days: index)).toString(),
//           description: index % 2 == 0 
//               ? "Top-up of ${(100.0 + (index * 50)).toString()}" 
//               : "Purchase: Course ${index + 1}",
//           status: "completed"
//         ),
//       ),
//     );
    
//     notifyListeners();
//   }
// }