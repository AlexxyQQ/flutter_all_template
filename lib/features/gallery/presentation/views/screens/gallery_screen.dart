import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../core/common/presentation/helpers/file_picker_helper.dart';
import '../../../../../core/common/presentation/views/widgets/system/default_app_bar.dart';
import '../widgets/design_components_widgets.dart';

/// Debug-only showcase of the design-system widgets.
@RoutePage(name: 'GalleryRoute')
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key, this.fileSelector});

  /// Injected for tests; defaults to the real platform picker.
  final IFileSelectorHelper? fileSelector;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: LocaleKeys
            .features_home_presentation_views_screens_home_screen_galleryTitle,
      ),
      body: DesignComponentsWidgets(
        fileSelector: fileSelector ?? FileSelectorHelperImpl(),
      ),
    );
  }
}
