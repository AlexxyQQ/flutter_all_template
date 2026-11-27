import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/app_settings/presentation/bloc/locale_cubit.dart';
import 'providers/global_bloc_providers.dart';
import 'theme/app_theme.dart';

/// Root widget. Dependencies are passed in by the composition root
/// (`main.dart`); `build` has no side effects.
class App extends StatefulWidget {
  const App({
    required this.router,
    required this.navigatorObservers,
    super.key,
  });

  final RootStackRouter router;

  /// Called once per router (root and every nested one). Must return
  /// **new** observer instances: a `NavigatorObserver` can only observe one
  /// navigator.
  final NavigatorObserversBuilder navigatorObservers;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // Created once: re-creating the router config on rebuild would reset
  // navigation state.
  late final RouterConfig<UrlState> _routerConfig = widget.router.config(
    navigatorObservers: widget.navigatorObservers,
  );

  @override
  Widget build(BuildContext context) {
    return GlobalBlocProvider(
      // LocaleCubit is the single source of truth; mirror it into
      // EasyLocalization (which runs with saveLocale: false).
      child: BlocListener<LocaleCubit, LocaleState>(
        listenWhen: (previous, current) =>
            previous.currentLocale != current.currentLocale,
        listener: (context, state) => context.setLocale(state.currentLocale),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: AppTheme.light,
          routerConfig: _routerConfig,
        ),
      ),
    );
  }
}
