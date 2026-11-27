import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

/// Router access for code that has no `BuildContext` (a notification tap
/// handler). Widgets use `context.router` instead.
@lazySingleton
class NavigationService {
  const NavigationService({required RootStackRouter router}) : _router = router;

  final RootStackRouter _router;

  /// Opens an app path (an `AppPaths` constant), reusing an existing
  /// destination in the stack; it can also set the initial route before the
  /// navigator mounts. Never pass untrusted input (push payloads, deep-link
  /// params) without an allowlist.
  Future<void> navigateToPath({
    required String path,
    OnNavigationFailure? onFailure,
  }) => _router.navigatePath(path, onFailure: onFailure);
}
