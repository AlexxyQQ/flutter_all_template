import '../../../../../config/constants/text/custom/app_custom_text_style.dart';
import '../../../../abstract/presentation/abstract_custom_app_text_style.dart';
import '../../../../abstract/presentation/abstract_custom_color_semantic.dart';
import '../../views/components/text_style.dart';

class ContextCustomTextStyles implements IAppCustomTextStyles {
  // We inject the current colors here
  const ContextCustomTextStyles(this._colors);
  final AppCustomSemanticColors _colors;

  // --- Global Headings (Usually Standard Text Color) ---
  @override
  KTextStyle get h1 => AppCustomTextStyles.h1.copyWith(color: _colors.text);
  @override
  KTextStyle get h2 => AppCustomTextStyles.h2.copyWith(color: _colors.text);
  @override
  KTextStyle get h3 => AppCustomTextStyles.h3.copyWith(color: _colors.text);

  // --- General Body ---
  @override
  KTextStyle get body => AppCustomTextStyles.body.copyWith(color: _colors.text);
  @override
  KTextStyle get bodySmall =>
      AppCustomTextStyles.bodySmall.copyWith(color: _colors.text);
  @override
  KTextStyle get caption =>
      AppCustomTextStyles.caption.copyWith(color: _colors.text); // Or colors.onDisabled for lighter text
  @override
  KTextStyle get note => AppCustomTextStyles.note.copyWith(color: _colors.text);

  // --- Buttons (Need specific colors based on button type) ---
  @override
  KTextStyle get buttonPrimary =>
      AppCustomTextStyles.buttonPrimary.copyWith(color: _colors.onPrimary);
  @override
  KTextStyle get buttonLarge =>
      AppCustomTextStyles.buttonLarge.copyWith(color: _colors.onPrimary);
  @override
  KTextStyle get buttonMedium =>
      AppCustomTextStyles.buttonMedium.copyWith(color: _colors.onPrimary);
  @override
  KTextStyle get buttonLink =>
      AppCustomTextStyles.buttonLink.copyWith(color: _colors.primary); // Links usually match Primary color

  // --- Navigation & AppBar ---
  @override
  KTextStyle get appBarTitle =>
      AppCustomTextStyles.appBarTitle.copyWith(color: _colors.text);
  @override
  KTextStyle get navLabelActive =>
      AppCustomTextStyles.navLabelActive.copyWith(color: _colors.primary);
  @override
  KTextStyle get navLabelInactive =>
      AppCustomTextStyles.navLabelInactive.copyWith(color: _colors.icon);

  // --- Forms & Inputs ---
  @override
  KTextStyle get inputLabel =>
      AppCustomTextStyles.inputLabel.copyWith(color: _colors.text);
  @override
  KTextStyle get inputText =>
      AppCustomTextStyles.inputText.copyWith(color: _colors.text);
  @override
  KTextStyle get inputHint =>
      AppCustomTextStyles.inputHint.copyWith(color: _colors.onDisabled); // Grayed out
  @override
  KTextStyle get inputError =>
      AppCustomTextStyles.inputError.copyWith(color: _colors.error); // Red

  // --- Component Specifics ---
  @override
  KTextStyle get snackbarText =>
      AppCustomTextStyles.snackbarText.copyWith(color: _colors.onActive);
  @override
  KTextStyle get pillLabel =>
      AppCustomTextStyles.pillLabel.copyWith(color: _colors.onPrimary);
  @override
  KTextStyle get tooltip =>
      AppCustomTextStyles.tooltip.copyWith(color: _colors.onPrimary);
  @override
  KTextStyle get badgeCount =>
      AppCustomTextStyles.badgeCount.copyWith(color: _colors.white);
}
