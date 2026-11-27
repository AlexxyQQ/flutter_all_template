import 'package:equatable/equatable.dart';

/// Non-secret user preferences. Secrets (tokens) live in `ITokenStore`.
final class AppPreferences extends Equatable {
  const AppPreferences({this.localeTag, this.hasOnboarded = false});

  /// BCP-47 language tag including the country code, e.g. `en-GB`, `ne-NP`.
  /// `null` until the user picks a language (the device locale is used).
  final String? localeTag;

  final bool hasOnboarded;

  AppPreferences copyWith({String? localeTag, bool? hasOnboarded}) {
    return AppPreferences(
      localeTag: localeTag ?? this.localeTag,
      hasOnboarded: hasOnboarded ?? this.hasOnboarded,
    );
  }

  @override
  List<Object?> get props => [localeTag, hasOnboarded];
}
