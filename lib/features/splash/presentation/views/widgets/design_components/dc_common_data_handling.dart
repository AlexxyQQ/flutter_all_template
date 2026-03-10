import 'package:flutter/material.dart';

import '../../../../../../config/constants/gen/assets.gen.dart';
import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../core/common/domain/entities/failure.dart';
import '../../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../../core/common/presentation/extensions/theme/theme_extension.dart';
import '../../../../../../core/common/presentation/views/widgets/common/error_widget.dart';
import '../design_components_widgets.dart';

class DcCommonDataHandling extends StatelessWidget {
  const DcCommonDataHandling({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: 16.allPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_data_handlers_error_states,
          ),

          // ---------------------------------------------------------
          // 1. Data Source Variants
          // ---------------------------------------------------------
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_k_1_failure_object_source,
          ),
          const NoteSection(
            note: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_uses_failuremessage_and_failur,
          ),
          AppErrorWidget(
            error: const Failure(
              message: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_network_connection_failed,
              code: '503',
              data: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_we_could_not_reach_the_server_,
              path: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_home,
            ),
            onRetry: () {},
          ),

          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_k_2_string_source_minimal,
          ),
          const NoteSection(
            note: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_uses_errormessage_only_falls_b,
          ),
          const AppErrorWidget(
            errorMessage: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_simple_error_occurred,
          ),

          // ---------------------------------------------------------
          // 2. Visual Asset Variants
          // ---------------------------------------------------------
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_k_3_variant_custom_icon,
          ),
          AppErrorWidget(
            errorMessage: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_access_denied,
            icon: Icons.gpp_bad_rounded,
            // Demonstrating overriding the default error color
            color: context.colors.warning.color,
            subtitle: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_you_do_not_have_permission_to_,
            onRetry: () {},
          ),

          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_k_4_variant_svg_asset,
          ),
          AppErrorWidget(
            errorMessage: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_transaction_failed,
            svg: Assets.icons.arrowCross,
            onRetry: () {},
          ),

          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_k_5_variant_image_asset,
          ),
          AppErrorWidget(
            errorMessage: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_nothing_to_see_here,
            image: Assets.images.logo.path,
            onRetry: () {},
          ),

          // ---------------------------------------------------------
          // 3. State & Layout Variants
          // ---------------------------------------------------------
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_k_6_no_retry_button_info_state,
          ),
          const NoteSection(
            note: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_passing_onretry_null_hides_the,
          ),
          AppErrorWidget(
            errorMessage: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_no_results_found,
            icon: Icons.search_off_rounded,
            // Using a neutral color for LocaleKeys.features_splash_presentation_views_widgets_design_components_dc_common_data_handling_empty_state feel rather than LocaleKeys.features_splash_presentation_views_widgets_design_components_dc_common_data_handling_error
            color: context.colors.primary,
            subtitle: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_try_adjusting_your_search_filt,
            // onRetry is explicitly null
          ),

          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_k_7_long_text_wrap_check,
          ),
          AppErrorWidget(
            errorMessage: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_this_is_a_very_long_error_mess,
            subtitle: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_common_data_handling_similarly_this_subtitle_is_qui,
            icon: Icons.wrap_text_rounded,
            onRetry: () {},
          ),

          12.verticalGap,
        ],
      ),
    );
  }
}
