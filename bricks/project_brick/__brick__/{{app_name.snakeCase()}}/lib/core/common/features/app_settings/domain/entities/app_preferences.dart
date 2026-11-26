import 'package:equatable/equatable.dart';

/// App-owned theme preference (kept free of Flutter's `ThemeMode` so the
/// domain layer stays pure Dart).
enum AppThemePreference { system, light, dark }

/// Non-secret user preferences. Secrets (tokens) live in `TokenStore`.
final class AppPreferences extends Equatable {
  const AppPreferences({
    this.theme = AppThemePreference.system,
    this.localeTag,
    this.hasOnboarded = false,
  });

  final AppThemePreference theme;

  /// BCP-47 language tag including the country code, e.g. `en-GB`, `ne-NP`.
  /// `null` until the user picks a language (the device locale is used).
  final String? localeTag;

  final bool hasOnboarded;

  AppPreferences copyWith({
    AppThemePreference? theme,
    String? localeTag,
    bool? hasOnboarded,
  }) {
    return AppPreferences(
      theme: theme ?? this.theme,
      localeTag: localeTag ?? this.localeTag,
      hasOnboarded: hasOnboarded ?? this.hasOnboarded,
    );
  }

  @override
  List<Object?> get props => [theme, localeTag, hasOnboarded];
}
