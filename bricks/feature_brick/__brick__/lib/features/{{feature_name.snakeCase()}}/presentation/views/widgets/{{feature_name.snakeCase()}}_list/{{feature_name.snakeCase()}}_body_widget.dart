import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../core/generic/presentation/bloc/bloc_exports.dart';
import '../../../bloc/{{feature_name.snakeCase()}}_list_bloc.dart';
import '{{feature_name.snakeCase()}}_tile_widget.dart';

class {{feature_name.pascalCase()}}Body extends StatelessWidget {
  const {{feature_name.pascalCase()}}Body({required this.state, super.key});

  final {{feature_name.pascalCase()}}ListState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<{{feature_name.pascalCase()}}ListBloc>();
    final failure = state.failure;

    if (state.items.isEmpty) {
      if (state.isInitial || state.isBusy) {
        return const Center(
          child: CircularProgressIndicator(key: Key('{{feature_name.snakeCase()}}_loader')),
        );
      }
      return Center(
        child: failure == null
            ? Text(
                LocaleKeys.common_errors_noDataFound.tr(),
                key: const Key('{{feature_name.snakeCase()}}_empty'),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(failure.message.tr(), key: const Key('{{feature_name.snakeCase()}}_error')),
                  const SizedBox(height: 12),
                  Semantics(
                    identifier: '{{feature_name.snakeCase()}}_retry_button',
                    child: ElevatedButton(
                      key: const Key('{{feature_name.snakeCase()}}_retry_button'),
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
        key: const Key('{{feature_name.snakeCase()}}_list'),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.items.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.items.length) {
            return TextButton(
              key: const Key('{{feature_name.snakeCase()}}_load_more_button'),
              onPressed: state.canLoadMore
                  ? () => bloc.add(const PagedListNextPageRequested())
                  : null,
              child: Text(LocaleKeys.common_sentences_loadMore.tr()),
            );
          }
          return {{feature_name.pascalCase()}}Tile({{feature_name.camelCase()}}: state.items[index]);
        },
      ),
    );
  }
}
