import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../locator/service_locator.dart';
import 'locale/locale_cubit.dart';
import 'theme/theme_cubit.dart';

/// App-wide blocs. This is a widget-tree root, so resolving from `sl` here is
/// allowed; everything below receives dependencies via the tree.
class GlobalBlocProvider extends StatelessWidget {
  const GlobalBlocProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<ThemeCubit>(
        create: (_) {
          final cubit = sl<ThemeCubit>();
          unawaited(cubit.load());
          return cubit;
        },
      ),
      BlocProvider<LocaleCubit>(
        create: (_) {
          final cubit = sl<LocaleCubit>();
          unawaited(cubit.load());
          return cubit;
        },
      ),
    ],
    child: child,
  );
}
