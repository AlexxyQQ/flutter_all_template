// ignore_for_file: avoid_hardcoded_strings_in_widgets
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../config/themes/components_theme/app_chip_theme.dart';
import '../../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../../core/common/presentation/views/components/app_color.dart';
import '../../../../../../core/common/presentation/views/widgets/system/app_chip_widget.dart';
import '../../../../../../core/common/presentation/views/widgets/system/app_divider.dart';
import '../design_components_widgets.dart';

class DcChips extends StatelessWidget {
  const DcChips({super.key});

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
                .features_splash_presentation_views_widgets_design_components_dc_chips_chips_showcase,
          ),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,

          // 1. Text Only (Detail)
          const _ChoiceChipsSection(),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,

          // 2. Icon + Text (Filter)
          const _FilterChipsSection(),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,

          // 3. SVG + Text (Payment/Brand)
          const _SvgChipsSection(),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,

          // 4. Custom Theming (Status)
          const _StatusChipsSection(),

          50.verticalGap,
        ],
      ),
    );
  }
}

// ==============================================================================
// 1. CHOICE CHIPS (Text Only - Single Select)
// Uses: AppChipWidget.detail
// ==============================================================================
class _ChoiceChipsSection extends StatefulWidget {
  const _ChoiceChipsSection();

  @override
  State<_ChoiceChipsSection> createState() => _ChoiceChipsSectionState();
}

class _ChoiceChipsSectionState extends State<_ChoiceChipsSection> {
  int _selectedIndex = 0;
  final List<String> _options = [
    LocaleKeys
        .features_splash_presentation_views_widgets_design_components_dc_chips_all,
    LocaleKeys
        .features_splash_presentation_views_widgets_design_components_dc_chips_popular,
    LocaleKeys
        .features_splash_presentation_views_widgets_design_components_dc_chips_recent,
    LocaleKeys
        .features_splash_presentation_views_widgets_design_components_dc_chips_trending,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_chips_choice_chips_text_only,
        ),
        const NoteSection(
          note: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_chips_single_selection_behavior_usin,
        ),
        12.verticalGap,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(_options.length, (index) {
            return AppChipWidget.detail(
              isSelected: _selectedIndex == index,
              title: _options[index],
              onTap: () => setState(() => _selectedIndex = index),
            );
          }),
        ),
      ],
    );
  }
}

// ==============================================================================
// 2. FILTER CHIPS (Icon + Text - Multi Select)
// Uses: AppChipWidget.icon
// ==============================================================================
class _FilterChipsSection extends StatefulWidget {
  const _FilterChipsSection();

  @override
  State<_FilterChipsSection> createState() => _FilterChipsSectionState();
}

class _FilterChipsSectionState extends State<_FilterChipsSection> {
  final List<String> _amenities = [
    LocaleKeys
        .features_splash_presentation_views_widgets_design_components_dc_chips_wifi,
    LocaleKeys
        .features_splash_presentation_views_widgets_design_components_dc_chips_parking,
    LocaleKeys
        .features_splash_presentation_views_widgets_design_components_dc_chips_pool,
    LocaleKeys
        .features_splash_presentation_views_widgets_design_components_dc_chips_gym,
    LocaleKeys
        .features_splash_presentation_views_widgets_design_components_dc_chips_breakfast,
  ];
  final List<String> _selected = [
    LocaleKeys
        .features_splash_presentation_views_widgets_design_components_dc_chips_wifi,
    LocaleKeys
        .features_splash_presentation_views_widgets_design_components_dc_chips_pool,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_chips_filter_chips_icon,
        ),
        const NoteSection(
          note: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_chips_multiple_selection_with_dynami,
        ),
        12.verticalGap,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: _amenities.map((amenity) {
            final isSelected = _selected.contains(amenity);
            return AppChipWidget.icon(
              isSelected: isSelected,
              title: amenity,
              // Different icons for selected vs unselected state
              selectedIcon: Icons.check,
              unselectedIcon: Icons.add,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selected.remove(amenity);
                  } else {
                    _selected.add(amenity);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ==============================================================================
// 3. SVG CHIPS (Brand/Payment - Blended vs Original)
// Uses: AppChipWidget.svg
// ==============================================================================
class _SvgChipsSection extends StatefulWidget {
  const _SvgChipsSection();

  @override
  State<_SvgChipsSection> createState() => _SvgChipsSectionState();
}

class _SvgChipsSectionState extends State<_SvgChipsSection> {
  String _selectedMethod = LocaleKeys
      .features_splash_presentation_views_widgets_design_components_dc_chips_card;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_chips_svg_chips_brand_blend,
        ),
        const NoteSection(
          note: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_chips_use_noblend_true_to_keep_origi,
        ),
        12.verticalGap,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            // 1. Generic Card (Blends with Theme Color)
            AppChipWidget.svg(
              isSelected: _selectedMethod == 'card',
              title: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_chips_credit_card,
              // Note: The factory requires LocaleKeys.features_splash_presentation_views_widgets_design_components_dc_chips_color, likely used internally for mapping if logic existed,
              // but currently your build uses theme.selectedColor. Passing a dummy or specific here.
              color: const KAppColor(0xFF2196F3),
              selectedSvgAsset: 'assets/icons/card_filled.svg',
              unselectedSvgAsset: 'assets/icons/card_outline.svg',
              onTap: () => setState(
                () => _selectedMethod = LocaleKeys
                    .features_splash_presentation_views_widgets_design_components_dc_chips_card,
              ),
            ),

            // 2. Apple Pay (Original Colors - noBlend)
            AppChipWidget.svg(
              isSelected: _selectedMethod == 'apple',
              title: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_chips_apple_pay,
              color: const KAppColor(0xFF000000),
              selectedSvgAsset: 'assets/icons/apple_logo.svg',
              unselectedSvgAsset: 'assets/icons/apple_logo.svg',
              onTap: () => setState(
                () => _selectedMethod = LocaleKeys
                    .features_splash_presentation_views_widgets_design_components_dc_chips_apple,
              ),
              noBlend: true, // Icon keeps its original black/white/colored look
            ),

            // 3. Google Pay (Original Colors - noBlend)
            AppChipWidget.svg(
              isSelected: _selectedMethod == 'google',
              title: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_chips_google_pay,
              color: const KAppColor(0xFFDB4437),
              selectedSvgAsset: 'assets/icons/google_g.svg',
              unselectedSvgAsset: 'assets/icons/google_g.svg',
              onTap: () => setState(
                () => _selectedMethod = LocaleKeys
                    .features_splash_presentation_views_widgets_design_components_dc_chips_google,
              ),
              noBlend: true,
            ),
          ],
        ),
      ],
    );
  }
}

// ==============================================================================
// 4. STATUS CHIPS (Custom Theming)
// Uses: AppChipWidget.detail / .icon with CustomAppChipTheme
// ==============================================================================
class _StatusChipsSection extends StatelessWidget {
  const _StatusChipsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelSection(
          title: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_chips_semantic_status_chips,
        ),
        const NoteSection(
          note: LocaleKeys
              .features_splash_presentation_views_widgets_design_components_dc_chips_overriding_defaults_using_cust,
        ),
        12.verticalGap,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            // Success Theme
            AppChipWidget.icon(
              isSelected: true,
              title: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_chips_completed,
              selectedIcon: Icons.check_circle,
              unselectedIcon: Icons.check_circle,
              onTap: () {},
              theme: CustomAppChipTheme(
                selectedColor: const KAppColor(0xFF4CAF50), // Green
                disabledColor: const KAppColor(0xFFE8F5E9),
                selectedLabelColor: const KAppColor(0xFFFFFFFF),
                disabledLabelColor: const KAppColor(0xFF4CAF50),
                selectedBackgroundOpacity: 1.0, // Solid fill
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),

            // Warning Theme
            AppChipWidget.icon(
              isSelected: true,
              title: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_chips_pending,
              selectedIcon: Icons.access_time_filled,
              unselectedIcon: Icons.access_time,
              onTap: () {},
              theme: CustomAppChipTheme(
                selectedColor: const KAppColor(0xFFFF9800), // Orange
                disabledColor: const KAppColor(0xFFFFF3E0),
                selectedLabelColor: const KAppColor(0xFFFFFFFF),
                disabledLabelColor: const KAppColor(0xFFFF9800),
                selectedBackgroundOpacity: 1.0,
                borderRadius: BorderRadius.circular(8.r), // Square corners
              ),
            ),

            // Error Theme (Outlined Style)
            AppChipWidget.detail(
              isSelected: true,
              title: LocaleKeys
                  .features_splash_presentation_views_widgets_design_components_dc_chips_overdue,
              onTap: () {},
              theme: CustomAppChipTheme(
                selectedColor: const KAppColor(0xFFF44336), // Red
                disabledColor: const KAppColor(0xFFFFEBEE),
                selectedLabelColor: const KAppColor(0xFFF44336), // Red Text
                disabledLabelColor: const KAppColor(0xFFF44336),
                selectedBackgroundOpacity: 0.1, // Light background
                borderRadius: BorderRadius.circular(50.r),
                border: true, // Show border
              ),
            ),
          ],
        ),
      ],
    );
  }
}
