import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../config/constants/text/material/app_material_text_primitives.dart';
import '../../../../../../config/themes/components_theme/app_button_theme.dart';
import '../../../../../../config/themes/components_theme/app_picture_theme.dart';
import '../../../extensions/size/size_extension.dart';
import '../../../extensions/theme/theme_extension.dart';
import '../../../themes/colors/app_material_colors.dart';
import '../../../themes/styles/button_style.dart';
import '../../components/app_color.dart';
import 'images/app_svg_picture_widget.dart';
import 'loaders/app_circular_loader.dart';
import 'text/app_text_widget.dart';

class AppButton extends StatefulWidget {
  factory AppButton.primary({
    required void Function()? onPressed,
    required String label,
    bool isLoading = false,
    bool translate = true,
    bool isDisabled = false,
    Widget? prefix,
    Widget? suffix,
    String? icon,
    double? height,
    double? width,
    bool? isExpanded,
  }) {
    return AppButton._(
      onPressed: onPressed,
      label: label,
      isLoading: isLoading,
      isDisabled: isDisabled,
      prefix: prefix,
      suffix: suffix,
      icon: icon,
      theme: ButtonStyles.primaryTheme.copyWith(expanded: isExpanded),
      height: height,
      width: width,
      translate: translate,
    );
  }

  factory AppButton.secondary({
    required void Function()? onPressed,
    required String label,
    bool isLoading = false,
    bool translate = true,
    bool isDisabled = false,
    Widget? prefix,
    Widget? suffix,
    String? icon,
    double? height,
    double? width,
    bool? isExpanded,
  }) {
    return AppButton._(
      onPressed: onPressed,
      label: label,
      isLoading: isLoading,
      isDisabled: isDisabled,
      prefix: prefix,
      suffix: suffix,
      icon: icon,
      theme: ButtonStyles.secondaryTheme.copyWith(expanded: isExpanded),
      height: height,
      width: width,
      translate: translate,
    );
  }

  factory AppButton.tertiary({
    required void Function()? onPressed,
    required String label,
    bool isLoading = false,
    bool translate = true,
    bool isDisabled = false,
    Widget? prefix,
    Widget? suffix,
    String? icon,
    double? height,
    double? width,
    bool? isExpanded,
  }) {
    return AppButton._(
      onPressed: onPressed,
      label: label,
      isLoading: isLoading,
      isDisabled: isDisabled,
      prefix: prefix,
      suffix: suffix,
      icon: icon,
      theme: ButtonStyles.tertiaryTheme.copyWith(expanded: isExpanded),
      height: height,
      width: width,
      translate: translate,
    );
  }

  factory AppButton.stroke({
    required void Function()? onPressed,
    required String label,
    bool isLoading = false,
    bool translate = true,
    bool isDisabled = false,
    Widget? prefix,
    Widget? suffix,
    String? icon,
    CustomButtonTheme? theme,
    double? height,
    double? width,
  }) {
    return AppButton._(
      onPressed: onPressed,
      label: label,
      isLoading: isLoading,
      isDisabled: isDisabled,
      prefix: prefix,
      suffix: suffix,
      icon: icon,
      theme: ButtonStyles.strokeTheme,
      height: height,
      width: width,
      translate: translate,
    );
  }

  factory AppButton.ghost({
    required void Function()? onPressed,
    required String label,
    bool isLoading = false,
    bool translate = true,
    bool isDisabled = false,
    Widget? prefix,
    Widget? suffix,
    String? icon,
    CustomButtonTheme? theme,
    double? height,
    double? width,
  }) {
    return AppButton._(
      onPressed: onPressed,
      label: label,
      isLoading: isLoading,
      isDisabled: isDisabled,
      prefix: prefix,
      suffix: suffix,
      icon: icon,
      theme: ButtonStyles.ghostTheme,
      height: height,
      width: width,
      translate: translate,
    );
  }

  factory AppButton.icon({
    required void Function()? onPressed,
    required String icon,
    bool isLoading = false,
    bool translate = true,
    bool isDisabled = false,
    CustomButtonTheme? theme,
    double? height,
    double? width,
    double? iconSize,
  }) {
    return AppButton._(
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      icon: icon,
      theme: theme ?? ButtonStyles.ghostTheme,
      height: height,
      width: width,
      translate: translate,

      iconSize: iconSize,
    );
  }

  factory AppButton.custom({
    required void Function()? onPressed,
    required String label,
    CustomButtonTheme theme = const CustomButtonTheme(),
    bool isLoading = false,
    bool translate = true,
    bool isDisabled = false,
    Widget? prefix,
    Widget? suffix,
    String? icon,
    double? height,
    double? width,
  }) {
    return AppButton._(
      onPressed: onPressed,
      label: label,
      isLoading: isLoading,
      isDisabled: isDisabled,
      prefix: prefix,
      suffix: suffix,
      icon: icon,
      theme: theme,
      height: height,
      width: width,
      translate: translate,
    );
  }
  const AppButton._({
    required this.onPressed,
    required this.theme,
    this.label,
    this.isLoading = false,
    this.translate = true,
    this.isDisabled = false,
    this.prefix,
    this.suffix,
    this.icon,
    this.height,
    this.width,
    this.iconSize,
  });

  final void Function()? onPressed;
  final String? label;
  final bool isLoading;
  final bool isDisabled;
  final Widget? prefix;
  final Widget? suffix;
  final String? icon;
  final double? height;
  final double? width;
  final CustomButtonTheme? theme;
  final double? iconSize;
  final bool translate;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  double _scale = 1.0;
  static const double _pressedScale = 0.86;
  static const Duration _duration = Duration(milliseconds: 120);

  bool get _isInteractive => !widget.isDisabled && !widget.isLoading;

  void _onTapDown(TapDownDetails details) {
    if (_isInteractive) {
      setState(() => _scale = _pressedScale);
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (_isInteractive) {
      setState(() => _scale = 1.0);
    }
  }

  void _onTapCancel() {
    if (_isInteractive) {
      setState(() => _scale = 1.0);
    }
  }

  void _onTap() {
    if (_isInteractive) {
      widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonTheme = widget.theme!.copyWith(translate: widget.translate);

    final KAppColor? backgroundColor = widget.isDisabled
        ? (buttonTheme.backgroundDisabledColor)
        : (buttonTheme.backgroundColor);

    final KAppColor? foregroundColor = widget.isDisabled
        ? (buttonTheme.foregroundDisabledColor)
        : (buttonTheme.foregroundColor);

    final BoxBorder? border = (buttonTheme.showBorder ?? false)
        ? Border.fromBorderSide(
            buttonTheme.border ??
                BorderSide(
                  color: widget.isDisabled
                      ? AppMaterialColors.inverseSurface
                      : AppMaterialColors.primary,
                ),
          )
        : null;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _onTap,
      behavior: HitTestBehavior.translucent,
      child: AnimatedScale(
        scale: _scale,
        duration: _duration,
        curve: Curves.easeOut,
        child: Container(
          height: (buttonTheme.fixSize ?? true)
              ? (widget.height ?? 90.h)
              : null,

          width:
              widget.width ??
              ((buttonTheme.expanded == true) ? double.infinity : null),
          padding:
              buttonTheme.padding ??
              (16.horizontalPadding + 12.verticalPadding),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: buttonTheme.radius ?? 12.borderCircular,
            border: border,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: buttonTheme.expanded == true
                ? MainAxisSize.max
                : MainAxisSize.min,
            children: [
              if (widget.isLoading)
                AppCircularLoader(
                  color: buttonTheme.loaderColor ?? foregroundColor,
                )
              else ...[
                if (widget.icon != null) ...[
                  AppSvgPicture.fromAsset(
                    widget.icon!,
                    width: widget.iconSize ?? 16,
                    height: widget.iconSize ?? 16,
                    theme: PictureTheme(color: foregroundColor),
                  ),

                  if (widget.label != null || widget.suffix != null)
                    8.horizontalGap,
                ],

                if (widget.prefix != null) ...[
                  widget.prefix!,

                  if (widget.label != null) 8.horizontalGap,
                ],

                if (widget.label != null)
                  Flexible(
                    child: AppText(
                      widget.label!,
                      textAlign: TextAlign.center,
                      style: buttonTheme.labelColor != null
                          ? context.textStyles.titleSmall.copyWith(
                              color: buttonTheme.labelColor,
                              fontWeight: AppMaterialTextPrimitives.semibold,
                              wordSpacing: 0.8,
                            )
                          : context.textStyles.titleSmall.copyWith(
                              color: foregroundColor,
                              fontWeight: AppMaterialTextPrimitives.semibold,
                              wordSpacing: 0.8,
                            ),
                      translate: buttonTheme.translate ?? true,
                    ),
                  ),

                if (widget.suffix != null) ...[
                  if (widget.label != null) 8.horizontalGap,
                  widget.suffix!,
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
