import 'package:injectable/injectable.dart';

import '../../../../config/constants/type_defs/typedef.dart';
{{#use_local_datasource}}import '../../../../core/error/app_exception.dart';
{{/use_local_datasource}}import '../../../../core/error/guard.dart';
import '../../../../core/generic/domain/entities/page.dart';
import '../../domain/entities/{{feature_name.snakeCase()}}.dart';
{{#use_params}}import '../../domain/params/{{feature_name.snakeCase()}}_params.dart';
{{/use_params}}import '../../domain/repositories/{{feature_name.snakeCase()}}_repository.dart';
{{#use_local_datasource}}import '../data_sources/local/{{feature_name.snakeCase()}}_local_data_source.dart';
{{/use_local_datasource}}import '../data_sources/remote/{{feature_name.snakeCase()}}_remote_data_source.dart';
{{#use_local_datasource}}import '../models/{{feature_name.snakeCase()}}_model.dart';
{{/use_local_datasource}}
{{#use_local_datasource}}/// Remote-first repository with an offline read cache: reads are cached and
/// served from the cache when offline (`NetworkException` /
/// `RequestTimeoutException`); writes go to the API, then update the cache.
/// A failing cache write never fails a successful remote call.
{{/use_local_datasource}}{{^use_local_datasource}}/// Remote repository: data-source exceptions become `Failure`s via `guard`.
{{/use_local_datasource}}@LazySingleton(as: I{{feature_name.pascalCase()}}Repository)
class {{feature_name.pascalCase()}}RepositoryImpl implements I{{feature_name.pascalCase()}}Repository {
  {{feature_name.pascalCase()}}RepositoryImpl(this._remote{{#use_local_datasource}}, this._local{{/use_local_datasource}});

  final I{{feature_name.pascalCase()}}RemoteDataSource _remote;
{{#use_local_datasource}}  final I{{feature_name.pascalCase()}}LocalDataSource _local;
{{/use_local_datasource}}
  @override
  ResultFuture<PageResult<{{feature_name.pascalCase()}}>> get{{feature_name.pascalCase()}}s({
    required PageRequest page,
    {{#use_params}}{{feature_name.pascalCase()}}Query{{/use_params}}{{^use_params}}String{{/use_params}} query = {{#use_params}}const {{feature_name.pascalCase()}}Query(){{/use_params}}{{^use_params}}''{{/use_params}},
  }) => guard(() async {
{{^use_local_datasource}}    final result = await _remote.get{{feature_name.pascalCase()}}s(page: page, query: query);
    return result.map((model) => model.toEntity());
{{/use_local_datasource}}{{#use_local_datasource}}    try {
      final result = await _remote.get{{feature_name.pascalCase()}}s(page: page, query: query);
      await _cache(() => _local.save{{feature_name.pascalCase()}}s(result.items));
      return result.map((model) => model.toEntity());
    } on AppException catch (e) {
      if (!_isOffline(e)) {
        rethrow;
      }
      final cached = await _local.get{{feature_name.pascalCase()}}s();
      if (cached.isEmpty) {
        rethrow;
      }
      return _pageOf(cached, page: page, search: {{#use_params}}query.search{{/use_params}}{{^use_params}}query{{/use_params}});
    }
{{/use_local_datasource}}  });

  @override
  ResultFuture<{{feature_name.pascalCase()}}> get{{feature_name.pascalCase()}}(String id) => guard(() async {
{{^use_local_datasource}}    final model = await _remote.get{{feature_name.pascalCase()}}(id);
    return model.toEntity();
{{/use_local_datasource}}{{#use_local_datasource}}    try {
      final model = await _remote.get{{feature_name.pascalCase()}}(id);
      await _cache(() => _local.save{{feature_name.pascalCase()}}(model));
      return model.toEntity();
    } on AppException catch (e) {
      if (!_isOffline(e)) {
        rethrow;
      }
      try {
        return (await _local.get{{feature_name.pascalCase()}}(id)).toEntity();
      } on CacheMissException {
        throw e; // Report the network problem, not the cache miss.
      }
    }
{{/use_local_datasource}}  });

  @override
  ResultFuture<{{feature_name.pascalCase()}}> create{{feature_name.pascalCase()}}({{#use_params}}Create{{feature_name.pascalCase()}}Params params{{/use_params}}{{^use_params}}{required String title}{{/use_params}}) => guard(() async {
    final model = await _remote.create{{feature_name.pascalCase()}}({{#use_params}}params{{/use_params}}{{^use_params}}title: title{{/use_params}});
{{#use_local_datasource}}    await _cache(() => _local.save{{feature_name.pascalCase()}}(model));
{{/use_local_datasource}}    return model.toEntity();
  });

  @override
  ResultFuture<{{feature_name.pascalCase()}}> update{{feature_name.pascalCase()}}({{#use_params}}Update{{feature_name.pascalCase()}}Params params{{/use_params}}{{^use_params}}{{feature_name.pascalCase()}} item{{/use_params}}) => guard(() async {
    final model = await _remote.update{{feature_name.pascalCase()}}({{#use_params}}params{{/use_params}}{{^use_params}}item{{/use_params}});
{{#use_local_datasource}}    await _cache(() => _local.save{{feature_name.pascalCase()}}(model));
{{/use_local_datasource}}    return model.toEntity();
  });

  @override
  ResultFuture<void> delete{{feature_name.pascalCase()}}(String id) => guard(() async {
    await _remote.delete{{feature_name.pascalCase()}}(id);
{{#use_local_datasource}}    await _cache(() => _local.delete{{feature_name.pascalCase()}}(id));
{{/use_local_datasource}}  });
{{#use_local_datasource}}
  static bool _isOffline(AppException e) =>
      e is NetworkException || e is RequestTimeoutException;

  /// Cache writes are best-effort: the remote call already succeeded.
  static Future<void> _cache(Future<void> Function() write) async {
    try {
      await write();
    } on StorageException {
      // Stale cache is acceptable; the next successful read rewrites it.
    }
  }

  /// Applies the search filter and page-number pagination to cached items.
  static PageResult<{{feature_name.pascalCase()}}> _pageOf(
    List<{{feature_name.pascalCase()}}Model> cached, {
    required PageRequest page,
    required String search,
  }) {
    final term = search.trim().toLowerCase();
    final matching =
        cached
            .where((m) => term.isEmpty || m.title.toLowerCase().contains(term))
            .map((m) => m.toEntity())
            .toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final items = matching.skip(page.offset).take(page.limit).toList();
    return PageResult(
      items: items,
      hasMore: page.offset + items.length < matching.length,
    );
  }
{{/use_local_datasource}}
}
