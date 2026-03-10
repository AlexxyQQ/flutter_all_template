import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../config/constants/text/material/app_material_text_primitives.dart';
import '../../../../domain/services/navigation/navigation_service.dart';
import '../../../../locator/service_locator.dart';
import '../../../extensions/size/size_extension.dart';
import '../../../extensions/theme/theme_extension.dart';
import '../../../routes/app_router.gr.dart';
import '../../widgets/system/icon/app_icon_widget.dart'; // Ensure this maps to your AppIcon
import '../../widgets/system/text/app_text_widget.dart'; // Ensure this maps to your AppText

enum DialogType { info, success, warning, error, confirmation, custom }

@RoutePage(name: 'AppDialogRoute')
class AppDialogPage extends StatelessWidget {
  const AppDialogPage({
    required this.type,
    super.key,
    this.title,
    this.message,
    this.customContent,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.autoCloseDuration,
    this.isDismissible = false,
  });

  final DialogType type;
  final String? title;
  final String? message;
  final Widget? customContent;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Duration? autoCloseDuration;
  final bool? isDismissible;

  @override
  Widget build(BuildContext context) {
    final nav = sl<NavigationService>();

    // 1. Auto-close logic
    if (autoCloseDuration != null) {
      Future.delayed(autoCloseDuration!, () {
        // Safe check to ensure we only pop if this specific route is active could go here
        nav.closeSpecificRoute(name: AppDialogRoute.name);
      });
    }

    // 2. Resolve Colors & Icons based on Semantic System
    // We map generic types to your specific AppSemanticColors
    Color primaryColor;
    IconData icon;

    switch (type) {
      case DialogType.info:
        primaryColor = context.colors.tertiary; // Blue family
        icon = Icons.info_outline;
      case DialogType.success:
        primaryColor = context.colors.success.color;
        icon = Icons.check_circle_outline;
      case DialogType.warning:
        primaryColor = context.colors.warning.color;
        icon = Icons.warning_amber_rounded;
      case DialogType.error:
        primaryColor = context.colors.error;
        icon = Icons.error_outline;
      case DialogType.confirmation:
        primaryColor = context.colors.primary;
        icon = Icons.help_outline;
      case DialogType.custom:
        primaryColor = context.colors.onSurface;
        icon = Icons.circle;
    }

    return PopScope(
      canPop: isDismissible ?? false,
      child: AlertDialog(
        backgroundColor: context.colors.surface,
        surfaceTintColor: context.colors.surface, // Remove Material 3 tint
        elevation: 0,
        // Using standard ScreenUtil for radius
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        // Standard Dialog Padding
        insetPadding: 24.w.horizontalPadding + 24.h.verticalPadding,
        titlePadding:
            (24.h).topOnly +
            (16.h).bottomOnly +
            (24.w).leftOnly +
            (24.w).rightOnly,
        contentPadding: (24.h).bottomOnly + (24.w).leftOnly + (24.w).rightOnly,
        actionsPadding: (16.h).bottomOnly + (24.w).leftOnly + (24.w).rightOnly,

        title: type == DialogType.custom && title == null
            ? null
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: 2.h.topOnly, // Align icon with text baseline
                    child: AppIcon(icon, color: primaryColor, size: 24.sp),
                  ),
                  12.horizontalGap,
                  Expanded(
                    child: AppText(
                      title ?? '',
                      style: context.textStyles.titleLarge
                          .copyWith(
                            fontWeight: AppMaterialTextPrimitives.semibold,
                          )
                          .copyWith(color: context.colors.onSurface),
                    ),
                  ),
                ],
              ),
        content:
            customContent ??
            AppText(
              message ?? '',
              style: context.textStyles.bodyLarge.copyWith(
                color: context.colors.onSurface.withOpacity(0.8),
              ),
            ),
        actions: _buildActions(context, nav, primaryColor),
      ),
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    NavigationService nav,
    Color primaryColor,
  ) {
    FutureOr<bool> closeDialog() =>
        nav.closeSpecificRoute(name: AppDialogRoute.name);

    // Helper for Buttons using your TextStyles
    Widget buildBtn({
      required String text,
      required Color color,
      required VoidCallback onPressed,
    }) {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: 16.w.horizontalPadding + 8.h.verticalPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          foregroundColor: color.withOpacity(0.1), // Splash color
        ),
        child: AppText(
          text,
          style: context.textStyles.titleSmall.copyWith(color: color),
        ),
      );
    }

    // 1. Single Button (Info/Error/Success)
    if (type == DialogType.info ||
        type == DialogType.error ||
        type == DialogType.success) {
      return [
        buildBtn(
          text: confirmText ?? LocaleKeys.common_words_close,
          color: primaryColor,
          onPressed: () {
            onConfirm?.call();
            closeDialog();
          },
        ),
      ];
    }

    // 2. Dual Button (Warning/Confirmation)
    if (type == DialogType.warning || type == DialogType.confirmation) {
      return [
        buildBtn(
          text: cancelText ?? LocaleKeys.common_words_cancel,
          color: context.colors.outlineVariant.withOpacity(
            0.8,
          ), // Muted color for cancel
          onPressed: () {
            onCancel?.call();
            closeDialog();
          },
        ),
        buildBtn(
          text: confirmText ?? LocaleKeys.common_words_confirm,
          color: primaryColor,
          onPressed: () {
            onConfirm?.call();
            closeDialog();
          },
        ),
      ];
    }

    // 3. Custom: Fallback close button if no actions provided in content
    return [
      if (onCancel != null || onConfirm != null)
        buildBtn(
          text: LocaleKeys.common_words_close,
          color: context.colors.outlineVariant,
          onPressed: closeDialog,
        ),
    ];
  }
}
