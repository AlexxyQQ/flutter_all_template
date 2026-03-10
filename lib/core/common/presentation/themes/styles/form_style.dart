import 'package:flutter/material.dart';

import '../../../../../config/constants/colors/material/material_primitive_colors.dart';
import '../../../../../config/constants/text/material/app_material_text_style.dart';
import '../../../../../config/themes/components_theme/app_text_form_field_theme.dart';
import '../../extensions/size/size_extension.dart';
import '../colors/app_material_colors.dart';

class FormStyles {
  /// Creates a KTextFormFieldTheme based on the current context's theme
  static FormFieldTheme getTheme(FormFieldTheme? theme) {
    // 1. Define the base default theme
    final defaultTheme = FormFieldTheme(
      // --- Styling Defaults ---
      fillColor: AppMaterialColors.surface,
      contentStyle: AppMaterialTextStyles.bodyLarge.copyWith(
        color: AppMaterialPrimitives.neutral20,
      ),
      hintTextStyle: AppMaterialTextStyles.bodyLarge,
      titleStyle: AppMaterialTextStyles.bodyMedium,
      errorTextStyle: AppMaterialTextStyles.labelMedium,
      fillDisabledColor: AppMaterialColors.surfaceContainerLowest,
      disabledTextColor: AppMaterialColors.primaryFixedDim,
      iconColor: AppMaterialColors.onSurface,
      isDense: true,

      // --- Border Defaults ---
      borderRadius: 12.borderCircular,
      contentPadding: 10.allPadding,
      enabledBorderColor: AppMaterialColors.primaryContainer,
      focusedBorderColor: AppMaterialColors.primary,
      errorBorderColor: AppMaterialColors.error,
      disabledBorderColor: AppMaterialColors.inverseSurface,
      borderWidth: 0.6,
      noBorder: false,

      // --- Behavior Defaults ---
      errorMaxLines: 1,
      enableSuggestions: true,
      autocorrect: true,
      enableIMEPersonalizedLearning: true,
      maxLines: 1,
      readOnly: false, // Enum can override this later
      obscuringCharacter: '●',
      prefixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
    );

    // 2. If no override theme is provided, return default
    if (theme == null) {
      return defaultTheme;
    }

    // 3. Merge: Apply 'theme' values.
    // Note: Since 'inputType' has a @Default in the freezed class, it is rarely null.
    return defaultTheme.copyWith(
      // --- Core Configuration ---
      inputType: theme.inputType,
      focusNode: theme.focusNode ?? defaultTheme.focusNode,
      controller: theme.controller ?? defaultTheme.controller,

      // --- Decoration & Colors ---
      fillColor: theme.fillColor ?? defaultTheme.fillColor,
      fillDisabledColor:
          theme.fillDisabledColor ?? defaultTheme.fillDisabledColor,
      iconColor: theme.iconColor ?? defaultTheme.iconColor,
      prefixIcon: theme.prefixIcon ?? defaultTheme.prefixIcon,
      suffixIcon: theme.suffixIcon ?? defaultTheme.suffixIcon,
      prefixIconConstraints:
          theme.prefixIconConstraints ?? defaultTheme.prefixIconConstraints,
      isDense: theme.isDense ?? defaultTheme.isDense,

      // --- Text Styles ---
      contentStyle: theme.contentStyle ?? defaultTheme.contentStyle,
      hintTextStyle: theme.hintTextStyle ?? defaultTheme.hintTextStyle,
      labelTextStyle: theme.labelTextStyle ?? defaultTheme.labelTextStyle,
      titleStyle: theme.titleStyle ?? defaultTheme.titleStyle,
      errorTextStyle: theme.errorTextStyle ?? defaultTheme.errorTextStyle,

      // --- Borders ---
      borderRadius: theme.borderRadius ?? defaultTheme.borderRadius,
      enabledBorderColor:
          theme.enabledBorderColor ?? defaultTheme.enabledBorderColor,
      focusedBorderColor:
          theme.focusedBorderColor ?? defaultTheme.focusedBorderColor,
      errorBorderColor: theme.errorBorderColor ?? defaultTheme.errorBorderColor,
      disabledBorderColor:
          theme.disabledBorderColor ?? defaultTheme.disabledBorderColor,
      borderWidth: theme.borderWidth ?? defaultTheme.borderWidth,
      contentPadding: theme.contentPadding ?? defaultTheme.contentPadding,
      noBorder: theme.noBorder ?? defaultTheme.noBorder,
      isCustomBorder: theme.isCustomBorder ?? defaultTheme.isCustomBorder,

      // --- Input Behavior ---
      enableSuggestions:
          theme.enableSuggestions ?? defaultTheme.enableSuggestions,
      autocorrect: theme.autocorrect ?? defaultTheme.autocorrect,
      enableIMEPersonalizedLearning:
          theme.enableIMEPersonalizedLearning ??
          defaultTheme.enableIMEPersonalizedLearning,
      maxLines: theme.maxLines ?? defaultTheme.maxLines,
      minLines: theme.minLines ?? defaultTheme.minLines,
      maxLength: theme.maxLength ?? defaultTheme.maxLength,
      readOnly: theme.readOnly ?? defaultTheme.readOnly,
      inputAction: theme.inputAction ?? defaultTheme.inputAction,
      autofillHints: theme.autofillHints ?? defaultTheme.autofillHints,
      inputFormatters: theme.inputFormatters ?? defaultTheme.inputFormatters,
      keyboardType: theme.keyboardType ?? defaultTheme.keyboardType,

      // --- Security & Password ---
      // We prioritize the theme's obscureText if set, otherwise fallback to default (which is null, allowing logic to work)
      obscureText: theme.obscureText ?? defaultTheme.obscureText,
      obscuringCharacter: theme
          .obscuringCharacter, // String is not nullable in default, so we take theme directly (or it has its own default)
      // --- Pickers & Date ---
      minDate: theme.minDate ?? defaultTheme.minDate,
      maxDate: theme.maxDate ?? defaultTheme.maxDate,
      // Removed: isTimePickerFiled, isDatePickerFiled, isDateRangePickerFiled (handled by inputType)

      // --- Validation ---
      errorMaxLines: theme.errorMaxLines ?? defaultTheme.errorMaxLines,
      requiredCharacter: theme.requiredCharacter,
      requiredColor: theme.requiredColor ?? defaultTheme.requiredColor,
    );
  }
}
