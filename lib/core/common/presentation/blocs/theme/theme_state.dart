part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  const ThemeState({
    required this.themeMode,
    required this.colors,
    required this.textStyles,
    this.isInitialized = false,
  });
  final ThemeMode themeMode;
  final MaterialSemanticColors colors;
  final IAppMaterialTextStyles textStyles;
  final bool isInitialized;

  @override
  List<Object> get props => [themeMode, colors, textStyles];
}
