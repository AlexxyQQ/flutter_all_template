import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../config/constants/enums/text_form_filed_enum.dart';
import '../../../../../../../../config/themes/components_theme/app_text_form_field_theme.dart';
import '../../../../../../domain/controllers/text_form_filed/text_field_controller.dart';
import '../../../../../extensions/size/size_extension.dart';
import '../../../../../extensions/theme/theme_extension.dart';
import '../../../../../helpers/handlers/field_interaction_handler.dart';
import '../../../../../helpers/handlers/picker_handler.dart';
import '../../../../../themes/styles/form_style.dart';
import '../../text/app_text_widget.dart';

/// A customizable text form field widget with support for various input types.
///
/// Supports: text, password, date picker, date range picker, time picker, and search.
///
/// Features:
/// - Built-in validation
/// - Optional title and note text
/// - Automatic date/time formatting
/// - Password visibility toggle
/// - Search field with clear button
/// - Customizable theming
class KTextFormField extends StatefulWidget {
  const KTextFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.titleText,
    this.initialValue,
    this.noteText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.theme,
    this.clear,
    this.isRequired = false,
  });

  final String? hintText;
  final String? labelText;
  final String? titleText;
  final String? noteText;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(dynamic)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String?)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final FormFieldTheme? theme;
  final bool? clear;
  final bool? isRequired;

  @override
  State<KTextFormField> createState() => _KTextFormFieldState();
}

class _KTextFormFieldState extends State<KTextFormField> {
  late final TextFieldControllerManager _controllerManager;
  late final PickerHandler _pickerHandler;
  late final FieldInteractionHandler _interactionHandler;

  FormFieldTheme get _theme => FormStyles.getTheme(widget.theme);

  @override
  void initState() {
    super.initState();
    _initializeManagers();
  }

  @override
  void didUpdateWidget(covariant KTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clear == true) {
      _controllerManager.resetToInitial(widget.initialValue);
      _pickerHandler.setDatePickerDefaultIfNeeded(_theme, widget.initialValue);
    }
  }

  @override
  void dispose() {
    _controllerManager.dispose();
    _interactionHandler.dispose();
    super.dispose();
  }

  void _initializeManagers() {
    _controllerManager = TextFieldControllerManager(
      externalController: widget.controller,
      initialValue: widget.initialValue,
      theme: _theme,
    );

    _pickerHandler = PickerHandler(
      controller: _controllerManager.controller,
      onChanged: widget.onChanged,
    );

    _interactionHandler = FieldInteractionHandler(
      controllerManager: _controllerManager,
    );

    // Set initial date picker value if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _pickerHandler.setDatePickerDefaultIfNeeded(_theme, widget.initialValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _interactionHandler.isPasswordObscured,
      builder: (context, isObscured, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: widget.titleText?.isNotEmpty ?? false
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            FieldHeader(
              titleText: widget.titleText,
              noteText: widget.noteText,
              isRequired: widget.isRequired,
              theme: _theme,
            ),
            _buildTextFormField(isObscured),
          ],
        );
      },
    );
  }

  Widget _buildTextFormField(bool isObscured) {
    return TextFormField(
      key: widget.key,
      autofillHints: _theme.autofillHints,
      readOnly: _getReadOnlyState(),
      controller: _controllerManager.controller,
      // textAlign: _theme.textAlign ?? TextAlign.start,
      keyboardType: _theme.keyboardType,
      obscuringCharacter: _theme.obscuringCharacter ?? '●',
      obscureText: _getObscureTextState(isObscured),
      inputFormatters: _theme.inputFormatters,
      enableSuggestions: _theme.enableSuggestions ?? true,
      autocorrect: _theme.autocorrect ?? true,
      textInputAction: _theme.inputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableIMEPersonalizedLearning:
          _theme.enableIMEPersonalizedLearning ?? true,
      style: _theme.effectiveContentStyle,
      focusNode: _controllerManager.getFocusNode(_theme),
      maxLines: _theme.maxLines,
      maxLength: _theme.maxLength,
      decoration: FieldDecorationBuilder.build(
        theme: _theme,
        hintText: widget.hintText?.tr(),
        labelText: widget.labelText?.tr(),
        isObscured: isObscured,
        textNotifier: _controllerManager.textNotifier,
        onTogglePassword: _interactionHandler.togglePasswordVisibility,
        onClearSearch: () => _handleSearchClear(),
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      onFieldSubmitted: widget.onFieldSubmitted,
      onEditingComplete: widget.onEditingComplete,
      onTap: _getEffectiveOnTap(),
      onTapOutside: _interactionHandler.handleTapOutside,
    );
  }

  bool _getReadOnlyState() {
    return (_theme.readOnly ?? false) ||
        _theme.inputType == AppInputTypeEnum.datePicker ||
        _theme.inputType == AppInputTypeEnum.dateRangePicker ||
        _theme.inputType == AppInputTypeEnum.timePicker;
  }

  bool _getObscureTextState(bool isObscured) {
    // return _theme.isPasswordField == true
    return _theme.inputAction == TextInputAction.done
        ? isObscured
        : (_theme.obscureText ?? false);
  }

  void Function()? _getEffectiveOnTap() {
    // if (_theme.isDatePickerFiled == true) {
    if (_theme.inputType == AppInputTypeEnum.datePicker) {
      return () =>
          _pickerHandler.selectDate(context, _theme, widget.initialValue);
    }
    // if (_theme.isDateRangePickerFiled == true) {
    if (_theme.inputType == AppInputTypeEnum.dateRangePicker) {
      return () =>
          _pickerHandler.selectDateRange(context, _theme, widget.initialValue);
    }
    // if (_theme.isTimePickerFiled == true) {
    if (_theme.inputType == AppInputTypeEnum.timePicker) {
      return () => _pickerHandler.selectTime(context);
    }
    return widget.onTap;
  }

  void _handleSearchClear() {
    _controllerManager.controller.clear();
    widget.onChanged?.call('');
  }
}

/// Displays the title and note text above the text field.
///
/// Shows:
/// - Title with optional required indicator
/// - Informational note with icon
class FieldHeader extends StatelessWidget {
  const FieldHeader({
    required this.theme,
    super.key,
    this.titleText,
    this.noteText,
    this.isRequired,
  });

  final String? titleText;
  final String? noteText;
  final bool? isRequired;
  final FormFieldTheme theme;

  @override
  Widget build(BuildContext context) {
    if ((titleText?.isEmpty ?? true) && (noteText?.isEmpty ?? true)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (titleText?.isNotEmpty ?? false) _buildTitleRow(context),
        if (noteText?.isNotEmpty ?? false) _buildNoteRow(),
      ],
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Padding(
      padding: 4.h.bottomOnly,
      child: Row(
        children: [
          Flexible(
            child: AppText(
              titleText!,
              style: theme.titleStyle ?? context.textStyles.bodyMedium,
            ),
          ),
          if (isRequired == true) ...[
            4.horizontalGap,
            AppText(theme.requiredCharacter, style: theme.requiredTextStyle),
          ],
        ],
      ),
    );
  }

  Widget _buildNoteRow() {
    return Padding(
      padding: 4.h.bottomOnly,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16.r, color: Colors.lime),
          4.horizontalGap,
          Expanded(child: AppText(noteText!)),
        ],
      ),
    );
  }
}

/// Builds the InputDecoration for the text field.
///
/// Handles:
/// - Border styles for all states
/// - Prefix and suffix icons
/// - Fill colors
/// - Padding and sizing
class FieldDecorationBuilder {
  static InputDecoration build({
    required FormFieldTheme theme,
    required String? hintText,
    required String? labelText,
    required bool isObscured,
    required ValueNotifier<String> textNotifier,
    required VoidCallback onTogglePassword,
    required VoidCallback onClearSearch,
  }) {
    return InputDecoration(
      contentPadding: theme.contentPadding,
      counterText: '',
      errorMaxLines: theme.errorMaxLines,
      fillColor: _getFillColor(theme),
      filled: theme.fillColor != null,
      hintText: hintText,
      hintStyle: theme.hintTextStyle,
      labelText: labelText,
      isDense: theme.isDense,
      prefixIcon: FieldIconBuilder.buildPrefixIcon(theme),
      suffixIcon: FieldIconBuilder.buildSuffixIcon(
        theme: theme,
        isObscured: isObscured,
        textNotifier: textNotifier,
        onTogglePassword: onTogglePassword,
        onClearSearch: onClearSearch,
      ),
      disabledBorder: _buildBorder(theme, theme.disabledBorderColor),
      enabledBorder: _buildBorder(theme, theme.effectiveEnabledBorderColor),
      focusedBorder: _buildBorder(theme, theme.focusedBorderColor),
      errorBorder: _buildBorder(theme, theme.errorBorderColor),
      focusedErrorBorder: _buildBorder(theme, theme.errorBorderColor),
      border: _buildBorder(theme, theme.enabledBorderColor),
    );
  }

  static Color? _getFillColor(FormFieldTheme theme) {
    return (theme.readOnly == true) ? theme.fillDisabledColor : theme.fillColor;
  }

  static InputBorder? _buildBorder(FormFieldTheme theme, Color? borderColor) {
    if (theme.noBorder ?? false) return InputBorder.none;

    return OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor ?? Colors.transparent,
        width: theme.borderWidth ?? 1.0,
      ),
      borderRadius: theme.borderRadius ?? 12.borderCircular,
    );
  }
}

/// Builds prefix and suffix icons for the text field.
///
/// Handles:
/// - Password visibility toggle
/// - Search clear button
/// - Date picker icon
/// - Custom icons from theme
class FieldIconBuilder {
  static Widget? buildPrefixIcon(FormFieldTheme theme) {
    if (theme.prefixIcon == null) return null;

    return Padding(
      padding: (8.h).topOnly + (8.h).bottomOnly + (12.w).leftOnly,
      child: theme.prefixIcon,
    );
  }

  static Widget? buildSuffixIcon({
    required FormFieldTheme theme,
    required bool isObscured,
    required ValueNotifier<String> textNotifier,
    required VoidCallback onTogglePassword,
    required VoidCallback onClearSearch,
  }) {
    Widget? icon;

    // Search field - show clear button when text is present
    // if (theme.isSearch == true) {
    if (theme.inputAction == TextInputAction.search) {
      return _buildSearchClearButton(textNotifier, onClearSearch);
    }

    // Password field - show visibility toggle
    // if (theme.isPasswordField == true) {
    if (theme.inputAction == TextInputAction.done) {
      icon = _buildPasswordToggle(isObscured, theme, onTogglePassword);
    }
    // Date picker field - show calendar icon
    // else if (theme.isDatePickerFiled == true) {
    else if (theme.inputType == AppInputTypeEnum.datePicker) {
      icon =
          theme.suffixIcon ??
          Icon(Icons.calendar_today_outlined, color: theme.iconColor, size: 20);
    }
    // Custom icon from theme
    else {
      icon = theme.suffixIcon;
    }

    if (icon == null) {
      return null;
    }

    return Padding(
      padding: (8.h).topOnly + (8.h).bottomOnly + (12.w).rightOnly,
      child: icon,
    );
  }

  static Widget _buildSearchClearButton(
    ValueNotifier<String> textNotifier,
    VoidCallback onClear,
  ) {
    return Padding(
      padding: (8.h).topOnly + (8.h).bottomOnly + (12.w).rightOnly,
      child: ValueListenableBuilder<String>(
        valueListenable: textNotifier,
        builder: (context, text, child) {
          if (text.trim().isEmpty) return const SizedBox.shrink();

          return GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close_rounded, size: 20),
          );
        },
      ),
    );
  }

  static Widget _buildPasswordToggle(
    bool isObscured,
    FormFieldTheme theme,
    VoidCallback onToggle,
  ) {
    return GestureDetector(
      onTap: onToggle,
      child: Icon(
        isObscured ? Icons.visibility_off : Icons.visibility,
        color: theme.iconColor,
        size: 20,
      ),
    );
  }
}
