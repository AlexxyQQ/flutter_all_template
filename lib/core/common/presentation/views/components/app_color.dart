import 'dart:ui';

class KAppColor extends Color {
  // 1. Modern constructor using toARGB32 instead of .value
  const KAppColor(super.value);

  // 2. Convenience factory from standard Color
  // We use toARGB32() because .value is deprecated
  factory KAppColor.fromColor(Color color) => KAppColor(color.toARGB32());

  // 3. Helper for hex ints
  static KAppColor color(int value) => KAppColor(value);

  // 4. FIX: Use withValues() instead of withOpacity()
  // This avoids the deprecated withOpacity and handles precision correctly
  @override
  KAppColor withValues({
    double? alpha,
    double? red,
    double? green,
    double? blue,
    ColorSpace? colorSpace,
  }) {
    final Color updated = super.withValues(
      alpha: alpha,
      red: red,
      green: green,
      blue: blue,
      colorSpace: colorSpace,
    );
    return KAppColor(updated.toARGB32());
  }

  // Helper for simple alpha changes (The modern replacement for withOpacity)
  KAppColor withAlphaValue(double opacity) {
    return withValues(alpha: opacity);
  }
}

extension CustomColorConverter on Color {
  /// Converts the current [Color] instance into a [KAppColor].
  KAppColor toCustom() {
    // Uses the explicitly non-deprecated toARGB32 logic
    return KAppColor(toARGB32());
  }
}
