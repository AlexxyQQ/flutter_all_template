import 'package:flutter/material.dart';

import '../../../../extensions/theme/theme_extension.dart';

class AppCircularLoader extends StatelessWidget {
  const AppCircularLoader({
    super.key,
    this.size = 24.0,
    this.width = 4.0,
    this.color,
  });

  final double size;
  final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        strokeWidth: width,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? context.colors.primary,
        ),
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
