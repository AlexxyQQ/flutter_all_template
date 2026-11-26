import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../core/generic/presentation/bloc/bloc_exports.dart';
import '../../../bloc/todo_list_bloc.dart';
import 'todo_tile_widget.dart';

class TodoBody extends StatelessWidget {
  const TodoBody({required this.state, super.key});

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
          return TodoTile(todo: state.items[index]);
        },
      ),
    );
  }
}
