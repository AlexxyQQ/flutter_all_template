import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Helpers for keeping the user's text-size preference while protecting
/// layouts from extreme values.
abstract final class AppTextScaler {
  static const double defaultMin = 0.85;
  static const double defaultMax = 1.6;

  /// Returns [scaler] clamped to [[minScaleFactor], [maxScaleFactor]].
  static TextScaler clamp(
    TextScaler scaler, {
    double minScaleFactor = defaultMin,
    double maxScaleFactor = defaultMax,
  }) => scaler.clamp(
    minScaleFactor: minScaleFactor,
    maxScaleFactor: math.max(minScaleFactor, maxScaleFactor),
  );

  /// `MaterialApp.builder`-compatible wrapper that clamps the ambient
  /// [MediaQueryData.textScaler]:
  ///
  /// ```dart
  /// MaterialApp.router(builder: AppTextScaler.builder(), …)
  /// ```
  static TransitionBuilder builder({
    double minScaleFactor = defaultMin,
    double maxScaleFactor = defaultMax,
  }) => (context, child) {
    final mq = MediaQuery.of(context);
    return MediaQuery(
      data: mq.copyWith(
        textScaler: clamp(
          mq.textScaler,
          minScaleFactor: minScaleFactor,
          maxScaleFactor: maxScaleFactor,
        ),
      ),
      child: child ?? const SizedBox.shrink(),
    );
  };
}
