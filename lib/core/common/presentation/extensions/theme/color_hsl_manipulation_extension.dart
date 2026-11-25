import 'package:flutter/material.dart';

import '../../views/components/app_color.dart';

extension HslColorManipulation on KAppColor {
  /// Creates a new color by replacing the existing HSL values with the provided ones.
  ///
  /// You can specify any combination of [hue], [saturation], or [lightness].
  /// Unspecified values will be inherited from the original color.
  /// Alpha (opacity) is always preserved.
  Color withHsl({double? hue, double? saturation, double? lightness}) {
    final hslColor = HSLColor.fromColor(this);

    return HSLColor.fromAHSL(
      hslColor.alpha,
      hue ?? hslColor.hue,
      saturation ?? hslColor.saturation,
      lightness ?? hslColor.lightness,
    ).toColor();
  }

  /// Creates a new color by adjusting the lightness by a given [amount].
  ///
  /// The [amount] is a value between -1.0 and 1.0.
  /// A positive value makes the color lighter, and a negative value makes it darker.
  /// The result is clamped to ensure it remains a valid color.
  Color adjustLightness(double amount) {
    final hslColor = HSLColor.fromColor(this);
    // Clamps the value between 0.0 and 1.0 to prevent invalid lightness values.
    final newLightness = (hslColor.lightness + amount).clamp(0.0, 1.0);
    return hslColor.withLightness(newLightness).toColor();
  }

  /// Creates a new color by adjusting the saturation by a given [amount].
  ///
  /// The [amount] is a value between -1.0 and 1.0.
  /// A positive value makes the color more saturated, and a negative value desaturates it.
  Color adjustSaturation(double amount) {
    final hslColor = HSLColor.fromColor(this);
    // Clamps the value between 0.0 and 1.0.
    final newSaturation = (hslColor.saturation + amount).clamp(0.0, 1.0);
    return hslColor.withSaturation(newSaturation).toColor();
  }

  /// Creates a new color by adjusting the hue by a given [amount].
  ///
  /// The hue value will wrap around the 360-degree color wheel. For example,
  /// adding 20 to a hue of 350 will result in a new hue of 10.
  Color adjustHue(double amount) {
    final hslColor = HSLColor.fromColor(this);
    // The modulo operator (%) handles the circular nature of hue.
    final newHue = (hslColor.hue + amount) % 360.0;
    return hslColor.withHue(newHue).toColor();
  }
}
