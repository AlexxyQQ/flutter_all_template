import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../config/constants/gen/assets.gen.dart';
import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../../core/common/presentation/themes/styles/button_style.dart';
import '../../../../../../core/common/presentation/views/widgets/system/app_button.dart';
import '../../../../../../core/common/presentation/views/widgets/system/app_selection_box.dart';
import '../design_components_widgets.dart';

class DcButton extends StatelessWidget {
  const DcButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: 16.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.verticalGap,
          const _CheckButton(),
          24.verticalGap,
          const _Primary(),
          24.verticalGap,
          const _Secondary(),
          24.verticalGap,
          const _Tertiary(),
          24.verticalGap,
          const _Stroke(),
          24.verticalGap,
          const _Ghost(),
          24.verticalGap,
          const _Icon(),
          24.verticalGap,
          const _Destructive(),
          40.verticalGap,
        ],
      ),
    );
  }
}

class _CheckButton extends StatelessWidget {
  const _CheckButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary
        const HeaderSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_check_buttons,
        ),
        //  Primary Normal
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            const AppSelection.checkbox(value: true),
            const AppSelection.checkbox(value: true),
            AppSelection.checkbox(value: false, borderRadius: 0.borderCircular),
            AppSelection.checkbox(value: false, borderRadius: 0.borderCircular),
            const AppSelection.radio(value: false),
            const AppSelection.radio(value: false),
          ],
        ),
      ],
    );
  }
}

class _Primary extends StatelessWidget {
  const _Primary();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary
        const HeaderSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_primary_buttons,
        ),
        //  Primary Normal
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            AppButton.primary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_primary,
            ),
            AppButton.primary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_loading,
              isLoading: true,
            ),
            AppButton.primary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_disabled,
              isDisabled: true,
            ),
            AppButton.primary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon,
              icon: Assets.icons.arrowCross,
            ),
            AppButton.primary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled,
              icon: Assets.icons.arrowCross,
              isDisabled: true,
            ),
            AppButton.primary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled,
              icon: Assets.icons.arrowCross,
              isDisabled: true,
              isLoading: true,
            ),
          ],
        ),
        12.verticalGap,

        //  Primary Expanded
        AppButton.primary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_primary_expanded,
        ),
        12.verticalGap,
        AppButton.primary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_loading_expanded,
          isLoading: true,
        ),
        12.verticalGap,
        AppButton.primary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_disabled_expanded,
          isDisabled: true,
        ),
        12.verticalGap,
        AppButton.primary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_expanded,
          icon: Assets.icons.arrowCross,
        ),
        12.verticalGap,
        AppButton.primary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled_expanded,
          icon: Assets.icons.arrowCross,
          isDisabled: true,
        ),
        12.verticalGap,
        AppButton.primary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled_expanded,
          icon: Assets.icons.arrowCross,
          isDisabled: true,
          isLoading: true,
        ),
      ],
    );
  }
}

class _Secondary extends StatelessWidget {
  const _Secondary();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Secondary
        const HeaderSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_secondary_buttons,
        ),
        //  Secondary Normal
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            AppButton.secondary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_secondary,
            ),
            AppButton.secondary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_loading,
              isLoading: true,
            ),
            AppButton.secondary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_disabled,
              isDisabled: true,
            ),
            AppButton.secondary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon,
              icon: Assets.icons.arrowCross,
            ),
            AppButton.secondary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled,
              icon: Assets.icons.arrowCross,
              isDisabled: true,
            ),
            AppButton.secondary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled,
              icon: Assets.icons.arrowCross,
              isDisabled: true,
              isLoading: true,
            ),
          ],
        ),
        12.verticalGap,

        //  Secondary Expanded
        AppButton.secondary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_secondary_expanded,
        ),
        12.verticalGap,
        AppButton.secondary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_loading_expanded,
          isLoading: true,
        ),
        12.verticalGap,
        AppButton.secondary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_disabled_expanded,
          isDisabled: true,
        ),
        12.verticalGap,
        AppButton.secondary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_expanded,
          icon: Assets.icons.arrowCross,
        ),
        12.verticalGap,
        AppButton.secondary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled_expanded,
          icon: Assets.icons.arrowCross,
          isDisabled: true,
        ),
        12.verticalGap,
        AppButton.secondary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled_expanded,
          icon: Assets.icons.arrowCross,
          isDisabled: true,
          isLoading: true,
        ),
      ],
    );
  }
}

class _Tertiary extends StatelessWidget {
  const _Tertiary();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tertiary
        const HeaderSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_tertiary_buttons,
        ),
        //  Tertiary Normal
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            AppButton.tertiary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_tertiary,
            ),
            AppButton.tertiary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_loading,
              isLoading: true,
            ),
            AppButton.tertiary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_disabled,
              isDisabled: true,
            ),
            AppButton.tertiary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon,
              icon: Assets.icons.arrowCross,
            ),
            AppButton.tertiary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled,
              icon: Assets.icons.arrowCross,
              isDisabled: true,
            ),
            AppButton.tertiary(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled,
              icon: Assets.icons.arrowCross,
              isDisabled: true,
              isLoading: true,
            ),
          ],
        ),
        12.verticalGap,

        //  Tertiary Expanded
        AppButton.tertiary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_tertiary_expanded,
        ),
        12.verticalGap,
        AppButton.tertiary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_loading_expanded,
          isLoading: true,
        ),
        12.verticalGap,
        AppButton.tertiary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_disabled_expanded,
          isDisabled: true,
        ),
        12.verticalGap,
        AppButton.tertiary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_expanded,
          icon: Assets.icons.arrowCross,
        ),
        12.verticalGap,
        AppButton.tertiary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled_expanded,
          icon: Assets.icons.arrowCross,
          isDisabled: true,
        ),
        12.verticalGap,
        AppButton.tertiary(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled_expanded,
          icon: Assets.icons.arrowCross,
          isDisabled: true,
          isLoading: true,
        ),
      ],
    );
  }
}

class _Stroke extends StatelessWidget {
  const _Stroke();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stroke
        const HeaderSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_stroke_buttons,
        ),
        //  Stroke Normal
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            AppButton.stroke(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_stroke,
            ),
            AppButton.stroke(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_loading,
              isLoading: true,
            ),
            AppButton.stroke(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_disabled,
              isDisabled: true,
            ),
            AppButton.stroke(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon,
              icon: Assets.icons.arrowCross,
            ),
            AppButton.stroke(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled,
              icon: Assets.icons.arrowCross,
              isDisabled: true,
            ),
            AppButton.stroke(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled,
              icon: Assets.icons.arrowCross,
              isDisabled: true,
              isLoading: true,
            ),
          ],
        ),
        12.verticalGap,

        //  Stroke Expanded
        AppButton.stroke(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_stroke_expanded,
        ),
        12.verticalGap,
        AppButton.stroke(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_loading_expanded,
          isLoading: true,
        ),
        12.verticalGap,
        AppButton.stroke(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_disabled_expanded,
          isDisabled: true,
        ),
        12.verticalGap,
        AppButton.stroke(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_expanded,
          icon: Assets.icons.arrowCross,
        ),
        12.verticalGap,
        AppButton.stroke(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled_expanded,
          icon: Assets.icons.arrowCross,
          isDisabled: true,
        ),
        12.verticalGap,
        AppButton.stroke(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled_expanded,
          icon: Assets.icons.arrowCross,
          isDisabled: true,
          isLoading: true,
        ),
      ],
    );
  }
}

class _Ghost extends StatelessWidget {
  const _Ghost();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ghost
        const HeaderSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_ghost_buttons,
        ),
        //  Ghost Normal
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            AppButton.ghost(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_ghost,
            ),
            AppButton.ghost(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_loading,
              isLoading: true,
            ),
            AppButton.ghost(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_disabled,
              isDisabled: true,
            ),
            AppButton.ghost(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon,
              icon: Assets.icons.arrowCross,
            ),
            AppButton.ghost(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled,
              icon: Assets.icons.arrowCross,
              isDisabled: true,
            ),
            AppButton.ghost(
              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled,
              icon: Assets.icons.arrowCross,
              isDisabled: true,
              isLoading: true,
            ),
          ],
        ),
        12.verticalGap,

        //  Ghost Expanded
        AppButton.ghost(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_ghost_expanded,
        ),
        12.verticalGap,
        AppButton.ghost(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_loading_expanded,
          isLoading: true,
        ),
        12.verticalGap,
        AppButton.ghost(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_disabled_expanded,
          isDisabled: true,
        ),
        12.verticalGap,
        AppButton.ghost(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_expanded,
          icon: Assets.icons.arrowCross,
        ),
        12.verticalGap,
        AppButton.ghost(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled_expanded,
          icon: Assets.icons.arrowCross,
          isDisabled: true,
        ),
        12.verticalGap,
        AppButton.ghost(
          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled_expanded,
          icon: Assets.icons.arrowCross,
          isDisabled: true,
          isLoading: true,
        ),
      ],
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        const HeaderSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_icon_buttons,
        ),
        //  Icon Normal
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            AppButton.icon(onPressed: () {}, icon: Assets.icons.arrowCross),
            AppButton.icon(
              icon: Assets.icons.arrowCross,
              onPressed: () {},
              isLoading: true,
            ),
            AppButton.icon(icon: Assets.icons.arrowCross, onPressed: () {}),
            AppButton.icon(onPressed: () {}, icon: Assets.icons.arrowCross),
            AppButton.icon(
              onPressed: () {},

              icon: Assets.icons.arrowCross,
              isDisabled: true,
            ),
            AppButton.icon(
              onPressed: () {},

              icon: Assets.icons.arrowCross,
              isDisabled: true,
              isLoading: true,
            ),
          ],
        ),
        12.verticalGap,

        //  Icon Expanded
        AppButton.icon(
          width: 1.sw,
          icon: Assets.icons.arrowCross,
          onPressed: () {},
        ),
        12.verticalGap,
        AppButton.icon(
          icon: Assets.icons.arrowCross,
          width: 1.sw,
          onPressed: () {},
          isLoading: true,
        ),
        12.verticalGap,
        AppButton.icon(
          icon: Assets.icons.arrowCross,
          width: 1.sw,
          onPressed: () {},
          isDisabled: true,
        ),
        12.verticalGap,
        AppButton.icon(
          width: 1.sw,
          onPressed: () {},

          icon: Assets.icons.arrowCross,
        ),
        12.verticalGap,
        AppButton.icon(
          width: 1.sw,
          onPressed: () {},

          icon: Assets.icons.arrowCross,
          isDisabled: true,
        ),
        12.verticalGap,
        AppButton.icon(
          width: 1.sw,
          onPressed: () {},

          icon: Assets.icons.arrowCross,
          isDisabled: true,
          isLoading: true,
        ),
      ],
    );
  }
}

class _Destructive extends StatelessWidget {
  const _Destructive();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Destructive
        const HeaderSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_destructive_buttons,
        ),
        //  Destructive Normal
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            AppButton.custom(
              theme: ButtonStyles.destructiveTheme,

              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_destructive,
            ),
            AppButton.custom(
              theme: ButtonStyles.destructiveTheme,

              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_loading,
              isLoading: true,
            ),
            AppButton.custom(
              theme: ButtonStyles.destructiveTheme,

              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_disabled,
              isDisabled: true,
            ),
            AppButton.custom(
              theme: ButtonStyles.destructiveTheme,

              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon,
              icon: Assets.icons.arrowCross,
            ),
            AppButton.custom(
              theme: ButtonStyles.destructiveTheme,

              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled,
              icon: Assets.icons.arrowCross,
              isDisabled: true,
            ),
            AppButton.custom(
              theme: ButtonStyles.destructiveTheme,

              onPressed: () {},
              label: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled,
              icon: Assets.icons.arrowCross,
              isDisabled: true,
              isLoading: true,
            ),
          ],
        ),
        12.verticalGap,

        //  Destructive Expanded
        AppButton.custom(
          theme: ButtonStyles.destructiveTheme,

          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_destructive_expanded,
        ),
        12.verticalGap,
        AppButton.custom(
          theme: ButtonStyles.destructiveTheme,

          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_loading_expanded,
          isLoading: true,
        ),
        12.verticalGap,
        AppButton.custom(
          theme: ButtonStyles.destructiveTheme,

          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_disabled_expanded,
          isDisabled: true,
        ),
        12.verticalGap,
        AppButton.custom(
          theme: ButtonStyles.destructiveTheme,

          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_expanded,
          icon: Assets.icons.arrowCross,
        ),
        12.verticalGap,
        AppButton.custom(
          theme: ButtonStyles.destructiveTheme,

          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled_expanded,
          icon: Assets.icons.arrowCross,
          isDisabled: true,
        ),
        12.verticalGap,
        AppButton.custom(
          theme: ButtonStyles.destructiveTheme,

          width: 1.sw,
          onPressed: () {},
          label: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_button_with_icon_disabled_expanded,
          icon: Assets.icons.arrowCross,
          isDisabled: true,
          isLoading: true,
        ),
      ],
    );
  }
}
