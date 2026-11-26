import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

abstract class AppMaterialTextPrimitives {
  // --- Font Families ---
  // We use GoogleFonts getters to ensure we get the correct TextStyle backing
  static final String fontHeadings = GoogleFonts.eczar().fontFamily!;
  static final String fontBody = GoogleFonts.manrope().fontFamily!;

  // --- Weights ---
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // --- Sizes (Material 3 Scale) ---
  static const double s57 = 57.0; // Display Large
  static const double s45 = 45.0; // Display Medium
  static const double s36 = 36.0; // Display Small
  static const double s32 = 32.0; // Headline Large
  static const double s28 = 28.0; // Headline Medium
  static const double s24 = 24.0; // Headline Small
  static const double s22 = 22.0; // Title Large
  static const double s16 = 16.0; // Body Large / Title Medium
  static const double s14 = 14.0; // Body Medium / Label Large
  static const double s12 = 12.0; // Body Small / Label Medium
  static const double s11 = 11.0; // Label Small

  // --- Line Heights ---
  static const double heightTight = 1.1;
  static const double heightNormal = 1.25;
  static const double heightRelaxed = 1.5;
}
