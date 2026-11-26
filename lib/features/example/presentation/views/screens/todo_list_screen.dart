import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../core/common/presentation/modals/modal_service.dart';
import '../../bloc/todo_list_bloc.dart';
import '../widgets/todo_list/add_todo_dialog_widget.dart';
import '../widgets/todo_list/todo_body_widget.dart';

/// Example list screen: loads, adds, toggles and deletes to-dos.
///
/// The [TodoListBloc] and [ModalService] come from the parent `TodoWrapper`
/// route.
@RoutePage(name: 'TodoRoute')
class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  Future<void> _addTodo(BuildContext context) async {
    final bloc = context.read<TodoListBloc>();
    final title = await context.read<ModalService>().showPopup<String>(
      context: context,
      builder: (_) => const AddTodoDialog(),
    );
    if (title != null && title.trim().isNotEmpty) {
      bloc.add(TodoCreated(title));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AutoLeadingButton(
          ignorePagelessRoutes: true,
          builder: (context, type, action) => type.isBack
              ? BackButton(onPressed: action)
              : const SizedBox.shrink(),
        ),
        title: Text(
          LocaleKeys
              .features_example_presentation_screens_todo_list_screen_title
              .tr(),
          key: const Key('todo_title'),
        ),
      ),
      floatingActionButton: Semantics(
        identifier: 'todo_add_button',
        child: FloatingActionButton(
          key: const Key('todo_add_button'),
          tooltip: LocaleKeys
              .features_example_presentation_screens_todo_list_screen_add
              .tr(),
          onPressed: () => _addTodo(context),
          child: const Icon(Icons.add),
        ),
      ),
      body: BlocConsumer<TodoListBloc, TodoListState>(
        listenWhen: (previous, current) =>
            current.failure != null &&
            current.items.isNotEmpty &&
            previous.failure != current.failure,
        listener: (context, state) => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.failure!.message.tr()))),
        builder: (context, state) => TodoBody(state: state),
      ),
    );
  }
}
