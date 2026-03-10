import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/common/presentation/views/components/app_color.dart';
import '../../constants/colors/material/material_primitive_colors.dart';
import '../../constants/enums/text_form_filed_enum.dart';
import '../../constants/text/material/app_material_text_style.dart';

part 'app_text_form_field_theme.freezed.dart';

@freezed
abstract class FormFieldTheme with _$FormFieldTheme {
  const FormFieldTheme._();

  factory FormFieldTheme({
    // --- Core Configuration ---
    @AppInputTypeEnumConverter()
    @Default(AppInputTypeEnum.text)
    AppInputTypeEnum inputType,
    Key? key,
    FocusNode? focusNode,
    TextEditingController?
    controller, // Ideally passed to the widget, but often kept here in config objects
    // --- Styling ---
    KAppColor? fillColor,
    KAppColor? disabledTextColor,
    TextStyle? contentStyle,
    TextStyle? hintTextStyle,
    TextStyle? labelTextStyle,
    TextStyle? titleStyle,
    TextStyle? errorTextStyle,

    // --- Borders ---
    BorderRadius? borderRadius,
    KAppColor? enabledBorderColor,
    KAppColor? focusedBorderColor,
    KAppColor? errorBorderColor,
    KAppColor? disabledBorderColor,
    KAppColor? fillDisabledColor,
    double? borderWidth,
    bool? noBorder,
    bool? isCustomBorder,

    // --- Layout & Icons ---
    EdgeInsetsGeometry? contentPadding,
    bool? isDense,
    KAppColor? iconColor,
    Widget? prefixIcon,
    Widget? suffixIcon,
    BoxConstraints? prefixIconConstraints,

    // --- Behavior ---
    bool? readOnly,
    bool? enableSuggestions,
    bool? autocorrect,
    bool? obscureText, // Can override the default Enum behavior
    bool? enableIMEPersonalizedLearning,
    int? maxLines,
    int? minLines,
    int? maxLength,
    int? errorMaxLines,

    // --- Input Logic ---
    TextInputAction? inputAction,
    List<String>? autofillHints,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    @Default('*') String obscuringCharacter,

    // --- Validation/Requirements ---
    @Default('*') String requiredCharacter,
    @Default(AppMaterialPrimitives.error50) KAppColor? requiredColor,

    // --- Date/Time Specifics ---
    DateTime? minDate,
    DateTime? maxDate,
  }) = _FormFieldTheme;

  // --- Computed Properties & Helpers ---

  /// Determines the effective Keyboard Type based on the Enum
  TextInputType get effectiveKeyboardType {
    if (keyboardType != null) return keyboardType!;

    return switch (inputType) {
      AppInputTypeEnum.text ||
      AppInputTypeEnum.password ||
      AppInputTypeEnum.search => TextInputType.text,
      AppInputTypeEnum.email => TextInputType.emailAddress,
      AppInputTypeEnum.number => TextInputType.number,
      AppInputTypeEnum.phone => TextInputType.phone,
      AppInputTypeEnum.multiline => TextInputType.multiline,
      _ => TextInputType.text,
    };
  }

  /// Determines if text should be obscured.
  /// Returns explicit `obscureText` if set, otherwise defaults based on Enum.
  bool get isObscured =>
      obscureText ?? (inputType == AppInputTypeEnum.password);

  /// Determines if the field is read-only (e.g. Date Pickers are usually read-only text fields that open a modal).
  bool get isReadOnly =>
      readOnly ??
      (inputType == AppInputTypeEnum.datePicker ||
          inputType == AppInputTypeEnum.dateRangePicker ||
          inputType == AppInputTypeEnum.timePicker);

  TextStyle get effectiveContentStyle =>
      contentStyle?.copyWith(color: isReadOnly ? disabledTextColor : null) ??
      AppMaterialTextStyles.bodyLarge.copyWith(
        color: isReadOnly ? disabledTextColor : null,
      );

  KAppColor get effectiveEnabledBorderColor => isReadOnly
      ? (disabledBorderColor ?? AppMaterialPrimitives.transparent)
      : (enabledBorderColor ?? AppMaterialPrimitives.transparent);

  TextStyle get requiredTextStyle =>
      titleStyle?.copyWith(color: requiredColor) ??
      AppMaterialTextStyles.bodyLarge.copyWith(color: requiredColor);
}
