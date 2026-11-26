import 'package:flutter/material.dart';

import '../../../extensions/theme/theme_extension.dart';

class AppDivider extends StatelessWidget {
  const AppDivider._({
    this.color,
    this.isVertical = false,
    this.thickness = 1.0,
    this.size,
  });

  /// Factory for horizontal divider
  factory AppDivider.horizontal({Color? color, double thickness = 1.0}) {
    return AppDivider._(color: color, thickness: thickness);
  }

  /// Factory for vertical divider
  factory AppDivider.vertical({
    Color? color,
    double thickness = 1.0,
    double? height,
  }) {
    return AppDivider._(
      color: color,
      isVertical: true,
      thickness: thickness,
      size: height,
    );
  }

  final Color? color;
  final bool isVertical;
  final double thickness;
  final double? size;

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      // ignore: avoid_sized_box_height
      return SizedBox(
        height: size,
        child: VerticalDivider(
          color: color ?? context.colors.outline,
          thickness: thickness,
          width: thickness,
        ),
      );
    }

    return Divider(
      color: color ?? context.colors.outline,
      thickness: thickness,
      height: 1.0,
    );
  }
}
