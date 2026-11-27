# App Settings (preferences)

Non-secret user preferences: locale and onboarding flag.
**Secrets (auth tokens) are not stored here** — see `lib/core/session/` (`ITokenStore`).

```
app_settings/
├── domain/
│   ├── entities/app_preferences.dart            # AppPreferences (pure Dart)
│   ├── repositories/app_preferences_repository.dart
│   └── usecases/                                # GetAppPreferencesUseCase, SetLocaleTagUseCase
└── data/
    └── repositories/app_preferences_repository_impl.dart   # backed by IPreferencesStore
```

- Reads are synchronous (`IPreferencesStore` is pre-loaded at startup) and never throw.
- Writes return `ResultFuture<void>` via `guard()`.
- The locale is stored as a full BCP-47 tag including the country code (`en-GB`, `ne-NP`).
- `LocaleCubit` (`presentation/bloc/`) is the only consumer
  in the template and goes through the use cases, not the repository. Logout is `ISessionManager.signOut()`; it does not reset preferences.
