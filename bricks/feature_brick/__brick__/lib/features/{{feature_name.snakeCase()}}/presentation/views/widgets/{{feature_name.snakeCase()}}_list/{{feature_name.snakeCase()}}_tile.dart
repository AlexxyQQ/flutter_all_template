{{#include_delete}}import 'package:easy_localization/easy_localization.dart';
{{/include_delete}}import 'package:flutter/material.dart';
{{#include_delete}}import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
{{/include_delete}}import '../../../../domain/entities/{{feature_name.snakeCase()}}.dart';
{{#include_delete}}import '../../../bloc/{{feature_name.snakeCase()}}_list_bloc.dart';
{{/include_delete}}
class {{feature_name.pascalCase()}}Tile extends StatelessWidget {
  const {{feature_name.pascalCase()}}Tile({required this.{{feature_name.camelCase()}}, super.key});

  final {{feature_name.pascalCase()}} {{feature_name.camelCase()}};

  @override
  Widget build(BuildContext context) {
{{#include_delete}}    final bloc = context.read<{{feature_name.pascalCase()}}ListBloc>();
{{/include_delete}}    final id = {{feature_name.camelCase()}}.id;
    return ListTile(
      key: Key('{{feature_name.snakeCase()}}_item_$id'),
      title: Text({{feature_name.camelCase()}}.title),
{{#include_delete}}      trailing: IconButton(
        key: Key('{{feature_name.snakeCase()}}_delete_$id'),
        icon: const Icon(Icons.delete_outline),
        tooltip: LocaleKeys.common_words_delete.tr(),
        onPressed: () => bloc.add({{feature_name.pascalCase()}}Deleted(id)),
      ),
{{/include_delete}}    );
  }
}
