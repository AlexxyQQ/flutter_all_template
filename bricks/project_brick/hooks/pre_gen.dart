import 'package:mason/mason.dart';

/// Normalises answers before templates are rendered.
///
/// * Push notifications are built on FCM, so they imply Firebase. Doing this
///   here keeps the Mustache sections in `__brick__` consistent with each
///   other.
/// * Rejects names that would produce a project that can't build.
/// * Derives the launcher display name and checks the dev API URL.
void run(HookContext context) {
  final vars = context.vars;
  final logger = context.logger;

  final appName = (vars['app_name'] as String).trim().snakeCase;
  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(appName)) {
    _fail(
      context,
      'app_name "${vars['app_name']}" must start with a letter and contain '
      'only letters, digits, "_" or "-" (it becomes the Dart package name).',
    );
  }
  final appOrg = (vars['app_org'] as String).trim();
  if (!RegExp(r'^[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z][A-Za-z0-9_]*)+$')
      .hasMatch(appOrg)) {
    _fail(
      context,
      'app_org "$appOrg" must be a reverse-domain identifier such as '
      'com.example (letters, digits, "_" and at least one ".").',
    );
  }

  final displayName = ((vars['app_display_name'] as String?) ?? '').trim();
  if (displayName.contains(RegExp(r'[\r\n"]'))) {
    _fail(
      context,
      'app_display_name must be a single line without double quotes.',
    );
  }

  var baseUrl = ((vars['base_url'] as String?) ?? '').trim();
  if (baseUrl.isNotEmpty) {
    final uri = Uri.tryParse(baseUrl);
    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        uri.host.isEmpty) {
      _fail(context, 'base_url "$baseUrl" must be an http(s) URL.');
    }
    // `ApiPaths` entries are relative to the base URL, which therefore has to
    // end with a slash (`https://host/v1/` + `todos`).
    if (!baseUrl.endsWith('/')) {
      baseUrl = '$baseUrl/';
    }
  }

  final useNotifications = vars['use_notifications'] == true;
  if (useNotifications && vars['use_firebase'] != true) {
    logger.warn(
      'Push notifications require Firebase - enabling Firebase too.',
    );
  }

  final useCi = vars['use_ci'] != false;
  final useCodemagic = vars['use_codemagic'] != false;
  context.vars = {
    ...vars,
    'app_display_name': displayName.isEmpty ? appName.titleCase : displayName,
    'base_url': baseUrl,
    'use_firebase': useNotifications || vars['use_firebase'] == true,
    // Normalised so the post-gen hook and the templates see real booleans.
    'use_ci': useCi,
    'use_codemagic': useCodemagic,
    'use_maestro': vars['use_maestro'] != false,
    // The CI/CD guide is only useful when at least one pipeline ships.
    'use_ci_docs': useCi || useCodemagic,
  };
}

Never _fail(HookContext context, String message) {
  context.logger.err(message);
  throw ArgumentError(message);
}
