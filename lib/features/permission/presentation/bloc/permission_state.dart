part of 'permission_bloc.dart';

final class PermissionState extends Equatable {
  const PermissionState({
    this.statuses = const {},
    this.skipped = const {},
    this.requesting,
    this.error,
  });

  /// Last known OS status per permission. Missing = not checked yet.
  final Map<AppPermission, AppPermissionStatus> statuses;

  /// Permissions the user skipped. Independent from [statuses].
  final Set<AppPermission> skipped;

  /// The permission whose OS prompt is open right now. Setting it and clearing
  /// it again is what lets the UI react to a finished request even when the
  /// resulting status did not change (e.g. permanently denied twice in a row).
  final AppPermission? requesting;

  /// Last failure; show it with `failure.displayText`.
  final Failure? error;

  AppPermissionStatus? statusOf(AppPermission permission) =>
      statuses[permission];

  bool isRequesting(AppPermission permission) => requesting == permission;

  bool isGranted(AppPermission permission) =>
      statuses[permission]?.isGranted ?? false;

  bool isSkipped(AppPermission permission) => skipped.contains(permission);

  /// Granted or explicitly skipped: the flow may continue.
  bool canProceed(AppPermission permission) =>
      isGranted(permission) || isSkipped(permission);

  PermissionState copyWith({
    Map<AppPermission, AppPermissionStatus>? statuses,
    Set<AppPermission>? skipped,
    AppPermission? Function()? requesting,
    Failure? Function()? error,
  }) {
    return PermissionState(
      statuses: statuses ?? this.statuses,
      skipped: skipped ?? this.skipped,
      requesting: requesting != null ? requesting() : this.requesting,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [statuses, skipped, requesting, error];
}
