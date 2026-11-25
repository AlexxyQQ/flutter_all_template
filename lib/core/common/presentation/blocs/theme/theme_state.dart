part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  const ThemeState({required this.themeMode, this.isInitialized = false});
  final ThemeMode themeMode;
  final bool isInitialized;

  @override
  List<Object> get props => [themeMode, isInitialized];
}
