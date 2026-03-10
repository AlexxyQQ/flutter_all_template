import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../abstract/presentation/abstract_material_app_text_style.dart';
import '../../../../abstract/presentation/abstract_material_color_semantic.dart';
import '../../blocs/theme/theme_cubit.dart';

extension ThemeContext on BuildContext {
  // ---------------------------------------------------------------------------
  // EXISTING (Keep these for use inside build() methods)
  // ---------------------------------------------------------------------------
  // This uses context.watch() or context.select() implicitly
  MaterialSemanticColors get colors => watch<ThemeCubit>().state.colors;
  IAppMaterialTextStyles get textStyles => watch<ThemeCubit>().state.textStyles;

  // ---------------------------------------------------------------------------
  // NEW (Add these for use in Snackbars, Dialogs, and Functions)
  // ---------------------------------------------------------------------------
  /// Reads the current colors ONE TIME without listening for changes.
  MaterialSemanticColors get readColors => read<ThemeCubit>().state.colors;

  /// Reads the current text styles ONE TIME without listening for changes.
  IAppMaterialTextStyles get readTextStyles =>
      read<ThemeCubit>().state.textStyles;
}
