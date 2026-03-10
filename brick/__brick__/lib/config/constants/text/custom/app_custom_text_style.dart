import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/presentation/views/components/text_style.dart';
import 'app_custom_text_primitives.dart';

class AppCustomTextStyles {
  // --- Global Headings ---
  static KTextStyle get h1 => _build(
    AppCustomTextPrimitives.s32,
    AppCustomTextPrimitives.bold,
    height: AppCustomTextPrimitives.heightTight,
  );
  static KTextStyle get h2 =>
      _build(AppCustomTextPrimitives.s24, AppCustomTextPrimitives.semibold);
  static KTextStyle get h3 =>
      _build(AppCustomTextPrimitives.s20, AppCustomTextPrimitives.semibold);

  // --- General Body ---
  static KTextStyle get body =>
      _build(AppCustomTextPrimitives.s16, AppCustomTextPrimitives.regular);
  static KTextStyle get bodySmall =>
      _build(AppCustomTextPrimitives.s14, AppCustomTextPrimitives.regular);
  static KTextStyle get caption =>
      _build(AppCustomTextPrimitives.s12, AppCustomTextPrimitives.regular);
  static KTextStyle get note => _build(
    AppCustomTextPrimitives.s10,
    AppCustomTextPrimitives.regular,
    fontStyle: FontStyle.italic,
  );

  // --- Buttons ---
  static KTextStyle get buttonPrimary =>
      _build(AppCustomTextPrimitives.s16, AppCustomTextPrimitives.semibold);
  static KTextStyle get buttonLarge =>
      _build(AppCustomTextPrimitives.s16, AppCustomTextPrimitives.semibold);
  static KTextStyle get buttonMedium =>
      _build(AppCustomTextPrimitives.s14, AppCustomTextPrimitives.semibold);
  static KTextStyle get buttonLink =>
      _build(AppCustomTextPrimitives.s14, AppCustomTextPrimitives.medium);

  // --- Navigation & AppBar ---
  static KTextStyle get appBarTitle =>
      _build(AppCustomTextPrimitives.s18, AppCustomTextPrimitives.semibold);
  static KTextStyle get navLabelActive =>
      _build(AppCustomTextPrimitives.s12, AppCustomTextPrimitives.semibold);
  static KTextStyle get navLabelInactive =>
      _build(AppCustomTextPrimitives.s12, AppCustomTextPrimitives.medium);

  // --- Forms & Inputs ---
  static KTextStyle get inputLabel =>
      _build(AppCustomTextPrimitives.s14, AppCustomTextPrimitives.medium);
  static KTextStyle get inputText =>
      _build(AppCustomTextPrimitives.s16, AppCustomTextPrimitives.regular);
  static KTextStyle get inputHint =>
      _build(AppCustomTextPrimitives.s16, AppCustomTextPrimitives.regular);
  static KTextStyle get inputError =>
      _build(AppCustomTextPrimitives.s12, AppCustomTextPrimitives.medium);

  // --- Component Specifics ---
  static KTextStyle get snackbarText =>
      _build(AppCustomTextPrimitives.s14, AppCustomTextPrimitives.medium);
  static KTextStyle get pillLabel =>
      _build(AppCustomTextPrimitives.s10, AppCustomTextPrimitives.bold);
  static KTextStyle get tooltip =>
      _build(AppCustomTextPrimitives.s12, AppCustomTextPrimitives.regular);
  static KTextStyle get badgeCount =>
      _build(AppCustomTextPrimitives.s10, AppCustomTextPrimitives.bold);

  // Private builder
  static KTextStyle _build(
    double size,
    FontWeight weight, {
    double? height,
    FontStyle? fontStyle,
  }) {
    return KTextStyle(
      fontFamily: AppCustomTextPrimitives.fontFamily,
      fontSize: size.sp,
      fontWeight: weight,
      height: height,
      letterSpacing: size < 14 ? 0.2 : 0, // Slight tracking for small text
    );
  }
}
