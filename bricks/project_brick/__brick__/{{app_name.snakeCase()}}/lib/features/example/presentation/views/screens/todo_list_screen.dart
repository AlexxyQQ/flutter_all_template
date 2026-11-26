import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../core/common/locator/service_locator.dart';
import '../../../../../core/generic/presentation/bloc/paged_list_bloc.dart';
import '../../../domain/entities/todo.dart';
import '../../bloc/todo_list_bloc.dart';

/// Example list screen: loads, adds, toggles and deletes to-dos.
@RoutePage(name: 'TodoRoute')
class TodoListScreen extends StatelessWidget implements AutoRouteWrapper {
  const TodoListScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider<TodoListBloc>(
    create: (_) => sl<TodoListBloc>()..add(const PagedListStarted()),
    child: this,
  );

  Future<void> _addTodo(BuildContext context) async {
    final bloc = context.read<TodoListBloc>();
    final title = await showDialog<String>(
      context: context,
      builder: (_) => const _AddTodoDialog(),
    );
    if (title != null && title.trim().isNotEmpty) {
      bloc.add(TodoCreated(title));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        builder: (context, state) => _TodoBody(state: state),
      ),
    );
  }
}

class _TodoBody extends StatelessWidget {
  const _TodoBody({required this.state});

  final TodoListState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TodoListBloc>();
    final failure = state.failure;

    if (state.items.isEmpty) {
      if (state.isInitial || state.isBusy) {
        return const Center(
          child: CircularProgressIndicator(key: Key('todo_loader')),
        );
      }
      return Center(
        child: failure == null
            ? Text(
                LocaleKeys.common_errors_noDataFound.tr(),
                key: const Key('todo_empty'),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(failure.message.tr(), key: const Key('todo_error')),
                  const SizedBox(height: 12),
                  Semantics(
                    identifier: 'todo_retry_button',
                    child: ElevatedButton(
                      key: const Key('todo_retry_button'),
                      onPressed: () => bloc.add(const PagedListRefreshed()),
                      child: Text(LocaleKeys.common_words_retry.tr()),
                    ),
                  ),
                ],
              ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => bloc.add(const PagedListRefreshed()),
      child: ListView.builder(
        key: const Key('todo_list'),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.items.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.items.length) {
            return TextButton(
              key: const Key('todo_load_more_button'),
              onPressed: state.canLoadMore
                  ? () => bloc.add(const PagedListNextPageRequested())
                  : null,
              child: Text(LocaleKeys.common_sentences_loadMore.tr()),
            );
          }
          return _TodoTile(todo: state.items[index]);
        },
      ),
    );
  }
}

class _TodoTile extends StatelessWidget {
  const _TodoTile({required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TodoListBloc>();
    return ListTile(
      key: Key('todo_item_${todo.id}'),
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (_) => bloc.add(TodoToggled(todo)),
      ),
      title: Text(
        todo.title,
        style: todo.isDone
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      trailing: IconButton(
        key: Key('todo_delete_${todo.id}'),
        icon: const Icon(Icons.delete_outline),
        tooltip: LocaleKeys.common_words_delete.tr(),
        onPressed: () => bloc.add(TodoDeleted(todo.id)),
      ),
    );
  }
}

class _AddTodoDialog extends StatefulWidget {
  const _AddTodoDialog();

  @override
  State<_AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<_AddTodoDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        LocaleKeys.features_example_presentation_screens_todo_list_screen_add
            .tr(),
      ),
      content: Semantics(
        identifier: 'todo_title_field',
        child: TextField(
          key: const Key('todo_title_field'),
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: LocaleKeys
                .features_example_presentation_screens_todo_list_screen_hint
                .tr(),
          ),
          onSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(LocaleKeys.common_words_cancel.tr()),
        ),
        Semantics(
          identifier: 'todo_save_button',
          child: ElevatedButton(
            key: const Key('todo_save_button'),
            onPressed: _submit,
            child: Text(LocaleKeys.common_words_save.tr()),
          ),
        ),
      ],
    );
  }
}
