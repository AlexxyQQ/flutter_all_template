import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../bloc/{{feature_name.snakeCase()}}_list_bloc.dart';
import '../widgets/{{feature_name.snakeCase()}}_list/add_{{feature_name.snakeCase()}}_dialog_widget.dart';
import '../widgets/{{feature_name.snakeCase()}}_list/{{feature_name.snakeCase()}}_body_widget.dart';

/// List screen: loads, adds and deletes {{feature_name.pascalCase()}}s.
///
/// The [{{feature_name.pascalCase()}}ListBloc] comes from the parent `{{feature_name.pascalCase()}}Wrapper` route.
@RoutePage(name: '{{feature_name.pascalCase()}}Route')
class {{feature_name.pascalCase()}}ListScreen extends StatelessWidget {
  const {{feature_name.pascalCase()}}ListScreen({super.key});

  Future<void> _add(BuildContext context) async {
    final bloc = context.read<{{feature_name.pascalCase()}}ListBloc>();
    final title = await showDialog<String>(
      context: context,
      builder: (_) => const Add{{feature_name.pascalCase()}}Dialog(),
    );
    if (title != null && title.trim().isNotEmpty) {
      bloc.add({{feature_name.pascalCase()}}Created(title));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys
              .features_{{feature_name.snakeCase()}}_presentation_screens_{{feature_name.snakeCase()}}_list_screen_title
              .tr(),
          key: const Key('{{feature_name.snakeCase()}}_title'),
        ),
      ),
      floatingActionButton: Semantics(
        identifier: '{{feature_name.snakeCase()}}_add_button',
        child: FloatingActionButton(
          key: const Key('{{feature_name.snakeCase()}}_add_button'),
          tooltip: LocaleKeys
              .features_{{feature_name.snakeCase()}}_presentation_screens_{{feature_name.snakeCase()}}_list_screen_add
              .tr(),
          onPressed: () => _add(context),
          child: const Icon(Icons.add),
        ),
      ),
      body: BlocConsumer<{{feature_name.pascalCase()}}ListBloc, {{feature_name.pascalCase()}}ListState>(
        listenWhen: (previous, current) =>
            current.failure != null &&
            current.items.isNotEmpty &&
            previous.failure != current.failure,
        listener: (context, state) => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.failure!.message.tr()))),
        builder: (context, state) => {{feature_name.pascalCase()}}Body(state: state),
      ),
    );
  }
}
