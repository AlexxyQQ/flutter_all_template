import 'package:flutter/material.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../../core/common/presentation/extensions/theme/theme_extension.dart';
import '../../../../../../core/common/presentation/views/widgets/system/app_button.dart';
import '../../../../../../core/common/presentation/views/widgets/system/app_divider.dart';
import '../../../../../../core/common/presentation/views/widgets/system/app_swtich.dart';
import '../../../../../../core/common/presentation/views/widgets/system/text/app_text_widget.dart';
import '../design_components_widgets.dart';

// ==============================================================================
// MAIN SHOWCASE WIDGET
// ==============================================================================

class DcSwitches extends StatelessWidget {
  const DcSwitches({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: 16.allPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          40.verticalGap,
          const HeaderSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_switch_switch_showcase,
          ),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,

          // 1. Basic & Standalone Variations
          const _BasicSwitchSection(),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,

          // 2. Complex & Descriptive Variations
          const _DescriptiveSwitchSection(),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,

          // 3. Controlled / External State Variations
          const _ControlledSwitchSection(),

          50.verticalGap,
        ],
      ),
    );
  }
}

// ==============================================================================
// 1. Basic Variations Section
// ==============================================================================
class _BasicSwitchSection extends StatelessWidget {
  const _BasicSwitchSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_switch_basic_variations,
        ),
        const NoteSection(
          note: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_switch_standard_toggles_with_and_with,
        ),
        12.verticalGap,

        // Variation: Standalone (No text)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText(
              LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_switch_standalone_no_title,
            ),
            AppSwitch(onChanged: (val) {}),
          ],
        ),

        12.verticalGap,

        // Variation: Simple Title
        AppSwitch(
          titleText: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_switch_push_notifications,
          initialValue: true,
          onChanged: (val) {
            debugPrint('Notifications: $val');
          },
        ),

        12.verticalGap,

        // Variation: Custom Text Style
        AppSwitch(
          titleText: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_switch_dark_mode_bold_style,
          titleStyle: context.textStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
          onChanged: (val) {},
        ),
      ],
    );
  }
}

// ==============================================================================
// 2. Descriptive Variations Section
// ==============================================================================
class _DescriptiveSwitchSection extends StatelessWidget {
  const _DescriptiveSwitchSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_switch_descriptive_layouts,
        ),
        const NoteSection(
          note: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_switch_switches_with_helper_notes_and,
        ),
        12.verticalGap,

        // Variation: With Note
        AppSwitch(
          titleText: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_switch_location_services,
          noteText: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_switch_allows_the_app_to_access_your_,
          initialValue: true,
          onChanged: (val) {},
        ),

        16.verticalGap,

        // Variation: Long Text Handling
        AppSwitch(
          titleText: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_switch_allow_automatic_downloads_for_,
          noteText: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_switch_this_might_consume_significant,
          onChanged: (val) {},
        ),
      ],
    );
  }
}

// ==============================================================================
// 3. Controlled Variations Section
// ==============================================================================
class _ControlledSwitchSection extends StatefulWidget {
  const _ControlledSwitchSection();

  @override
  State<_ControlledSwitchSection> createState() =>
      _ControlledSwitchSectionState();
}

class _ControlledSwitchSectionState extends State<_ControlledSwitchSection> {
  // Create a controller to manipulate the switch from outside
  final AppSwitchController _biometricController = AppSwitchController();

  @override
  void dispose() {
    _biometricController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_switch_controlled_state,
        ),
        const NoteSection(
          note: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_switch_using_appswitchcontroller_to_t,
        ),
        12.verticalGap,

        // The Switch
        AppSwitch(
          controller: _biometricController,
          titleText: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_switch_biometric_login,
          onChanged: (val) {
            // Logic when user taps the switch physically
            debugPrint('Biometric changed to $val');
          },
        ),

        16.verticalGap,

        // External Controls
        Row(
          children: [
            Expanded(
              child: AppButton.primary(
                onPressed: () => _biometricController.toggle(),
                label: LocaleKeys
                    .features_splash_presentation_views_widgets_design_components_dc_switch_toggle_via_button,
              ),
            ),
            12.horizontalGap,
            Expanded(
              child: AppButton.primary(
                onPressed: () => _biometricController.setValue(true),
                label: LocaleKeys
                    .features_splash_presentation_views_widgets_design_components_dc_switch_set_true,
              ),
            ),
            12.horizontalGap,
            Expanded(
              child: AppButton.primary(
                onPressed: () => _biometricController.setValue(false),
                label: LocaleKeys
                    .features_splash_presentation_views_widgets_design_components_dc_switch_set_false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
