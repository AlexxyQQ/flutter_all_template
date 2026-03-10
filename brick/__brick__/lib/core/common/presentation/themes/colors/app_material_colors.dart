import 'package:flutter/material.dart';

import '../../../../../config/constants/colors/material/material_semantics.dart';
import '../../../../abstract/presentation/abstract_material_color_semantic.dart';
import '../../views/components/app_color.dart';

class AppMaterialColors {
  static MaterialSemanticColors _current = MaterialLightSemantic();

  static void load(Brightness brightness) {
    _current = (brightness == Brightness.dark)
        ? MaterialDarkSemantic()
        : MaterialLightSemantic();
  }

  static MaterialSemanticColors of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? MaterialDarkSemantic()
        : MaterialLightSemantic();
  }

  // Primary
  static KAppColor get primary => _current.primary;
  static KAppColor get onPrimary => _current.onPrimary;
  static KAppColor get primaryContainer => _current.primaryContainer;
  static KAppColor get onPrimaryContainer => _current.onPrimaryContainer;
  static KAppColor get primaryFixed => _current.primaryFixed;
  static KAppColor get primaryFixedDim => _current.primaryFixedDim;
  static KAppColor get onPrimaryFixed => _current.onPrimaryFixed;
  static KAppColor get onPrimaryFixedVariant => _current.onPrimaryFixedVariant;

  // Secondary
  static KAppColor get secondary => _current.secondary;
  static KAppColor get onSecondary => _current.onSecondary;
  static KAppColor get secondaryContainer => _current.secondaryContainer;
  static KAppColor get onSecondaryContainer => _current.onSecondaryContainer;
  static KAppColor get secondaryFixed => _current.secondaryFixed;
  static KAppColor get secondaryFixedDim => _current.secondaryFixedDim;
  static KAppColor get onSecondaryFixed => _current.onSecondaryFixed;
  static KAppColor get onSecondaryFixedVariant =>
      _current.onSecondaryFixedVariant;

  // Tertiary
  static KAppColor get tertiary => _current.tertiary;
  static KAppColor get onTertiary => _current.onTertiary;
  static KAppColor get tertiaryContainer => _current.tertiaryContainer;
  static KAppColor get onTertiaryContainer => _current.onTertiaryContainer;
  static KAppColor get tertiaryFixed => _current.tertiaryFixed;
  static KAppColor get tertiaryFixedDim => _current.tertiaryFixedDim;
  static KAppColor get onTertiaryFixed => _current.onTertiaryFixed;
  static KAppColor get onTertiaryFixedVariant =>
      _current.onTertiaryFixedVariant;

  // Error
  static KAppColor get error => _current.error;
  static KAppColor get onError => _current.onError;
  static KAppColor get errorContainer => _current.errorContainer;
  static KAppColor get onErrorContainer => _current.onErrorContainer;

  // Surface
  static KAppColor get surface => _current.surface;
  static KAppColor get onSurface => _current.onSurface;
  static KAppColor get surfaceDim => _current.surfaceDim;
  static KAppColor get surfaceBright => _current.surfaceBright;
  static KAppColor get surfaceContainerLowest =>
      _current.surfaceContainerLowest;
  static KAppColor get surfaceContainerLow => _current.surfaceContainerLow;
  static KAppColor get surfaceContainer => _current.surfaceContainer;
  static KAppColor get surfaceContainerHigh => _current.surfaceContainerHigh;
  static KAppColor get surfaceContainerHighest =>
      _current.surfaceContainerHighest;
  static KAppColor get onSurfaceVariant => _current.onSurfaceVariant;
  static KAppColor get surfaceVariant => _current.surfaceVariant;

  // Utility
  static KAppColor get outline => _current.outline;
  static KAppColor get outlineVariant => _current.outlineVariant;
  static KAppColor get shadow => _current.shadow;
  static KAppColor get scrim => _current.scrim;
  static KAppColor get inverseSurface => _current.inverseSurface;
  static KAppColor get inverseOnSurface => _current.inverseOnSurface;
  static KAppColor get inversePrimary => _current.inversePrimary;
  static KAppColor get surfaceTint => _current.surfaceTint;

  // Extended

  static MaterialExtendedSemanticColors get income => _current.income;
  static MaterialExtendedSemanticColors get expense => _current.expense;
  static MaterialExtendedSemanticColors get warning => _current.warning;
  static MaterialExtendedSemanticColors get saving => _current.saving;
  static MaterialExtendedSemanticColors get success => _current.success;
}
