import 'package:flutter/material.dart';

import '../../../../../config/themes/components_theme/app_text_form_field_theme.dart';
import '../../../domain/controllers/text_form_field/text_field_controller.dart';

/// Handles user interactions with the text field.
///
/// Manages:
/// - Password visibility toggling
/// - Focus management
/// - Tap outside handling
class FieldInteractionHandler {
  FieldInteractionHandler({
    required TextFieldControllerManager controllerManager,
  }) : _controllerManager = controllerManager;

  final TextFieldControllerManager _controllerManager;
  final ValueNotifier<bool> isPasswordObscured = ValueNotifier(true);

  /// Toggles password visibility
  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  /// Handles tap outside the field (unfocus)
  void handleTapOutside(PointerDownEvent details) {
    _controllerManager.getFocusNode(FormFieldTheme()).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void dispose() {
    isPasswordObscured.dispose();
  }
}
