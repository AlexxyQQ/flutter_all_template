import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/constants/text/material/app_material_text_primitives.dart';
import '../extensions/size/size_extension.dart';
import '../extensions/theme/theme_extension.dart';
import '../views/widgets/system/icon/app_icon_widget.dart';
import '../views/widgets/system/text/app_text_widget.dart';

/// Overlay-based snackbars.
///
/// `message`/`details` are localization keys by default; pass
/// `translate: false` when the text is already translated (e.g. a server
/// message) so it is not translated twice.
abstract final class SnackbarHelper {
  // --- STATE MANAGEMENT ---
  static OverlayEntry? _activeOverlayEntry;
  static Timer? _activeTimer;

  static void _closeCurrentOverlay() {
    _activeOverlayEntry?.remove();
    _activeOverlayEntry = null;
    _activeTimer?.cancel();
    _activeTimer = null;
  }

  // ===========================================================================
  // PUBLIC API
  // ===========================================================================

  /// 1. STANDARD BOTTOM SNACKBAR (Full Width)
  static void showBottom({
    required BuildContext context,
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
    Widget? prefixIcon,
    Widget? suffixIcon,
    VoidCallback? onTap,
    bool translate = true,
  }) {
    final colors = _getThemeColors(context, isError);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    _showOverlay(
      context: context,
      duration: duration,
      direction: _SlideDirection.up,
      // Position parameters
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: double.infinity,
        color: colors.background,
        padding: 16.allPadding + bottomPadding.bottomOnly,
        child: _buildStandardContent(
          context,
          message: message,
          textColor: colors.foreground,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          isError: isError,
          translate: translate,
        ),
      ),
      onTap: onTap,
      announcement: _announcement(message, null, translate),
    );
  }

  /// 2. FLOATING SNACKBAR
  static void showFloating({
    required BuildContext context,
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
    Widget? prefixIcon,
    Widget? suffixIcon,
    VoidCallback? onTap,
    bool translate = true,
  }) {
    final colors = _getThemeColors(context, isError);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    _showOverlay(
      context: context,
      duration: duration,
      direction: _SlideDirection.up,
      // Position parameters (with margin)
      bottom: bottomPadding + 20.h,
      left: 20.w,
      right: 20.w,
      child: Container(
        padding: 16.allPadding,
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _buildStandardContent(
          context,
          message: message,
          textColor: colors.foreground,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          isError: isError,
          translate: translate,
        ),
      ),
      onTap: onTap,
      announcement: _announcement(message, null, translate),
    );
  }

  /// 3. TOP FULL-SCREEN SNACKBAR
  static void showTop({
    required BuildContext context,
    required String message,
    String? details,
    bool isError = false,
    Duration duration = const Duration(seconds: 4),
    Widget? prefixIcon,
    Widget? suffixIcon,
    Alignment alignment = Alignment.center,
    VoidCallback? onTap,
    bool translate = true,
  }) {
    final colors = _getThemeColors(context, isError);
    final topPadding = MediaQuery.of(context).padding.top;

    _showOverlay(
      context: context,
      duration: duration,
      direction: _SlideDirection.down,
      // Position parameters
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        width: double.infinity,
        color: colors.background,
        padding:
            (topPadding + 50.h).topOnly +
            16.bottomOnly +
            16.leftOnly +
            16.rightOnly,
        child: _buildStandardContent(
          context,
          message: message,
          subMessage: details,
          textColor: colors.foreground,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          isError: isError,
          translate: translate,
          alignment: alignment,
        ),
      ),
      onTap: onTap,
      announcement: _announcement(message, details, translate),
    );
  }

  // ===========================================================================
  // PRIVATE HELPERS (The DRY Logic)
  // ===========================================================================

  /// Centralized Overlay Logic
  static void _showOverlay({
    required BuildContext context,
    required Widget child,
    required _SlideDirection direction,
    Duration duration = const Duration(seconds: 3),
    double? left,
    double? right,
    double? top,
    double? bottom,
    VoidCallback? onTap,
    String announcement = '',
  }) {
    _closeCurrentOverlay();

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
        child: Material(
          color: Colors.transparent,
          child: _SlideAnimation(
            direction: direction,
            child: GestureDetector(
              excludeFromSemantics: onTap == null,
              onTap: () {
                onTap?.call();
                _closeCurrentOverlay();
              },
              child: child,
            ),
          ),
        ),
      ),
    );

    _activeOverlayEntry = overlayEntry;
    if (announcement.isNotEmpty) {
      unawaited(
        SemanticsService.sendAnnouncement(
          View.of(context),
          announcement,
          Directionality.of(context),
        ),
      );
    }
    Overlay.of(context).insert(overlayEntry);
    _activeTimer = Timer(duration, _closeCurrentOverlay);
  }

  /// Centralized Content Builder (Row with Icon -> Text -> Icon)
  static Widget _buildStandardContent(
    BuildContext context, {
    required String message,
    required Color textColor,
    required bool isError,
    required bool translate,
    String? subMessage,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Alignment alignment = Alignment.centerLeft,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Prefix
        if (prefixIcon != null) ...[
          prefixIcon,
          12.horizontalGap,
        ] else if (subMessage == null) ...[
          // Only show default icon if it's not the detailed Top view (optional preference)
          AppIcon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: textColor,
            size: 20.sp,
          ),
          12.horizontalGap,
        ],

        // Text Content
        Expanded(
          child: Align(
            alignment: alignment,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: alignment == Alignment.center
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                AppText(
                  message,
                  translate: translate,
                  style: context.textStyles.labelLarge.copyWith(
                    color: textColor,
                    fontWeight: subMessage != null
                        ? AppMaterialTextPrimitives.bold
                        : AppMaterialTextPrimitives.regular,
                  ),
                ),
                if (subMessage != null) ...[
                  4.verticalGap,
                  AppText(
                    subMessage,
                    translate: translate,
                    style: context.textStyles.bodySmall.copyWith(
                      color: textColor,
                    ),
                    maxLines: 2,
                    textAlign: alignment == Alignment.center
                        ? TextAlign.center
                        : TextAlign.start,
                  ),
                ],
              ],
            ),
          ),
        ),

        // Suffix
        if (suffixIcon != null) ...[12.horizontalGap, suffixIcon],
      ],
    );
  }

  static String _announcement(String message, String? details, bool translate) {
    String t(String v) => translate ? v.tr() : v;
    return details == null ? t(message) : '${t(message)}. ${t(details)}';
  }

  /// Helper to extract colors
  static ({Color background, Color foreground}) _getThemeColors(
    BuildContext context,
    bool isError,
  ) {
    return (
      background: isError ? context.colors.error : context.tokens.success.color,
      foreground: isError
          ? context.colors.onError
          : context.tokens.success.onColor,
    );
  }
}

// =============================================================================
// ANIMATION WIDGET
// =============================================================================

enum _SlideDirection { up, down }

class _SlideAnimation extends StatefulWidget {
  const _SlideAnimation({
    required this.child,
    required this.direction,
    // ignore: unused_element_parameter
    this.duration = const Duration(milliseconds: 500),
  });
  final Widget child;
  final Duration duration;
  final _SlideDirection direction;

  @override
  State<_SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<_SlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    final beginOffset = widget.direction == _SlideDirection.down
        ? const Offset(0.0, -1.0)
        : const Offset(0.0, 1.0);

    _offsetAnimation = Tween<Offset>(begin: beginOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutQuart,
            reverseCurve: Curves.easeInQuart,
          ),
        );

    unawaited(_controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _offsetAnimation, child: widget.child);
  }
}
