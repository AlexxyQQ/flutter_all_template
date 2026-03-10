import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../config/constants/paths/app_path.dart';
import '../../../../../../core/common/domain/services/navigation/navigation_service.dart';
import '../../../../../../core/common/locator/service_locator.dart';
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
            title: 'LocaleKeys.common_sentences_navigations_to_another_feature',
          ),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: [
              AppButton.stroke(
                onPressed: () {
                  sl<NavigationService>().push(const AnotherScreenRoute());
                },
                label: 'LocaleKeys.common_sentences_to_another_screen',
              ),
              AppButton.stroke(
                onPressed: () {
                  sl<NavigationService>().pushNamed(
                    '${AppPaths.anotherFeature}/${AppPaths.notificationDebugger}',
                  );
                },
                label: 'LocaleKeys.common_sentences_to_notification_debugger',
              ),
              AppButton.stroke(
                onPressed: () {
                  // sl<NavigationService>().push(
                  //   const PermissionTestScreenRoute(),
                  // );
                },
                label: 'LocaleKeys.common_sentences_to_permission_test',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
