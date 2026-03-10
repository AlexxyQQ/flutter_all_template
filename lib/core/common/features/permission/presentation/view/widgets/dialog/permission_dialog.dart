import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../../../config/constants/enums/permission_type_enum.dart';
import '../../../../../../../../config/constants/gen/assets.gen.dart';
import '../../../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../../../config/constants/text/material/app_material_text_primitives.dart';
import '../../../../../../domain/services/logger/logger_service.dart';
import '../../../../../../locator/service_locator.dart';
import '../../../../../../presentation/extensions/dialog/dialog_extension.dart';
import '../../../../../../presentation/extensions/size/size_extension.dart';
import '../../../../../../presentation/extensions/theme/theme_extension.dart';
import '../../../../../../presentation/views/widgets/system/app_button.dart';
import '../../../../../../presentation/views/widgets/system/images/app_image_widget.dart';
import '../../../../../../presentation/views/widgets/system/text/app_text_widget.dart';
import '../../../bloc/permission_bloc.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({
    required this.type,
    required this.title,
    required this.description,
    super.key,
    this.onGranted,
  });

  final PermissionTypeEnum type;
  final String title;
  final String description;
  final Function()? onGranted;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PermissionBloc>(),
      child: _PermissionDialog(
        type: type,
        title: title,
        description: description,
        onGranted: onGranted,
      ),
    );
  }
}

class _PermissionDialog extends StatefulWidget {
  const _PermissionDialog({
    required this.type,
    required this.title,
    required this.description,
    this.onGranted,
  });

  final PermissionTypeEnum type;
  final String title;
  final String description;
  final Function()? onGranted;

  @override
  State<_PermissionDialog> createState() => __PermissionDialogState();
}

class __PermissionDialogState extends State<_PermissionDialog> {
  // --- UI Configuration Helpers ---

  /// Returns the icon asset path based on type.
  String get _iconPath {
    switch (widget.type) {
      case PermissionTypeEnum.notification:
        // Return notification specific icon
        return Assets.images.logo.path;
      case PermissionTypeEnum.location:
        // Return location specific icon
        return Assets.images.logo.path;
      case PermissionTypeEnum.camera:
        // Return camera specific icon
        return Assets.images.logo.path;
      case PermissionTypeEnum.storage:
        // Return storage specific icon
        return Assets.images.logo.path;
    }
  }

  // --- Logic Helpers ---

  /// Retrieves the current status from the Bloc State based on the PermissionTypeEnum.
  /// *Note: Ensure your PermissionState has these fields defined.*
  PermissionStatus _getCurrentStatus(PermissionState state) {
    switch (widget.type) {
      case PermissionTypeEnum.notification:
        return state.notificationPermissionStatus;
      case PermissionTypeEnum.location:
        return state.locationPermissionStatus;
      case PermissionTypeEnum.camera:
        return state.cameraPermissionStatus;
      case PermissionTypeEnum.storage:
        return state.storagePermissionStatus;
    }
  }

  /// Dispatches the correct event to the Bloc based on PermissionTypeEnum.
  /// *Note: Ensure your PermissionBloc handles these events.*
  void _requestPermission() {
    final bloc = context.read<PermissionBloc>();
    switch (widget.type) {
      case PermissionTypeEnum.notification:
        bloc.add(PermissionEventRequestNotificationPermission());
      case PermissionTypeEnum.location:
        bloc.add(PermissionEventRequestLocationPermission());
      case PermissionTypeEnum.camera:
        bloc.add(PermissionEventRequestCameraPermission());
      case PermissionTypeEnum.storage:
        bloc.add(PermissionEventRequestStoragePermission());
    }
  }

  Future<void> _handlePermanentlyDenied() async {
    context.showConfirmationDialog(
      title: widget.title,
      message: widget.description,

      onConfirm: () => openAppSettings(),
      onCancel: () => context.closeDialog,
    );
  }

  void _onContinuePressed() {
    _requestPermission();
  }

  void _onSkipPressed() {
    context.closeDialog;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PermissionBloc, PermissionState>(
      listenWhen: (previous, current) {
        final previousStatus = _getCurrentStatus(previous);
        final currentStatus = _getCurrentStatus(current);

        // 1. Status Changed
        final bool statusChanged = previousStatus != currentStatus;

        // 2. Skipped Changed (assumes shared skipped logic, adjust if specific skips are needed)
        final bool skippedChanged =
            previous.skippedNotificationPermissionGranted !=
            current.skippedNotificationPermissionGranted;

        // 3. Retry Logic for Permanently Denied
        final bool retryDenied =
            currentStatus == PermissionStatus.permanentlyDenied &&
            previousStatus == PermissionStatus.permanentlyDenied &&
            previous.isLoading &&
            !current.isLoading;

        return statusChanged || skippedChanged || retryDenied;
      },
      listener: (context, state) async {
        if (state.isLoading) {
          return;
        }

        final currentStatus = _getCurrentStatus(state);

        // 1. Handle Granted
        if (currentStatus == PermissionStatus.granted) {
          widget.onGranted?.call();
          context.closeDialog;
        }
        // 2. Handle Skipped
        else if (state.skippedNotificationPermissionGranted) {
          context.closeDialog;
        }

        AppLogger.debug(
          '${widget.type.name} permission status: $currentStatus',
        );

        // 3. Handle Permanently Denied
        if (currentStatus == PermissionStatus.permanentlyDenied) {
          _handlePermanentlyDenied();
        }
      },
      builder: (context, state) {
        return Padding(
          padding: 16.topOnly,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppImage.fromAsset(_iconPath, height: 80.h, width: 80.w),
              12.verticalGap,
              AppText(
                widget.title,
                textAlign: TextAlign.center,
                style: context.textStyles.headlineSmall.copyWith(
                  fontWeight: AppMaterialTextPrimitives.semibold,
                ),
              ),
              6.verticalGap,
              AppText(
                widget.description,
                style: context.textStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
              18.verticalGap,

              // Continue Button
              AppButton.primary(
                isLoading: state.isLoading,
                onPressed: _onContinuePressed,
                label: LocaleKeys.common_words_continue,
              ),

              12.verticalGap,

              // Skip Button
              AppButton.ghost(
                isDisabled: state.isLoading,
                onPressed: _onSkipPressed,
                label: LocaleKeys.common_sentences_mayBeLater,
              ),
            ],
          ),
        );
      },
    );
  }
}
