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
        5,
        (index) => DummyWalletTransaction(
          id: index + 1,
          type: index % 2 == 0 ? "credit" : "debit",
          amount: (100.0 + (index * 50)).toString(),
          date: DateTime.now().subtract(Duration(days: index)).toString(),
          description: index % 2 == 0 
              ? "Top-up of ${(100.0 + (index * 50)).toString()}" 
              : "Purchase: Course ${index + 1}",
          status: "completed"
        ),
      ),
    );
    
    notifyListeners();
  }
}