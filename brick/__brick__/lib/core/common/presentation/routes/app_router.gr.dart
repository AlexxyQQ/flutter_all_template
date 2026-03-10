// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i16;
import 'package:collection/collection.dart' as _i18;
import 'package:flutter/material.dart' as _i17;
import 'package:flutter_all_template/core/common/features/permission/presentation/view/screens/camera_permission_screen.dart'
    as _i6;
import 'package:flutter_all_template/core/common/features/permission/presentation/view/screens/location_permission_screen.dart'
    as _i8;
import 'package:flutter_all_template/core/common/features/permission/presentation/view/screens/microphone_permission_screen.dart'
    as _i9;
import 'package:flutter_all_template/core/common/features/permission/presentation/view/screens/notification_permission_screen.dart'
    as _i10;
import 'package:flutter_all_template/core/common/features/permission/presentation/view/screens/storage_permission_screen.dart'
    as _i14;
import 'package:flutter_all_template/core/common/features/permission/presentation/view/screens/contacts_permission_screen.dart'
    as _i19;
import 'package:flutter_all_template/core/common/features/permission/presentation/view/screens/calendar_permission_screen.dart'
    as _i20;
import 'package:flutter_all_template/core/common/features/permission/presentation/view/screens/bluetooth_permission_screen.dart'
    as _i21;
import 'package:flutter_all_template/core/common/features/permission/presentation/view/screens/phone_permission_screen.dart'
    as _i22;
import 'package:flutter_all_template/core/common/features/permission/presentation/view/screens/activity_recognition_permission_screen.dart'
    as _i23;
import 'package:flutter_all_template/core/common/features/permission/presentation/view/wrapper/permission.wrapper.dart'
    as _i11;
import 'package:flutter_all_template/core/common/presentation/views/pages/bottom_sheets/app_bottom_sheet.dart'
    as _i3;
import 'package:flutter_all_template/core/common/presentation/views/pages/bottom_sheets/app_date_selector_bottom_sheet.dart'
    as _i15;
import 'package:flutter_all_template/core/common/presentation/views/pages/bottom_sheets/delete_item_bottom_sheet.dart'
    as _i7;
import 'package:flutter_all_template/core/common/presentation/views/pages/dialogs/app_dialog.dart'
    as _i5;
import 'package:flutter_all_template/core/common/presentation/views/widgets/system/loaders/app_dialog_loader.dart'
    as _i4;
import 'package:flutter_all_template/features/another/presentation/views/screens/another_screen.dart'
    as _i1;
import 'package:flutter_all_template/features/another/presentation/wrappers/another_wrapper.dart'
    as _i2;
import 'package:flutter_all_template/features/splash/presentation/views/screens/splash_screen.dart'
    as _i12;
import 'package:flutter_all_template/features/splash/presentation/views/wrappers/splash_wrapper.dart'
    as _i13;

/// generated route for
/// [_i1.AnotherScreen]
class AnotherScreenRoute extends _i16.PageRouteInfo<void> {
  const AnotherScreenRoute({List<_i16.PageRouteInfo>? children})
    : super(AnotherScreenRoute.name, initialChildren: children);

  static const String name = 'AnotherScreenRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i1.AnotherScreen();
    },
  );
}

/// generated route for
/// [_i2.AnotherWrapperScreen]
class AnotherWrapperRoute extends _i16.PageRouteInfo<void> {
  const AnotherWrapperRoute({List<_i16.PageRouteInfo>? children})
    : super(AnotherWrapperRoute.name, initialChildren: children);

  static const String name = 'AnotherWrapperRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return _i16.WrappedRoute(child: const _i2.AnotherWrapperScreen());
    },
  );
}

/// generated route for
/// [_i3.AppBottomSheetWidget]
class AppBottomSheetWidgetRoute
    extends _i16.PageRouteInfo<AppBottomSheetWidgetRouteArgs> {
  AppBottomSheetWidgetRoute({
    required _i17.Widget child,
    _i17.Key? key,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         AppBottomSheetWidgetRoute.name,
         args: AppBottomSheetWidgetRouteArgs(child: child, key: key),
         initialChildren: children,
       );

  static const String name = 'AppBottomSheetWidgetRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppBottomSheetWidgetRouteArgs>();
      return _i3.AppBottomSheetWidget(child: args.child, key: args.key);
    },
  );
}

class AppBottomSheetWidgetRouteArgs {
  const AppBottomSheetWidgetRouteArgs({required this.child, this.key});

  final _i17.Widget child;

  final _i17.Key? key;

  @override
  String toString() {
    return 'AppBottomSheetWidgetRouteArgs{child: $child, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppBottomSheetWidgetRouteArgs) return false;
    return child == other.child && key == other.key;
  }

  @override
  int get hashCode => child.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i4.AppDialogLoader]
class AppDialogLoaderRoute
    extends _i16.PageRouteInfo<AppDialogLoaderRouteArgs> {
  AppDialogLoaderRoute({
    _i17.Key? key,
    Duration? duration,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         AppDialogLoaderRoute.name,
         args: AppDialogLoaderRouteArgs(key: key, duration: duration),
         initialChildren: children,
       );

  static const String name = 'AppDialogLoaderRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppDialogLoaderRouteArgs>(
        orElse: () => const AppDialogLoaderRouteArgs(),
      );
      return _i4.AppDialogLoader(key: args.key, duration: args.duration);
    },
  );
}

class AppDialogLoaderRouteArgs {
  const AppDialogLoaderRouteArgs({this.key, this.duration});

  final _i17.Key? key;

  final Duration? duration;

  @override
  String toString() {
    return 'AppDialogLoaderRouteArgs{key: $key, duration: $duration}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppDialogLoaderRouteArgs) return false;
    return key == other.key && duration == other.duration;
  }

  @override
  int get hashCode => key.hashCode ^ duration.hashCode;
}

/// generated route for
/// [_i5.AppDialogPage]
class AppDialogRoute extends _i16.PageRouteInfo<AppDialogRouteArgs> {
  AppDialogRoute({
    required _i5.DialogType type,
    _i17.Key? key,
    String? title,
    String? message,
    _i17.Widget? customContent,
    String? confirmText,
    String? cancelText,
    _i17.VoidCallback? onConfirm,
    _i17.VoidCallback? onCancel,
    Duration? autoCloseDuration,
    bool? isDismissible = false,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         AppDialogRoute.name,
         args: AppDialogRouteArgs(
           type: type,
           key: key,
           title: title,
           message: message,
           customContent: customContent,
           confirmText: confirmText,
           cancelText: cancelText,
           onConfirm: onConfirm,
           onCancel: onCancel,
           autoCloseDuration: autoCloseDuration,
           isDismissible: isDismissible,
         ),
         initialChildren: children,
       );

  static const String name = 'AppDialogRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppDialogRouteArgs>();
      return _i5.AppDialogPage(
        type: args.type,
        key: args.key,
        title: args.title,
        message: args.message,
        customContent: args.customContent,
        confirmText: args.confirmText,
        cancelText: args.cancelText,
        onConfirm: args.onConfirm,
        onCancel: args.onCancel,
        autoCloseDuration: args.autoCloseDuration,
        isDismissible: args.isDismissible,
      );
    },
  );
}

class AppDialogRouteArgs {
  const AppDialogRouteArgs({
    required this.type,
    this.key,
    this.title,
    this.message,
    this.customContent,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.autoCloseDuration,
    this.isDismissible = false,
  });

  final _i5.DialogType type;

  final _i17.Key? key;

  final String? title;

  final String? message;

  final _i17.Widget? customContent;

  final String? confirmText;

  final String? cancelText;

  final _i17.VoidCallback? onConfirm;

  final _i17.VoidCallback? onCancel;

  final Duration? autoCloseDuration;

  final bool? isDismissible;

  @override
  String toString() {
    return 'AppDialogRouteArgs{type: $type, key: $key, title: $title, message: $message, customContent: $customContent, confirmText: $confirmText, cancelText: $cancelText, onConfirm: $onConfirm, onCancel: $onCancel, autoCloseDuration: $autoCloseDuration, isDismissible: $isDismissible}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppDialogRouteArgs) return false;
    return type == other.type &&
        key == other.key &&
        title == other.title &&
        message == other.message &&
        customContent == other.customContent &&
        confirmText == other.confirmText &&
        cancelText == other.cancelText &&
        onConfirm == other.onConfirm &&
        onCancel == other.onCancel &&
        autoCloseDuration == other.autoCloseDuration &&
        isDismissible == other.isDismissible;
  }

  @override
  int get hashCode =>
      type.hashCode ^
      key.hashCode ^
      title.hashCode ^
      message.hashCode ^
      customContent.hashCode ^
      confirmText.hashCode ^
      cancelText.hashCode ^
      onConfirm.hashCode ^
      onCancel.hashCode ^
      autoCloseDuration.hashCode ^
      isDismissible.hashCode;
}

/// generated route for
/// [_i6.CameraPermissionScreen]
class CameraPermissionScreenRoute
    extends _i16.PageRouteInfo<CameraPermissionScreenRouteArgs> {
  CameraPermissionScreenRoute({
    _i17.Key? key,
    String? next,
    _i16.PageRouteInfo<Object?>? nextPage,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         CameraPermissionScreenRoute.name,
         args: CameraPermissionScreenRouteArgs(
           key: key,
           next: next,
           nextPage: nextPage,
         ),
         initialChildren: children,
       );

  static const String name = 'CameraPermissionScreenRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CameraPermissionScreenRouteArgs>(
        orElse: () => const CameraPermissionScreenRouteArgs(),
      );
      return _i6.CameraPermissionScreen(
        key: args.key,
        next: args.next,
        nextPage: args.nextPage,
      );
    },
  );
}

class CameraPermissionScreenRouteArgs {
  const CameraPermissionScreenRouteArgs({this.key, this.next, this.nextPage});

  final _i17.Key? key;

  final String? next;

  final _i16.PageRouteInfo<Object?>? nextPage;

  @override
  String toString() {
    return 'CameraPermissionScreenRouteArgs{key: $key, next: $next, nextPage: $nextPage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CameraPermissionScreenRouteArgs) return false;
    return key == other.key && next == other.next && nextPage == other.nextPage;
  }

  @override
  int get hashCode => key.hashCode ^ next.hashCode ^ nextPage.hashCode;
}

/// generated route for
/// [_i7.DeleteItemBottomSheet]
class DeleteItemBottomSheetRoute
    extends _i16.PageRouteInfo<DeleteItemBottomSheetRouteArgs> {
  DeleteItemBottomSheetRoute({
    required _i17.VoidCallback onDelete,
    required String description,
    required String title,
    _i17.Key? key,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         DeleteItemBottomSheetRoute.name,
         args: DeleteItemBottomSheetRouteArgs(
           onDelete: onDelete,
           description: description,
           title: title,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'DeleteItemBottomSheetRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DeleteItemBottomSheetRouteArgs>();
      return _i7.DeleteItemBottomSheet(
        onDelete: args.onDelete,
        description: args.description,
        title: args.title,
        key: args.key,
      );
    },
  );
}

class DeleteItemBottomSheetRouteArgs {
  const DeleteItemBottomSheetRouteArgs({
    required this.onDelete,
    required this.description,
    required this.title,
    this.key,
  });

  final _i17.VoidCallback onDelete;

  final String description;

  final String title;

  final _i17.Key? key;

  @override
  String toString() {
    return 'DeleteItemBottomSheetRouteArgs{onDelete: $onDelete, description: $description, title: $title, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DeleteItemBottomSheetRouteArgs) return false;
    return onDelete == other.onDelete &&
        description == other.description &&
        title == other.title &&
        key == other.key;
  }

  @override
  int get hashCode =>
      onDelete.hashCode ^ description.hashCode ^ title.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i8.LocationPermissionScreen]
class LocationPermissionScreenRoute
    extends _i16.PageRouteInfo<LocationPermissionScreenRouteArgs> {
  LocationPermissionScreenRoute({
    _i17.Key? key,
    String? next,
    _i16.PageRouteInfo<Object?>? nextPage,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         LocationPermissionScreenRoute.name,
         args: LocationPermissionScreenRouteArgs(
           key: key,
           next: next,
           nextPage: nextPage,
         ),
         initialChildren: children,
       );

  static const String name = 'LocationPermissionScreenRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LocationPermissionScreenRouteArgs>(
        orElse: () => const LocationPermissionScreenRouteArgs(),
      );
      return _i8.LocationPermissionScreen(
        key: args.key,
        next: args.next,
        nextPage: args.nextPage,
      );
    },
  );
}

class LocationPermissionScreenRouteArgs {
  const LocationPermissionScreenRouteArgs({this.key, this.next, this.nextPage});

  final _i17.Key? key;

  final String? next;

  final _i16.PageRouteInfo<Object?>? nextPage;

  @override
  String toString() {
    return 'LocationPermissionScreenRouteArgs{key: $key, next: $next, nextPage: $nextPage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LocationPermissionScreenRouteArgs) return false;
    return key == other.key && next == other.next && nextPage == other.nextPage;
  }

  @override
  int get hashCode => key.hashCode ^ next.hashCode ^ nextPage.hashCode;
}

/// generated route for
/// [_i9.MicrophonePermissionScreen]
class MicrophonePermissionScreenRoute
    extends _i16.PageRouteInfo<MicrophonePermissionScreenRouteArgs> {
  MicrophonePermissionScreenRoute({
    _i17.Key? key,
    String? next,
    _i16.PageRouteInfo<Object?>? nextPage,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         MicrophonePermissionScreenRoute.name,
         args: MicrophonePermissionScreenRouteArgs(
           key: key,
           next: next,
           nextPage: nextPage,
         ),
         initialChildren: children,
       );

  static const String name = 'MicrophonePermissionScreenRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MicrophonePermissionScreenRouteArgs>(
        orElse: () => const MicrophonePermissionScreenRouteArgs(),
      );
      return _i9.MicrophonePermissionScreen(
        key: args.key,
        next: args.next,
        nextPage: args.nextPage,
      );
    },
  );
}

class MicrophonePermissionScreenRouteArgs {
  const MicrophonePermissionScreenRouteArgs({
    this.key,
    this.next,
    this.nextPage,
  });

  final _i17.Key? key;

  final String? next;

  final _i16.PageRouteInfo<Object?>? nextPage;

  @override
  String toString() {
    return 'MicrophonePermissionScreenRouteArgs{key: $key, next: $next, nextPage: $nextPage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MicrophonePermissionScreenRouteArgs) return false;
    return key == other.key && next == other.next && nextPage == other.nextPage;
  }

  @override
  int get hashCode => key.hashCode ^ next.hashCode ^ nextPage.hashCode;
}

/// generated route for
/// [_i10.NotificationPermissionScreen]
class NotificationPermissionScreenRoute
    extends _i16.PageRouteInfo<NotificationPermissionScreenRouteArgs> {
  NotificationPermissionScreenRoute({
    _i17.Key? key,
    String? next,
    _i16.PageRouteInfo<Object?>? nextPage,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         NotificationPermissionScreenRoute.name,
         args: NotificationPermissionScreenRouteArgs(
           key: key,
           next: next,
           nextPage: nextPage,
         ),
         initialChildren: children,
       );

  static const String name = 'NotificationPermissionScreenRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NotificationPermissionScreenRouteArgs>(
        orElse: () => const NotificationPermissionScreenRouteArgs(),
      );
      return _i10.NotificationPermissionScreen(
        key: args.key,
        next: args.next,
        nextPage: args.nextPage,
      );
    },
  );
}

class NotificationPermissionScreenRouteArgs {
  const NotificationPermissionScreenRouteArgs({
    this.key,
    this.next,
    this.nextPage,
  });

  final _i17.Key? key;

  final String? next;

  final _i16.PageRouteInfo<Object?>? nextPage;

  @override
  String toString() {
    return 'NotificationPermissionScreenRouteArgs{key: $key, next: $next, nextPage: $nextPage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NotificationPermissionScreenRouteArgs) return false;
    return key == other.key && next == other.next && nextPage == other.nextPage;
  }

  @override
  int get hashCode => key.hashCode ^ next.hashCode ^ nextPage.hashCode;
}

/// generated route for
/// [_i11.PermissionWrapper]
class PermissionWrapperRoute extends _i16.PageRouteInfo<void> {
  const PermissionWrapperRoute({List<_i16.PageRouteInfo>? children})
    : super(PermissionWrapperRoute.name, initialChildren: children);

  static const String name = 'PermissionWrapperRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return _i16.WrappedRoute(child: const _i11.PermissionWrapper());
    },
  );
}

/// generated route for
/// [_i12.SplashScreen]
class SplashScreenRoute extends _i16.PageRouteInfo<void> {
  const SplashScreenRoute({List<_i16.PageRouteInfo>? children})
    : super(SplashScreenRoute.name, initialChildren: children);

  static const String name = 'SplashScreenRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i12.SplashScreen();
    },
  );
}

/// generated route for
/// [_i13.SplashWrapper]
class SplashWrapperRoute extends _i16.PageRouteInfo<void> {
  const SplashWrapperRoute({List<_i16.PageRouteInfo>? children})
    : super(SplashWrapperRoute.name, initialChildren: children);

  static const String name = 'SplashWrapperRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return _i16.WrappedRoute(child: const _i13.SplashWrapper());
    },
  );
}

/// generated route for
/// [_i14.StoragePermissionScreen]
class StoragePermissionScreenRoute
    extends _i16.PageRouteInfo<StoragePermissionScreenRouteArgs> {
  StoragePermissionScreenRoute({
    _i17.Key? key,
    String? next,
    _i16.PageRouteInfo<Object?>? nextPage,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         StoragePermissionScreenRoute.name,
         args: StoragePermissionScreenRouteArgs(
           key: key,
           next: next,
           nextPage: nextPage,
         ),
         initialChildren: children,
       );

  static const String name = 'StoragePermissionScreenRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StoragePermissionScreenRouteArgs>(
        orElse: () => const StoragePermissionScreenRouteArgs(),
      );
      return _i14.StoragePermissionScreen(
        key: args.key,
        next: args.next,
        nextPage: args.nextPage,
      );
    },
  );
}

class StoragePermissionScreenRouteArgs {
  const StoragePermissionScreenRouteArgs({this.key, this.next, this.nextPage});

  final _i17.Key? key;

  final String? next;

  final _i16.PageRouteInfo<Object?>? nextPage;

  @override
  String toString() {
    return 'StoragePermissionScreenRouteArgs{key: $key, next: $next, nextPage: $nextPage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! StoragePermissionScreenRouteArgs) return false;
    return key == other.key && next == other.next && nextPage == other.nextPage;
  }

  @override
  int get hashCode => key.hashCode ^ next.hashCode ^ nextPage.hashCode;
}

/// generated route for
/// [_i15.StyledDatePickerSheet]
class DateSelectorBottomSheet
    extends _i16.PageRouteInfo<DateSelectorBottomSheetArgs> {
  DateSelectorBottomSheet({
    required String title,
    _i17.Key? key,
    DateTime? seed,
    DateTime? minDate,
    DateTime? maxDate,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         DateSelectorBottomSheet.name,
         args: DateSelectorBottomSheetArgs(
           title: title,
           key: key,
           seed: seed,
           minDate: minDate,
           maxDate: maxDate,
         ),
         initialChildren: children,
       );

  static const String name = 'DateSelectorBottomSheet';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DateSelectorBottomSheetArgs>();
      return _i15.StyledDatePickerSheet(
        title: args.title,
        key: args.key,
        seed: args.seed,
        minDate: args.minDate,
        maxDate: args.maxDate,
      );
    },
  );
}

class DateSelectorBottomSheetArgs {
  const DateSelectorBottomSheetArgs({
    required this.title,
    this.key,
    this.seed,
    this.minDate,
    this.maxDate,
  });

  final String title;

  final _i17.Key? key;

  final DateTime? seed;

  final DateTime? minDate;

  final DateTime? maxDate;

  @override
  String toString() {
    return 'DateSelectorBottomSheetArgs{title: $title, key: $key, seed: $seed, minDate: $minDate, maxDate: $maxDate}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DateSelectorBottomSheetArgs) return false;
    return title == other.title &&
        key == other.key &&
        seed == other.seed &&
        minDate == other.minDate &&
        maxDate == other.maxDate;
  }

  @override
  int get hashCode =>
      title.hashCode ^
      key.hashCode ^
      seed.hashCode ^
      minDate.hashCode ^
      maxDate.hashCode;
}

/// generated route for
/// [_i15.StyledDateRangeSheet]
class DateRangeSelectorBottomSheet
    extends _i16.PageRouteInfo<DateRangeSelectorBottomSheetArgs> {
  DateRangeSelectorBottomSheet({
    required String title,
    required List<DateTime?> seed,
    _i17.Key? key,
    DateTime? minDate,
    DateTime? maxDate,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         DateRangeSelectorBottomSheet.name,
         args: DateRangeSelectorBottomSheetArgs(
           title: title,
           seed: seed,
           key: key,
           minDate: minDate,
           maxDate: maxDate,
         ),
         initialChildren: children,
       );

  static const String name = 'DateRangeSelectorBottomSheet';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DateRangeSelectorBottomSheetArgs>();
      return _i15.StyledDateRangeSheet(
        title: args.title,
        seed: args.seed,
        key: args.key,
        minDate: args.minDate,
        maxDate: args.maxDate,
      );
    },
  );
}

class DateRangeSelectorBottomSheetArgs {
  const DateRangeSelectorBottomSheetArgs({
    required this.title,
    required this.seed,
    this.key,
    this.minDate,
    this.maxDate,
  });

  final String title;

  final List<DateTime?> seed;

  final _i17.Key? key;

  final DateTime? minDate;

  final DateTime? maxDate;

  @override
  String toString() {
    return 'DateRangeSelectorBottomSheetArgs{title: $title, seed: $seed, key: $key, minDate: $minDate, maxDate: $maxDate}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DateRangeSelectorBottomSheetArgs) return false;
    return title == other.title &&
        const _i18.ListEquality<DateTime?>().equals(seed, other.seed) &&
        key == other.key &&
        minDate == other.minDate &&
        maxDate == other.maxDate;
  }

  @override
  int get hashCode =>
      title.hashCode ^
      const _i18.ListEquality<DateTime?>().hash(seed) ^
      key.hashCode ^
      minDate.hashCode ^
      maxDate.hashCode;
}

/// generated route for
/// [_i19.ContactsPermissionScreen]
class ContactsPermissionScreenRoute
    extends _i16.PageRouteInfo<ContactsPermissionScreenRouteArgs> {
  ContactsPermissionScreenRoute({
    _i17.Key? key,
    String? next,
    _i16.PageRouteInfo<Object?>? nextPage,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         ContactsPermissionScreenRoute.name,
         args: ContactsPermissionScreenRouteArgs(
           key: key,
           next: next,
           nextPage: nextPage,
         ),
         initialChildren: children,
       );

  static const String name = 'ContactsPermissionScreenRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ContactsPermissionScreenRouteArgs>(
        orElse: () => const ContactsPermissionScreenRouteArgs(),
      );
      return _i19.ContactsPermissionScreen(
        key: args.key,
        next: args.next,
        nextPage: args.nextPage,
      );
    },
  );
}

class ContactsPermissionScreenRouteArgs {
  const ContactsPermissionScreenRouteArgs({this.key, this.next, this.nextPage});

  final _i17.Key? key;
  final String? next;
  final _i16.PageRouteInfo<Object?>? nextPage;

  @override
  String toString() {
    return 'ContactsPermissionScreenRouteArgs{key: $key, next: $next, nextPage: $nextPage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ContactsPermissionScreenRouteArgs) return false;
    return key == other.key && next == other.next && nextPage == other.nextPage;
  }

  @override
  int get hashCode => key.hashCode ^ next.hashCode ^ nextPage.hashCode;
}

/// generated route for
/// [_i20.CalendarPermissionScreen]
class CalendarPermissionScreenRoute
    extends _i16.PageRouteInfo<CalendarPermissionScreenRouteArgs> {
  CalendarPermissionScreenRoute({
    _i17.Key? key,
    String? next,
    _i16.PageRouteInfo<Object?>? nextPage,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         CalendarPermissionScreenRoute.name,
         args: CalendarPermissionScreenRouteArgs(
           key: key,
           next: next,
           nextPage: nextPage,
         ),
         initialChildren: children,
       );

  static const String name = 'CalendarPermissionScreenRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CalendarPermissionScreenRouteArgs>(
        orElse: () => const CalendarPermissionScreenRouteArgs(),
      );
      return _i20.CalendarPermissionScreen(
        key: args.key,
        next: args.next,
        nextPage: args.nextPage,
      );
    },
  );
}

class CalendarPermissionScreenRouteArgs {
  const CalendarPermissionScreenRouteArgs({this.key, this.next, this.nextPage});

  final _i17.Key? key;
  final String? next;
  final _i16.PageRouteInfo<Object?>? nextPage;

  @override
  String toString() {
    return 'CalendarPermissionScreenRouteArgs{key: $key, next: $next, nextPage: $nextPage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CalendarPermissionScreenRouteArgs) return false;
    return key == other.key && next == other.next && nextPage == other.nextPage;
  }

  @override
  int get hashCode => key.hashCode ^ next.hashCode ^ nextPage.hashCode;
}

/// generated route for
/// [_i21.BluetoothPermissionScreen]
class BluetoothPermissionScreenRoute
    extends _i16.PageRouteInfo<BluetoothPermissionScreenRouteArgs> {
  BluetoothPermissionScreenRoute({
    _i17.Key? key,
    String? next,
    _i16.PageRouteInfo<Object?>? nextPage,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         BluetoothPermissionScreenRoute.name,
         args: BluetoothPermissionScreenRouteArgs(
           key: key,
           next: next,
           nextPage: nextPage,
         ),
         initialChildren: children,
       );

  static const String name = 'BluetoothPermissionScreenRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BluetoothPermissionScreenRouteArgs>(
        orElse: () => const BluetoothPermissionScreenRouteArgs(),
      );
      return _i21.BluetoothPermissionScreen(
        key: args.key,
        next: args.next,
        nextPage: args.nextPage,
      );
    },
  );
}

class BluetoothPermissionScreenRouteArgs {
  const BluetoothPermissionScreenRouteArgs({this.key, this.next, this.nextPage});

  final _i17.Key? key;
  final String? next;
  final _i16.PageRouteInfo<Object?>? nextPage;

  @override
  String toString() {
    return 'BluetoothPermissionScreenRouteArgs{key: $key, next: $next, nextPage: $nextPage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BluetoothPermissionScreenRouteArgs) return false;
    return key == other.key && next == other.next && nextPage == other.nextPage;
  }

  @override
  int get hashCode => key.hashCode ^ next.hashCode ^ nextPage.hashCode;
}

/// generated route for
/// [_i22.PhonePermissionScreen]
class PhonePermissionScreenRoute
    extends _i16.PageRouteInfo<PhonePermissionScreenRouteArgs> {
  PhonePermissionScreenRoute({
    _i17.Key? key,
    String? next,
    _i16.PageRouteInfo<Object?>? nextPage,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         PhonePermissionScreenRoute.name,
         args: PhonePermissionScreenRouteArgs(
           key: key,
           next: next,
           nextPage: nextPage,
         ),
         initialChildren: children,
       );

  static const String name = 'PhonePermissionScreenRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PhonePermissionScreenRouteArgs>(
        orElse: () => const PhonePermissionScreenRouteArgs(),
      );
      return _i22.PhonePermissionScreen(
        key: args.key,
        next: args.next,
        nextPage: args.nextPage,
      );
    },
  );
}

class PhonePermissionScreenRouteArgs {
  const PhonePermissionScreenRouteArgs({this.key, this.next, this.nextPage});

  final _i17.Key? key;
  final String? next;
  final _i16.PageRouteInfo<Object?>? nextPage;

  @override
  String toString() {
    return 'PhonePermissionScreenRouteArgs{key: $key, next: $next, nextPage: $nextPage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PhonePermissionScreenRouteArgs) return false;
    return key == other.key && next == other.next && nextPage == other.nextPage;
  }

  @override
  int get hashCode => key.hashCode ^ next.hashCode ^ nextPage.hashCode;
}

/// generated route for
/// [_i23.ActivityRecognitionPermissionScreen]
class ActivityRecognitionPermissionScreenRoute
    extends _i16.PageRouteInfo<ActivityRecognitionPermissionScreenRouteArgs> {
  ActivityRecognitionPermissionScreenRoute({
    _i17.Key? key,
    String? next,
    _i16.PageRouteInfo<Object?>? nextPage,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         ActivityRecognitionPermissionScreenRoute.name,
         args: ActivityRecognitionPermissionScreenRouteArgs(
           key: key,
           next: next,
           nextPage: nextPage,
         ),
         initialChildren: children,
       );

  static const String name = 'ActivityRecognitionPermissionScreenRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ActivityRecognitionPermissionScreenRouteArgs>(
        orElse: () => const ActivityRecognitionPermissionScreenRouteArgs(),
      );
      return _i23.ActivityRecognitionPermissionScreen(
        key: args.key,
        next: args.next,
        nextPage: args.nextPage,
      );
    },
  );
}

class ActivityRecognitionPermissionScreenRouteArgs {
  const ActivityRecognitionPermissionScreenRouteArgs({
    this.key,
    this.next,
    this.nextPage,
  });

  final _i17.Key? key;
  final String? next;
  final _i16.PageRouteInfo<Object?>? nextPage;

  @override
  String toString() {
    return 'ActivityRecognitionPermissionScreenRouteArgs{key: $key, next: $next, nextPage: $nextPage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ActivityRecognitionPermissionScreenRouteArgs) return false;
    return key == other.key && next == other.next && nextPage == other.nextPage;
  }

  @override
  int get hashCode => key.hashCode ^ next.hashCode ^ nextPage.hashCode;
}
