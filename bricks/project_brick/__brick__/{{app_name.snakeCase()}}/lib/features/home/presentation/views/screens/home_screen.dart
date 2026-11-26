import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../core/common/presentation/routes/app_router.gr.dart';

/// Minimal landing page. Replace with the app's real home.
@RoutePage(name: 'HomeRoute')
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          identifier: 'home_title',
          child: Text(
            LocaleKeys.features_home_presentation_screens_home_screen_title
                .tr(),
            key: const Key('home_title'),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys
                    .features_home_presentation_screens_home_screen_welcome
                    .tr(),
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                LocaleKeys
                    .features_home_presentation_screens_home_screen_subtitle
                    .tr(),
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              Semantics(
                identifier: 'home_open_todos_button',
                child: ElevatedButton(
                  key: const Key('home_open_todos_button'),
                  onPressed: () =>
                      unawaited(context.router.push(const TodoRoute())),
                  child: Text(
                    LocaleKeys
                        .features_home_presentation_screens_home_screen_openTodos
                        .tr(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
