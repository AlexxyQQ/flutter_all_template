import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../../core/common/presentation/extensions/theme/theme_extension.dart';

class DcContextExtension extends StatelessWidget {
  const DcContextExtension({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 16.horizontalPadding,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                color: context.colors.surface,
                child: Container(
                  margin: 8.allPadding,
                  color: context.colors.onSurface,
                ),
              ),
              12.horizontalGap,
              Container(
                width: 50.w,
                height: 50.w,
                color: context.colors.surfaceContainerHighest,
                child: Container(
                  margin: 8.allPadding,
                  color: context.tokens.success.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
