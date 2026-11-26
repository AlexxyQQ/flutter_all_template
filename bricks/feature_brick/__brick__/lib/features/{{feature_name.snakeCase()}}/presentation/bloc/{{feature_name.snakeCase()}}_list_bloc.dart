import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/generic/presentation/bloc/paged_list_bloc.dart';
import '../../domain/entities/{{feature_name.snakeCase()}}.dart';
{{#use_params}}import '../../domain/params/{{feature_name.snakeCase()}}_params.dart';
{{/use_params}}import '../../domain/usecases/create_{{feature_name.snakeCase()}}_use_case.dart';
import '../../domain/usecases/delete_{{feature_name.snakeCase()}}_use_case.dart';
import '../../domain/usecases/get_{{feature_name.snakeCase()}}s_use_case.dart';

part '{{feature_name.snakeCase()}}_list_event.dart';

typedef {{feature_name.pascalCase()}}ListState = PagedState<{{feature_name.pascalCase()}}, {{#use_params}}{{feature_name.pascalCase()}}Query{{/use_params}}{{^use_params}}String{{/use_params}}>;

/// Paged, searchable list with create/delete.
///
/// Paging, refresh and search come from [PagedListBloc] (`PagedListStarted`,
/// `PagedListRefreshed`, `PagedListNextPageRequested`,
/// `PagedListQueryChanged`). Mutations run one at a time and report errors
/// through [PagedState.failure] without touching the loaded items.
///
/// Provide it with `BlocProvider(create: (_) => sl<{{feature_name.pascalCase()}}ListBloc>())` and
/// render `state.items` with a `ListView`. See
/// `lib/features/example/presentation/views/screens/todo_list_screen.dart`
/// for a complete Material screen.
@injectable
class {{feature_name.pascalCase()}}ListBloc extends PagedListBloc<{{feature_name.pascalCase()}}, {{#use_params}}{{feature_name.pascalCase()}}Query{{/use_params}}{{^use_params}}String{{/use_params}}> {
  {{feature_name.pascalCase()}}ListBloc({
    required Get{{feature_name.pascalCase()}}sUseCase get{{feature_name.pascalCase()}}s,
    required Create{{feature_name.pascalCase()}}UseCase create{{feature_name.pascalCase()}},
    required Delete{{feature_name.pascalCase()}}UseCase delete{{feature_name.pascalCase()}},
    @ignoreParam super.queryDebounce,
  }) : _create{{feature_name.pascalCase()}} = create{{feature_name.pascalCase()}},
       _delete{{feature_name.pascalCase()}} = delete{{feature_name.pascalCase()}},
       super(
        initialQuery: {{#use_params}}const {{feature_name.pascalCase()}}Query(){{/use_params}}{{^use_params}}''{{/use_params}},
        fetchPage: (page, query) => get{{feature_name.pascalCase()}}s(page: page, query: query),
      ) {
    on<{{feature_name.pascalCase()}}Created>(_onCreated, transformer: sequential());
    on<{{feature_name.pascalCase()}}Deleted>(_onDeleted, transformer: sequential());
  }

  final Create{{feature_name.pascalCase()}}UseCase _create{{feature_name.pascalCase()}};
  final Delete{{feature_name.pascalCase()}}UseCase _delete{{feature_name.pascalCase()}};

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
  }

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
  }
}
