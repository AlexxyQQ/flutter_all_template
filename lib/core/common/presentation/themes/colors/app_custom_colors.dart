import 'package:flutter/material.dart';

import '../../../../../config/constants/colors/custom/custom_semantics.dart';
import '../../../../abstract/presentation/abstract_custom_color_semantic.dart';
import '../../views/components/app_color.dart';

class AppCustomColors {
  static AppCustomSemanticColors _current = AppCustomLightSemantics();

  static void load(Brightness brightness) {
    _current = (brightness == Brightness.dark)
        ? AppCustomDarkSemantics()
        : AppCustomLightSemantics();
  }

  static AppCustomSemanticColors of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? AppCustomDarkSemantics()
        : AppCustomLightSemantics();
  }

  // This allows you to use AppColors.primary
  static KAppColor get primary => _current.primary;
  static KAppColor get onPrimary => _current.onPrimary;
  static KAppColor get secondary => _current.secondary;
  static KAppColor get onSecondary => _current.onSecondary;
  static KAppColor get tertiary => _current.tertiary;
  static KAppColor get onTertiary => _current.onTertiary;

  static KAppColor get active => _current.active;
  static KAppColor get onActive => _current.onActive;
  static KAppColor get disabled => _current.disabled;
  static KAppColor get onDisabled => _current.onDisabled;

  static KAppColor get icon => _current.icon;
  static KAppColor get disabledIcon => _current.disabledIcon;
  static KAppColor get selectedIcon => _current.selectedIcon;

  static KAppColor get border => _current.border;
  static KAppColor get selectedBorder => _current.selectedBorder;
  static KAppColor get disabledBorder => _current.disabledBorder;
  static KAppColor get errorBorder => _current.errorBorder;

  static KAppColor get background => _current.background;
  static KAppColor get text => _current.text;

  static KAppColor get success => _current.success;
  static KAppColor get onSuccess => _current.onSuccess;
  static KAppColor get warning => _current.warning;
  static KAppColor get onWarning => _current.onWarning;
  static KAppColor get error => _current.error;
  static KAppColor get onError => _current.onError;
  static KAppColor get errorDisabled => _current.errorDisabled;

  static KAppColor get transparent => _current.transparent;
  static KAppColor get white => _current.white;
  static KAppColor get black => _current.black;
}
