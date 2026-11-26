import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../config/constants/text/material/app_material_text_primitives.dart';
import '../../../../../../config/themes/components_theme/app_button_theme.dart';
import '../../../../../../config/themes/components_theme/app_picture_theme.dart';
import '../../../extensions/size/size_extension.dart';
import '../../../extensions/theme/theme_extension.dart';
import '../../../themes/styles/button_style.dart';
import 'images/app_svg_picture_widget.dart';
import 'loaders/app_circular_loader.dart';
import 'text/app_text_widget.dart';

export '../../../themes/styles/button_style.dart' show ButtonVariant;

/// The app's button.
///
/// Use a named constructor for a variant (`AppButton.primary(...)`), or the
/// default constructor with [variant]. All variants share one implementation;
/// colours come from the ambient [ColorScheme] via [ButtonStyles].
class AppButton extends StatefulWidget {
  const AppButton({
    required this.onPressed,
    super.key,
    this.variant = ButtonVariant.primary,
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
    this.isExpanded,
    this.theme,
    this.semanticLabel,
    this.tooltip,
  });

  const AppButton.primary({
    required this.onPressed,
    required String this.label,
    super.key,
    this.isLoading = false,
    this.translate = true,
    this.isDisabled = false,
    this.prefix,
    this.suffix,
    this.icon,
    this.height,
    this.width,
    this.isExpanded,
    this.semanticLabel,
  }) : variant = ButtonVariant.primary,
       theme = null,
       iconSize = null,
       tooltip = null;

  const AppButton.secondary({
    required this.onPressed,
    required String this.label,
    super.key,
    this.isLoading = false,
    this.translate = true,
    this.isDisabled = false,
    this.prefix,
    this.suffix,
    this.icon,
    this.height,
    this.width,
    this.isExpanded,
    this.semanticLabel,
  }) : variant = ButtonVariant.secondary,
       theme = null,
       iconSize = null,
       tooltip = null;

  const AppButton.tertiary({
    required this.onPressed,
    required String this.label,
    super.key,
    this.isLoading = false,
    this.translate = true,
    this.isDisabled = false,
    this.prefix,
    this.suffix,
    this.icon,
    this.height,
    this.width,
    this.isExpanded,
    this.semanticLabel,
  }) : variant = ButtonVariant.tertiary,
       theme = null,
       iconSize = null,
       tooltip = null;

  /// Outlined button. A non-null [theme] replaces the default stroke theme.
  const AppButton.stroke({
    required this.onPressed,
    required String this.label,
    super.key,
    this.isLoading = false,
    this.translate = true,
    this.isDisabled = false,
    this.prefix,
    this.suffix,
    this.icon,
    this.theme,
    this.height,
    this.width,
    this.isExpanded,
    this.semanticLabel,
  }) : variant = ButtonVariant.stroke,
       iconSize = null,
       tooltip = null;

  /// Text-only button. A non-null [theme] replaces the default ghost theme.
  const AppButton.ghost({
    required this.onPressed,
    required String this.label,
    super.key,
    this.isLoading = false,
    this.translate = true,
    this.isDisabled = false,
    this.prefix,
    this.suffix,
    this.icon,
    this.theme,
    this.height,
    this.width,
    this.isExpanded,
    this.semanticLabel,
  }) : variant = ButtonVariant.ghost,
       iconSize = null,
       tooltip = null;

  /// Error-coloured button for destructive actions.
  const AppButton.destructive({
    required this.onPressed,
    required String this.label,
    super.key,
    this.isLoading = false,
    this.translate = true,
    this.isDisabled = false,
    this.prefix,
    this.suffix,
    this.icon,
    this.height,
    this.width,
    this.isExpanded,
    this.semanticLabel,
  }) : variant = ButtonVariant.destructive,
       theme = null,
       iconSize = null,
       tooltip = null;

  /// Icon-only button (SVG asset). Provide [semanticLabel] (or [tooltip]) so
  /// screen readers can announce it.
  const AppButton.icon({
    required this.onPressed,
    required String this.icon,
    super.key,
    this.isLoading = false,
    this.translate = true,
    this.isDisabled = false,
    this.theme,
    this.height,
    this.width,
    this.iconSize,
    this.semanticLabel,
    this.tooltip,
  }) : variant = ButtonVariant.ghost,
       label = null,
       prefix = null,
       suffix = null,
       isExpanded = null;

  /// Fully custom colours via [theme] (no variant defaults are applied).
  const AppButton.custom({
    required this.onPressed,
    required String this.label,
    super.key,
    CustomButtonTheme this.theme = const CustomButtonTheme(),
    this.isLoading = false,
    this.translate = true,
    this.isDisabled = false,
    this.prefix,
    this.suffix,
    this.icon,
    this.height,
    this.width,
    this.isExpanded,
    this.semanticLabel,
  }) : variant = ButtonVariant.primary,
       iconSize = null,
       tooltip = null;

  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final String? label;
  final bool isLoading;
  final bool isDisabled;
  final Widget? prefix;
  final Widget? suffix;

  /// SVG asset path rendered before the label.
  final String? icon;
  final double? height;
  final double? width;

  /// Overrides the variant's theme entirely when non-null.
  final CustomButtonTheme? theme;
  final double? iconSize;
  final bool? isExpanded;
  final bool translate;

  /// Accessibility label; defaults to the (translated) [label].
  final String? semanticLabel;

  /// Optional tooltip (useful for icon-only buttons).
  final String? tooltip;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  double _scale = 1.0;
  static const double _pressedScale = 0.96;
  static const Duration _duration = Duration(milliseconds: 120);

  bool get _isInteractive =>
      !widget.isDisabled && !widget.isLoading && widget.onPressed != null;

  void _setPressed(bool pressed) {
    if (_isInteractive) {
      setState(() => _scale = pressed ? _pressedScale : 1.0);
    }
  }

  void _onTap() {
    if (_isInteractive) {
      widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final base = widget.theme ?? ButtonStyles.of(widget.variant, cs);
    final expanded = widget.isExpanded ?? base.expanded ?? false;
    final disabled = widget.isDisabled;

    final Color? background = disabled
        ? base.backgroundDisabledColor
        : base.backgroundColor;
    final Color? foreground = disabled
        ? base.foregroundDisabledColor
        : base.foregroundColor;

    final BoxBorder? border = (base.showBorder ?? false)
        ? Border.fromBorderSide(
            base.border ??
                BorderSide(color: disabled ? cs.outline : cs.primary),
          )
        : null;

    final translate = widget.translate && (base.translate ?? true);
    final label = widget.label;
    final semanticLabel =
        widget.semanticLabel ??
        widget.tooltip ??
        (label == null ? null : (translate ? label.tr() : label));

    Widget content = AnimatedScale(
      scale: _scale,
      duration: _duration,
      curve: Curves.easeOut,
      child: Container(
        height: widget.height,
        width: widget.width ?? (expanded ? double.infinity : null),
        constraints: const BoxConstraints(minHeight: 40),
        padding: base.padding ?? (16.horizontalPadding + 12.verticalPadding),
        decoration: BoxDecoration(
          color: background,
          borderRadius: base.radius ?? 12.borderCircular,
          border: border,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          children: widget.isLoading
              ? [AppCircularLoader(color: base.loaderColor ?? foreground)]
              : _children(context, base, foreground, translate),
        ),
      ),
    );

    content = Semantics(
      button: true,
      enabled: _isInteractive,
      label: semanticLabel,
      excludeSemantics: semanticLabel != null,
      onTap: _isInteractive ? _onTap : null,
      child: GestureDetector(
        excludeFromSemantics: true,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      ),
    );

    final tooltip = widget.tooltip;
    if (tooltip != null) {
      content = Tooltip(
        message: translate ? tooltip.tr() : tooltip,
        excludeFromSemantics: true,
        child: content,
      );
    }
    return content;
  }

  List<Widget> _children(
    BuildContext context,
    CustomButtonTheme base,
    Color? foreground,
    bool translate,
  ) {
    final label = widget.label;
    return [
      if (widget.icon != null) ...[
        AppSvgPicture.fromAsset(
          widget.icon!,
          width: widget.iconSize ?? 16,
          height: widget.iconSize ?? 16,
          theme: PictureTheme(color: foreground),
        ),
        if (label != null || widget.suffix != null) 8.horizontalGap,
      ],
      if (widget.prefix != null) ...[
        widget.prefix!,
        if (label != null) 8.horizontalGap,
      ],
      if (label != null)
        Flexible(
          child: AppText(
            label,
            textAlign: TextAlign.center,
            translate: translate,
            style: context.textStyles.titleSmall.copyWith(
              color: base.labelColor ?? foreground,
              fontWeight: AppMaterialTextPrimitives.semibold,
              wordSpacing: 0.8,
            ),
          ),
        ),
      if (widget.suffix != null) ...[
        if (label != null) 8.horizontalGap,
        widget.suffix!,
      ],
    ];
  }
}
