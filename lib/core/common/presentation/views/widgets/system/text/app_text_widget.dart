import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../extensions/theme/theme_extension.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.translate = true,
  }) : _isNote = false;

  /// Small caption-style text (theme `labelSmall`).
  const AppText.note({
    required this.data,
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.translate = true,
  }) : style = null,
       _isNote = true;
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool translate;
  final bool _isNote;

  @override
  Widget build(BuildContext context) {
    return Text(
      translate ? data.tr() : data,
      style: _isNote ? context.textStyles.labelSmall : style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
