import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../config/constants/text/material/app_material_text_primitives.dart';
import '../../../extensions/dialog/dialog_extension.dart';
import '../../../extensions/size/size_extension.dart';
import '../../../extensions/theme/theme_extension.dart';
import '../../widgets/system/icon/app_icon_widget.dart';
import '../../widgets/system/text/app_text_widget.dart';

enum DialogType { info, success, warning, error, confirmation, custom }

@RoutePage(name: 'AppDialogRoute')
class AppDialogPage extends StatefulWidget {
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
  State<AppDialogPage> createState() => _AppDialogPageState();
}

class _AppDialogPageState extends State<AppDialogPage> {
  Timer? _autoClose;

  DialogType get type => widget.type;

  @override
  void initState() {
    super.initState();
    final duration = widget.autoCloseDuration;
    if (duration != null) {
      _autoClose = Timer(duration, () {
        if (mounted) {
          context.closeDialog;
        }
      });
    }
  }

  @override
  void dispose() {
    _autoClose?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title;
    final Color primaryColor;
    final IconData icon;

    switch (type) {
      case DialogType.info:
        primaryColor = context.tokens.info.color;
        icon = Icons.info_outline;
      case DialogType.success:
        primaryColor = context.tokens.success.color;
        icon = Icons.check_circle_outline;
      case DialogType.warning:
        primaryColor = context.tokens.warning.color;
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
      canPop: widget.isDismissible ?? false,
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
            widget.customContent ??
            AppText(
              widget.message ?? '',
              style: context.textStyles.bodyLarge.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
        actions: _buildActions(context, primaryColor),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, Color primaryColor) {
    void closeDialog() => context.closeDialog;

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
          foregroundColor: color,
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
          text: widget.confirmText ?? LocaleKeys.common_words_close,
          color: primaryColor,
          onPressed: () {
            widget.onConfirm?.call();
            closeDialog();
          },
        ),
      ];
    }

    // 2. Dual Button (Warning/Confirmation)
    if (type == DialogType.warning || type == DialogType.confirmation) {
      return [
        buildBtn(
          text: widget.cancelText ?? LocaleKeys.common_words_cancel,
          color: context.colors.onSurfaceVariant,
          onPressed: () {
            widget.onCancel?.call();
            closeDialog();
          },
        ),
        buildBtn(
          text: widget.confirmText ?? LocaleKeys.common_words_confirm,
          color: primaryColor,
          onPressed: () {
            widget.onConfirm?.call();
            closeDialog();
          },
        ),
      ];
    }

    // 3. Custom: Fallback close button if no actions provided in content
    return [
      if (widget.onCancel != null || widget.onConfirm != null)
        buildBtn(
          text: LocaleKeys.common_words_close,
          color: context.colors.onSurfaceVariant,
          onPressed: closeDialog,
        ),
    ];
  }
}
