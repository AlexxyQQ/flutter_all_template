import 'package:mason/mason.dart';

void run(HookContext context) {
  final snake = (context.vars['feature_name'] as String).snakeCase;
  final root = 'lib/features/$snake';
  // Mason skips a template whose rendered path is empty.
  context.vars = {
    ...context.vars,
    'params_path': context.vars['use_params'] == true
        ? '$root/domain/params/${snake}_params.dart'
        : '',
    'local_path': context.vars['use_local_datasource'] == true
        ? '$root/data/data_sources/local/${snake}_local_data_source.dart'
        : '',
  };
}
