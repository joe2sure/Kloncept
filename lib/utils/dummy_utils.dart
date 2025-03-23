// Simulate the utils.dart file needed by CourseGridItem

// Simple class for course details navigation
class DummyDataSend {
  final int? userId;
  final bool? isPurchased;
  final int? courseId;
  final int? categoryId;
  final String? type;

  DummyDataSend(this.userId, this.isPurchased, this.courseId, this.categoryId, this.type);
}

// Global variables
String selectedCurrency = "USD";
double selectedCurrencyRate = 1.0;

String currencySymbol(String? code) {
  switch (code) {
    case "USD":
      return "\$";
    case "EUR":
      return "€";
    case "GBP":
      return "£";
    case "INR":
      return "₹";
    default:
      return "\$";
  }
}