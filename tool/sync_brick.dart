// Generates `bricks/project_brick/__brick__` from this repository so the
// Mason brick can never drift from the real template. The output is git-ignored:
// it is produced on demand (before `mason make`, and as a smoke test in CI),
// never committed.
//
// Usage (from the repository root):
//
//   dart run tool/sync_brick.dart           # (re)write the brick
//
// How optional modules work: source files stay valid Dart/YAML/Gradle and mark
// optional regions with comment markers, which this script turns into Mustache
// sections for Mason:
//
//   // brick:if use_permissions      -> {{#use_permissions}}
//   // brick:unless use_firebase     -> {{^use_firebase}}
//   // brick:end                     -> {{/<innermost open section>}}
//   // brick:repo-only ... brick:end -> region is dropped from the brick (for
//                                      steps that only make sense in the
//                                      template repo itself; no nesting)
//
// `#` comments work the same way in YAML. Directories of disabled modules are
// removed by `hooks/post_gen.dart`, which also rewrites the template's package
// name and bundle ids in config files (codemagic.yaml, .maestro/, scripts/,
// docs/, .github/).
//
// What generated projects get (everything else tracked in the repo ships as is):
//   - lean PR CI (.github/workflows/ci.yml without the brick-sync step),
//     weekly OSV scan, dependabot, codemagic.yaml, scripts/, .maestro/, docs/
//   - a short project README instead of the template README
//   - NOT shipped: bricks/, tool/, mason files, CHANGELOG.md, the `brick`
//     rps script
import 'dart:convert';
import 'dart:io';

const String _brickDir = 'bricks/project_brick/__brick__';

/// Everything is rendered inside this folder so `mason make` creates
/// `<app_name>/` instead of dumping files into the current directory.
const String _projectDir = '{{app_name.snakeCase()}}';

/// Repo files that must not ship in generated projects.
final List<RegExp> _excluded = <RegExp>[
  RegExp(r'^bricks/'),
  RegExp(r'^tool/'),
  RegExp(r'^\.git/'),
  RegExp(r'^\.claude/'),
  RegExp(r'^\.mason/'),
  RegExp(r'^mason(-lock)?\.(yaml|json)$'),
  RegExp(r'^CHANGELOG\.md$'),
  RegExp(r'^README\.md$'), // replaced by a generated project README
];

/// Files whose literal `{{ ... }}` (e.g. GitHub Actions expressions) must be
/// protected from Mustache by switching delimiters for the whole file.
final List<RegExp> _literalBraces = <RegExp>[
  RegExp(r'^\.github/'),
  RegExp(r'^\.maestro/'),
  RegExp(r'^docs/'),
  RegExp(r'^scripts/'),
  RegExp(r'^codemagic\.yaml$'),
];

final RegExp _marker = RegExp(
  r'^\s*(?://|#)\s*brick:(if|unless|end|repo-only)(?:\s+(\w+))?\s*$',
);

Future<void> main() async {
  final files = await _trackedFiles();
  final output = <String, List<int>>{};
  final problems = <String>[];

  for (final path in files) {
    if (_excluded.any((r) => r.hasMatch(path))) {
      continue;
    }
    final file = File(path);
    if (!file.existsSync()) {
      continue;
    }
    final bytes = file.readAsBytesSync();
    final text = _tryDecode(bytes);
    if (text == null) {
      output[path] = bytes; // binary asset
      continue;
    }
    try {
      output[path] = utf8.encode(_transform(path, text));
    } on FormatException catch (e) {
      problems.add('$path: ${e.message}');
    }
  }

  output['README.md'] = utf8.encode(_projectReadme);

  if (problems.isNotEmpty) {
    stderr.writeln('sync_brick failed:\n  ${problems.join('\n  ')}');
    exit(2);
  }

  final root = Directory(_brickDir);
  if (root.existsSync()) {
    root.deleteSync(recursive: true);
  }
  for (final entry in output.entries) {
    File('$_brickDir/$_projectDir/${entry.key}')
      ..createSync(recursive: true)
      ..writeAsBytesSync(entry.value);
  }
  stdout.writeln('Wrote ${output.length} files to $_brickDir');
}

Future<List<String>> _trackedFiles() async {
  final result = await Process.run('git', <String>[
    'ls-files',
    '--cached',
    '--others',
    '--exclude-standard',
    '-z',
  ], stdoutEncoding: utf8);
  if (result.exitCode != 0) {
    stderr.writeln(result.stderr);
    exit(2);
  }
  return (result.stdout as String)
      .split('\u0000')
      .where((p) => p.isNotEmpty)
      .toSet()
      .toList()
    ..sort();
}

String? _tryDecode(List<int> bytes) {
  try {
    return utf8.decode(bytes);
  } on FormatException {
    return null;
  }
}

String _transform(String path, String input) {
  final out = StringBuffer();
  final open = <String>[];
  const repoOnly = '<repo-only>';

  for (final line in input.split('\n')) {
    final cr = line.endsWith('\r') ? '\r' : '';
    final match = _marker.firstMatch(line);
    final skipping = open.isNotEmpty && open.last == repoOnly;
    if (match == null) {
      if (skipping) {
        continue;
      }
      out
        ..write(line)
        ..write('\n');
      continue;
    }
    final kind = match.group(1)!;
    final name = match.group(2);
    if (skipping && kind != 'end') {
      throw FormatException('brick:$kind inside brick:repo-only');
    }
    switch (kind) {
      case 'if':
        open.add(name!);
        out.write('{{#$name}}$cr\n');
      case 'unless':
        open.add(name!);
        out.write('{{^$name}}$cr\n');
      case 'repo-only':
        open.add(repoOnly);
      case _:
        if (open.isEmpty) {
          throw const FormatException('brick:end without an open section');
        }
        final closed = open.removeLast();
        if (closed != repoOnly) {
          out.write('{{/$closed}}$cr\n');
        }
    }
  }
  if (open.isNotEmpty) {
    throw FormatException('unclosed brick section(s): ${open.join(', ')}');
  }

  // `split('\n')` of text ending in '\n' yields a trailing '' — drop the
  // extra newline it produced.
  var result = out.toString();
  if (input.endsWith('\n') && result.endsWith('\n\n')) {
    result = result.substring(0, result.length - 1);
  } else if (!input.endsWith('\n') && result.endsWith('\n')) {
    result = result.substring(0, result.length - 1);
  }

  if (path == 'pubspec.yaml') {
    result = result
        .replaceFirst(
          RegExp(r'^name: flutter_all_template', multiLine: true),
          'name: {{app_name.snakeCase()}}',
        )
        .replaceFirst(
          'description: "A new Flutter project."',
          'description: "{{app_name.titleCase()}}"',
        )
        // The brick tooling is not part of generated projects.
        .replaceFirst(
          RegExp(
            r'^  brick: dart run tool/sync_brick\.dart\r?\n',
            multiLine: true,
          ),
          '',
        );
  }

  final stripped = result.replaceAll(
    RegExp(r'\{\{[#^/]\w+\}\}|\{\{app_name\.\w+\(\)\}\}'),
    '',
  );
  if (stripped.contains('{{')) {
    if (_literalBraces.any((r) => r.hasMatch(path))) {
      return '{{=<% %>=}}\n$result';
    }
    throw const FormatException(
      'contains a literal "{{" that Mason would treat as a template tag; '
      'rewrite it or add the file to _literalBraces',
    );
  }
  return result;
}

const String _projectReadme = '''# {{app_name.titleCase()}}

Flutter app generated from the Flutter All Template: Clean Architecture, BLoC,
get_it + injectable, auto_route, Freezed, Material 3.

## First run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart run easy_localization:generate -S assets/translations -f keys -O lib/config/constants/gen -o locale_keys.g.dart
dart fix --apply && dart format .
cp env/dev.example.json env/dev.json   # then edit BASE_URL
flutter run --dart-define-from-file=env/dev.json
```

Generated code (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.config.dart`, locale
keys) is git-ignored. Re-run the two generators after changing models, routes,
injectable classes or translations.

## Docs

- `FOLDER_STRUCTURE.md` - where things live and the layering rules
- `RULES.md` - coding rules with do/don't examples (read before your first PR)
{{#use_ci_docs}}- `docs/CI_CD.md` - PR CI, local Android releases, Codemagic for iOS
{{/use_ci_docs}}{{#use_maestro}}- `docs/MAESTRO.md` - end-to-end tests
{{/use_maestro}}- `docs/FLAVORS.md`, `docs/CODE_SIGNING.md`, `docs/PLATFORM_SETUP.md`
- `SECURITY.md` - secret handling and release hardening
''';
