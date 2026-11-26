import 'package:injectable/injectable.dart';

import '../../../../config/constants/type_defs/typedef.dart';
import '../entities/{{feature_name.snakeCase()}}.dart';
import '../repositories/{{feature_name.snakeCase()}}_repository.dart';

/// Loads a single {{feature_name.pascalCase()}} by id.
@lazySingleton
class Get{{feature_name.pascalCase()}}UseCase {
  const Get{{feature_name.pascalCase()}}UseCase({required I{{feature_name.pascalCase()}}Repository repository}) : _repository = repository;

  final I{{feature_name.pascalCase()}}Repository _repository;

  ResultFuture<{{feature_name.pascalCase()}}> call({required String id}) =>
      _repository.get{{feature_name.pascalCase()}}(id: id);
}
