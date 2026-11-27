{{#has_mutations}}import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
{{/has_mutations}}import 'package:injectable/injectable.dart';

import '../../../../core/generic/presentation/bloc/paged_list_bloc.dart';
import '../../domain/entities/{{feature_name.snakeCase()}}.dart';
{{#use_params}}import '../../domain/params/{{feature_name.snakeCase()}}_params.dart';
{{/use_params}}{{#include_create}}import '../../domain/usecases/create_{{feature_name.snakeCase()}}_use_case.dart';
{{/include_create}}{{#include_delete}}import '../../domain/usecases/delete_{{feature_name.snakeCase()}}_use_case.dart';
{{/include_delete}}import '../../domain/usecases/get_{{feature_plural.snakeCase()}}_use_case.dart';
{{#include_update}}import '../../domain/usecases/update_{{feature_name.snakeCase()}}_use_case.dart';
{{/include_update}}
part '{{feature_name.snakeCase()}}_list_event.dart';

typedef {{feature_name.pascalCase()}}ListState = PagedState<{{feature_name.pascalCase()}}, {{#use_params}}{{feature_name.pascalCase()}}Query{{/use_params}}{{^use_params}}String{{/use_params}}>;

/// Paged{{#include_search}}, searchable{{/include_search}} list{{#has_mutations}} with {{mutations_label}}{{/has_mutations}}.
///
/// Paging, refresh and search come from [PagedListBloc] (`PagedListStarted`,
/// `PagedListRefreshed`, `PagedListNextPageRequested`,
/// `PagedListQueryChanged`).{{#has_mutations}} Mutations run one at a time and report errors
/// through [PagedState.failure] without touching the loaded items.{{/has_mutations}}
///
/// Provided by the `{{feature_name.pascalCase()}}Wrapper` route (see `views/wrappers/`), which loads the
/// first page; `{{feature_name.pascalCase()}}ListScreen` and its widgets render `state.items`.
@injectable
class {{feature_name.pascalCase()}}ListBloc extends PagedListBloc<{{feature_name.pascalCase()}}, {{#use_params}}{{feature_name.pascalCase()}}Query{{/use_params}}{{^use_params}}String{{/use_params}}> {
  {{feature_name.pascalCase()}}ListBloc({
    required Get{{feature_plural.pascalCase()}}UseCase get{{feature_plural.pascalCase()}},
{{#include_create}}    required Create{{feature_name.pascalCase()}}UseCase create{{feature_name.pascalCase()}},
{{/include_create}}{{#include_update}}    required Update{{feature_name.pascalCase()}}UseCase update{{feature_name.pascalCase()}},
{{/include_update}}{{#include_delete}}    required Delete{{feature_name.pascalCase()}}UseCase delete{{feature_name.pascalCase()}},
{{/include_delete}}    @ignoreParam super.queryDebounce,
  }){{#has_mutations}} : {{#include_create}}_create{{feature_name.pascalCase()}} = create{{feature_name.pascalCase()}},
       {{/include_create}}{{#include_update}}_update{{feature_name.pascalCase()}} = update{{feature_name.pascalCase()}},
       {{/include_update}}{{#include_delete}}_delete{{feature_name.pascalCase()}} = delete{{feature_name.pascalCase()}},
       {{/include_delete}}super(
         initialQuery: {{#use_params}}const {{feature_name.pascalCase()}}Query(){{/use_params}}{{^use_params}}''{{/use_params}},
         fetchPage: (page, query) => get{{feature_plural.pascalCase()}}(page: page, query: query),
       ) {
{{#include_create}}    on<{{feature_name.pascalCase()}}Created>(_onCreated, transformer: sequential());
{{/include_create}}{{#include_update}}    on<{{feature_name.pascalCase()}}Updated>(_onUpdated, transformer: sequential());
{{/include_update}}{{#include_delete}}    on<{{feature_name.pascalCase()}}Deleted>(_onDeleted, transformer: sequential());
{{/include_delete}}  }{{/has_mutations}}{{^has_mutations}} : super(
         initialQuery: {{#use_params}}const {{feature_name.pascalCase()}}Query(){{/use_params}}{{^use_params}}''{{/use_params}},
         fetchPage: (page, query) => get{{feature_plural.pascalCase()}}(page: page, query: query),
       );{{/has_mutations}}{{#has_mutations}}
{{/has_mutations}}{{#include_create}}
  final Create{{feature_name.pascalCase()}}UseCase _create{{feature_name.pascalCase()}};{{/include_create}}{{#include_update}}
  final Update{{feature_name.pascalCase()}}UseCase _update{{feature_name.pascalCase()}};{{/include_update}}{{#include_delete}}
  final Delete{{feature_name.pascalCase()}}UseCase _delete{{feature_name.pascalCase()}};{{/include_delete}}{{#include_create}}

  Future<void> _onCreated(
    {{feature_name.pascalCase()}}Created event,
    Emitter<{{feature_name.pascalCase()}}ListState> emit,
  ) async {
    final result = await _create{{feature_name.pascalCase()}}(
      {{#use_params}}params: Create{{feature_name.pascalCase()}}Params(title: event.title){{/use_params}}{{^use_params}}title: event.title{{/use_params}},
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
  }{{/include_create}}{{#include_update}}

  Future<void> _onUpdated(
    {{feature_name.pascalCase()}}Updated event,
    Emitter<{{feature_name.pascalCase()}}ListState> emit,
  ) async {
    final result = await _update{{feature_name.pascalCase()}}(
      {{#use_params}}params: Update{{feature_name.pascalCase()}}Params(id: event.id, title: event.title){{/use_params}}{{^use_params}}item: event.item{{/use_params}},
    );
    emit(
      result.fold(
        (failure) => state.copyWith(failure: () => failure),
        (updated) => state.copyWith(
          items: [
            for (final item in state.items)
              if (item.id == updated.id) updated else item,
          ],
          failure: () => null,
        ),
      ),
    );
  }{{/include_update}}{{#include_delete}}

  Future<void> _onDeleted(
    {{feature_name.pascalCase()}}Deleted event,
    Emitter<{{feature_name.pascalCase()}}ListState> emit,
  ) async {
    final result = await _delete{{feature_name.pascalCase()}}(id: event.id);
    emit(
      result.fold(
        (failure) => state.copyWith(failure: () => failure),
        (_) => state.copyWith(
          items: state.items.where((item) => item.id != event.id).toList(),
          failure: () => null,
        ),
      ),
    );
  }{{/include_delete}}
}
