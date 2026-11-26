import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/observers/route_observer.dart';
import '../config/themes/material_app_theme.dart';
import 'common/presentation/blocs/global_bloc_providers.dart';
import 'common/presentation/blocs/locale/locale_cubit.dart';
import 'common/presentation/blocs/theme/theme_cubit.dart';
import 'common/presentation/routes/app_router.dart';

/// Root widget. Dependencies are passed in by the composition root
/// (`main.dart`); `build` has no side effects.
class App extends StatefulWidget {
  const App({required this.router, required this.routeObserver, super.key});

  final AppRouter router;
  final AppRouteObserver routeObserver;

  /// Design size used by `flutter_screenutil` for scaling.
  static const Size designSize = Size(428, 926);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // Created once: re-creating the router config on rebuild would reset
  // navigation state.
  late final RouterConfig<UrlState> _routerConfig = widget.router.config(
    navigatorObservers: () => [widget.routeObserver],
  );

  @override
  Widget build(BuildContext context) {
    return GlobalBlocProvider(
      child: ScreenUtilInit(
        designSize: App.designSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          // LocaleCubit is the single source of truth; mirror it into
          // EasyLocalization (which runs with saveLocale: false).
          return BlocListener<LocaleCubit, LocaleState>(
            listenWhen: (previous, current) =>
                previous.currentLocale != current.currentLocale,
            listener: (context, state) =>
                context.setLocale(state.currentLocale),
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                if (!themeState.isInitialized) {
                  return const ColoredBox(color: Colors.transparent);
                }
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  themeMode: themeState.themeMode,
                  theme: MaterialAppTheme.getTheme(
                    theme: ThemeMode.light,
                    context: context,
                  ),
                  darkTheme: MaterialAppTheme.getTheme(
                    theme: ThemeMode.dark,
                    context: context,
                  ),
                  routerConfig: _routerConfig,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
