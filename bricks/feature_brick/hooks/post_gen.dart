import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart';

const _apiPathsFile = 'lib/config/constants/api/api_paths.dart';
const _routerFile = 'lib/core/common/presentation/routes/app_router.dart';
const _translationFiles = [
  'assets/translations/en-GB.json',
];
const _testHelper = 'test/widget/helpers/test_app.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['feature_name'] as String;
  final useParams = context.vars['use_params'] as bool;

  // Must match the mustache lambdas used in the templates.
  final snake = name.snakeCase;
  final pascal = name.pascalCase;
  final pathConstant = '${name.camelCase}s';
  final pathValue = '/${name.paramCase}s';
  final featureDir = 'lib/features/$snake';
  final testFile = 'test/widget/features/$snake/${snake}_flow_test.dart';

  final progress = context.logger.progress('Configuring $featureDir');
  final addedPath = _addApiPath(pathConstant, pathValue);
  final addedRoute = _addRoute(snake, pascal);
  final translated = [
    for (final file in _translationFiles) _addTranslations(file, snake, name),
  ];
  final testPatched = _fixTestPackage(testFile, snake);
  final formatted = await Process.run(
    'dart',
    ['format', featureDir, 'test/widget/features/$snake'],
    runInShell: true,
  );
  if (formatted.exitCode != 0) {
    progress.fail('dart format failed');
    throw ProcessException(
        'dart',
        ['format', featureDir, 'test/widget/features/$snake'],
        '${formatted.stdout}\n${formatted.stderr}',
        formatted.exitCode);
  }
  progress.complete('Generated $featureDir');

  final log = context.logger;
  log
    ..info('')
    ..info(
      addedPath
          ? 'Added ApiPaths.$pathConstant = $pathValue to $_apiPathsFile.'
          : 'Add to $_apiPathsFile (inside ApiPaths):\n'
              "  static const String $pathConstant = '$pathValue';",
    )
    ..info(
      addedRoute
          ? 'Registered ${pascal}Routes.route in $_routerFile.'
          : 'Register the route by hand in $_routerFile:\n'
              "  import '../../../../features/$snake/presentation/routes/"
              "${snake}_route.dart';\n"
              '  and add ${pascal}Routes.route, to the routes list.',
    );
  for (var i = 0; i < _translationFiles.length; i++) {
    log.info(
      translated[i]
          ? 'Added features.$snake.* keys to ${_translationFiles[i]}.'
          : 'Add features.$snake.presentation.screens.${snake}_list_screen '
              '{title, add, hint} to ${_translationFiles[i]} by hand.',
    );
  }
  log.info(
      'Translate features.$snake.presentation.screens.${snake}_list_screen '
      '{title, add, hint} in assets/translations/ne-NP.json.');
  if (!testPatched) {
    log.warn(
      'No package name found in pubspec.yaml: in $testFile replace '
      '"package:__package__/" with your package name.',
    );
  }
  if (!File(_testHelper).existsSync()) {
    log.warn('$_testHelper not found: the generated widget test needs it.');
  }
  log
    ..info('')
    ..info('Next steps:')
    ..info('  1. Add your fields to $pascal, ${pascal}Model'
        '${useParams ? ' and the params in domain/params/' : ''}.')
    ..info('  2. dart run build_runner build --delete-conflicting-outputs')
    ..info('     (generates Freezed/JSON code, registers the data sources,')
    ..info('     ${pascal}RepositoryImpl, the use cases and ${pascal}ListBloc')
    ..info('     with injectable, and the auto_route routes).')
    ..info('  3. dart run easy_localization:generate -S assets/translations '
        '-f keys -O lib/config/constants/gen -o locale_keys.g.dart')
    ..info('     (generates the LocaleKeys the new screen uses).')
    ..info('  4. Adapt the API contract documented in '
        '${snake}_remote_data_source.dart to your backend.')
    ..info(
        '  5. Open the page with context.router.push(const ${pascal}Route())')
    ..info('     (or add a button for it on the home screen).')
    ..info('');
}

/// Inserts the path constant into `ApiPaths`. Returns `false` when the file
/// doesn't have the expected shape (the user adds it by hand).
bool _addApiPath(String constant, String value) {
  final file = File(_apiPathsFile);
  if (!file.existsSync()) {
    return false;
  }
  final source = file.readAsStringSync();
  // Restrict automatic edits to the template's simple constant-only class.
  final matches = RegExp(
    r'^abstract final class ApiPaths \{\r?\n'
    r"((?:[ \t]*static const String \w+ = '/[\w/-]*';[ \t]*\r?\n|[ \t]*\r?\n)*)"
    r'\}',
    multiLine: true,
  ).allMatches(source).toList();
  if (matches.length != 1 ||
      source.contains('/*') ||
      source.contains("'''") ||
      source.contains('\"\"\"')) return false;
  final match = matches.single;
  final body = match.group(1)!;
  if (RegExp('static const String $constant = ').hasMatch(body)) {
    return body.contains("static const String $constant = '$value';");
  }
  final eol = source.contains('\r\n') ? '\r\n' : '\n';
  final end = match.end - 1;
  file.writeAsStringSync(source.replaceRange(
    end,
    end,
    "  static const String $constant = '$value';$eol",
  ));
  return true;
}

/// Registers `<Pascal>Routes.route` in `AppRouter`: adds the (sorted) import
/// and the entry in the `<AutoRoute>[...]` list. Idempotent. Returns `false`
/// when an anchor is missing (the user does it by hand).
bool _addRoute(String snake, String pascal) {
  final file = File(_routerFile);
  if (!file.existsSync()) {
    return false;
  }
  final source = file.readAsStringSync();
  final eol = source.contains('\r\n') ? '\r' : '';
  final lines = source.split('\n');

  final importPath = '../../../../features/$snake/presentation/routes/'
      '${snake}_route.dart';
  final importLine = "import '$importPath';$eol";
  final entry = '    ${pascal}Routes.route,$eol';

  final hasImport = lines.any((l) => l.trim() == importLine.trim());
  final hasEntry = lines.any((l) => l.trim() == '${pascal}Routes.route,');
  if (hasImport && hasEntry) {
    return true;
  }

  // Locate the routes list first so a missing anchor changes nothing.
  final listStart = lines.indexWhere(
    (l) => RegExp(r'routes\s*=>\s*(<AutoRoute>)?\[').hasMatch(l),
  );
  var listEnd = -1;
  if (listStart >= 0) {
    listEnd = lines.indexWhere((l) => l.trim() == '];', listStart);
  }
  if (!hasEntry && listEnd < 0) {
    return false;
  }

  if (!hasEntry) {
    // After the last plain entry that precedes any `// brick:` comment.
    var insertAt = listStart + 1;
    for (var i = listStart + 1; i < listEnd; i++) {
      final t = lines[i].trim();
      if (t.startsWith('//')) {
        break;
      }
      if (RegExp(r'^\w+(\.\w+)+,$').hasMatch(t)) {
        insertAt = i + 1;
      }
    }
    lines.insert(insertAt, entry);
  }

  if (!hasImport) {
    final featureImport = RegExp(r"^import '\.\./\.\./\.\./\.\./features/");
    final features = [
      for (var i = 0; i < lines.length; i++)
        if (featureImport.hasMatch(lines[i])) i,
    ];
    var insertAt = -1;
    for (final i in features) {
      if (lines[i].trim().compareTo(importLine.trim()) > 0) {
        insertAt = i;
        break;
      }
    }
    if (insertAt < 0 && features.isNotEmpty) {
      insertAt = features.last + 1;
    }
    if (insertAt < 0) {
      final export = lines.indexWhere((l) => l.startsWith('export '));
      final lastImport = lines.lastIndexWhere((l) => l.startsWith('import '));
      insertAt = export >= 0 ? export : lastImport + 1;
    }
    lines.insert(insertAt, importLine);
  }

  file.writeAsStringSync(lines.join('\n'));
  return true;
}

/// Adds `features.<snake>.presentation.screens.<snake>_list_screen` with
/// `title`, `add` and `hint` to a translation file, keeping its indentation
/// and key order and never overwriting existing keys. Returns `false` when
/// the file is missing or not a JSON object.
bool _addTranslations(String path, String snake, String name) {
  final file = File(path);
  if (!file.existsSync()) {
    return false;
  }
  final source = file.readAsStringSync();
  final Object? decoded;
  try {
    decoded = jsonDecode(source);
  } on FormatException {
    return false;
  }
  if (decoded is! Map<String, dynamic>) {
    return false;
  }

  // English text derived from the name; ne-NP has no translation to offer.
  final words = snake.split('_');
  final label = words.join(' ');
  final plural = '${words.map(_capitalize).join(' ')}s';
  final texts = {
    'title': plural,
    'add': 'Add $label',
    'hint': '${_capitalize(label)} title',
  };

  var node = decoded;
  for (final key in ['features', snake, 'presentation', 'screens']) {
    final next = node[key];
    if (next is Map<String, dynamic>) {
      node = next;
    } else if (next == null) {
      node = node[key] = <String, dynamic>{};
    } else {
      return false;
    }
  }
  final screen = node.putIfAbsent(
    '${snake}_list_screen',
    () => <String, dynamic>{},
  );
  if (screen is! Map<String, dynamic>) {
    return false;
  }
  var changed = false;
  for (final entry in texts.entries) {
    if (!screen.containsKey(entry.key)) {
      screen[entry.key] = entry.value;
      changed = true;
    }
  }
  if (changed) {
    final indent = RegExp(r'\n([ \t]+)"').firstMatch(source)?.group(1) ?? '  ';
    final eol = source.contains('\r\n') ? '\r\n' : '\n';
    var out = JsonEncoder.withIndent(indent).convert(decoded);
    if (eol != '\n') {
      out = out.replaceAll('\n', eol);
    }
    file.writeAsStringSync(
      source.endsWith('\n') ? '$out$eol' : out,
    );
  }
  return true;
}

String _capitalize(String word) =>
    word.isEmpty ? word : word[0].toUpperCase() + word.substring(1);

/// Points the generated widget test at this project's package (read from
/// `pubspec.yaml`) and re-sorts its `package:` imports. Returns `false` (the
/// placeholder stays) when the name can't be read.
bool _fixTestPackage(String path, String snake) {
  final file = File(path);
  if (!file.existsSync()) {
    return false;
  }
  final pubspec = File('pubspec.yaml');
  final packageName = pubspec.existsSync()
      ? RegExp(r'^name:\s*(\S+)', multiLine: true)
          .firstMatch(pubspec.readAsStringSync())
          ?.group(1)
      : null;
  if (packageName == null) {
    return false;
  }

  final lines = file.readAsStringSync().split('\n');
  const marker = 'package:__package__/';
  final ours = [
    for (var i = 0; i < lines.length; i++)
      if (lines[i].contains(marker)) i,
  ];
  if (ours.isEmpty) {
    return true;
  }
  final first = ours.first;
  final last = ours.last;
  // Contiguous `package:` import block that holds the placeholder lines.
  var start = first;
  while (start > 0 && lines[start - 1].startsWith("import 'package:")) {
    start--;
  }
  var end = last;
  while (
      end + 1 < lines.length && lines[end + 1].startsWith("import 'package:")) {
    end++;
  }
  final block = lines.sublist(start, end + 1);

  final sorted = [
    for (final l in block) l.replaceFirst(marker, 'package:$packageName/'),
  ]..sort();
  lines.replaceRange(start, end + 1, sorted);
  file.writeAsStringSync(lines.join('\n'));
  return true;
}
