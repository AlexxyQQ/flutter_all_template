part of 'theme_cubit.dart';

final class ThemeState extends Equatable {
  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.isInitialized = false,
  });

  final ThemeMode themeMode;
  final bool isInitialized;

  @override
  List<Object> get props => [themeMode, isInitialized];
}
