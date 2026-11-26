import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../../../../config/themes/components_theme/app_icon_theme.dart';
import '../../../../extensions/theme/theme_extension.dart';
import '../../../../themes/styles/app_icon_style.dart';

/// Material icon with optional circular background and tap handling.
///
/// When [onTap] is set the icon is exposed to assistive technologies as a
/// button; give it a [semanticLabel] (a localization key when [translate] is
/// true) or a [tooltip] so screen readers can announce it.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
    this.textDirection,
    this.onTap,
    this.isCircular = false,
    this.backgroundColor,
    this.containerSize,
    this.theme,
    this.isDisabled = false,
    this.tooltip,
    this.translate = true,
  });

  /// Icon rendered in the theme's `outlineVariant` colour and not tappable.
  const AppIcon.disabled(
    this.icon, {
    super.key,
    this.size,
    this.semanticLabel,
    this.textDirection,
    this.theme,
    this.translate = true,
  }) : color = null,
       onTap = null,
       isCircular = false,
       backgroundColor = null,
       containerSize = null,
       isDisabled = true,
       tooltip = null;

  /// Icon inside a circular container.
  const AppIcon.circular(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.backgroundColor,
    this.semanticLabel,
    this.textDirection,
    this.containerSize,
    this.theme,
    this.onTap,
    this.tooltip,
    this.translate = true,
  }) : isCircular = true,
       isDisabled = false;

  final IconData icon;
  final double? size;
  final Color? color;

  /// Accessibility label (localization key when [translate] is true).
  final String? semanticLabel;
  final TextDirection? textDirection;
  final VoidCallback? onTap;
  final bool isCircular;
  final Color? backgroundColor;

  /// Diameter / side length of the circular container.
  final double? containerSize;
  final AppIconTheme? theme;
  final bool isDisabled;

  /// Optional tooltip (localization key when [translate] is true).
  final String? tooltip;
  final bool translate;

  String? _tr(String? value) =>
      value == null ? null : (translate ? value.tr() : value);

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final appIconTheme = AppIconStyles.getTheme(theme, color: cs.onSurface);
    final label = _tr(semanticLabel) ?? _tr(tooltip);

    Widget iconWidget = Icon(
      icon,
      size: size ?? appIconTheme.size,
      color: isDisabled ? cs.outlineVariant : (color ?? appIconTheme.color),
      semanticLabel: onTap == null ? label : null,
      textDirection: textDirection,
    );

    final shouldBeCircular = isCircular || (appIconTheme.isCircular ?? false);
    if (shouldBeCircular) {
      final finalContainerSize =
          containerSize ??
          appIconTheme.containerHeight ??
          appIconTheme.containerWidth ??
          (size != null ? size! * 2 : 48);

      iconWidget = Container(
        width: finalContainerSize,
        height: finalContainerSize,
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: appIconTheme.shape ?? BoxShape.circle,
          color:
              backgroundColor ??
              appIconTheme.backgroundColor ??
              cs.primary.withValues(alpha: 0.1),
          border:
              appIconTheme.borderWidth != null &&
                  appIconTheme.borderColor != null
              ? Border.all(
                  color: appIconTheme.borderColor!,
                  width: appIconTheme.borderWidth!,
                )
              : null,
          borderRadius: appIconTheme.shape == BoxShape.rectangle
              ? appIconTheme.borderRadius
              : null,
        ),
        child: iconWidget,
      );
    }

    if (onTap != null && !isDisabled) {
      iconWidget = Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.translucent,
          child: iconWidget,
        ),
      );
    }

    final tip = _tr(tooltip);
    if (tip != null) {
      iconWidget = Tooltip(
        message: tip,
        excludeFromSemantics: true,
        child: iconWidget,
      );
    }

    return iconWidget;
  }
}
