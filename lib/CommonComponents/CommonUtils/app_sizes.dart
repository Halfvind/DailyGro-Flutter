
// Responsive layout utils
import 'package:flutter/material.dart';

/// A utility class to provide consistent and responsive sizing across the app.
class AppSizes {
  // These will be set during init
  static late double screenHeight;
  static late double screenWidth;
  static late double scaleHeight;
  static late double scaleWidth;

  /// Define your Figma/design dimensions here (e.g., iPhone 11 = 375 x 812)
  static const double _designHeight = 812.0;
  static const double _designWidth = 375.0;

  /// Initialize once in your app's main widget (e.g. in build() or initState())
  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    scaleHeight = screenHeight / _designHeight;
    scaleWidth = screenWidth / _designWidth;
  }

  // --- Dimensions ---

  /// Scale height (use for vertical sizes like height, top/bottom padding)
  static double height(double value) => value * scaleHeight;

  /// Scale width (use for horizontal sizes like width, left/right padding)
  static double width(double value) => value * scaleWidth;

  /// Scale font (uses average of height and width scale to be more balanced)
  /// You can pass optional [min] and [max] to clamp the font size
  static double font(double value, {double min = 10, double max = 40}) {
    final scaled = value * ((scaleHeight + scaleWidth) / 2);
    return scaled.clamp(min, max);
  }

  /// Scale corner radius
  static double radius(double value) => value * scaleWidth;

  /// Scale icon size
  static double iconSize(double value) {
    final bool isPortrait = screenHeight > screenWidth;
    return value * (isPortrait
        ? (scaleWidth * 0.6 + scaleHeight * 0.4) // Emphasize width on tall screens
        : (scaleWidth * 0.4 + scaleHeight * 0.6)); // Emphasize height on wide screens
  }

  /// Scale icon height
  static double iconHeight(double value) => value * scaleHeight;

  /// Scale icon width
  static double iconWidth(double value) => value * scaleWidth;

  /// Common padding (e.g., horizontal screen padding)
  static EdgeInsets screenPadding() => EdgeInsets.symmetric(
    horizontal: width(20),
    vertical: height(0),
  );

  /// Common margin
  static EdgeInsets screenMargin() => EdgeInsets.symmetric(
    horizontal: width(5),
    vertical: height(5),
  );

  /// Vertical spacing helper
  static SizedBox vSpace(double value) => SizedBox(height: height(value));

  /// Horizontal spacing helper
  static SizedBox hSpace(double value) => SizedBox(width: width(value));

  /// Get percentage of screen height
  static double percentHeight(double percent) => screenHeight * percent;

  /// Get percentage of screen width
  static double percentWidth(double percent) => screenWidth * percent;


  /// Common spacing & sizes



  // Font Sizes
  static double get fontXS => font(10);
  static double get fontS => font(12);
  static double get sideHeading => font(12);
  static double get fontM => font(14);
  static double get fontL => font(16);
  static double get fontXL => font(18);
  static double get fontXXL => font(22);
  static double get fontXXXL => font(26);

  // Icon Sizes
/*  static double get iconSizeS => size(16);
  static double get iconSizeM => size(20);
  static double get iconSizeL => size(24);
  static double get iconSizeXL => size(26);*/

  // Radii
  static double get radiusS => radius(8);
  static double get radiusM => radius(16);
  static double get radiusL => radius(20);
  static double get radiusXL => radius(24);

  // Paddings
  static double get p4 => height(4);
  static double get p6 => height(6);
  static double get p8 => height(8);
  static double get p12 => height(12);
  static double get p16 => height(16);
  static double get p20 => height(20);
  static double get p24 => height(24);
}
