
// App-wide constants

// lib/CommonComponents/CommonUtils/app_constants.dart

class AppConstants {
  // App Info
  static const String appName = "DailyGro";
  static const String appVersion = "1.0.0";

  // Static Locations
  static const List<String> supportedCities = [
    "Chennai",
    "Bangalore",
    "Hyderabad",
    "Visakhapatnam",
  ];

  // Default Currency
  static const String currencySymbol = "₹";
  static const String currencyCode = "INR";

  // Default User Types
  static const List<String> userRoles = [
    "Outlet",
    "SubAgent",
    "Retailer",
  ];

  // Dummy Contact Info
  static const String supportEmail = "support@dailygro.app";
  static const String supportPhone = "+91 9876543210";

  // Default Image Placeholder
  static const String placeholderImage =
      "https://via.placeholder.com/150x150.png?text=DailyGro";

  // Cart Constants
  static const double defaultTaxPercent = 5.0;
  static const int bagWeightInKg = 50;

  // Others
  static const String defaultLanguage = "en";
  static const bool enableDarkMode = true;

  // Voucher Constants
  static const List<String> availableVouchers = [
    "DG10", // 10% off
    "SAVE20", // ₹20 off
    "FREESHIP", // Free delivery
  ];
}
