import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../config/constants/paths/app_path.dart';
import '../../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../../core/common/presentation/routes/app_router.gr.dart';
import '../../../../../../core/common/presentation/views/widgets/system/app_button.dart';
import '../design_components_widgets.dart';

class DcNavigation extends StatelessWidget {
  const DcNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 16.allPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderSection(
            title: LocaleKeys
                .features_home_presentation_views_screens_home_screen_title,
          ),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: [
              AppButton.stroke(
                onPressed: () => context.router.push(const HomeRoute()),
                label: LocaleKeys
                    .features_home_presentation_views_screens_home_screen_title,
              ),
              AppButton.stroke(
                onPressed: () => context.router.pushPath(
                  '${AppPaths.permission}/${AppPaths.notificationPermission}',
                ),
                label: LocaleKeys
                    .core_common_features_permission_presentation_screens_notification_permission_screen_title,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
