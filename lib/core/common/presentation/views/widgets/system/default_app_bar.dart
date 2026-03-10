import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../config/constants/text/material/app_material_text_primitives.dart';
import '../../../../domain/services/navigation/navigation_service.dart';
import '../../../../locator/service_locator.dart';
import '../../../extensions/theme/theme_extension.dart';
import '../../components/app_color.dart';
import 'icon/app_icon_widget.dart';
import 'text/app_text_widget.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    super.key,
    this.actions,
    this.leadingWidget,
    this.titleWidget,
    this.centerTitle = false,
    this.backgroundColor,
    this.title,
    this.leadingAction,
  });

  final List<Widget>? actions;
  final Widget? leadingWidget;
  final Widget? titleWidget;
  final String? title;
  final bool centerTitle;
  final KAppColor? backgroundColor;
  final VoidCallback? leadingAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leadingWidth: 80.w,
      title: (title != null)
          ? AppText(
              title!,
              style: context.textStyles.titleLarge.copyWith(
                fontWeight: AppMaterialTextPrimitives.semibold,
              ),
            )
          : titleWidget,
      centerTitle: centerTitle,
      leading: sl<NavigationService>().canPop()
          ? leadingWidget ??
                AppIcon(
                  Icons.chevron_left_rounded,
                  onTap:
                      leadingAction ?? () => sl<NavigationService>().maybePop(),
                )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
