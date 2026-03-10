import '../../../../../config/constants/text/material/app_material_text_style.dart';
import '../../../../abstract/presentation/abstract_material_app_text_style.dart';
import '../../../../abstract/presentation/abstract_material_color_semantic.dart';
import '../../views/components/text_style.dart';

class ContextMaterialTextStyles implements IAppMaterialTextStyles {
  const ContextMaterialTextStyles(this._colors);
  final MaterialSemanticColors _colors;

  // --- Display (Eczar) ---
  @override
  KTextStyle get displayLarge =>
      AppMaterialTextStyles.displayLarge.copyWith(color: _colors.onSurface);
  @override
  KTextStyle get displayMedium =>
      AppMaterialTextStyles.displayMedium.copyWith(color: _colors.onSurface);
  @override
  KTextStyle get displaySmall =>
      AppMaterialTextStyles.displaySmall.copyWith(color: _colors.onSurface);

  // --- Headline (Eczar) ---
  @override
  KTextStyle get headlineLarge =>
      AppMaterialTextStyles.headlineLarge.copyWith(color: _colors.onSurface);
  @override
  KTextStyle get headlineMedium =>
      AppMaterialTextStyles.headlineMedium.copyWith(color: _colors.onSurface);
  @override
  KTextStyle get headlineSmall =>
      AppMaterialTextStyles.headlineSmall.copyWith(color: _colors.onSurface);

  // --- Title (Eczar) ---
  @override
  KTextStyle get titleLarge =>
      AppMaterialTextStyles.titleLarge.copyWith(color: _colors.onSurface);
  @override
  KTextStyle get titleMedium =>
      AppMaterialTextStyles.titleMedium.copyWith(color: _colors.onSurface);
  @override
  KTextStyle get titleSmall =>
      AppMaterialTextStyles.titleSmall.copyWith(color: _colors.onSurface);

  // --- Body (Manrope) ---
  @override
  KTextStyle get bodyLarge =>
      AppMaterialTextStyles.bodyLarge.copyWith(color: _colors.onSurface);
  @override
  KTextStyle get bodyMedium =>
      AppMaterialTextStyles.bodyMedium.copyWith(color: _colors.onSurface);
  @override
  KTextStyle get bodySmall =>
      AppMaterialTextStyles.bodySmall.copyWith(color: _colors.onSurface); // Often used for captions

  // --- Label (Manrope) - Used for buttons, inputs, tags ---
  @override
  KTextStyle get labelLarge =>
      AppMaterialTextStyles.labelLarge.copyWith(color: _colors.onSurface);
  @override
  KTextStyle get labelMedium =>
      AppMaterialTextStyles.labelMedium.copyWith(color: _colors.onSurface);
  @override
  KTextStyle get labelSmall =>
      AppMaterialTextStyles.labelSmall.copyWith(color: _colors.onSurface);
}
