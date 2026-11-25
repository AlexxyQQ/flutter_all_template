import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../config/constants/gen/locale_keys.g.dart';
import 'domain/entities/app_permission.dart';

/// Static description of an [AppPermission]: which platform permission backs
/// it and what the permission screen shows.
///
/// All texts are localization keys (translated by the widgets).
@immutable
class PermissionSpec {
  const PermissionSpec({
    required this.permission,
    required this.platformPermission,
    required this.icon,
    required this.titleKey,
    required this.messageKey,
    required this.reAskTitleKey,
    required this.reAskMessageKey,
    this.imageAsset,
  });

  final AppPermission permission;

  /// The `permission_handler` permission. Data layer only.
  final Permission platformPermission;

  /// Icon shown on the permission screen when [imageAsset] is null.
  final IconData icon;

  /// Optional illustration (asset path) that replaces [icon].
  final String? imageAsset;

  final String titleKey;
  final String messageKey;

  /// Dialog shown when the permission is permanently denied.
  final String reAskTitleKey;
  final String reAskMessageKey;
}

/// The single source of truth for every [AppPermission].
///
/// An exhaustive `switch`, so adding an enum value without a spec is a
/// compile error.
extension AppPermissionSpecX on AppPermission {
  PermissionSpec get spec => switch (this) {
    AppPermission.notification => const PermissionSpec(
      permission: AppPermission.notification,
      platformPermission: Permission.notification,
      icon: Icons.notifications_active_outlined,
      titleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_notification_permission_screen_title,
      messageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_notification_permission_screen_message,
      reAskTitleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_notification_permission_screen_dialog_reAskTitle,
      reAskMessageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_notification_permission_screen_dialog_reAskMessage,
    ),
    AppPermission.location => const PermissionSpec(
      permission: AppPermission.location,
      platformPermission: Permission.locationWhenInUse,
      icon: Icons.location_on_outlined,
      titleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_location_permission_screen_title,
      messageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_location_permission_screen_message,
      reAskTitleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_location_permission_screen_dialog_reAskTitle,
      reAskMessageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_location_permission_screen_dialog_reAskMessage,
    ),
    AppPermission.storage => const PermissionSpec(
      permission: AppPermission.storage,
      platformPermission: Permission.storage,
      icon: Icons.folder_outlined,
      titleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_storage_permission_screen_title,
      messageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_storage_permission_screen_message,
      reAskTitleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_storage_permission_screen_dialog_reAskTitle,
      reAskMessageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_storage_permission_screen_dialog_reAskMessage,
    ),
    AppPermission.camera => const PermissionSpec(
      permission: AppPermission.camera,
      platformPermission: Permission.camera,
      icon: Icons.photo_camera_outlined,
      titleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_camera_permission_screen_title,
      messageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_camera_permission_screen_message,
      reAskTitleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_camera_permission_screen_dialog_reAskTitle,
      reAskMessageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_camera_permission_screen_dialog_reAskMessage,
    ),
    AppPermission.microphone => const PermissionSpec(
      permission: AppPermission.microphone,
      platformPermission: Permission.microphone,
      icon: Icons.mic_none_outlined,
      titleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_microphone_permission_screen_title,
      messageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_microphone_permission_screen_message,
      reAskTitleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_microphone_permission_screen_dialog_reAskTitle,
      reAskMessageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_microphone_permission_screen_dialog_reAskMessage,
    ),
    AppPermission.contacts => const PermissionSpec(
      permission: AppPermission.contacts,
      platformPermission: Permission.contacts,
      icon: Icons.contacts_outlined,
      titleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_contacts_permission_screen_title,
      messageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_contacts_permission_screen_message,
      reAskTitleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_contacts_permission_screen_dialog_reAskTitle,
      reAskMessageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_contacts_permission_screen_dialog_reAskMessage,
    ),
    AppPermission.calendar => const PermissionSpec(
      permission: AppPermission.calendar,
      platformPermission: Permission.calendarFullAccess,
      icon: Icons.calendar_month_outlined,
      titleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_calendar_permission_screen_title,
      messageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_calendar_permission_screen_message,
      reAskTitleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_calendar_permission_screen_dialog_reAskTitle,
      reAskMessageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_calendar_permission_screen_dialog_reAskMessage,
    ),
    AppPermission.bluetooth => const PermissionSpec(
      permission: AppPermission.bluetooth,
      platformPermission: Permission.bluetooth,
      icon: Icons.bluetooth,
      titleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_bluetooth_permission_screen_title,
      messageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_bluetooth_permission_screen_message,
      reAskTitleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_bluetooth_permission_screen_dialog_reAskTitle,
      reAskMessageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_bluetooth_permission_screen_dialog_reAskMessage,
    ),
    AppPermission.phone => const PermissionSpec(
      permission: AppPermission.phone,
      platformPermission: Permission.phone,
      icon: Icons.phone_outlined,
      titleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_phone_permission_screen_title,
      messageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_phone_permission_screen_message,
      reAskTitleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_phone_permission_screen_dialog_reAskTitle,
      reAskMessageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_phone_permission_screen_dialog_reAskMessage,
    ),
    AppPermission.activityRecognition => const PermissionSpec(
      permission: AppPermission.activityRecognition,
      platformPermission: Permission.activityRecognition,
      icon: Icons.directions_run,
      titleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_activity_recognition_permission_screen_title,
      messageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_activity_recognition_permission_screen_message,
      reAskTitleKey: LocaleKeys
          .core_common_features_permission_presentation_screens_activity_recognition_permission_screen_dialog_reAskTitle,
      reAskMessageKey: LocaleKeys
          .core_common_features_permission_presentation_screens_activity_recognition_permission_screen_dialog_reAskMessage,
    ),
  };
}
