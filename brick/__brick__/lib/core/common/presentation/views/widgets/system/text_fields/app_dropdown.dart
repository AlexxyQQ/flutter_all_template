import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../config/themes/components_theme/app_text_form_field_theme.dart';
import '../../../../extensions/size/size_extension.dart';
import '../../../../extensions/theme/theme_extension.dart';
import '../../../../themes/styles/form_style.dart';
import '../icon/app_icon_widget.dart';
import '../text/app_text_widget.dart';

class AppDropdown<T> extends StatefulWidget {
  const AppDropdown({
    required this.value,
    required this.items,
    super.key,
    this.hint,
    this.onChanged,
    this.itemBuilder,
    this.displayStringForItem,
    this.theme,
    this.titleText,
    this.isRequired = false,
    this.disabled = false,
  });

  final T? value;
  final List<T> items;
  final String? hint;
  final String? titleText;
  final bool? isRequired;
  final bool? disabled;
  final Function(T?)? onChanged;
  final Widget Function(T item)? itemBuilder;
  final String Function(T item)? displayStringForItem;
  final FormFieldTheme? theme;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  // Moved theme calculation to build to ensure it updates if the widget rebuilds
  // with a new theme configuration.

  String _getDisplayText() {
    if (widget.value == null) {
      return widget.hint ?? 'Select an option';
    }
    if (widget.displayStringForItem != null) {
      return widget.displayStringForItem!(widget.value as T);
    }
    return widget.value.toString();
  }

  Future<void> _showDropdown() async {
    // Get latest theme data
    final effectiveTheme = FormStyles.getTheme(widget.theme);

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // Use theme for popup menu style
    final popupColor = effectiveTheme.fillColor ?? context.colors.surface;
    final popupShape = RoundedRectangleBorder(
      borderRadius: effectiveTheme.borderRadius ?? 8.rounded,
      side: effectiveTheme.enabledBorderColor != null
          ? BorderSide(color: effectiveTheme.enabledBorderColor!)
          : BorderSide.none,
    );

    // Determine text style for menu items
    final itemStyle =
        effectiveTheme.contentStyle ??
        TextStyle(
          color: context.colors.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 13.0,
          height: 22 / 13,
        );

    final selectedItem = await showMenu<T>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height + 4,
        MediaQuery.of(context).size.width - position.dx - size.width,
        0,
      ),
      constraints: BoxConstraints(minWidth: size.width, maxWidth: size.width),
      items: widget.items.map((T item) {
        return PopupMenuItem<T>(
          value: item,
          child: widget.itemBuilder != null
              ? widget.itemBuilder!(item)
              : AppText(
                  widget.displayStringForItem != null
                      ? widget.displayStringForItem!(item)
                      : item.toString(),
                  style: itemStyle,
                ),
        );
      }).toList(),
      elevation: 4.0,
      shape: popupShape,
      color: popupColor,
    );

    if (selectedItem != null && widget.onChanged != null) {
      widget.onChanged!(selectedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Resolve effective colors and styles
    final effectiveTheme = FormStyles.getTheme(widget.theme);

    final effectiveFillColor =
        effectiveTheme.fillColor ?? context.colors.surface;
    final effectiveBorderRadius = effectiveTheme.borderRadius ?? 8.rounded;
    final effectivePadding = effectiveTheme.contentPadding ?? 10.allPadding;

    // Border Logic
    BoxBorder? border;
    if (effectiveTheme.noBorder != true) {
      if (effectiveTheme.enabledBorderColor != null ||
          effectiveTheme.borderWidth != null) {
        border = Border.all(
          color: effectiveTheme.enabledBorderColor ?? Colors.transparent,
          width: effectiveTheme.borderWidth ?? 1.0,
        );
      }
    }

    // Text Styles
    final isHint = widget.value == null;
    final baseTextStyle = isHint
        ? (effectiveTheme.hintTextStyle ??
              TextStyle(
                color: context.colors.outlineVariant,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ))
        : (effectiveTheme.contentStyle ??
              TextStyle(
                color: context.colors.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ));

    return Column(
      children: [
        // Title
        if (widget.titleText?.isEmpty == false) ...[
          Row(
            children: [
              AppText(
                widget.titleText ?? '',
                style:
                    effectiveTheme.titleStyle?.copyWith(
                      color: widget.disabled == true
                          ? context.colors.outlineVariant
                          : null,
                    ) ??
                    context.textStyles.bodyLarge.copyWith(
                      color: widget.disabled == true
                          ? context.colors.onSurface
                          : null,
                    ),
              ),
              if (widget.isRequired == true) ...[
                4.horizontalGap,
                // Is Required
                AppText(
                  '*',
                  style:
                      effectiveTheme.titleStyle?.copyWith(
                        color: context.colors.error,
                      ) ??
                      context.textStyles.bodyLarge.copyWith(
                        color: context.colors.error,
                      ),
                ),
              ],
            ],
          ),
          4.verticalGap,
        ],
        // Input Area
        GestureDetector(
          onTap: widget.disabled == true ? null : _showDropdown,
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              color: widget.disabled == true
                  ? context.colors.outlineVariant
                  : effectiveFillColor,
              borderRadius: effectiveBorderRadius,
              border: border,
              // Removed dynamic shadow logic as it was tied to press state
            ),
            padding: effectivePadding,
            height: effectiveTheme.isDense == true ? 40 : null,
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    _getDisplayText(),
                    style: baseTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AppIcon(
                  Icons.arrow_drop_down_rounded,
                  size: 24.r,
                  onTap: widget.disabled == true ? null : _showDropdown,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
