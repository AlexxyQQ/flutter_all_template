import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/common/presentation/routes/app_router.gr.dart';

/// Debug-only design-components gallery.
///
/// The route is registered (and therefore reachable, including by deep link)
/// only in debug builds.
class GalleryRoutes {
  static const String path = '/gallery';

  static bool get isEnabled => kDebugMode;

  static final route = AutoRoute(page: GalleryRoute.page, path: path);

  /// Routes to add to the router: empty outside debug builds.
  static List<AutoRoute> get routes => isEnabled ? [route] : const [];
}
