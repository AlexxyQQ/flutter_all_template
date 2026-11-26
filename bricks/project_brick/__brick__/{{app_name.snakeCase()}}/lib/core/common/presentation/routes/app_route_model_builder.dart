import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/size/size_extension.dart';

class _AppBottomSheet extends StatelessWidget {
  const _AppBottomSheet({
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.showDragHandle = true,
    this.isDismissible = true,
    this.enableDrag = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool showDragHandle;
  final bool isDismissible;
  final bool enableDrag;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        clipBehavior: Clip.hardEdge,

        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,

          borderRadius:
              borderRadius ?? BorderRadius.vertical(top: Radius.circular(20.r)),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(padding: padding ?? 16.allPadding, child: child),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppDialog extends StatelessWidget {
  const _AppDialog({
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
    this.insetPadding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsets? insetPadding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation ?? 0,
      clipBehavior: Clip.hardEdge,
      insetPadding: insetPadding ?? 24.horizontalPadding + 24.verticalPadding,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? 20.borderCircular,
      ),
      // Update: Wrap in Column with min size
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // This forces the dialog to wrap content height
        children: [
          Flexible(
            // Flexible allows the content to shrink if it's too big for the screen
            child: Padding(padding: padding ?? 16.allPadding, child: child),
          ),
        ],
      ),
    );
  }
}

CustomRouteBuilder createModalSheetBuilder({
  Color routeBackgroundColor = Colors.white,
  bool enableDrag = true,
  bool isDismissible = true,
  bool useSafeArea = true,
  double? elevation,
  ShapeBorder? shape,
  BoxConstraints? constraints,
  Clip? clipBehavior,
  EdgeInsetsGeometry? sheetPadding,
  Color? sheetBackgroundColor,
  BorderRadius? sheetBorderRadius,
  bool showDragHandle = true,
}) {
  return <T>(BuildContext context, Widget child, AutoRoutePage<T> page) {
    return ModalBottomSheetRoute<T>(
      settings: page,
      isScrollControlled: true,
      backgroundColor: routeBackgroundColor,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      useSafeArea: useSafeArea,
      elevation: elevation,
      shape: shape,
      constraints: constraints,
      clipBehavior: clipBehavior,
      builder: (context) {
        return _AppBottomSheet(
          padding: sheetPadding,
          backgroundColor: sheetBackgroundColor,
          borderRadius: sheetBorderRadius,
          showDragHandle: showDragHandle,
          enableDrag: enableDrag,
          isDismissible: isDismissible,
          child: child,
        );
      },
    );
  };
}

CustomRouteBuilder createDialogBuilder({
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  Duration transitionDuration = const Duration(milliseconds: 200),
  String? barrierLabel,
  bool useSafeArea = true,

  EdgeInsetsGeometry? dialogPadding,
  EdgeInsets? insetPadding,
  Color? dialogBackgroundColor,
  BorderRadius? dialogBorderRadius,
  double? elevation,
}) {
  return <T>(BuildContext context, Widget child, AutoRoutePage<T> page) {
    return DialogRoute<T>(
      context: context,
      settings: page,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      builder: (context) {
        return _AppDialog(
          padding: dialogPadding,
          insetPadding: insetPadding,
          backgroundColor: dialogBackgroundColor,
          borderRadius: dialogBorderRadius,
          elevation: elevation,
          child: child,
        );
      },
    );
  };
}
