import 'package:flutter/material.dart';

import '../../domain/entities/app_permission.dart';

/// What the permission screen shows for an [AppPermission]: an icon plus four
/// texts, all stored under `features.permission.<name>.*` in the translation
/// files (`title`, `message`, `reAskTitle`, `reAskMessage`).
///
/// The keys follow the enum name, so a new permission only needs an icon here
/// and its four translations. `permission_content_test.dart` fails when a
/// translation is missing.
extension PermissionContent on AppPermission {
  /// Exhaustive on purpose: a new permission without an icon does not compile.
  IconData get icon => switch (this) {
    AppPermission.notification => Icons.notifications_active_outlined,
    AppPermission.location => Icons.location_on_outlined,
    AppPermission.storage => Icons.folder_outlined,
    AppPermission.camera => Icons.photo_camera_outlined,
    AppPermission.microphone => Icons.mic_none_outlined,
    AppPermission.contacts => Icons.contacts_outlined,
    AppPermission.calendar => Icons.calendar_month_outlined,
    AppPermission.bluetooth => Icons.bluetooth,
    AppPermission.phone => Icons.phone_outlined,
    AppPermission.activityRecognition => Icons.directions_run,
  };

  /// Explains why the app asks.
  String get titleKey => _key('title');
  String get messageKey => _key('message');

  /// Shown when the permission is permanently denied and only the system
  /// settings can grant it.
  String get reAskTitleKey => _key('reAskTitle');
  String get reAskMessageKey => _key('reAskMessage');

  String _key(String field) => 'features.permission.$name.$field';
}
