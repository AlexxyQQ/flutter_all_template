import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../core/common/presentation/views/widgets/system/text/app_text_widget.dart';
import '../widgets/design_components_widgets.dart';

@RoutePage(name: 'SplashScreenRoute')
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          LocaleKeys
              .features_splash_presentation_views_screens_splash_screen_splashScreen,
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [DesignComponentsWidgets()],
        ),
      ),
    );
  }
}
