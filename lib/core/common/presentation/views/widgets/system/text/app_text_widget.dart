import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../config/constants/text/material/app_material_text_style.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.translate = true,
  });

  factory AppText.note({
    required String data,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText(
      data,
      style: AppMaterialTextStyles.labelSmall,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool translate;

  @override
  Widget build(BuildContext context) {
    return Text(
      translate ? data.tr() : data,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
