import 'package:injectable/injectable.dart';

import '../../../../core/error/typedef.dart';
import '../repositories/app_preferences_repository.dart';

/// Persists the chosen locale as a BCP-47 tag with country code (`en-GB`).
@lazySingleton
class SetLocaleTagUseCase {
  const SetLocaleTagUseCase({required IAppPreferencesRepository repository})
    : _repository = repository;

  final IAppPreferencesRepository _repository;

  ResultFuture<void> call({required String localeTag}) =>
      _repository.setLocaleTag(localeTag: localeTag);
}
