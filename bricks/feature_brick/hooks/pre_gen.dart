import 'package:mason/mason.dart';

/// Normalises the answers and derives everything the templates need that
/// Mustache can't compute itself: the plural form, the paths, and which
/// optional files exist.
///
/// Mason skips a template whose rendered path is empty, so optional files are
/// named `{{{<something>_path}}}` and this hook sets the variable to the full
/// path (enabled) or to `''` (disabled).
void run(HookContext context) {
  final vars = context.vars;
  final name = (vars['feature_name'] as String).trim();
  final snake = name.snakeCase;

  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(snake)) {
    _fail(
      context,
      'feature_name "$name" must start with a letter and contain only '
      'letters, digits, "_" or "-".',
    );
  }

  final given = (vars['feature_plural'] as String?)?.trim() ?? '';
  final plural = (given.isEmpty ? _pluralize(snake) : given.snakeCase);
  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(plural)) {
    _fail(context, 'feature_plural "$given" is not a valid name.');
  }
  if (plural.pascalCase == name.pascalCase) {
    _fail(
      context,
      'The plural of "$name" is identical to the singular, so '
      'get${name.pascalCase}() and get${plural.pascalCase}() would clash. '
      'Pass a different feature_plural (e.g. "${snake}_list").',
    );
  }

  // `ApiPaths` entries are relative to the base URL (which ends with `/`), so
  // they never start with a slash; route paths always do.
  final apiPath =
      _path(context, 'api_path', vars['api_path'], plural).substring(1);
  final routePath = _path(context, 'route_path', vars['route_path'], plural);

  final create = vars['include_create'] == true;
  final update = vars['include_update'] == true;
  final delete = vars['include_delete'] == true;
  final search = vars['include_search'] == true;
  final mutations = [
    if (create) 'create',
    if (update) 'update',
    if (delete) 'delete',
  ];

  final root = 'lib/features/$snake';
  final widgets = '$root/presentation/views/widgets/${snake}_list';
  String ifOn(bool on, String path) => on ? path : '';

  context.vars = {
    ...vars,
    'feature_plural': plural,
    'api_path': apiPath,
    'route_path': routePath,
    'has_mutations': mutations.isNotEmpty,
    'mutations_label': mutations.join('/'),
    'params_path': ifOn(
      vars['use_params'] == true,
      '$root/domain/params/${snake}_params.dart',
    ),
    'local_path': ifOn(
      vars['use_local_datasource'] == true,
      '$root/data/data_sources/local/${snake}_local_data_source.dart',
    ),
    'create_use_case_path': ifOn(
      create,
      '$root/domain/usecases/create_${snake}_use_case.dart',
    ),
    'update_use_case_path': ifOn(
      update,
      '$root/domain/usecases/update_${snake}_use_case.dart',
    ),
    'delete_use_case_path': ifOn(
      delete,
      '$root/domain/usecases/delete_${snake}_use_case.dart',
    ),
    'test_path': ifOn(
      vars['generate_tests'] == true,
      'test/widget/features/$snake/${snake}_flow_test.dart',
    ),
    'add_dialog_path': ifOn(create, '$widgets/add_${snake}_dialog.dart'),
    'search_field_path': ifOn(search, '$widgets/${snake}_search_field.dart'),
  };
}

Never _fail(HookContext context, String message) {
  context.logger.err(message);
  throw ArgumentError(message);
}

/// `note` -> `notes`, `category` -> `categories`, `address` -> `addresses`.
/// Only the last word of a snake_case name is changed. Irregular plurals
/// (person -> people) need an explicit `feature_plural`.
String _pluralize(String snake) {
  final words = snake.split('_');
  final last = words.removeLast();
  final String plural;
  if (RegExp(r'[^aeiou]y$').hasMatch(last)) {
    plural = '${last.substring(0, last.length - 1)}ies';
  } else if (RegExp(r'(s|x|z|ch|sh)$').hasMatch(last)) {
    plural = '${last}es';
  } else {
    plural = '${last}s';
  }
  return [...words, plural].join('_');
}

/// A leading-slash, no-trailing-slash path (callers strip the slash if needed) made of `[A-Za-z0-9_/-]` only (the
/// post-gen hook edits `ApiPaths` with a regex that relies on this).
String _path(HookContext context, String key, Object? raw, String plural) {
  var value = (raw as String?)?.trim() ?? '';
  if (value.isEmpty) {
    return '/${plural.paramCase}';
  }
  if (!value.startsWith('/')) {
    value = '/$value';
  }
  while (value.length > 1 && value.endsWith('/')) {
    value = value.substring(0, value.length - 1);
  }
  if (!RegExp(r'^/[A-Za-z0-9_/-]+$').hasMatch(value)) {
    _fail(
      context,
      '$key "$value" may only contain letters, digits, "_", "-" and "/".',
    );
  }
  return value;
}
