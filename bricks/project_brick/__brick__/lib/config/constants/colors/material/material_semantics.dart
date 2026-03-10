import '../../../../core/abstract/presentation/abstract_material_color_semantic.dart';
import '../../../../core/common/presentation/views/components/app_color.dart';
import 'material_primitive_colors.dart';

class ExtendedSemanticColorsImpl implements MaterialExtendedSemanticColors {
  const ExtendedSemanticColorsImpl({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  @override
  final KAppColor color;
  @override
  final KAppColor onColor;
  @override
  final KAppColor colorContainer;
  @override
  final KAppColor onColorContainer;
}

class MaterialLightSemantic implements MaterialSemanticColors {
  @override
  final KAppColor primary = AppMaterialPrimitives.primary40;
  @override
  final KAppColor onPrimary = AppMaterialPrimitives.primary100;
  @override
  final KAppColor primaryContainer = AppMaterialPrimitives.primary90; // Approx #BCF0B4
  @override
  final KAppColor onPrimaryContainer = AppMaterialPrimitives.primary10; // Approx #245024
  @override
  final KAppColor primaryFixed = AppMaterialPrimitives.primary90;
  @override
  final KAppColor primaryFixedDim = AppMaterialPrimitives.primary80;
  @override
  final KAppColor onPrimaryFixed = AppMaterialPrimitives.primary10;
  @override
  final KAppColor onPrimaryFixedVariant = AppMaterialPrimitives.primary30;

  @override
  final KAppColor secondary = AppMaterialPrimitives.secondary40;
  @override
  final KAppColor onSecondary = AppMaterialPrimitives.secondary100;
  @override
  final KAppColor secondaryContainer = AppMaterialPrimitives.secondary90;
  @override
  final KAppColor onSecondaryContainer = AppMaterialPrimitives.secondary10;
  @override
  final KAppColor secondaryFixed = AppMaterialPrimitives.secondary90;
  @override
  final KAppColor secondaryFixedDim = AppMaterialPrimitives.secondary80;
  @override
  final KAppColor onSecondaryFixed = AppMaterialPrimitives.secondary10;
  @override
  final KAppColor onSecondaryFixedVariant = AppMaterialPrimitives.secondary30;

  @override
  final KAppColor tertiary = AppMaterialPrimitives.tertiary40;
  @override
  final KAppColor onTertiary = AppMaterialPrimitives.tertiary100;
  @override
  final KAppColor tertiaryContainer = AppMaterialPrimitives.tertiary90;
  @override
  final KAppColor onTertiaryContainer = AppMaterialPrimitives.tertiary10;
  @override
  final KAppColor tertiaryFixed = AppMaterialPrimitives.tertiary90;
  @override
  final KAppColor tertiaryFixedDim = AppMaterialPrimitives.tertiary80;
  @override
  final KAppColor onTertiaryFixed = AppMaterialPrimitives.tertiary10;
  @override
  final KAppColor onTertiaryFixedVariant = AppMaterialPrimitives.tertiary30;

  @override
  final KAppColor error = AppMaterialPrimitives.error40; // Mapped to error as per your JSON
  @override
  final KAppColor onError = AppMaterialPrimitives.error100;
  @override
  final KAppColor errorContainer = AppMaterialPrimitives.error90;
  @override
  final KAppColor onErrorContainer = AppMaterialPrimitives.error10;

  @override
  final KAppColor surface = AppMaterialPrimitives.neutral99;
  @override
  final KAppColor onSurface = AppMaterialPrimitives.neutral10;
  @override
  final KAppColor surfaceVariant = AppMaterialPrimitives.neutralVariant90;
  @override
  final KAppColor onSurfaceVariant = AppMaterialPrimitives.neutralVariant30;
  @override
  final KAppColor surfaceDim = AppMaterialPrimitives.neutral90;
  @override
  final KAppColor surfaceBright = AppMaterialPrimitives.neutral99;
  @override
  final KAppColor surfaceContainerLowest = AppMaterialPrimitives.neutral100;
  @override
  final KAppColor surfaceContainerLow = AppMaterialPrimitives.neutral95;
  @override
  final KAppColor surfaceContainer = AppMaterialPrimitives.neutral90;
  @override
  final KAppColor surfaceContainerHigh = AppMaterialPrimitives.neutral80;
  @override
  final KAppColor surfaceContainerHighest = AppMaterialPrimitives.neutral70;

  @override
  final KAppColor outline = AppMaterialPrimitives.neutralVariant50;
  @override
  final KAppColor outlineVariant = AppMaterialPrimitives.neutralVariant80;
  @override
  final KAppColor shadow = AppMaterialPrimitives.black;
  @override
  final KAppColor scrim = AppMaterialPrimitives.black;
  @override
  final KAppColor inverseSurface = AppMaterialPrimitives.neutral20;
  @override
  final KAppColor inverseOnSurface = AppMaterialPrimitives.neutral95;
  @override
  final KAppColor inversePrimary = AppMaterialPrimitives.primary80;
  @override
  final KAppColor surfaceTint = AppMaterialPrimitives.primary40;

  // --- Extended Colors (Light) ---
  @override
  final income = const ExtendedSemanticColorsImpl(
    color: AppMaterialPrimitives.grass,
    onColor: AppMaterialPrimitives.grass100,
    colorContainer: AppMaterialPrimitives.grass90,
    onColorContainer: AppMaterialPrimitives.grass10,
  );

  @override
  final expense = const ExtendedSemanticColorsImpl(
    color: AppMaterialPrimitives.terracotta,
    onColor: AppMaterialPrimitives.terracotta100,
    colorContainer: AppMaterialPrimitives.terracotta90,
    onColorContainer: AppMaterialPrimitives.terracotta10,
  );

  @override
  final warning = const ExtendedSemanticColorsImpl(
    color: AppMaterialPrimitives.tori,
    onColor: AppMaterialPrimitives.tori100,
    colorContainer: AppMaterialPrimitives.tori90,
    onColorContainer: AppMaterialPrimitives.primary10,
  );

  @override
  final saving = const ExtendedSemanticColorsImpl(
    color: AppMaterialPrimitives.marigold,
    onColor: AppMaterialPrimitives.marigold100,
    colorContainer: AppMaterialPrimitives.marigold90,
    onColorContainer: AppMaterialPrimitives.marigold10,
  );

  @override
  final success = const ExtendedSemanticColorsImpl(
    color: AppMaterialPrimitives.grass,
    onColor: AppMaterialPrimitives.grass100,
    colorContainer: AppMaterialPrimitives.grass90,
    onColorContainer: AppMaterialPrimitives.grass10,
  );
}

class MaterialDarkSemantic implements MaterialSemanticColors {
  @override
  final KAppColor primary = AppMaterialPrimitives.primary80;
  @override
  final KAppColor onPrimary = AppMaterialPrimitives.primary10;
  @override
  final KAppColor primaryContainer = AppMaterialPrimitives.primary20;
  @override
  final KAppColor onPrimaryContainer = AppMaterialPrimitives.primary90;
  @override
  final KAppColor primaryFixed = AppMaterialPrimitives.primary90;
  @override
  final KAppColor primaryFixedDim = AppMaterialPrimitives.primary80;
  @override
  final KAppColor onPrimaryFixed = AppMaterialPrimitives.primary10;
  @override
  final KAppColor onPrimaryFixedVariant = AppMaterialPrimitives.primary30;

  @override
  final KAppColor secondary = AppMaterialPrimitives.secondary80;
  @override
  final KAppColor onSecondary = AppMaterialPrimitives.secondary10;
  @override
  final KAppColor secondaryContainer = AppMaterialPrimitives.secondary20;
  @override
  final KAppColor onSecondaryContainer = AppMaterialPrimitives.secondary90;
  @override
  final KAppColor secondaryFixed = AppMaterialPrimitives.secondary90;
  @override
  final KAppColor secondaryFixedDim = AppMaterialPrimitives.secondary80;
  @override
  final KAppColor onSecondaryFixed = AppMaterialPrimitives.secondary10;
  @override
  final KAppColor onSecondaryFixedVariant = AppMaterialPrimitives.secondary30;

  @override
  final KAppColor tertiary = AppMaterialPrimitives.tertiary80;
  @override
  final KAppColor onTertiary = AppMaterialPrimitives.tertiary10;
  @override
  final KAppColor tertiaryContainer = AppMaterialPrimitives.tertiary20;
  @override
  final KAppColor onTertiaryContainer = AppMaterialPrimitives.tertiary90;
  @override
  final KAppColor tertiaryFixed = AppMaterialPrimitives.tertiary90;
  @override
  final KAppColor tertiaryFixedDim = AppMaterialPrimitives.tertiary80;
  @override
  final KAppColor onTertiaryFixed = AppMaterialPrimitives.tertiary10;
  @override
  final KAppColor onTertiaryFixedVariant = AppMaterialPrimitives.tertiary30;

  @override
  final KAppColor error = AppMaterialPrimitives.error80;
  @override
  final KAppColor onError = AppMaterialPrimitives.error10;
  @override
  final KAppColor errorContainer = AppMaterialPrimitives.error20;
  @override
  final KAppColor onErrorContainer = AppMaterialPrimitives.error90;

  @override
  final KAppColor surface = AppMaterialPrimitives.neutral10;
  @override
  final KAppColor onSurface = AppMaterialPrimitives.neutral90;
  @override
  final KAppColor surfaceVariant = AppMaterialPrimitives.neutralVariant30;
  @override
  final KAppColor onSurfaceVariant = AppMaterialPrimitives.neutralVariant80;
  @override
  final KAppColor surfaceDim = AppMaterialPrimitives.neutral5;
  @override
  final KAppColor surfaceBright = AppMaterialPrimitives.neutral30;
  @override
  final KAppColor surfaceContainerLowest = AppMaterialPrimitives.neutral0;
  @override
  final KAppColor surfaceContainerLow = AppMaterialPrimitives.neutral10;
  @override
  final KAppColor surfaceContainer = AppMaterialPrimitives.neutral15;
  @override
  final KAppColor surfaceContainerHigh = AppMaterialPrimitives.neutral20;
  @override
  final KAppColor surfaceContainerHighest = AppMaterialPrimitives.neutral25;

  @override
  final KAppColor outline = AppMaterialPrimitives.neutralVariant60;
  @override
  final KAppColor outlineVariant = AppMaterialPrimitives.neutralVariant30;
  @override
  final KAppColor shadow = AppMaterialPrimitives.black;
  @override
  final KAppColor scrim = AppMaterialPrimitives.black;
  @override
  final KAppColor inverseSurface = AppMaterialPrimitives.neutral90;
  @override
  final KAppColor inverseOnSurface = AppMaterialPrimitives.neutral20;
  @override
  final KAppColor inversePrimary = AppMaterialPrimitives.primary40;
  @override
  final KAppColor surfaceTint = AppMaterialPrimitives.primary80;

  // --- Extended Colors (Dark) ---
  @override
  final income = const ExtendedSemanticColorsImpl(
    color: AppMaterialPrimitives.grass80,
    onColor: AppMaterialPrimitives.grass10,
    colorContainer: AppMaterialPrimitives.grass20,
    onColorContainer: AppMaterialPrimitives.grass90,
  );

  @override
  final expense = const ExtendedSemanticColorsImpl(
    color: AppMaterialPrimitives.terracotta80,
    onColor: AppMaterialPrimitives.terracotta10,
    colorContainer: AppMaterialPrimitives.terracotta20,
    onColorContainer: AppMaterialPrimitives.terracotta90,
  );

  @override
  final warning = const ExtendedSemanticColorsImpl(
    color: AppMaterialPrimitives.tori80,
    onColor: AppMaterialPrimitives.tori10,
    colorContainer: AppMaterialPrimitives.tori20,
    onColorContainer: AppMaterialPrimitives.tori90,
  );

  @override
  final saving = const ExtendedSemanticColorsImpl(
    color: AppMaterialPrimitives.marigold80,
    onColor: AppMaterialPrimitives.marigold10,
    colorContainer: AppMaterialPrimitives.marigold20,
    onColorContainer: AppMaterialPrimitives.marigold90,
  );

  @override
  final success = const ExtendedSemanticColorsImpl(
    color: AppMaterialPrimitives.grass80,
    onColor: AppMaterialPrimitives.grass10,
    colorContainer: AppMaterialPrimitives.grass20,
    onColorContainer: AppMaterialPrimitives.grass90,
  );
}
