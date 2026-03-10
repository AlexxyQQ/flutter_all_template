import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final appName = _toSnakeCase(context.vars['app_name'] as String);
  final appOrg = context.vars['app_org'] as String;
  final useFirebase = context.vars['use_firebase'] as bool;
  final useNotifications = context.vars['use_notifications'] as bool;
  final usePermissions = context.vars['use_permissions'] as bool;

  final progress = context.logger.progress('Configuring project...');

  try {
    // 1. Replace package name in all .dart files
    await _replaceInDartFiles(
      Directory('.'),
      'flutter_all_template',
      appName,
    );

    // 2. Update pubspec.yaml description
    _replaceInFile(
      'pubspec.yaml',
      'A new Flutter project.',
      'A new Flutter project — $appName.',
    );

    // 3. Update Android applicationId and namespace
    _updateAndroidConfig(appOrg, appName);

    // 4. Delete disabled feature directories
    if (!useFirebase) {
      _deleteDir('lib/config/firebase');
    }
    if (!useNotifications) {
      _deleteDir('lib/core/common/domain/services/notification');
    }
    if (!usePermissions) {
      _deleteDir('lib/core/common/features/permission');
    }

    progress.complete('Project configured successfully!');
  } catch (e) {
    progress.fail('Configuration failed: $e');
    rethrow;
  }

  // Print next steps
  context.logger.info('');
  context.logger.info('✅ Your project is ready! Next steps:');
  context.logger.info('');
  context.logger.info('  cd $appName');
  if (useFirebase) {
    context.logger.info(
      '  1. Run: flutterfire configure  (sets up Firebase for your project)',
    );
    context.logger.info(
      '  2. Run: flutter pub get',
    );
    context.logger.info(
      '  3. Run: dart run build_runner build --delete-conflicting-outputs',
    );
  } else {
    context.logger.info('  1. Run: flutter pub get');
    context.logger.info(
      '  2. Run: dart run build_runner build --delete-conflicting-outputs',
    );
  }
  context.logger.info('  4. Run: flutter run');
  context.logger.info('');
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

/// Converts a string to snake_case (handles spaces and hyphens).
String _toSnakeCase(String input) =>
    input.trim().toLowerCase().replaceAll(RegExp(r'[\s\-]+'), '_');

/// Recursively replaces [from] with [to] in all `.dart` files under [dir].
Future<void> _replaceInDartFiles(
  Directory dir,
  String from,
  String to,
) async {
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();
      if (content.contains(from)) {
        await entity.writeAsString(content.replaceAll(from, to));
      }
    }
  }
}

/// Replaces [from] with [to] in a single file at [path].
void _replaceInFile(String path, String from, String to) {
  final file = File(path);
  if (!file.existsSync()) return;
  final content = file.readAsStringSync();
  if (content.contains(from)) {
    file.writeAsStringSync(content.replaceAll(from, to));
  }
}

/// Updates Android `build.gradle` with the correct applicationId / namespace.
void _updateAndroidConfig(String appOrg, String appName) {
  final packageId = '$appOrg.$appName';

  // app/build.gradle
  _replaceInFile(
    'android/app/build.gradle',
    'com.example.flutter_all_template',
    packageId,
  );

  // Also update AndroidManifest.xml package attribute if present
  _replaceInFile(
    'android/app/src/main/AndroidManifest.xml',
    'com.example.flutter_all_template',
    packageId,
  );

  // MainActivity.kt / .java path rename is complex — guide user in next steps
}

/// Recursively deletes a directory if it exists. Silently skips if missing.
void _deleteDir(String path) {
  final dir = Directory(path);
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
  }
}
