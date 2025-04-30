import 'package:flutter/material.dart';

// Colors
const kPrimaryColor = Color(0xffF7F9FA); // Major White Color
const kSecondaryColor = Color(0xFF05021C); // Major headline color
const kWhiteColor = Color(0xFFFFFFFF); // Large Title color (Shopmate)
const kBlackColor = Color(0xFF1F2021);
const kGreyColor1 = Color(0xFF737373);
const kGreyColor2 = Color(0xFFA3A3A3);
const kPurpleColor = Color(0xFF4739E3);
const kFadedPurple = Color(0xFFE5E3FC);
const kSuccessColor = Color(0xFF4CD964);
const kWarningColor = Color(0xFFFFCC00);
const kErrorColor = Color(0xFFFF3B30);

// Dimensions
const kCardBorderRadius = 20.0;
const kButtonBorderRadius = 12.0;
const kDefaultPadding = 16.0;

// Text Styles
const kHeadingTextStyle = TextStyle(
  fontFamily: 'Raleway',
  fontSize: 32,
  fontWeight: FontWeight.w500,
  color: kSecondaryColor,
);

const kSubheadingTextStyle = TextStyle(
  fontFamily: 'Raleway',
  fontSize: 24,
  fontWeight: FontWeight.w400,
  color: kSecondaryColor,
);

const kTitleTextStyle = TextStyle(
  fontFamily: 'Raleway',
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: kSecondaryColor,
);

const kBodyTextStyle = TextStyle(
  fontFamily: 'Raleway',
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: kBlackColor,
);

const kCaptionTextStyle = TextStyle(
  fontFamily: 'Raleway',
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: kGreyColor1,
);

const kButtonTextStyle = TextStyle(
  fontFamily: 'Raleway',
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: kWhiteColor,
);

const kSmallButtonTextStyle = TextStyle(
  fontFamily: 'Raleway',
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: kPurpleColor,
);

// Shadows
final kCardShadow = BoxShadow(
  color: kSecondaryColor.withValues(alpha: 0.1),
  blurRadius: 10,
  offset: const Offset(0, 4),
);

// Theme Data
ThemeData getAppTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Raleway',
    scaffoldBackgroundColor: kPrimaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPurpleColor,
      brightness: Brightness.light,
      // Optionally override specific colors if needed:
      // primary: kPurpleColor,
      // secondary: kSecondaryColor,
      // background: kPrimaryColor,
      // surface: kWhiteColor,
      // error: kErrorColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: kPurpleColor,
      foregroundColor: kWhiteColor,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPurpleColor,
        foregroundColor: kWhiteColor,
        elevation: 2,
        textStyle: kButtonTextStyle,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButtonBorderRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kPurpleColor,
        side: const BorderSide(color: kPurpleColor, width: 1.5),
        textStyle: kSmallButtonTextStyle,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButtonBorderRadius),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: kWhiteColor,
      elevation: 2,
      shadowColor: kSecondaryColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardBorderRadius),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kWhiteColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kButtonBorderRadius),
        borderSide: const BorderSide(color: kGreyColor2, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kButtonBorderRadius),
        borderSide: const BorderSide(color: kGreyColor2, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kButtonBorderRadius),
        borderSide: const BorderSide(color: kPurpleColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kButtonBorderRadius),
        borderSide: const BorderSide(color: kErrorColor, width: 1),
      ),
      labelStyle: kBodyTextStyle.copyWith(color: kGreyColor1),
      hintStyle: kBodyTextStyle.copyWith(color: kGreyColor2),
    ),
  );
}
