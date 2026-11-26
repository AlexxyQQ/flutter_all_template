import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/generic/presentation/bloc/paged_list_bloc.dart';
import '../../domain/entities/{{feature_name.snakeCase()}}.dart';
{{#use_params}}import '../../domain/params/{{feature_name.snakeCase()}}_params.dart';
{{/use_params}}import '../../domain/repositories/{{feature_name.snakeCase()}}_repository.dart';

part '{{feature_name.snakeCase()}}_list_event.dart';

typedef {{feature_name.pascalCase()}}ListState = PagedState<{{feature_name.pascalCase()}}, {{#use_params}}{{feature_name.pascalCase()}}Query{{/use_params}}{{^use_params}}String{{/use_params}}>;

/// Paged, searchable list with create/delete.
///
/// Paging, refresh and search come from [PagedListBloc] (`PagedListStarted`,
/// `PagedListRefreshed`, `PagedListNextPageRequested`,
/// `PagedListQueryChanged`). Mutations run one at a time and report errors
/// through [PagedState.failure] without touching the loaded items.
///
/// ```dart
/// BlocProvider(
///   create: (_) => sl<{{feature_name.pascalCase()}}ListBloc>(),
///   child: PaginationListView<{{feature_name.pascalCase()}}>(
///     bloc: context.read<{{feature_name.pascalCase()}}ListBloc>(),
///     itemBuilder: (context, item, _) => ListTile(title: Text(item.title)),
///   ),
/// );
/// ```
@injectable
class {{feature_name.pascalCase()}}ListBloc extends PagedListBloc<{{feature_name.pascalCase()}}, {{#use_params}}{{feature_name.pascalCase()}}Query{{/use_params}}{{^use_params}}String{{/use_params}}> {
  {{feature_name.pascalCase()}}ListBloc(this._repository, {@ignoreParam super.queryDebounce})
    : super(
        initialQuery: {{#use_params}}const {{feature_name.pascalCase()}}Query(){{/use_params}}{{^use_params}}''{{/use_params}},
        fetchPage: (page, query) =>
            _repository.get{{feature_name.pascalCase()}}s(page: page, query: query),
      ) {
    on<{{feature_name.pascalCase()}}Created>(_onCreated, transformer: sequential());
    on<{{feature_name.pascalCase()}}Deleted>(_onDeleted, transformer: sequential());
  }

  final I{{feature_name.pascalCase()}}Repository _repository;

  Future<void> _onCreated(
    {{feature_name.pascalCase()}}Created event,
    Emitter<{{feature_name.pascalCase()}}ListState> emit,
  ) async {
    final result = await _repository.create{{feature_name.pascalCase()}}(
      {{#use_params}}Create{{feature_name.pascalCase()}}Params(title: event.title.trim()){{/use_params}}{{^use_params}}title: event.title.trim(){{/use_params}},
    );
    emit(
      result.fold(
        (failure) => state.copyWith(failure: () => failure),
        (item) => state.copyWith(
          items: [item, ...state.items],
          failure: () => null,
          hasLoaded: true,
        ),
      ),
    );
  }

  Future<void> _onDeleted(
    {{feature_name.pascalCase()}}Deleted event,
    Emitter<{{feature_name.pascalCase()}}ListState> emit,
  ) async {
    final result = await _repository.delete{{feature_name.pascalCase()}}(event.id);
    emit(
      result.fold(
        (failure) => state.copyWith(failure: () => failure),
        (_) => state.copyWith(
          items: state.items.where((item) => item.id != event.id).toList(),
          failure: () => null,
        ),
      ),
    );
  }
}
