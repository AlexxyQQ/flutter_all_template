import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../extensions/size/size_extension.dart';
import '../../../extensions/theme/theme_extension.dart';

class AppSelection extends StatefulWidget {
  // 1. Constructor for Checkbox (Square with Checkmark)
  const AppSelection.checkbox({
    required this.value,
    super.key,
    this.onChanged,
    this.showIcon = true,
    this.borderRadius,
  }) : _isRadio = false;

  // 2. Constructor for Radio (Circle with Dot)
  const AppSelection.radio({
    required this.value,
    super.key,
    this.onChanged,
    this.showIcon = true,
  }) : _isRadio = true,
       borderRadius = null; // Radios are always circular

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool showIcon;
  final BorderRadius? borderRadius;

  // Internal flag to determine behavior (No Enum used)
  final bool _isRadio;

  @override
  State<AppSelection> createState() => _AppSelectionState();
}

class _AppSelectionState extends State<AppSelection> {
  late bool _localValue;

  @override
  void initState() {
    super.initState();
    _localValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant AppSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync if parent updates the value
    if (widget.value != oldWidget.value) {
      _localValue = widget.value;
    }
  }

  void _handleTap() {
    setState(() {
      _localValue = !_localValue;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(_localValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logic: If it is a radio, shape is circle. If checkbox, rectangle.
    final shape = widget._isRadio ? BoxShape.circle : BoxShape.rectangle;

    // Logic: If radio, no border radius needed (it's a circle).
    // If checkbox, use provided radius or default to 6.r
    final effectiveRadius = widget._isRadio
        ? null
        : (widget.borderRadius ?? BorderRadius.circular(6.r));

    // Colors
    final activeColor = context.colors.primary;
    final inactiveColor = context.colors.outlineVariant;
    final borderColor = _localValue
        ? activeColor
        : context.colors.outlineVariant;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24.w,
        height: 24.h,
        margin: 4.w.horizontalPadding,
        decoration: BoxDecoration(
          color: _localValue ? activeColor : inactiveColor,
          shape: shape,
          borderRadius: effectiveRadius,
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: _localValue && widget.showIcon
            ? Center(
                child: Icon(
                  // Radio gets a Dot, Checkbox gets a Check
                  widget._isRadio ? Icons.circle : Icons.check,
                  size: widget._isRadio ? 10.r : 16.r,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
