import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../domain/entities/todo.dart';
import '../../../bloc/todo_list_bloc.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog();

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
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
