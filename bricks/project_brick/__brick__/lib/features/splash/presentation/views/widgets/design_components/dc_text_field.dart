import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
// Alias to avoid conflicts if any

// Import your specific files
import '../../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../../core/common/presentation/extensions/validation/form_validator_extension.dart';
import '../../../../../../core/common/presentation/views/widgets/system/app_divider.dart';
import '../../../../../../core/common/presentation/views/widgets/system/text_fields/app_dropdown.dart';
import '../../../../../../core/common/presentation/views/widgets/system/text_fields/app_text_filed.dart';
import '../design_components_widgets.dart';

class DcTextField extends StatefulWidget {
  const DcTextField({super.key});

  @override
  State<DcTextField> createState() => _DcTextFieldState();
}

class _DcTextFieldState extends State<DcTextField> {
  // Controller needed specifically for Confirm Password validation
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: 16.w.allPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_text_form_field_showcase,
          ),

          // ---------------------------------------------------------
          // 1. Identity & Contact
          // ---------------------------------------------------------
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_identity_contact,
          ),
          AppTextField.text(
            titleText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_full_name,
            hintText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_eg_john_doe,
            isRequired: true,
            readOnly: true,
            validator: (v) => v.validateName().fold((l) => l, (r) => null),
          ),
          16.verticalGap,
          AppTextField.email(
            titleText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_email_address,
            hintText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_userexamplecom,
            isRequired: true,
            validator: (v) => v.validateEmail().fold((l) => l, (r) => null),
          ),
          16.verticalGap,
          AppTextField.number(
            titleText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_phone_number,
            hintText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_eg_1234567890,
            isPhone: true,
            isRequired: true,
            validator: (v) =>
                v.validatePhoneNumber().fold((l) => l, (r) => null),
          ),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,
          // ---------------------------------------------------------
          // 2. Security (Password Matching)
          // ---------------------------------------------------------
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_security,
          ),
          AppTextField.password(
            controller: _passwordController,
            noteText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_min_8_chars_1_upper_1_lower_1_,
            validator: (v) => v.validatePassword().fold((l) => l, (r) => null),
          ),
          16.verticalGap,
          AppTextField.password(
            titleText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_confirm_password,
            hintText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_reenter_password,
            // Validates against the controller of the first password field
            validator: (v) => v
                .validateConfirmPassword(_passwordController.text)
                .fold((l) => l, (r) => null),
          ),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,
          // ---------------------------------------------------------
          // 3. Financial
          // ---------------------------------------------------------
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_financial_banking,
          ),
          AppTextField.number(
            titleText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_credit_card,
            hintText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_xxxx_xxxx_xxxx_xxxx,
            isRequired: true,
            prefixIcon: const Icon(Icons.credit_card),
            validator: (v) =>
                v.validateCreditCard().fold((l) => l, (r) => null),
          ),
          16.verticalGap,
          AppTextField.text(
            titleText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_account_number,
            hintText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_bank_account_no,
            isRequired: true,
            validator: (v) =>
                v.validateAccountNumber().fold((l) => l, (r) => null),
          ),
          16.verticalGap,
          AppTextField.number(
            titleText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_amount,
            hintText: LocaleKeys.common_form_field_placeholders_phoneNumber,
            isRequired: true,
            prefixIcon: Padding(
              padding: 12.0.allPadding,
              child: const Text(
                '\$',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            validator: (v) => v
                .validateMoney(
                  fieldName: LocaleKeys
                      .features_splash_presentation_views_widgets_design_components_dc_text_field_amount,
                )
                .fold((l) => l, (r) => null),
          ),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,
          // ---------------------------------------------------------
          // 4. Web & Social
          // ---------------------------------------------------------
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_web_social,
          ),
          AppTextField.text(
            titleText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_website_url,
            hintText: 'https://...',
            validator: (v) => v.validateUrl().fold((l) => l, (r) => null),
          ),
          16.verticalGap,
          AppTextField.text(
            titleText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_social_handle,
            hintText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_username,
            validator: (v) => v
                .validateSocialMediaHandle(
                  fieldName: LocaleKeys
                      .features_splash_presentation_views_widgets_design_components_dc_text_field_handle,
                )
                .fold((l) => l, (r) => null),
          ),
          16.verticalGap,
          AppTextField.text(
            titleText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_postal_code,
            hintText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_zip_pin,
            validator: (v) =>
                v.validatePostalCode().fold((l) => l, (r) => null),
          ),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,
          // ---------------------------------------------------------
          // 5. Special Inputs (OTP, Time specific)
          // ---------------------------------------------------------
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_specialized_inputs,
          ),
          AppTextField.number(
            titleText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_otp,
            hintText: '123456',
            maxLength: 6,
            validator: (v) => v.validateOtp().fold((l) => l, (r) => null),
          ),
          16.verticalGap,
          Row(
            children: [
              Expanded(
                child: AppTextField.number(
                  titleText: LocaleKeys
                      .features_splash_presentation_views_widgets_design_components_dc_text_field_hours,
                  hintText:
                      LocaleKeys.common_form_field_placeholders_phoneNumber,
                  validator: (v) =>
                      v.validateHours().fold((l) => l, (r) => null),
                ),
              ),
              16.horizontalGap,
              Expanded(
                child: AppTextField.number(
                  titleText: LocaleKeys
                      .features_splash_presentation_views_widgets_design_components_dc_text_field_minutes,
                  hintText:
                      LocaleKeys.common_form_field_placeholders_phoneNumber,
                  validator: (v) =>
                      v.validateMinutes().fold((l) => l, (r) => null),
                ),
              ),
            ],
          ),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,
          // ---------------------------------------------------------
          // 6. Pickers (Date & Time)
          // ---------------------------------------------------------
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_system_pickers,
          ),
          Row(
            children: [
              Expanded(
                child: AppTextField.datePicker(
                  titleText: LocaleKeys
                      .features_splash_presentation_views_widgets_design_components_dc_text_field_date_of_birth,
                  isRequired: true,
                  initialValue: DateTime.tryParse('2000-01-01'),
                  maxDate: DateTime.now(),
                  validator: (v) => v
                      .validateNotEmpty(
                        fieldName: LocaleKeys
                            .features_splash_presentation_views_widgets_design_components_dc_text_field_date,
                      )
                      .fold((l) => l, (r) => null),
                ),
              ),
              16.horizontalGap,
              Expanded(
                child: AppTextField.timePicker(
                  titleText: LocaleKeys
                      .features_splash_presentation_views_widgets_design_components_dc_text_field_meeting_time,
                  validator: (v) => v
                      .validateNotEmpty(
                        fieldName: LocaleKeys
                            .features_splash_presentation_views_widgets_design_components_dc_text_field_time,
                      )
                      .fold((l) => l, (r) => null),
                ),
              ),
            ],
          ),
          12.verticalGap,
          AppTextField.dateRangePicker(
            titleText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_select_date_range,
            isRequired: true,
            initialValue: [
              DateTime.now().subtract(const Duration(days: 5)),
              DateTime.now(),
            ],
            maxDate: DateTime.now(),
            validator: (v) => v
                .validateNotEmpty(
                  fieldName: LocaleKeys
                      .features_splash_presentation_views_widgets_design_components_dc_text_field_date,
                )
                .fold((l) => l, (r) => null),
          ),
          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,
          // ---------------------------------------------------------
          // 7. Layout & Utility
          // ---------------------------------------------------------
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_layout_utility,
          ),
          AppTextField.multiline(
            titleText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_bio_description,
            hintText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_tell_us_about_yourself,
            maxLines: 6,
            maxLength: 200,
            validator: (v) => v
                .validateNotEmpty(
                  fieldName: LocaleKeys
                      .features_splash_presentation_views_widgets_design_components_dc_text_field_bio,
                )
                .fold((l) => l, (r) => null),
          ),
          16.verticalGap,
          AppTextField.search(
            hintText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_search_products,
            clear: true, // Show clear button if text exists
            onChanged: (val) {
              // Handle search logic
            },
          ),
          16.verticalGap,
          AppTextField.text(
            titleText: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_read_only_field,
            initialValue: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_field_this_cannot_be_edited,
            readOnly: true,
            suffixIcon: const Icon(Icons.lock_outline, size: 18),
          ),
          16.verticalGap,
          const AppDropdown<String?>(
            value: null,
            items: [
              LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_text_field_value,
              'a',
              'd',
            ],
          ),
          100.verticalGap,
        ],
      ),
    );
  }
}
