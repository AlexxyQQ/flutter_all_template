import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/constants/enums/permission_type_enum.dart';
import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../core/common/features/permission/presentation/view/widgets/dialog/permission_dialog.dart';
import '../../../../../core/common/presentation/extensions/dialog/dialog_extension.dart';
import '../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../core/common/presentation/views/widgets/system/app_button.dart';
import '../../../../../core/common/presentation/views/widgets/system/default_app_bar.dart';
import '../../../bloc/test_cubit.dart';
import '../../../bloc/test_state.dart';

@RoutePage(name: 'AnotherScreenRoute')
class AnotherScreen extends StatelessWidget {
  const AnotherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestCubit, TestState>(
      listener: (context, state) {
        if (!state.hasLocationPermission && !state.isLoading) {
          context.showCustomDialog(
            content: PermissionDialog(
              title: '',
              description: '',
              type: PermissionTypeEnum.location,
              onGranted: () {
                context.read<TestCubit>().sendUserLocationToServer();
              },
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const DefaultAppBar(
            title: LocaleKeys
                .features_another_presentation_views_screens_another_screen_another,
          ),
          body: Padding(
            padding: 16.allPadding,
            child: Column(
              children: [
                AppButton.primary(
                  onPressed: () {
                    context.read<TestCubit>().sendUserLocationToServer();
                  },
                  isLoading: state.isLoading,
                  label: LocaleKeys
                      .features_another_presentation_views_screens_another_screen_testLocationPermission,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
