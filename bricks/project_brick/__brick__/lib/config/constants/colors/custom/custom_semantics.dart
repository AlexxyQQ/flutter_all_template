import '../../../../core/abstract/presentation/abstract_custom_color_semantic.dart';
import '../../../../core/common/presentation/views/components/app_color.dart';
import 'custom_primitive_colors.dart';

/// LIGHT THEME IMPLEMENTATION
class AppCustomLightSemantics implements AppCustomSemanticColors {
  @override
  KAppColor get primary => AppCustomPrimitives.ocean500;
  @override
  KAppColor get onPrimary => AppCustomPrimitives.ocean50;
  @override
  KAppColor get secondary => AppCustomPrimitives.yellow500;
  @override
  KAppColor get onSecondary => AppCustomPrimitives.yellow50;
  @override
  KAppColor get tertiary => AppCustomPrimitives.blue500;
  @override
  KAppColor get onTertiary => AppCustomPrimitives.blue50;

  @override
  KAppColor get active => AppCustomPrimitives.ocean500;
  @override
  KAppColor get onActive => AppCustomPrimitives.white;
  @override
  KAppColor get disabled => AppCustomPrimitives.gray200;
  @override
  KAppColor get onDisabled => AppCustomPrimitives.gray400;

  @override
  KAppColor get icon => AppCustomPrimitives.gray700;
  @override
  KAppColor get disabledIcon => AppCustomPrimitives.gray300;
  @override
  KAppColor get selectedIcon => AppCustomPrimitives.ocean500;

  @override
  KAppColor get border => AppCustomPrimitives.gray300;
  @override
  KAppColor get selectedBorder => AppCustomPrimitives.ocean500;
  @override
  KAppColor get disabledBorder => AppCustomPrimitives.gray300;
  @override
  KAppColor get errorBorder => AppCustomPrimitives.danger;

  @override
  KAppColor get background => AppCustomPrimitives.gray50;
  @override
  KAppColor get text => AppCustomPrimitives.gray900;

  @override
  KAppColor get success => AppCustomPrimitives.success;
  @override
  KAppColor get onSuccess => AppCustomPrimitives.white;
  @override
  KAppColor get warning => AppCustomPrimitives.warning;
  @override
  KAppColor get onWarning => AppCustomPrimitives.white;
  @override
  KAppColor get error => AppCustomPrimitives.danger;
  @override
  KAppColor get onError => AppCustomPrimitives.white;
  @override
  KAppColor get errorDisabled => AppCustomPrimitives.dangerLight;

  @override
  KAppColor get black => AppCustomPrimitives.black;

  @override
  KAppColor get transparent => AppCustomPrimitives.transparent;

  @override
  KAppColor get white => AppCustomPrimitives.white;
}

/// DARK THEME IMPLEMENTATION
class AppCustomDarkSemantics implements AppCustomSemanticColors {
  @override
  KAppColor get primary => AppCustomPrimitives.ocean900;
  @override
  KAppColor get onPrimary => AppCustomPrimitives.ocean100;
  @override
  KAppColor get secondary => AppCustomPrimitives.yellow900;
  @override
  KAppColor get onSecondary => AppCustomPrimitives.yellow100;
  @override
  KAppColor get tertiary => AppCustomPrimitives.blue900;
  @override
  KAppColor get onTertiary => AppCustomPrimitives.blue100;

  @override
  KAppColor get active => AppCustomPrimitives.ocean500;
  @override
  KAppColor get onActive => AppCustomPrimitives.white;
  @override
  KAppColor get disabled => AppCustomPrimitives.gray800;
  @override
  KAppColor get onDisabled => AppCustomPrimitives.gray600;

  @override
  KAppColor get icon => AppCustomPrimitives.gray300;
  @override
  KAppColor get disabledIcon => AppCustomPrimitives.gray700;
  @override
  KAppColor get selectedIcon => AppCustomPrimitives.ocean100;

  @override
  KAppColor get border => AppCustomPrimitives.gray700;
  @override
  KAppColor get selectedBorder => AppCustomPrimitives.ocean100;
  @override
  KAppColor get disabledBorder => AppCustomPrimitives.gray700;
  @override
  KAppColor get errorBorder => AppCustomPrimitives.danger;

  @override
  KAppColor get background => AppCustomPrimitives.gray900;
  @override
  KAppColor get text => AppCustomPrimitives.gray50;

  @override
  KAppColor get success => AppCustomPrimitives.success;
  @override
  KAppColor get onSuccess => AppCustomPrimitives.white;
  @override
  KAppColor get warning => AppCustomPrimitives.warning;
  @override
  KAppColor get onWarning => AppCustomPrimitives.white;
  @override
  KAppColor get error => AppCustomPrimitives.danger;
  @override
  KAppColor get onError => AppCustomPrimitives.white;
  @override
  KAppColor get errorDisabled => AppCustomPrimitives.dangerLight;

  @override
  KAppColor get black => AppCustomPrimitives.black;

  @override
  KAppColor get transparent => AppCustomPrimitives.transparent;

  @override
  KAppColor get white => AppCustomPrimitives.white;
}
