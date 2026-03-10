import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/observers/route_observer.dart';
import '../config/themes/material_app_theme.dart';
import 'common/domain/services/logger/logger_service.dart';
import 'common/locator/service_locator.dart';
import 'common/presentation/blocs/global_bloc_providers.dart';
import 'common/presentation/blocs/locale/locale_cubit.dart';
import 'common/presentation/blocs/theme/theme_cubit.dart';
import 'common/presentation/routes/app_router.dart';

class App extends StatelessWidget {
  App({super.key});

  final AppRouter _appRouter = sl<AppRouter>();

  @override
  Widget build(BuildContext context) {
    sl<ILoggerService>().startPeriodicUpload();
    return GlobalBlocProvider(
      child: ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          // 1. Listen for Locale changes to update EasyLocalization
          return BlocListener<LocaleCubit, LocaleState>(
            listener: (context, state) {
              context.setLocale(state.currentLocale);
            },
            // 2. Consume Locale State
            child: BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, localeState) {
                // 3. Consume Theme State
                return BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, themeState) {
                    // --- THE GATEKEEPER ---
                    // If either is not initialized, show a splash/empty widget
                    if (!localeState.isInitialized ||
                        !themeState.isInitialized) {
                      return const Material(child: Center(child: SizedBox()));
                    }

                    // Only load MaterialApp when settings are applied
                    return MaterialApp.router(
                      key: ValueKey(
                        context.locale,
                      ), // Ensures rebuild on locale change
                      debugShowCheckedModeBanner: false,
                      localizationsDelegates: context.localizationDelegates,
                      supportedLocales: context.supportedLocales,
                      locale: context.locale,
                      themeMode: themeState.themeMode,
                      darkTheme: MaterialAppTheme.getTheme(
                        theme: ThemeMode.dark,
                        context: context,
                      ),
                      theme: MaterialAppTheme.getTheme(
                        theme: ThemeMode.light,
                        context: context,
                      ),
                      routerConfig: _appRouter.config(
                        navigatorObservers: () => [sl<AppRouteObserver>()],
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
