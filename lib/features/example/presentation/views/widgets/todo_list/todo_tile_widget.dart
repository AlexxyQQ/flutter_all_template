import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../domain/entities/todo.dart';
import '../../../bloc/todo_list_bloc.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({required this.todo});

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
