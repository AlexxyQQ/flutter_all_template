import '../../common/presentation/views/components/app_color.dart';

abstract class MaterialExtendedSemanticColors {
  abstract final KAppColor color;
  abstract final KAppColor onColor;
  abstract final KAppColor colorContainer;
  abstract final KAppColor onColorContainer;
}

abstract class MaterialSemanticColors {
  // --- Primary ---
  abstract final KAppColor primary;
  abstract final KAppColor onPrimary;
  abstract final KAppColor primaryContainer;
  abstract final KAppColor onPrimaryContainer;
  abstract final KAppColor primaryFixed;
  abstract final KAppColor primaryFixedDim;
  abstract final KAppColor onPrimaryFixed;
  abstract final KAppColor onPrimaryFixedVariant;

  // --- Secondary ---
  abstract final KAppColor secondary;
  abstract final KAppColor onSecondary;
  abstract final KAppColor secondaryContainer;
  abstract final KAppColor onSecondaryContainer;
  abstract final KAppColor secondaryFixed;
  abstract final KAppColor secondaryFixedDim;
  abstract final KAppColor onSecondaryFixed;
  abstract final KAppColor onSecondaryFixedVariant;

  // --- Tertiary ---
  abstract final KAppColor tertiary;
  abstract final KAppColor onTertiary;
  abstract final KAppColor tertiaryContainer;
  abstract final KAppColor onTertiaryContainer;
  abstract final KAppColor tertiaryFixed;
  abstract final KAppColor tertiaryFixedDim;
  abstract final KAppColor onTertiaryFixed;
  abstract final KAppColor onTertiaryFixedVariant;

  // --- Error ---
  abstract final KAppColor error;
  abstract final KAppColor onError;
  abstract final KAppColor errorContainer;
  abstract final KAppColor onErrorContainer;

  // --- Surface ---
  abstract final KAppColor surface;
  abstract final KAppColor onSurface;
  abstract final KAppColor surfaceVariant;
  abstract final KAppColor onSurfaceVariant;
  abstract final KAppColor surfaceDim;
  abstract final KAppColor surfaceBright;
  abstract final KAppColor surfaceContainerLowest;
  abstract final KAppColor surfaceContainerLow;
  abstract final KAppColor surfaceContainer;
  abstract final KAppColor surfaceContainerHigh;
  abstract final KAppColor surfaceContainerHighest;

  // --- Utility ---
  abstract final KAppColor outline;
  abstract final KAppColor outlineVariant;
  abstract final KAppColor shadow;
  abstract final KAppColor scrim;
  abstract final KAppColor inverseSurface;
  abstract final KAppColor inverseOnSurface;
  abstract final KAppColor inversePrimary;
  abstract final KAppColor surfaceTint;

  // Extended
  abstract final MaterialExtendedSemanticColors income;
  abstract final MaterialExtendedSemanticColors expense;
  abstract final MaterialExtendedSemanticColors warning;
  abstract final MaterialExtendedSemanticColors saving;
  abstract final MaterialExtendedSemanticColors success;
}
