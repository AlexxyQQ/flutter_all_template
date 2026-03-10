import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../../config/constants/enums/text_form_filed_enum.dart';
import '../../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../../config/themes/components_theme/app_text_form_field_theme.dart';
import 'base/custom_text_form_field_widget.dart';

class AppTextField extends StatelessWidget {
  // ===========================================================================
  // Factory Constructors
  // ===========================================================================

  /// 1. Standard Text Input
  factory AppTextField.text({
    Key? key,
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    String? noteText,
    String? titleText,
    String? initialValue,
    bool isRequired = false,
    bool? clear,
    bool? readOnly,
    String? Function(String?)? validator,
    void Function(dynamic)? onChanged,
    void Function(String?)? onSaved,
    void Function(String?)? onFieldSubmitted,
    void Function()? onEditingComplete,
    void Function()? onTap,
    int? maxLines = 1,
    int? maxLength,
    Widget? prefixIcon,
    Widget? suffixIcon,
    FormFieldTheme? theme,
  }) {
    return AppTextField._(
      key: key,
      inputType: AppInputTypeEnum.text,
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      noteText: noteText,
      titleText: titleText,
      initialValue: initialValue,
      isRequired: isRequired,
      clear: clear,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      onTap: onTap,
      maxLines: maxLines,
      maxLength: maxLength,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      themeOverrides: theme,
    );
  }

  /// 2. Password Input
  factory AppTextField.password({
    Key? key,
    TextEditingController? controller,
    String? hintText = LocaleKeys.common_form_field_titles_password,
    String? labelText,
    String? noteText,
    String? titleText = LocaleKeys.common_form_field_titles_password,
    bool isRequired = true,
    bool? readOnly,
    bool? clear,
    String? Function(String?)? validator,
    void Function(dynamic)? onChanged,
    void Function(String?)? onSaved,
    void Function(String?)? onFieldSubmitted,
    void Function()? onEditingComplete,
    TextInputAction textInputAction = TextInputAction.done,
    FormFieldTheme? theme,
  }) {
    return AppTextField._(
      key: key,
      inputType: AppInputTypeEnum.password,
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      noteText: noteText,
      titleText: titleText,
      isRequired: isRequired,
      clear: clear,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      maxLines: 1,
      textInputAction: textInputAction,
      prefixIcon: const Icon(Icons.lock_outline),
      themeOverrides: theme,
    );
  }

  /// 3. Email Input
  factory AppTextField.email({
    Key? key,
    TextEditingController? controller,
    String? hintText = 'example@email.com',
    String? labelText,
    String? noteText,
    String? titleText = LocaleKeys.common_form_field_titles_email,
    String? initialValue,
    bool isRequired = false,
    bool? clear,
    bool? readOnly,
    String? Function(String?)? validator,
    void Function(dynamic)? onChanged,
    void Function(String?)? onSaved,
    void Function(String?)? onFieldSubmitted,
    void Function()? onEditingComplete,
    FormFieldTheme? theme,
  }) {
    return AppTextField._(
      key: key,
      inputType: AppInputTypeEnum.email,
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      noteText: noteText,
      titleText: titleText,
      initialValue: initialValue,
      isRequired: isRequired,
      clear: clear,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined),
      themeOverrides: theme,
    );
  }

  /// 4. Search Input
  factory AppTextField.search({
    Key? key,
    TextEditingController? controller,
    String? hintText = 'Search...',
    void Function(dynamic)? onChanged,
    VoidCallback? onEditingComplete,
    void Function(String?)? onFieldSubmitted,
    bool? clear,
    FormFieldTheme? theme,
  }) {
    return AppTextField._(
      key: key,
      inputType: AppInputTypeEnum.search,
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      clear: clear,
      textInputAction: TextInputAction.search,
      prefixIcon: const Icon(Icons.search),
      themeOverrides: theme,
    );
  }

  /// 5. Number/Phone Input
  factory AppTextField.number({
    Key? key,
    TextEditingController? controller,
    String? hintText,
    String? titleText,
    String? initialValue,
    bool isPhone = false,
    bool isRequired = false,
    bool? clear,
    bool? readOnly,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(dynamic)? onChanged,
    void Function(String?)? onSaved,
    void Function(String?)? onFieldSubmitted,
    void Function()? onEditingComplete,
    int? maxLength = 10,
    FormFieldTheme? theme,
  }) {
    return AppTextField._(
      key: key,
      inputType: isPhone ? AppInputTypeEnum.phone : AppInputTypeEnum.number,
      controller: controller,
      hintText: hintText,
      titleText: titleText,
      initialValue: initialValue,
      isRequired: isRequired,
      clear: clear,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      maxLines: 1,
      maxLength: maxLength,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.number,
      themeOverrides: theme?.copyWith(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  /// 6. Multiline/Area Input
  factory AppTextField.multiline({
    Key? key,
    TextEditingController? controller,
    String? hintText,
    String? titleText,
    String? initialValue,
    bool isRequired = false,
    bool? clear,
    bool? readOnly,
    String? Function(String?)? validator,
    void Function(dynamic)? onChanged,
    void Function(String?)? onSaved,
    int minLines = 3,
    int maxLines = 5,
    int? maxLength,
    FormFieldTheme? theme,
  }) {
    return AppTextField._(
      key: key,
      inputType: AppInputTypeEnum.multiline,
      controller: controller,
      hintText: hintText,
      titleText: titleText,
      initialValue: initialValue,
      isRequired: isRequired,
      clear: clear,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      themeOverrides: theme,
    );
  }

  /// 7. Date Picker
  factory AppTextField.datePicker({
    Key? key,
    TextEditingController? controller,
    String? hintText = LocaleKeys.common_form_field_titles_selectDate,
    String? titleText,
    DateTime? initialValue,
    bool isRequired = false,
    bool? clear,
    bool? readOnly = true,
    String? Function(String?)? validator,
    void Function(dynamic)? onChanged,
    void Function(String?)? onSaved,
    DateTime? minDate,
    DateTime? maxDate,
    FormFieldTheme? theme,
  }) {
    return AppTextField._(
      key: key,
      inputType: AppInputTypeEnum.datePicker,
      controller: controller,
      hintText: hintText,
      titleText: titleText,
      initialValue: initialValue.toString(),
      isRequired: isRequired,
      clear: clear,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      minDate: minDate,
      maxDate: maxDate,
      suffixIcon: const Icon(Icons.calendar_month),
      themeOverrides: theme,
    );
  }

  /// 8. Time Picker
  factory AppTextField.timePicker({
    Key? key,
    TextEditingController? controller,
    String? hintText = LocaleKeys.common_form_field_titles_selectTime,
    String? titleText,
    TimeOfDay? initialValue,
    bool isRequired = false,
    bool? clear,
    bool? readOnly = true,
    String? Function(String?)? validator,
    void Function(dynamic)? onChanged,
    void Function(String?)? onSaved,
    FormFieldTheme? theme,
  }) {
    return AppTextField._(
      key: key,
      inputType: AppInputTypeEnum.timePicker,
      controller: controller,
      hintText: hintText,
      titleText: titleText,
      initialValue: initialValue.toString(),
      isRequired: isRequired,
      clear: clear,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      suffixIcon: const Icon(Icons.access_time),
      themeOverrides: theme,
    );
  }

  /// 9. Date Range Picker
  factory AppTextField.dateRangePicker({
    Key? key,
    TextEditingController? controller,
    String? hintText = LocaleKeys.common_form_field_titles_selectDateRange,
    String? titleText,
    List<DateTime>? initialValue,
    bool isRequired = false,
    bool? clear,
    bool? readOnly = true,
    String? Function(String?)? validator,
    void Function(dynamic)? onChanged,
    void Function(String?)? onSaved,
    DateTime? minDate,
    DateTime? maxDate,
    FormFieldTheme? theme,
  }) {
    return AppTextField._(
      key: key,
      inputType: AppInputTypeEnum.dateRangePicker,
      controller: controller,
      hintText: hintText,
      titleText: titleText,
      initialValue: initialValue.toString(),
      isRequired: isRequired,
      clear: clear,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      minDate: minDate,
      maxDate: maxDate,
      suffixIcon: const Icon(Icons.calendar_month),
      themeOverrides: theme,
    );
  }

  /// Base Private Constructor
  const AppTextField._({
    required this.inputType,
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.titleText,
    this.noteText,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.themeOverrides,
    this.isRequired = false,
    this.clear,
    // specific overrides
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.textInputAction,
    this.keyboardType,
    this.minDate,
    this.maxDate,
    this.readOnly,
  });

  final AppInputTypeEnum inputType;
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? titleText;
  final String? noteText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(dynamic)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String?)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final FormFieldTheme? themeOverrides;
  final bool isRequired;
  final bool? clear;

  // Specific Style/Behavior Overrides
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool? readOnly;

  // ===========================================================================
  // Build Method
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    // 1. Start with the user provided theme or a fresh one
    final baseTheme = themeOverrides ?? FormFieldTheme();

    // 2. Merge factory-specific overrides into the theme
    final effectiveTheme = baseTheme.copyWith(
      inputType: inputType,
      prefixIcon: prefixIcon ?? baseTheme.prefixIcon,
      suffixIcon: suffixIcon ?? baseTheme.suffixIcon,
      maxLines: maxLines ?? baseTheme.maxLines,
      minLines: minLines ?? baseTheme.minLines,
      maxLength: maxLength ?? baseTheme.maxLength,
      inputAction: textInputAction ?? baseTheme.inputAction,
      keyboardType: keyboardType ?? baseTheme.keyboardType,
      readOnly: readOnly ?? baseTheme.readOnly,
      minDate: minDate ?? baseTheme.minDate,
      maxDate: maxDate ?? baseTheme.maxDate,
    );

    // 3. Return the heavy-lifter widget
    return KTextFormField(
      key: key, // Pass the key down
      controller: controller,
      initialValue: initialValue,
      hintText: hintText,
      labelText: labelText,
      noteText: noteText,
      titleText: titleText,
      isRequired: isRequired,
      clear: clear,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      onTap: onTap,
      theme: effectiveTheme.copyWith(readOnly: readOnly),
    );
  }
}
