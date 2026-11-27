import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final appName = (context.vars['app_name'] as String).snakeCase;
  final appOrg = context.vars['app_org'] as String;
  final useFirebase = context.vars['use_firebase'] as bool;
  final useNotifications = context.vars['use_notifications'] as bool;
  final usePermissions = context.vars['use_permissions'] as bool;
  // Options added later default to on, so older config files keep working.
  final useCi = context.vars['use_ci'] != false;
  final useCodemagic = context.vars['use_codemagic'] != false;
  final useMaestro = context.vars['use_maestro'] != false;
  final displayName =
      (context.vars['app_display_name'] as String?)?.trim().isNotEmpty == true
          ? (context.vars['app_display_name'] as String).trim()
          : appName.titleCase;
  final baseUrl = ((context.vars['base_url'] as String?) ?? '').trim();

  final progress = context.logger.progress('Configuring project...');

  // The brick renders into `<app_name>/`; every path below is relative to it.
  final originalDirectory = Directory.current;
  try {
    Directory.current = Directory(appName);
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
    _updateIosBundleId(appOrg, appName);
    _setDisplayName(displayName, appName);
    if (baseUrl.isNotEmpty) {
      _setDevBaseUrl(baseUrl);
    }

    // 3b. Template names inside CI/release/test config (codemagic.yaml,
    //     scripts/, .maestro/, docs/, .github/).
    _renameInConfigFiles(appOrg, appName);

    // 4. Delete files of disabled modules. Source files that reference these
    //    modules are already conditional (see tool/sync_brick.dart markers).
    if (useFirebase) {
      _materialiseFirebaseConfig();
    } else {
      _deleteDir('lib/config/firebase');
      _deleteDir('lib/core/services/analytics/data/firebase');
      _deleteDir('test/unit/core/services/analytics/firebase');
      for (final f in _firebaseConfigFiles) {
        _deleteFile(f);
        _deleteFile('$f.example');
      }
    }
    if (!useNotifications) {
      _deleteDir('lib/core/services/notification');
      _deleteDir('test/unit/core/services/notification');
      // Its repository test constructs the notification-aware variant.
      _deleteFile(
          'test/unit/features/permission/permission_repository_test.dart');
    }
    if (!usePermissions) {
      _deleteDir('lib/features/permission');
      _deleteDir('test/unit/features/permission');
    }
    // Delivery tooling. Source files don't reference these, except the rps
    // `maestro` scripts in pubspec.yaml, which are conditional (brick:if).
    if (!useCi) {
      _deleteDir('.github');
      _deleteFile('.gitleaks.toml');
    }
    if (!useCodemagic) {
      _deleteFile('codemagic.yaml');
    }
    if (!useMaestro) {
      _deleteDir('.maestro');
      _deleteFile('scripts/maestro.sh');
      _deleteFile('docs/MAESTRO.md');
    }
    if (!useCi && !useCodemagic) {
      _deleteFile('docs/CI_CD.md');
    }

    progress.complete('Project configured successfully!');
  } catch (e) {
    progress.fail('Configuration failed: $e');
    rethrow;
  } finally {
    Directory.current = originalDirectory;
  }

  // Print next steps
  context.logger.info('');
  context.logger.info('✅ Your project is ready! Next steps:');
  context.logger.info('');
  context.logger.info('  cd $appName');
  var step = 1;
  if (useFirebase) {
    context.logger.info(
      '  ${step++}. flutterfire configure   (replaces the YOUR_* placeholders)',
    );
  }
  context.logger.info('  ${step++}. flutter pub get');
  context.logger.info(
    '  ${step++}. dart run easy_localization:generate -S assets/translations '
    '-f keys -O lib/config/constants/gen -o locale_keys.g.dart',
  );
  context.logger.info(
    '  ${step++}. dart run build_runner build --delete-conflicting-outputs',
  );
  context.logger.info(
    '  ${step++}. dart fix --apply && dart format .   '
    '(re-sorts imports after the package rename)',
  );
  context.logger.info(
    baseUrl.isEmpty
        ? '  ${step++}. cp env/dev.example.json env/dev.json   (set BASE_URL)'
        : '  ${step++}. cp env/dev.example.json env/dev.json   '
            '(BASE_URL is already $baseUrl)',
  );
  context.logger.info(
    '  ${step++}. flutter run --dart-define-from-file=env/dev.json',
  );
  if (baseUrl.startsWith('http://') && !_isLocalHost(Uri.parse(baseUrl).host)) {
    context.logger.warn(
      'base_url uses plain http: debug builds only allow cleartext traffic '
      'to the emulator/localhost (see android/app/src/debug/res/xml/'
      'network_security_config.xml), and release builds block it.',
    );
  }
  context.logger.info('');
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

/// Firebase client config: git-ignored, shipped only as `<name>.example`.
const _firebaseConfigFiles = <String>[
  'android/app/google-services.json',
  'ios/Runner/GoogleService-Info.plist',
  'firebase.json',
  'lib/config/firebase/firebase_options.dart',
];

/// Creates the real (git-ignored) placeholder files from the `.example`
/// files so the project compiles before `flutterfire configure` is run.
void _materialiseFirebaseConfig() {
  for (final path in _firebaseConfigFiles) {
    final example = File('$path.example');
    final real = File(path);
    if (example.existsSync() && !real.existsSync()) {
      example.copySync(path);
    }
  }
}

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

bool _isLocalHost(String host) =>
    host == 'localhost' || host == '10.0.2.2' || host == '127.0.0.1';

/// Sets the name under the launcher icon (Android `android:label`, iOS
/// `CFBundleDisplayName`). Runs before the package rename, which would
/// otherwise turn the template's Android label into the snake_case name.
void _setDisplayName(String displayName, String appName) {
  _replaceInFile(
    'android/app/src/main/AndroidManifest.xml',
    'android:label="flutter_all_template"',
    'android:label="${_xmlEscape(displayName)}"',
  );
  final plist = File('ios/Runner/Info.plist');
  if (plist.existsSync()) {
    final updated = plist.readAsStringSync().replaceFirstMapped(
          RegExp(
              r'(<key>CFBundleDisplayName</key>\s*<string>)[^<]*(</string>)'),
          (m) => '${m[1]}${_xmlEscape(displayName)}${m[2]}',
        );
    plist.writeAsStringSync(updated);
  }
}

/// Points `BASE_URL` of the dev environment at [baseUrl] (`env/dev.example.json`
/// is the committed file; `dev.json` is git-ignored and copied from it).
void _setDevBaseUrl(String baseUrl) {
  final file = File('env/dev.example.json');
  if (!file.existsSync()) {
    return;
  }
  final updated = file.readAsStringSync().replaceFirstMapped(
        RegExp(r'("BASE_URL"\s*:\s*)"[^"]*"'),
        (m) => '${m[1]}${jsonEncode(baseUrl)}',
      );
  file.writeAsStringSync(updated);
}

String _xmlEscape(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

/// Updates Android `build.gradle.kts` with the correct applicationId / namespace.
void _updateAndroidConfig(String appOrg, String appName) {
  final packageId = '$appOrg.$appName';

  // app/build.gradle.kts
  _replaceInFile(
    'android/app/build.gradle.kts',
    'com.alexxy.flutter_all_template',
    packageId,
  );

  _replaceInFile(
    'android/app/google-services.json.example',
    'com.alexxy.flutter_all_template',
    packageId,
  );

  // Also update AndroidManifest.xml package attribute if present
  _replaceInFile(
    'android/app/src/main/AndroidManifest.xml',
    'com.alexxy.flutter_all_template',
    packageId,
  );

  _moveMainActivity(packageId);
}

/// Moves `MainActivity.kt` into the new package directory and fixes its
/// `package` line, otherwise the generated Android app can't find its activity.
void _moveMainActivity(String packageId) {
  const oldPackage = 'com.alexxy.flutter_all_template';
  if (packageId == oldPackage) return;
  const kotlinRoot = 'android/app/src/main/kotlin';
  final oldFile = File(
    '$kotlinRoot/${oldPackage.replaceAll('.', '/')}/MainActivity.kt',
  );
  if (!oldFile.existsSync()) return;

  final newDir = Directory('$kotlinRoot/${packageId.replaceAll('.', '/')}')
    ..createSync(recursive: true);
  File('${newDir.path}/MainActivity.kt').writeAsStringSync(
    oldFile.readAsStringSync().replaceAll(oldPackage, packageId),
  );
  oldFile.deleteSync();

  // Prune now-empty directories left behind (com/alexxy/...).
  var dir = oldFile.parent;
  while (dir.path != kotlinRoot && dir.existsSync() && dir.listSync().isEmpty) {
    dir.deleteSync();
    dir = dir.parent;
  }
}

/// iOS bundle identifiers use camelCase app names (`com.example.myApp`).
String _iosBundleId(String appOrg, String appName) {
  final parts = appName.split('_').where((p) => p.isNotEmpty).toList();
  final camel = parts.first +
      parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
  return '$appOrg.$camel';
}

void _updateIosBundleId(String appOrg, String appName) {
  _replaceInFile(
    'ios/Runner.xcodeproj/project.pbxproj',
    'com.alexxy.flutterAllTemplate',
    _iosBundleId(appOrg, appName),
  );
}

/// Replaces the template's bundle ids and package name in the config files
/// that ship with the project but are not Dart or platform sources.
void _renameInConfigFiles(String appOrg, String appName) {
  // Longest first: `flutter_all_template` is a prefix of the Android id.
  final replacements = <String, String>{
    'com.alexxy.flutterAllTemplate': _iosBundleId(appOrg, appName),
    'com.alexxy.flutter_all_template': '$appOrg.$appName',
    'com/alexxy/flutter_all_template':
        '${appOrg.replaceAll('.', '/')}/$appName',
    'flutter_all_template': appName,
  };
  const targets = <String>[
    'codemagic.yaml',
    'scripts',
    '.maestro',
    'docs',
    '.github',
    'SECURITY.md',
    'FOLDER_STRUCTURE.md',
    'env',
    '.gitleaks.toml',
    'ios/Runner/Info.plist',
    'android/app/src/main/AndroidManifest.xml',
    'lib/core/services/notification/docs',
  ];
  const textExtensions = <String>[
    '.yaml', '.yml', '.sh', '.md', '.json', '.mjs', '.toml', '.plist',
    '.xml', //
  ];
  for (final target in targets) {
    final files = <File>[];
    if (FileSystemEntity.isDirectorySync(target)) {
      files.addAll(
          Directory(target).listSync(recursive: true).whereType<File>());
    } else if (File(target).existsSync()) {
      files.add(File(target));
    }
    for (final file in files) {
      if (!textExtensions.any(file.path.endsWith)) continue;
      var content = file.readAsStringSync();
      final original = content;
      replacements
          .forEach((from, to) => content = content.replaceAll(from, to));
      if (content != original) file.writeAsStringSync(content);
    }
  }
}

/// Deletes a file if it exists. Silently skips if missing.
void _deleteFile(String path) {
  final file = File(path);
  if (file.existsSync()) {
    file.deleteSync();
  }
}

/// Recursively deletes a directory if it exists. Silently skips if missing.
void _deleteDir(String path) {
  final dir = Directory(path);
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
  }
}
