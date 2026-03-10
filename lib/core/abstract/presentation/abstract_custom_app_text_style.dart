import '../../common/presentation/views/components/text_style.dart';

abstract class IAppCustomTextStyles {
  // --- Global Headings ---
  KTextStyle get h1;
  KTextStyle get h2;
  KTextStyle get h3;

  // --- General Body ---
  KTextStyle get body;
  KTextStyle get bodySmall;
  KTextStyle get caption;
  KTextStyle get note;
  // --- Buttons ---
  KTextStyle get buttonPrimary;
  KTextStyle get buttonLarge;
  KTextStyle get buttonMedium;
  KTextStyle get buttonLink;

  // --- Navigation & AppBar ---
  KTextStyle get appBarTitle;
  KTextStyle get navLabelActive;
  KTextStyle get navLabelInactive;

  // --- Forms & Inputs ---
  KTextStyle get inputLabel;
  KTextStyle get inputText;
  KTextStyle get inputHint;
  KTextStyle get inputError;

  // --- Component Specifics ---
  KTextStyle get snackbarText;
  KTextStyle get pillLabel;
  KTextStyle get tooltip;
  KTextStyle get badgeCount;
}
