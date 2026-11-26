import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../constants/colors/material/material_primitive_colors.dart';
import '../../constants/enums/text_form_field_enum.dart';

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
    Color? fillColor,
    Color? disabledTextColor,
    TextStyle? contentStyle,
    TextStyle? hintTextStyle,
    TextStyle? labelTextStyle,
    TextStyle? titleStyle,
    TextStyle? errorTextStyle,

    // --- Borders ---
    BorderRadius? borderRadius,
    Color? enabledBorderColor,
    Color? focusedBorderColor,
    Color? errorBorderColor,
    Color? disabledBorderColor,
    Color? fillDisabledColor,
    double? borderWidth,
    bool? noBorder,
    bool? isCustomBorder,

    // --- Layout & Icons ---
    EdgeInsetsGeometry? contentPadding,
    bool? isDense,
    Color? iconColor,
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
    Color? requiredColor,

    // --- Date/Time Specifics ---
    DateTime? minDate,
    DateTime? maxDate,
  }) = _FormFieldTheme;

  // --- Computed Properties & Helpers ---

  /// Determines the effective Keyboard Type based on the Enum
  TextInputType get effectiveKeyboardType {
    if (keyboardType != null) {
      return keyboardType!;
    }

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

  TextStyle get effectiveContentStyle => (contentStyle ?? const TextStyle())
      .copyWith(color: isReadOnly ? disabledTextColor : null);

  Color get effectiveEnabledBorderColor => isReadOnly
      ? (disabledBorderColor ?? AppMaterialPrimitives.transparent)
      : (enabledBorderColor ?? AppMaterialPrimitives.transparent);

  TextStyle get requiredTextStyle =>
      (titleStyle ?? const TextStyle()).copyWith(color: requiredColor);
}
