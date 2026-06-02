import 'package:farmtec/core/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TextStyles {

  

    // Large Titles (e.g., Dashboard "Field Alpha is thriving")
    static TextStyle displayLarge = GoogleFonts.manrope(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: Pallete.primaryColor,
      letterSpacing: -0.5,
    );  
    // Screen Headers (e.g., "AI Models", "Market Prices")
   static TextStyle headlineMedium = GoogleFonts.manrope(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Pallete.primaryColor,
      letterSpacing: -0.2,
    );
    
    // Section Headers (e.g., "Soil Metrics", "Quick Tools")
    static TextStyle titleLarge = GoogleFonts.manrope(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Pallete.secondaryColor,
    );
    
    // Card Subheaders / Metric Labels
    static TextStyle titleMedium = GoogleFonts.manrope(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Pallete.secondaryColor,
    );
    
    // Tiny Labels (e.g., Nav bar labels, Overline)
    static TextStyle labelSmall = GoogleFonts.manrope(
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
      color: Pallete.primaryColor.withOpacity(0.7),
    );

    static const TextStyle manropeRegular = TextStyle(
    fontFamily: 'Manrope',
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Base Manrope Medium style
  static const TextStyle manropeMedium = TextStyle(
    fontFamily: 'Manrope',
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  /// Base Manrope SemiBold style
  static const TextStyle manropeSemiBold = TextStyle(
    fontFamily: 'Manrope',
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  /// Base Manrope Bold style
  static const TextStyle manropeBold = TextStyle(
    fontFamily: 'Manrope',
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// Base Manrope ExtraBold style
  static const TextStyle manropeExtraBold = TextStyle(
    fontFamily: 'Manrope',
    fontWeight: FontWeight.w800,
    height: 1.1,
  );

  /// Base Inter Regular style
  static const TextStyle interRegular = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Base Inter Medium style
  static const TextStyle interMedium = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  /// Base Inter SemiBold style
  static const TextStyle interSemiBold = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Base Inter Bold style
  static const TextStyle interBold = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    height: 1.33,
  );

  // --- Common Pre-defined Styles (Convenience) ---

  /// Heading 1 (Manrope Bold, 48px)
  static final TextStyle h1 = manropeBold.copyWith(fontSize: 48.0, letterSpacing: -1.2);

  /// Heading 2 (Manrope Bold, 36px)
  static final TextStyle h2 = manropeBold.copyWith(fontSize: 36.0, letterSpacing: -0.9);

  /// Heading 3 (Manrope Bold, 30px)
  static final TextStyle h3 = manropeBold.copyWith(fontSize: 30.0, letterSpacing: -0.75);

  /// Subtitle (Manrope SemiBold, 20px)
  static final TextStyle subtitle = manropeSemiBold.copyWith(fontSize: 20.0, letterSpacing: -0.5);

  /// Body Large (Inter Regular, 16px)
  static final TextStyle bodyLarge = interRegular.copyWith(fontSize: 16.0);

  /// Body Medium (Inter Regular, 14px)
  static final TextStyle bodyMedium = interRegular.copyWith(fontSize: 14.0);

  /// Body Small (Inter Regular, 12px)
  static final TextStyle bodySmall = interRegular.copyWith(fontSize: 12.0);

  /// Caption (Inter Medium, 10px)
  static final TextStyle caption = interMedium.copyWith(fontSize: 10.0, letterSpacing: 0.25);

  /// Label (Inter Bold, 12px, Uppercase style)
  static final TextStyle label = interBold.copyWith(fontSize: 12.0, letterSpacing: 1.2);
    
}