import 'package:flutter/material.dart';

import '../constants/colors/material/material_primitive_colors.dart';

/// A role colour with its "on" colour and container pair, mirroring how
/// Material 3 models `primary` / `onPrimary` / `primaryContainer` /
/// `onPrimaryContainer`.
@immutable
class AppSemanticColor {
  const AppSemanticColor({
    required this.color,
    required this.onColor,
    required this.container,
    required this.onContainer,
  });

  final Color color;
  final Color onColor;
  final Color container;
  final Color onContainer;

  static AppSemanticColor lerp(
    AppSemanticColor a,
    AppSemanticColor b,
    double t,
  ) => AppSemanticColor(
    color: Color.lerp(a.color, b.color, t)!,
    onColor: Color.lerp(a.onColor, b.onColor, t)!,
    container: Color.lerp(a.container, b.container, t)!,
    onContainer: Color.lerp(a.onContainer, b.onContainer, t)!,
  );

  @override
  bool operator ==(Object other) =>
      other is AppSemanticColor &&
      other.color == color &&
      other.onColor == onColor &&
      other.container == container &&
      other.onContainer == onContainer;

  @override
  int get hashCode => Object.hash(color, onColor, container, onContainer);
}

/// App-specific design tokens that Material's [ColorScheme] has no slot for.
///
/// Registered on [ThemeData.extensions] by `AppTheme`; read it with
/// `context.tokens` (or `Theme.of(context).extension<AppTokens>()!`).
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.success,
    required this.warning,
    required this.info,
    required this.income,
    required this.expense,
    required this.saving,
  });

  /// Positive outcome (e.g. "saved", "granted").
  final AppSemanticColor success;

  /// Needs attention but is not an error.
  final AppSemanticColor warning;

  /// Neutral information (snackbars, banners).
  final AppSemanticColor info;

  /// Domain examples kept from the original template palette.
  final AppSemanticColor income;
  final AppSemanticColor expense;
  final AppSemanticColor saving;

  static const AppTokens light = AppTokens(
    success: AppSemanticColor(
      color: AppMaterialPrimitives.grass,
      onColor: AppMaterialPrimitives.grass100,
      container: AppMaterialPrimitives.grass90,
      onContainer: AppMaterialPrimitives.grass10,
    ),
    warning: AppSemanticColor(
      color: AppMaterialPrimitives.tori,
      onColor: AppMaterialPrimitives.tori100,
      container: AppMaterialPrimitives.tori90,
      onContainer: AppMaterialPrimitives.tori10,
    ),
    info: AppSemanticColor(
      color: AppMaterialPrimitives.secondary40,
      onColor: AppMaterialPrimitives.secondary100,
      container: AppMaterialPrimitives.secondary90,
      onContainer: AppMaterialPrimitives.secondary10,
    ),
    income: AppSemanticColor(
      color: AppMaterialPrimitives.grass,
      onColor: AppMaterialPrimitives.grass100,
      container: AppMaterialPrimitives.grass90,
      onContainer: AppMaterialPrimitives.grass10,
    ),
    expense: AppSemanticColor(
      color: AppMaterialPrimitives.terracotta,
      onColor: AppMaterialPrimitives.terracotta100,
      container: AppMaterialPrimitives.terracotta90,
      onContainer: AppMaterialPrimitives.terracotta10,
    ),
    saving: AppSemanticColor(
      color: AppMaterialPrimitives.marigold,
      onColor: AppMaterialPrimitives.marigold100,
      container: AppMaterialPrimitives.marigold90,
      onContainer: AppMaterialPrimitives.marigold10,
    ),
  );

  static const AppTokens dark = AppTokens(
    success: AppSemanticColor(
      color: AppMaterialPrimitives.grass80,
      onColor: AppMaterialPrimitives.grass10,
      container: AppMaterialPrimitives.grass20,
      onContainer: AppMaterialPrimitives.grass90,
    ),
    warning: AppSemanticColor(
      color: AppMaterialPrimitives.tori80,
      onColor: AppMaterialPrimitives.tori10,
      container: AppMaterialPrimitives.tori20,
      onContainer: AppMaterialPrimitives.tori90,
    ),
    info: AppSemanticColor(
      color: AppMaterialPrimitives.secondary80,
      onColor: AppMaterialPrimitives.secondary10,
      container: AppMaterialPrimitives.secondary20,
      onContainer: AppMaterialPrimitives.secondary90,
    ),
    income: AppSemanticColor(
      color: AppMaterialPrimitives.grass80,
      onColor: AppMaterialPrimitives.grass10,
      container: AppMaterialPrimitives.grass20,
      onContainer: AppMaterialPrimitives.grass90,
    ),
    expense: AppSemanticColor(
      color: AppMaterialPrimitives.terracotta80,
      onColor: AppMaterialPrimitives.terracotta10,
      container: AppMaterialPrimitives.terracotta20,
      onContainer: AppMaterialPrimitives.terracotta90,
    ),
    saving: AppSemanticColor(
      color: AppMaterialPrimitives.marigold80,
      onColor: AppMaterialPrimitives.marigold10,
      container: AppMaterialPrimitives.marigold20,
      onContainer: AppMaterialPrimitives.marigold90,
    ),
  );

  @override
  AppTokens copyWith({
    AppSemanticColor? success,
    AppSemanticColor? warning,
    AppSemanticColor? info,
    AppSemanticColor? income,
    AppSemanticColor? expense,
    AppSemanticColor? saving,
  }) => AppTokens(
    success: success ?? this.success,
    warning: warning ?? this.warning,
    info: info ?? this.info,
    income: income ?? this.income,
    expense: expense ?? this.expense,
    saving: saving ?? this.saving,
  );

  @override
  AppTokens lerp(covariant AppTokens? other, double t) {
    if (other == null) {
      return this;
    }
    return AppTokens(
      success: AppSemanticColor.lerp(success, other.success, t),
      warning: AppSemanticColor.lerp(warning, other.warning, t),
      info: AppSemanticColor.lerp(info, other.info, t),
      income: AppSemanticColor.lerp(income, other.income, t),
      expense: AppSemanticColor.lerp(expense, other.expense, t),
      saving: AppSemanticColor.lerp(saving, other.saving, t),
    );
  }
}
