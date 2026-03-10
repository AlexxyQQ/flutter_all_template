import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../extensions/size/size_extension.dart';
import '../../../extensions/theme/theme_extension.dart';
import 'icon/app_icon_widget.dart';
import 'text/app_text_widget.dart';

class AppSwitchController extends ValueNotifier<bool> {
  AppSwitchController([super.value = false]);

  void toggle() {
    value = !value;
  }

  void setValue(bool newValue) {
    value = newValue;
  }
}

class AppSwitch extends StatefulWidget {
  const AppSwitch({
    super.key,
    this.titleText,
    this.noteText,
    this.controller,
    this.onChanged,
    this.initialValue = false,
    this.titleStyle,
  });
  final String? titleText;
  final String? noteText;
  final AppSwitchController? controller;
  final void Function(bool)? onChanged;
  final bool initialValue;
  final TextStyle? titleStyle;

  @override
  State<AppSwitch> createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch> {
  late AppSwitchController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? AppSwitchController(widget.initialValue);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleChanged(bool value) {
    _controller.setValue(value);
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.titleText?.isNotEmpty == true) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: AppText(
                  widget.titleText ?? '',
                  style: widget.titleStyle ?? context.textStyles.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              // Added gap between text and switch
              8.horizontalGap,
              ValueListenableBuilder<bool>(
                valueListenable: _controller,
                builder: (context, value, child) {
                  return Switch(
                    value: value,
                    onChanged: _handleChanged,
                    activeThumbColor: context.colors.primary,
                    inactiveThumbColor: context.colors.outline,
                    inactiveTrackColor: context.colors.outlineVariant,
                  );
                },
              ),
            ],
          ),
        ] else ...[
          // Standalone switch (No title)
          ValueListenableBuilder<bool>(
            valueListenable: _controller,
            builder: (context, value, child) {
              return Switch(
                value: value,
                onChanged: _handleChanged,
                activeThumbColor: context.colors.primary,
                inactiveThumbColor: context.colors.outline,
                inactiveTrackColor: context.colors.outlineVariant,
              );
            },
          ),
        ],

        if (widget.noteText?.isNotEmpty == true) ...[
          // Removed verticalGap inside Row and replaced with horizontalGap
          // or just padding.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: 2.h.topOnly, // Align icon with text top
                child: AppIcon(Icons.info_outline, size: 16.r),
              ),

              4.horizontalGap, // CHANGED: verticalGap to horizontalGap for Row

              Expanded(
                child: AppText(
                  widget.noteText ?? '',
                  style: context.textStyles.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
