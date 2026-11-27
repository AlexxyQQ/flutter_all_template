import 'package:injectable/injectable.dart';

import '../entities/app_preferences.dart';
import '../repositories/app_preferences_repository.dart';

/// Reads the pre-loaded user preferences (synchronous, never throws).
@lazySingleton
class GetAppPreferencesUseCase {
  const GetAppPreferencesUseCase({
    required IAppPreferencesRepository repository,
  }) : _repository = repository;

  final IAppPreferencesRepository _repository;

  AppPreferences call() => _repository.read();
}
