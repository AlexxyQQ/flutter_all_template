import 'package:auto_route/auto_route.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../domain/services/logger/logger_service.dart';
import '../../../../../domain/services/navigation/navigation_service.dart';
import '../../../../../locator/service_locator.dart';
import '../../../../../presentation/routes/app_router.gr.dart';
import '../../../domain/repository/permission_repository.dart';
import '../../../domain/services/permission_cache_service.dart';

/// An [AutoRouteGuard] that checks for notification permissions.
///
/// This guard verifies if notification permissions have been granted
/// or if the user has explicitly skipped the permission prompt.
///
/// If permission is granted or skipped, navigation proceeds.
/// Otherwise, the user is redirected to the [NotificationPermissionPageRoute].
///
/// @example
/// ```dart
/// AutoRoute(
///   path: '/notifications',
///   page: NotificationFeatureRoute.page,
///   guards: [NotificationPermissionGuard()],
/// )
/// ```
class NotificationPermissionGuard extends AutoRouteGuard {
  NotificationPermissionGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    try {
      final repository = sl<IPermissionRepository>();
      final cache = sl<PermissionCacheService>();

      // 1. Check if skipped
      final skipped = cache.getSync()?.skippedNotificationPermission == true;
      AppLogger.debug('Notification Permission Skipped: $skipped');
      if (skipped) {
        resolver.next(); // Skipped, so allow access
        return;
      }

      // 2. Check if granted
      final result = await repository.checkNotificationPermission();
      AppLogger.debug('Notification Permission Result: $result');

      result.fold(
        (error) {
          // Error checking, redirect to Splash to be safe
          sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
        },
        (status) {
          if (status == PermissionStatus.granted) {
            resolver.next(); // Granted, allow access
          } else {
            // Not granted and not skipped, redirect to permission page
            sl<NavigationService>().push(
              NotificationPermissionScreenRoute(
                nextPage: resolver.route.toPageRouteInfo(),
              ),
            );
          }
        },
      );
    } catch (e, s) {
      AppLogger.error(
        'Error in NotificationPermissionGuard: $e',
        error: e,
        stackTrace: s,
      );
      // Fallback for any other error
      sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
    }
  }
}

// --- 2. Location Permission Guard ---

/// An [AutoRouteGuard] that checks for location permissions.
///
/// This guard verifies if location permissions have been granted
/// or if the user has explicitly skipped the permission prompt.
///
/// If permission is granted or skipped, navigation proceeds.
/// Otherwise, the user is redirected to the [LocationPermissionRoute].
///
/// @example
/// ```dart
/// AutoRoute(
///   path: '/map',
///   page: MapFeatureRoute.page,
///   guards: [LocationPermissionGuard()],
/// )
/// ```
class LocationPermissionGuard extends AutoRouteGuard {
  LocationPermissionGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    try {
      final repository = sl<IPermissionRepository>();
      final cache = sl<PermissionCacheService>();

      // 1. Check if skipped
      final skipped = cache.getSync()?.skippedLocationPermission == true;
      AppLogger.debug('Location Permission Skipped: $skipped');
      if (skipped) {
        resolver.next(); // Skipped, so allow access
        return;
      }

      // 2. Check if granted
      final result = await repository.checkLocationPermission();
      AppLogger.debug('Location Permission Result: $result');

      result.fold(
        (error) {
          sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
        },
        (status) {
          if (status == PermissionStatus.granted) {
            resolver.next(); // Granted, allow access
          } else {
            // Not granted and not skipped, redirect to permission page
            sl<NavigationService>().push(
              LocationPermissionScreenRoute(
                nextPage: resolver.route.toPageRouteInfo(),
              ),
            );
          }
        },
      );
    } catch (e, s) {
      AppLogger.error(
        'Error in NotificationPermissionGuard: $e',
        error: e,
        stackTrace: s,
      );
      // Fallback for any other error
      sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
    }
  }
}

// --- 3. Camera Permission Guard ---

/// An [AutoRouteGuard] that checks for camera permissions.
///
/// This guard verifies if camera permissions have been granted
/// or if the user has explicitly skipped the permission prompt.
///
/// If permission is granted or skipped, navigation proceeds.
/// Otherwise, the user is redirected to the [CameraPermissionPageRoute].
///
/// @example
/// ```dart
/// AutoRoute(
///   path: '/profile-picture',
///   page: ProfilePictureRoute.page,
///   guards: [CameraPermissionGuard()],
/// )
/// ```
class CameraPermissionGuard extends AutoRouteGuard {
  CameraPermissionGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    try {
      final repository = sl<IPermissionRepository>();
      final cache = sl<PermissionCacheService>();

      // 1. Check if skipped
      final skipped = cache.getSync()?.skippedCameraPermission == true;
      AppLogger.debug('Camera Permission Skipped: $skipped');
      if (skipped) {
        resolver.next(); // Skipped, so allow access
        return;
      }

      // 2. Check if granted
      final result = await repository.checkCameraPermission();
      AppLogger.debug('Camera Permission Result: $result');

      result.fold(
        (error) {
          sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
        },
        (status) {
          if (status == PermissionStatus.granted) {
            resolver.next(); // Granted, allow access
          } else {
            // Not granted and not skipped, redirect to permission page
            sl<NavigationService>().push(
              CameraPermissionScreenRoute(
                nextPage: resolver.route.toPageRouteInfo(),
              ),
            );
          }
        },
      );
    } catch (e, s) {
      AppLogger.error(
        'Error in NotificationPermissionGuard: $e',
        error: e,
        stackTrace: s,
      );
      // Fallback for any other error
      sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
    }
  }
}

// --- 4. Microphone Permission Guard ---

/// An [AutoRouteGuard] that checks for microphone permissions.
///
/// This guard verifies if microphone permissions have been granted
/// or if the user has explicitly skipped the permission prompt.
///
/// If permission is granted or skipped, navigation proceeds.
/// Otherwise, the user is redirected to the [MicrophonePermissionPageRoute].
///
/// @example
/// ```dart
/// AutoRoute(
///   path: '/voice-note',
///   page: VoiceNoteRoute.page,
///   guards: [MicrophonePermissionGuard()],
/// )
/// ```
class MicrophonePermissionGuard extends AutoRouteGuard {
  MicrophonePermissionGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    try {
      final repository = sl<IPermissionRepository>();
      final cache = sl<PermissionCacheService>();

      // 1. Check if skipped
      final skipped = cache.getSync()?.skippedMicrophonePermission == true;
      AppLogger.debug('Microphone Permission Skipped: $skipped');
      if (skipped) {
        resolver.next(); // Skipped, so allow access
        return;
      }

      // 2. Check if granted
      final result = await repository.checkMicrophonePermission();
      AppLogger.debug('Microphone Permission Result: $result');

      result.fold(
        (error) {
          sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
        },
        (status) {
          if (status == PermissionStatus.granted) {
            resolver.next(); // Granted, allow access
          } else {
            // Not granted and not skipped, redirect to permission page
            sl<NavigationService>().push(
              MicrophonePermissionScreenRoute(
                nextPage: resolver.route.toPageRouteInfo(),
              ),
            );
          }
        },
      );
    } catch (e, s) {
      AppLogger.error(
        'Error in NotificationPermissionGuard: $e',
        error: e,
        stackTrace: s,
      );
      // Fallback for any other error
      sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
    }
  }
}

// --- 6. Contacts Permission Guard ---

/// An [AutoRouteGuard] that checks for contacts permissions.
class ContactsPermissionGuard extends AutoRouteGuard {
  ContactsPermissionGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    try {
      final repository = sl<IPermissionRepository>();
      final cache = sl<PermissionCacheService>();

      final skipped = cache.getSync()?.skippedContactsPermission == true;
      AppLogger.debug('Contacts Permission Skipped: $skipped');
      if (skipped) {
        resolver.next();
        return;
      }

      final result = await repository.checkContactsPermission();
      AppLogger.debug('Contacts Permission Result: $result');

      result.fold(
        (error) => sl<NavigationService>().replaceAll([const SplashScreenRoute()]),
        (status) {
          if (status == PermissionStatus.granted) {
            resolver.next();
          } else {
            sl<NavigationService>().push(
              ContactsPermissionScreenRoute(
                nextPage: resolver.route.toPageRouteInfo(),
              ),
            );
          }
        },
      );
    } catch (e, s) {
      AppLogger.error('Error in ContactsPermissionGuard: $e', error: e, stackTrace: s);
      sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
    }
  }
}

// --- 7. Calendar Permission Guard ---

/// An [AutoRouteGuard] that checks for calendar permissions.
class CalendarPermissionGuard extends AutoRouteGuard {
  CalendarPermissionGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    try {
      final repository = sl<IPermissionRepository>();
      final cache = sl<PermissionCacheService>();

      final skipped = cache.getSync()?.skippedCalendarPermission == true;
      AppLogger.debug('Calendar Permission Skipped: $skipped');
      if (skipped) {
        resolver.next();
        return;
      }

      final result = await repository.checkCalendarPermission();
      AppLogger.debug('Calendar Permission Result: $result');

      result.fold(
        (error) => sl<NavigationService>().replaceAll([const SplashScreenRoute()]),
        (status) {
          if (status == PermissionStatus.granted) {
            resolver.next();
          } else {
            sl<NavigationService>().push(
              CalendarPermissionScreenRoute(
                nextPage: resolver.route.toPageRouteInfo(),
              ),
            );
          }
        },
      );
    } catch (e, s) {
      AppLogger.error('Error in CalendarPermissionGuard: $e', error: e, stackTrace: s);
      sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
    }
  }
}

// --- 8. Bluetooth Permission Guard ---

/// An [AutoRouteGuard] that checks for bluetooth permissions.
class BluetoothPermissionGuard extends AutoRouteGuard {
  BluetoothPermissionGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    try {
      final repository = sl<IPermissionRepository>();
      final cache = sl<PermissionCacheService>();

      final skipped = cache.getSync()?.skippedBluetoothPermission == true;
      AppLogger.debug('Bluetooth Permission Skipped: $skipped');
      if (skipped) {
        resolver.next();
        return;
      }

      final result = await repository.checkBluetoothPermission();
      AppLogger.debug('Bluetooth Permission Result: $result');

      result.fold(
        (error) => sl<NavigationService>().replaceAll([const SplashScreenRoute()]),
        (status) {
          if (status == PermissionStatus.granted) {
            resolver.next();
          } else {
            sl<NavigationService>().push(
              BluetoothPermissionScreenRoute(
                nextPage: resolver.route.toPageRouteInfo(),
              ),
            );
          }
        },
      );
    } catch (e, s) {
      AppLogger.error('Error in BluetoothPermissionGuard: $e', error: e, stackTrace: s);
      sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
    }
  }
}

// --- 9. Phone Permission Guard ---

/// An [AutoRouteGuard] that checks for phone permissions.
class PhonePermissionGuard extends AutoRouteGuard {
  PhonePermissionGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    try {
      final repository = sl<IPermissionRepository>();
      final cache = sl<PermissionCacheService>();

      final skipped = cache.getSync()?.skippedPhonePermission == true;
      AppLogger.debug('Phone Permission Skipped: $skipped');
      if (skipped) {
        resolver.next();
        return;
      }

      final result = await repository.checkPhonePermission();
      AppLogger.debug('Phone Permission Result: $result');

      result.fold(
        (error) => sl<NavigationService>().replaceAll([const SplashScreenRoute()]),
        (status) {
          if (status == PermissionStatus.granted) {
            resolver.next();
          } else {
            sl<NavigationService>().push(
              PhonePermissionScreenRoute(
                nextPage: resolver.route.toPageRouteInfo(),
              ),
            );
          }
        },
      );
    } catch (e, s) {
      AppLogger.error('Error in PhonePermissionGuard: $e', error: e, stackTrace: s);
      sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
    }
  }
}

// --- 10. Activity Recognition Permission Guard ---

/// An [AutoRouteGuard] that checks for activity recognition permissions.
class ActivityRecognitionPermissionGuard extends AutoRouteGuard {
  ActivityRecognitionPermissionGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    try {
      final repository = sl<IPermissionRepository>();
      final cache = sl<PermissionCacheService>();

      final skipped = cache.getSync()?.skippedActivityRecognitionPermission == true;
      AppLogger.debug('Activity Recognition Permission Skipped: $skipped');
      if (skipped) {
        resolver.next();
        return;
      }

      final result = await repository.checkActivityRecognitionPermission();
      AppLogger.debug('Activity Recognition Permission Result: $result');

      result.fold(
        (error) => sl<NavigationService>().replaceAll([const SplashScreenRoute()]),
        (status) {
          if (status == PermissionStatus.granted) {
            resolver.next();
          } else {
            sl<NavigationService>().push(
              ActivityRecognitionPermissionScreenRoute(
                nextPage: resolver.route.toPageRouteInfo(),
              ),
            );
          }
        },
      );
    } catch (e, s) {
      AppLogger.error('Error in ActivityRecognitionPermissionGuard: $e', error: e, stackTrace: s);
      sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
    }
  }
}

// --- 5. Storage Permission Guard ---

/// An [AutoRouteGuard] that checks for storage permissions.
///
/// This guard verifies if storage permissions have been granted
/// or if the user has explicitly skipped the permission prompt.
///
/// If permission is granted or skipped, navigation proceeds.
/// Otherwise, the user is redirected to the [StoragePermissionPageRoute].
///
/// @example
/// ```dart
/// AutoRoute(
///   path: '/download-file',
///   page: DownloadRoute.page,
///   guards: [StoragePermissionGuard()],
/// )
/// ```
class StoragePermissionGuard extends AutoRouteGuard {
  StoragePermissionGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    try {
      final repository = sl<IPermissionRepository>();
      final cache = sl<PermissionCacheService>();

      // 1. Check if skipped
      final skipped = cache.getSync()?.skippedStoragePermission == true;
      AppLogger.debug('Storage Permission Skipped: $skipped');
      if (skipped) {
        resolver.next(); // Skipped, so allow access
        return;
      }

      // 2. Check if granted
      final result = await repository.checkStoragePermission();
      AppLogger.debug('Storage Permission Result: $result');

      result.fold(
        (error) {
          sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
        },
        (status) {
          if (status == PermissionStatus.granted) {
            resolver.next(); // Granted, allow access
          } else {
            // Not granted and not skipped, redirect to permission page
            sl<NavigationService>().push(
              StoragePermissionScreenRoute(
                nextPage: resolver.route.toPageRouteInfo(),
              ),
            );
          }
        },
      );
    } catch (e, s) {
      AppLogger.error(
        'Error in NotificationPermissionGuard: $e',
        error: e,
        stackTrace: s,
      );
      // Fallback for any other error
      sl<NavigationService>().replaceAll([const SplashScreenRoute()]);
    }
  }
}
