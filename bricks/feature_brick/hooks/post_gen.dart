import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) {
  final featureName = context.vars['feature_name'] as String;
  final useLocalDatasource = context.vars['use_local_datasource'] as bool;
  final useParams = context.vars['use_params'] as bool;

  final snakeFeature = _toSnakeCase(featureName);
  final featureBase = 'lib/features/$snakeFeature';

  final progress = context.logger.progress('Configuring feature...');

  try {
    if (!useParams) {
      _deleteDir('$featureBase/domain/entities/params');
    }

    if (!useLocalDatasource) {
      _deleteDir('$featureBase/data/data_sources/local');
    }

    progress.complete('Feature configured!');
  } catch (e) {
    progress.fail('Configuration failed: $e');
    rethrow;
  }

  context.logger.info('');
  context.logger.info('✅ Feature "$snakeFeature" generated! Next steps:');
  context.logger.info('');
  context.logger.info(
    '  1. Add ${snakeFeature.toUpperCase()} path to ApiPaths (lib/config/constants/api/api_paths.dart)',
  );
  context.logger.info(
    '  2. Register ${_toPascalCase(snakeFeature)}RepositoryImpl in your DI module (if not using injectable auto-wiring)',
  );
  context.logger.info(
    '  3. Run: dart run build_runner build --delete-conflicting-outputs',
  );
  if (useParams) {
    context.logger.info(
      '  4. Extend ${_toPascalCase(snakeFeature)}RequestParams with your fields',
    );
  }
  context.logger.info('');
}

String _toSnakeCase(String input) =>
    input.trim().toLowerCase().replaceAll(RegExp(r'[\s\-]+'), '_');

String _toPascalCase(String snakeCase) {
  return snakeCase
      .split('_')
      .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
      .join();
}

void _deleteDir(String path) {
  final dir = Directory(path);
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
  }
}
