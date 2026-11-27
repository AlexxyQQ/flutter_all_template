import '../../../../core/error/typedef.dart';
import '../entities/app_permission.dart';

/// Persists which permissions the user chose to skip ("maybe later").
///
/// Skipping is **not** granting: callers must still check the real status
/// before using the guarded feature.
abstract interface class IPermissionSkipRepository {
  /// Synchronous read (backed by pre-loaded preferences).
  bool isSkipped({required AppPermission permission});

  ResultFuture<void> markSkipped({required AppPermission permission});
}
