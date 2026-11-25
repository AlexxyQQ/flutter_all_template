import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../config/constants/locales/app_locales.dart';
import '../../../../../../core/common/presentation/blocs/locale/locale_cubit.dart';
import '../../../../../../core/common/presentation/blocs/theme/theme_cubit.dart';
import '../../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../../core/common/presentation/extensions/text/text_case_extension.dart';
import '../../../../../../core/common/presentation/views/widgets/system/app_chip_widget.dart';
import '../design_components_widgets.dart';

class DcChangeable extends StatelessWidget {
  const DcChangeable({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: 16.allPadding,

      child: Column(
        children: [
          // Locale Chips
          const HeaderSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_changable_locales,
          ),
          12.verticalGap,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: AppLocales.appLocales.map((locale) {
              final isSelected = context.locale == locale;
              return AppChipWidget.detail(
                isSelected: isSelected,
                title: locale.languageCode.toUpperCase(),
                onTap: () {
                  context.read<LocaleCubit>().changeLocale(locale);
                },
              );
            }).toList(),
          ),
          24.verticalGap,
          // Locale Chips
          const HeaderSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_changable_theme_modes,
          ),
          12.verticalGap,
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: ThemeMode.values.map((mode) {
                  final isSelected = state.themeMode == mode;
                  return AppChipWidget.detail(
                    isSelected: isSelected,
                    title: mode.name.toTitleCase,
                    onTap: () {
                      context.read<ThemeCubit>().changeTheme(mode);
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
