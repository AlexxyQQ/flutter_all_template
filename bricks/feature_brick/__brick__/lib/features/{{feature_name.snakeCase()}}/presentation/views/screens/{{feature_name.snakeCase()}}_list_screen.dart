import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../core/presentation/failure_text.dart';
import '../../bloc/{{feature_name.snakeCase()}}_list_bloc.dart';
{{#include_create}}import '../widgets/{{feature_name.snakeCase()}}_list/add_{{feature_name.snakeCase()}}_dialog.dart';
{{/include_create}}import '../widgets/{{feature_name.snakeCase()}}_list/{{feature_name.snakeCase()}}_body.dart';
{{#include_search}}import '../widgets/{{feature_name.snakeCase()}}_list/{{feature_name.snakeCase()}}_search_field.dart';
{{/include_search}}
/// List screen: loads{{#include_create}}, adds{{/include_create}}{{#include_delete}}, deletes{{/include_delete}} {{feature_plural.pascalCase()}}.
///
/// The [{{feature_name.pascalCase()}}ListBloc] comes from the parent `{{feature_name.pascalCase()}}Wrapper` route.
@RoutePage()
class {{feature_name.pascalCase()}}ListScreen extends StatelessWidget {
  const {{feature_name.pascalCase()}}ListScreen({super.key});{{#include_create}}

  Future<void> _add(BuildContext context) async {
    final bloc = context.read<{{feature_name.pascalCase()}}ListBloc>();
    final title = await showDialog<String>(
      context: context,
      builder: (_) => const Add{{feature_name.pascalCase()}}Dialog(),
    );
    if (title != null && title.trim().isNotEmpty) {
      bloc.add({{feature_name.pascalCase()}}Created(title));
    }
  }{{/include_create}}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.features_{{feature_name.snakeCase()}}_title.tr(),
          key: const Key('{{feature_name.snakeCase()}}_title'),
        ),
{{#include_search}}        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(64),
          child: {{feature_name.pascalCase()}}SearchField(),
        ),
{{/include_search}}      ),
{{#include_create}}      floatingActionButton: Semantics(
        identifier: '{{feature_name.snakeCase()}}_add_button',
        child: FloatingActionButton(
          key: const Key('{{feature_name.snakeCase()}}_add_button'),
          tooltip: LocaleKeys.features_{{feature_name.snakeCase()}}_add.tr(),
          onPressed: () => _add(context),
          child: const Icon(Icons.add),
        ),
      ),
{{/include_create}}      body: BlocConsumer<{{feature_name.pascalCase()}}ListBloc, {{feature_name.pascalCase()}}ListState>(
        listenWhen: (previous, current) =>
            current.failure != null &&
            current.items.isNotEmpty &&
            previous.failure != current.failure,
        listener: (context, state) => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.failure!.displayText))),
        builder: (context, state) => {{feature_name.pascalCase()}}Body(state: state),
      ),
    );
  }
}
