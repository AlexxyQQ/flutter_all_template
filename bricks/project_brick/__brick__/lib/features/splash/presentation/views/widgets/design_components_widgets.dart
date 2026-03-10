import 'package:flutter/material.dart';

import '../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../core/common/presentation/extensions/theme/theme_extension.dart';
import '../../../../../core/common/presentation/views/widgets/system/app_divider.dart';
import '../../../../../core/common/presentation/views/widgets/system/text/app_text_widget.dart';
import 'design_components/dc_button.dart';
import 'design_components/dc_changeable.dart';
import 'design_components/dc_chips.dart';
import 'design_components/dc_common_data_handling.dart';
import 'design_components/dc_context_extension.dart';
import 'design_components/dc_file_picker.dart';
import 'design_components/dc_image.dart';
import 'design_components/dc_navigation.dart';
import 'design_components/dc_switch.dart';
import 'design_components/dc_text.dart';
import 'design_components/dc_text_field.dart';

class DesignComponentsWidgets extends StatelessWidget {
  const DesignComponentsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          50.verticalGap,
          const DcChangeable(),
          24.verticalGap,
          AppDivider.horizontal(
            thickness: 3,
            color: context.colors.outlineVariant,
          ),
          24.verticalGap,
          const DcText(),
          24.verticalGap,
          AppDivider.horizontal(
            thickness: 3,
            color: context.colors.outlineVariant,
          ),
          24.verticalGap,
          const DcChips(),
          24.verticalGap,
          AppDivider.horizontal(
            thickness: 3,
            color: context.colors.outlineVariant,
          ),
          24.verticalGap,
          const DcSwitches(),
          24.verticalGap,
          AppDivider.horizontal(
            thickness: 3,
            color: context.colors.outlineVariant,
          ),
          24.verticalGap,
          const DcContextExtension(),
          24.verticalGap,
          AppDivider.horizontal(
            thickness: 3,
            color: context.colors.outlineVariant,
          ),
          24.verticalGap,
          const DcNavigation(),
          24.verticalGap,
          AppDivider.horizontal(
            thickness: 3,
            color: context.colors.outlineVariant,
          ),
          24.verticalGap,
          const DcFilePicker(),
          24.verticalGap,
          AppDivider.horizontal(
            thickness: 3,
            color: context.colors.outlineVariant,
          ),
          24.verticalGap,
          const DcButton(),
          24.verticalGap,
          AppDivider.horizontal(
            thickness: 3,
            color: context.colors.outlineVariant,
          ),
          24.verticalGap,
          const DcImage(),
          24.verticalGap,
          AppDivider.horizontal(
            thickness: 3,
            color: context.colors.outlineVariant,
          ),
          24.verticalGap,
          const DcTextField(),
          24.verticalGap,
          AppDivider.horizontal(
            thickness: 3,
            color: context.colors.outlineVariant,
          ),
          24.verticalGap,
          const DcCommonDataHandling(),
          24.verticalGap,
          AppDivider.horizontal(
            thickness: 3,
            color: context.colors.outlineVariant,
          ),
          24.verticalGap,

          50.verticalGap,
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 18.bottomOnly,
      child: AppText(title, style: context.textStyles.headlineMedium),
    );
  }
}

class LabelSection extends StatelessWidget {
  const LabelSection({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 8.topOnly + 4.bottomOnly,
      child: AppText(title, style: context.textStyles.bodySmall),
    );
  }
}

class NoteSection extends StatelessWidget {
  const NoteSection({required this.note, super.key});
  final String note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 8.topOnly + 4.bottomOnly,
      child: AppText(note, style: context.textStyles.labelSmall),
    );
  }
}
