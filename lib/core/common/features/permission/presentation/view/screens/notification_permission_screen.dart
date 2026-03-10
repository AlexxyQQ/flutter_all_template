import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../../config/constants/gen/assets.gen.dart';
import '../../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../../config/constants/paths/app_path.dart';
import '../../../../../../../config/constants/text/material/app_material_text_primitives.dart';
import '../../../../../domain/services/logger/logger_service.dart';
import '../../../../../domain/services/navigation/navigation_service.dart';
import '../../../../../locator/service_locator.dart';
import '../../../../../presentation/extensions/dialog/dialog_extension.dart';
import '../../../../../presentation/extensions/size/size_extension.dart';
import '../../../../../presentation/extensions/theme/theme_extension.dart';
import '../../../../../presentation/views/widgets/system/app_button.dart';
import '../../../../../presentation/views/widgets/system/default_app_bar.dart';
import '../../../../../presentation/views/widgets/system/images/app_image_widget.dart';
import '../../../../../presentation/views/widgets/system/text/app_text_widget.dart';
import '../../bloc/permission_bloc.dart';

@RoutePage(name: 'NotificationPermissionScreenRoute')
class NotificationPermissionScreen extends StatefulWidget {
  const NotificationPermissionScreen({super.key, this.next, this.nextPage});

  @override
  State<NotificationPermissionScreen> createState() =>
      _NotificationPermissionScreenState();

  final String? next;
  final PageRouteInfo? nextPage;
}

class _NotificationPermissionScreenState
    extends State<NotificationPermissionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PermissionBloc>().add(
      PermissionEventCheckNotificationPermission(),
    );
  }

  Future<void> _handlePermanentlyDenied() async {
    context.showConfirmationDialog(
      title: LocaleKeys
          .core_common_features_permission_presentation_screens_notification_permission_screen_dialog_reAskTitle,
      message: LocaleKeys
          .core_common_features_permission_presentation_screens_notification_permission_screen_dialog_reAskMessage,
      onConfirm: () => openAppSettings(),
      onCancel: () => context.closeDialog,
    );
  }

  void _onContinuePressed() {
    context.read<PermissionBloc>().add(
      PermissionEventRequestNotificationPermission(),
    );
  }

  void _onSkipPressed() {
    context.read<PermissionBloc>().add(
      PermissionEventSkipNotificationPermission(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PermissionBloc, PermissionState>(
      listenWhen: (previous, current) {
        // 1. Always listen if the specific statuses change
        final bool statusChanged =
            previous.notificationPermissionStatus !=
            current.notificationPermissionStatus;
        final bool skippedChanged =
            previous.skippedNotificationPermissionGranted !=
            current.skippedNotificationPermissionGranted;

        // 2. Handle the "Retry" case for Permanently Denied
        // Only listen if we stayed in 'permanentlyDenied' BUT loading just finished.
        // This prevents the listener from firing when loading STARTS.
        final bool retryDenied =
            current.notificationPermissionStatus ==
                PermissionStatus.permanentlyDenied &&
            previous.notificationPermissionStatus ==
                PermissionStatus.permanentlyDenied &&
            previous.isLoading && // Was loading
            !current.isLoading; // Now finished

        return statusChanged || skippedChanged || retryDenied;
      },
      listener: (context, state) async {
        if (state.isLoading) return;

        // 1. Handle Navigation (Granted or Skipped)
        if (state.notificationPermissionStatus == PermissionStatus.granted ||
            state.skippedNotificationPermissionGranted) {
          if (widget.nextPage != null) {
            sl<NavigationService>().push(widget.nextPage!);
          } else if (widget.next != null) {
            sl<NavigationService>().pushNamed(widget.next!);
          } else {
            sl<NavigationService>().pushNamed(AppPaths.splashRoute);
          }
          return;
        }

        AppLogger.debug(
          ' Notification permission status: '
          '${state.notificationPermissionStatus}',
        );

        // 2. Handle Permanently Denied (Show Dialog)
        if (state.notificationPermissionStatus ==
            PermissionStatus.permanentlyDenied) {
          _handlePermanentlyDenied();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const DefaultAppBar(),
          body: Padding(
            padding: 16.allPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage.fromAsset(
                  Assets.images.logo.path,
                  height: 250.h,
                  width: 250.w,
                ),
                12.verticalGap,
                AppText(
                  LocaleKeys
                      .core_common_features_permission_presentation_screens_notification_permission_screen_title,
                  textAlign: TextAlign.center,
                  style: context.textStyles.headlineSmall.copyWith(
                    fontWeight: AppMaterialTextPrimitives.semibold,
                  ),
                ),
                Padding(
                  padding: 32.horizontalPadding,
                  child: AppText(
                    LocaleKeys
                        .core_common_features_permission_presentation_screens_notification_permission_screen_message,
                    style: context.textStyles.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                32.verticalGap,

                // Continue Button
                AppButton.primary(
                  isLoading: state.isLoading,
                  onPressed: _onContinuePressed,
                  label: LocaleKeys.common_words_continue,
                ),

                20.verticalGap,

                // Skip Button
                AppButton.ghost(
                  isDisabled: state.isLoading,
                  onPressed: _onSkipPressed,
                  label: LocaleKeys.common_sentences_mayBeLater,
                ),
                50.verticalGap,
              ],
            ),
          ),
        );
      },
    );
  }
}
