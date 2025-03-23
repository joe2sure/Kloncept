class DummyWalletModel {
  final String? wallet;
  final String? path;
  final List<DummyWalletTransaction>? transactions;

  DummyWalletModel({
    this.wallet,
    this.path,
    this.transactions,
  });
}

class DummyWalletTransaction {
  final int id;
  final String type;
  final String amount;
  final String date;
  final String description;
  final String status;

  DummyWalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
    required this.status,
  });
}
