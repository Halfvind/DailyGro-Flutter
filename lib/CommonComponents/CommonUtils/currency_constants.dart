
const String currencySymbol = '₹';
// lib/CommonComponents/CommonUtils/currency_constants.dart

class CurrencyConstants {
  static const String defaultCurrency = "INR";
  static const String currencySymbol = "₹";

  static const Map<String, String> currencySymbols = {
    "INR": "₹",
    "USD": "\$",
    "EUR": "€",
    "GBP": "£",
  };

  static String getSymbol(String currencyCode) {
    return currencySymbols[currencyCode] ?? currencySymbol;
  }

  static const List<String> supportedCurrencies = [
    "INR",
    "USD",
    "EUR",
    "GBP",
  ];
}
