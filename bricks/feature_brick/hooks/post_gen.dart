import 'dart:io';

import 'package:mason/mason.dart';

const _apiPathsFile = 'lib/config/constants/api/api_paths.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['feature_name'] as String;
  final useLocal = context.vars['use_local_datasource'] as bool;
  final useParams = context.vars['use_params'] as bool;

  // Must match the mustache lambdas used in the templates.
  final snake = name.snakeCase;
  final pascal = name.pascalCase;
  final pathConstant = '${name.camelCase}s';
  final pathValue = '/${name.paramCase}s';
  final featureDir = 'lib/features/$snake';

  final progress = context.logger.progress('Configuring $featureDir');
  if (!useParams) {
    _deleteDir('$featureDir/domain/params');
  }
  if (!useLocal) {
    _deleteDir('$featureDir/data/data_sources/local');
  }
  final addedPath = _addApiPath(pathConstant, pathValue);
  await Process.run('dart', ['format', featureDir], runInShell: true);
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
    ..info('')
    ..info('Next steps:')
    ..info('  1. Add your fields to $pascal, ${pascal}Model'
        '${useParams ? ' and the params in domain/params/' : ''}.')
    ..info('  2. dart run build_runner build --delete-conflicting-outputs')
    ..info('     (generates Freezed/JSON code and registers the data sources,')
    ..info(
        '     ${pascal}RepositoryImpl and ${pascal}ListBloc with injectable).')
    ..info('  3. Adapt the API contract documented in '
        '${snake}_remote_data_source.dart to your backend.')
    ..info(
        '  4. Build a page: BlocProvider(create: (_) => sl<${pascal}ListBloc>())'
        ' + PaginationListView<$pascal>, and add its route.')
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
  if (source.contains(' $constant ')) {
    return true;
  }
  final classStart = source.indexOf('class ApiPaths');
  final classEnd = source.lastIndexOf('}');
  if (classStart < 0 || classEnd < classStart) {
    return false;
  }
  final line = "  static const String $constant = '$value';\n";
  file.writeAsStringSync(
    source.substring(0, classEnd) + line + source.substring(classEnd),
  );
  return true;
}

void _deleteDir(String path) {
  final dir = Directory(path);
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
  }
}
