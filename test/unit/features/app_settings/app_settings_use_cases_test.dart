import 'package:flutter_all_template/features/app_settings/domain/entities/app_preferences.dart';
import 'package:flutter_all_template/features/app_settings/domain/repositories/app_preferences_repository.dart';
import 'package:flutter_all_template/features/app_settings/domain/usecases/get_app_preferences_use_case.dart';
import 'package:flutter_all_template/features/app_settings/domain/usecases/set_locale_tag_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements IAppPreferencesRepository {}

void main() {
  late _MockRepository repository;

  setUp(() => repository = _MockRepository());

  test('GetAppPreferencesUseCase reads from the repository', () {
    const prefs = AppPreferences(localeTag: 'ne-NP');
    when(() => repository.read()).thenReturn(prefs);

    expect(GetAppPreferencesUseCase(repository: repository)(), prefs);
  });

  test('SetLocaleTagUseCase forwards the tag', () async {
    when(
      () => repository.setLocaleTag(localeTag: 'en-GB'),
    ).thenAnswer((_) async => const Right(null));

    await SetLocaleTagUseCase(repository: repository)(localeTag: 'en-GB');

    verify(() => repository.setLocaleTag(localeTag: 'en-GB')).called(1);
  });
}
