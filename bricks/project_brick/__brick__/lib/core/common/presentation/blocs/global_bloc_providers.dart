import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import '../../../generic/presentation/bloc/crud/crud_exports.dart';
import '../../features/app_settings/presentation/bloc/app_setting_bloc.dart';
import '../../locator/service_locator.dart';
import 'locale/locale_cubit.dart';
import 'theme/theme_cubit.dart';

class GlobalBlocProvider extends StatelessWidget {
  const GlobalBlocProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(_) => MultiBlocProvider(
    providers: <SingleChildWidget>[
      BlocProvider<AppSettingBloc>(
        create: (context) => sl<AppSettingBloc>()..add(const ReadEntityEvent()),
      ),
      BlocProvider<ThemeCubit>(
        create: (context) => sl<ThemeCubit>()..getSavedTheme(),
      ),
      BlocProvider<LocaleCubit>(
        create: (context) =>
            sl<LocaleCubit>()..getSavedLocale(context: context),
      ),
    ],
    child: child,
  );
}
