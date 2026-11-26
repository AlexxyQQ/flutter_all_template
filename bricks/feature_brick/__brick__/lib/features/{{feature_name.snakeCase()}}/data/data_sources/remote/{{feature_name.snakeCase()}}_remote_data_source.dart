import 'package:injectable/injectable.dart';

import '../../../../../config/constants/api/api_paths.dart';
import '../../../../../core/generic/domain/entities/page.dart';
import '../../../../../core/network/api_client.dart';
{{^use_params}}import '../../../domain/entities/{{feature_name.snakeCase()}}.dart';
{{/use_params}}{{#use_params}}import '../../../domain/params/{{feature_name.snakeCase()}}_params.dart';
{{/use_params}}import '../../models/{{feature_name.snakeCase()}}_model.dart';

/// HTTP access to `ApiPaths.{{feature_name.camelCase()}}s`. Throws `AppException`s (via [ApiClient]).
abstract interface class I{{feature_name.pascalCase()}}RemoteDataSource {
  Future<PageResult<{{feature_name.pascalCase()}}Model>> get{{feature_name.pascalCase()}}s({
    required PageRequest page,
    required {{#use_params}}{{feature_name.pascalCase()}}Query{{/use_params}}{{^use_params}}String{{/use_params}} query,
  });

  Future<{{feature_name.pascalCase()}}Model> get{{feature_name.pascalCase()}}(String id);

  Future<{{feature_name.pascalCase()}}Model> create{{feature_name.pascalCase()}}({{#use_params}}Create{{feature_name.pascalCase()}}Params params{{/use_params}}{{^use_params}}{required String title}{{/use_params}});

  Future<{{feature_name.pascalCase()}}Model> update{{feature_name.pascalCase()}}({{#use_params}}Update{{feature_name.pascalCase()}}Params params{{/use_params}}{{^use_params}}{{feature_name.pascalCase()}} item{{/use_params}});

  Future<void> delete{{feature_name.pascalCase()}}(String id);
}

/// API contract (adapt to your backend):
///
/// | Call | Request | Response |
/// |---|---|---|
/// | list | `GET /path?page=&limit=&cursor=&search=` | `{"items": [..], "has_more": bool?, "next_cursor": String?}` |
/// | read | `GET /path/{id}` | item |
/// | create | `POST /path` | item (201) |
/// | update | `PATCH /path/{id}` | item |
/// | delete | `DELETE /path/{id}` | empty (204) |
@LazySingleton(as: I{{feature_name.pascalCase()}}RemoteDataSource)
class {{feature_name.pascalCase()}}RemoteDataSource implements I{{feature_name.pascalCase()}}RemoteDataSource {
  {{feature_name.pascalCase()}}RemoteDataSource(this._client);

  final ApiClient _client;

  static String _item(String id) =>
      '${ApiPaths.{{feature_name.camelCase()}}s}/${Uri.encodeComponent(id)}';

  @override
  Future<PageResult<{{feature_name.pascalCase()}}Model>> get{{feature_name.pascalCase()}}s({
    required PageRequest page,
    required {{#use_params}}{{feature_name.pascalCase()}}Query{{/use_params}}{{^use_params}}String{{/use_params}} query,
  }) {
    return _client.get(
      ApiPaths.{{feature_name.camelCase()}}s,
      query: {
        'page': page.page,
        'limit': page.limit,
        if (page.cursor != null) 'cursor': page.cursor,
        if ({{#use_params}}query.search{{/use_params}}{{^use_params}}query{{/use_params}}.isNotEmpty) 'search': {{#use_params}}query.search{{/use_params}}{{^use_params}}query{{/use_params}},
      },
      decode: (json) {
        final body = Decoders.object(json);
        final items = Decoders.listOf({{feature_name.pascalCase()}}Model.fromJson)(body['items']);
        final nextCursor = body['next_cursor'] as String?;
        final hasMore = body['has_more'] as bool?;
        return hasMore == null && nextCursor == null
            ? PageResult.fromItems(items, request: page)
            : PageResult(
                items: items,
                hasMore: hasMore ?? true,
                nextCursor: nextCursor,
              );
      },
    );
  }

  @override
  Future<{{feature_name.pascalCase()}}Model> get{{feature_name.pascalCase()}}(String id) =>
      _client.get(_item(id), decode: _decode);

  @override
  Future<{{feature_name.pascalCase()}}Model> create{{feature_name.pascalCase()}}({{#use_params}}Create{{feature_name.pascalCase()}}Params params{{/use_params}}{{^use_params}}{required String title}{{/use_params}}) => _client.post(
    ApiPaths.{{feature_name.camelCase()}}s,
    body: {'title': {{#use_params}}params.{{/use_params}}title},
    decode: _decode,
  );

  @override
  Future<{{feature_name.pascalCase()}}Model> update{{feature_name.pascalCase()}}({{#use_params}}Update{{feature_name.pascalCase()}}Params params{{/use_params}}{{^use_params}}{{feature_name.pascalCase()}} item{{/use_params}}) => _client.patch(
    _item({{#use_params}}params{{/use_params}}{{^use_params}}item{{/use_params}}.id),
    body: {
      {{#use_params}}if (params.title != null) 'title': params.title,{{/use_params}}{{^use_params}}'title': item.title,{{/use_params}}
    },
    decode: _decode,
  );

  @override
  Future<void> delete{{feature_name.pascalCase()}}(String id) =>
      _client.delete(_item(id), decode: Decoders.ignore);

  static {{feature_name.pascalCase()}}Model _decode(Object? json) =>
      {{feature_name.pascalCase()}}Model.fromJson(Decoders.object(json));
}
