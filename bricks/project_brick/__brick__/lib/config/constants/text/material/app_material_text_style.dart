import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/common/presentation/views/components/text_style.dart';
import 'app_material_text_primitives.dart';

class AppMaterialTextStyles {
  // ===========================================================================
  // HEADINGS (Font: ECZAR)
  // Used for: Display, Headline, Title
  // ===========================================================================

  static KTextStyle get displayLarge => _buildEczar(
    AppMaterialTextPrimitives.s57,
    AppMaterialTextPrimitives.regular,
    height: 1.12, // M3 Spec
    letterSpacing: -0.25,
  );

  static KTextStyle get displayMedium => _buildEczar(
    AppMaterialTextPrimitives.s45,
    AppMaterialTextPrimitives.regular,
    height: 1.16,
  );

  static KTextStyle get displaySmall => _buildEczar(
    AppMaterialTextPrimitives.s36,
    AppMaterialTextPrimitives.regular,
    height: 1.22,
  );

  static KTextStyle get headlineLarge => _buildEczar(
    AppMaterialTextPrimitives.s32,
    AppMaterialTextPrimitives.regular,
    height: 1.25,
  );

  static KTextStyle get headlineMedium => _buildEczar(
    AppMaterialTextPrimitives.s28,
    AppMaterialTextPrimitives.regular,
    height: 1.29,
  );

  static KTextStyle get headlineSmall => _buildEczar(
    AppMaterialTextPrimitives.s24,
    AppMaterialTextPrimitives.regular,
    height: 1.33,
  );

  static KTextStyle get titleLarge => _buildEczar(
    AppMaterialTextPrimitives.s22,
    AppMaterialTextPrimitives.medium, // Titles often need more weight
    height: 1.27,
  );

  static KTextStyle get titleMedium => _buildEczar(
    AppMaterialTextPrimitives.s16,
    AppMaterialTextPrimitives.medium,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static KTextStyle get titleSmall => _buildEczar(
    AppMaterialTextPrimitives.s14,
    AppMaterialTextPrimitives.medium,
    height: 1.43,
    letterSpacing: 0.1,
  );

  // ===========================================================================
  // BODY & LABELS (Font: MANROPE)
  // Used for: Body text, Buttons, Captions, Inputs
  // ===========================================================================

  static KTextStyle get bodyLarge => _buildManrope(
    AppMaterialTextPrimitives.s16,
    AppMaterialTextPrimitives.regular,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static KTextStyle get bodyMedium => _buildManrope(
    AppMaterialTextPrimitives.s14,
    AppMaterialTextPrimitives.regular,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static KTextStyle get bodySmall => _buildManrope(
    AppMaterialTextPrimitives.s12,
    AppMaterialTextPrimitives.regular,
    height: 1.33,
    letterSpacing: 0.4,
  );

  static KTextStyle get labelLarge => _buildManrope(
    AppMaterialTextPrimitives.s14,
    AppMaterialTextPrimitives.medium,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static KTextStyle get labelMedium => _buildManrope(
    AppMaterialTextPrimitives.s12,
    AppMaterialTextPrimitives.medium,
    height: 1.33,
    letterSpacing: 0.5,
  );

  static KTextStyle get labelSmall => _buildManrope(
    AppMaterialTextPrimitives.s11,
    AppMaterialTextPrimitives.medium,
    height: 1.45,
    letterSpacing: 0.5,
  );

  // --- Private Builders ---

  static KTextStyle _buildEczar(
    double size,
    FontWeight weight, {
    double? height,
    double? letterSpacing,
  }) {
    return KTextStyle(
      fontFamily: AppMaterialTextPrimitives.fontHeadings,
      fontSize: size.sp,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static KTextStyle _buildManrope(
    double size,
    FontWeight weight, {
    double? height,
    double? letterSpacing,
  }) {
    return KTextStyle(
      fontFamily: AppMaterialTextPrimitives.fontBody,
      fontSize: size.sp,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
