part of 'permission_bloc.dart';

final class PermissionState extends Equatable {
  const PermissionState({
    this.statuses = const {},
    this.skipped = const {},
    this.isLoading = false,
    this.error,
    this.lastRequested,
    this.requestCount = 0,
  });

  /// Last known OS status per permission. Missing = not checked yet.
  final Map<AppPermission, AppPermissionStatus> statuses;

  /// Permissions the user skipped. Independent from [statuses].
  final Set<AppPermission> skipped;

  final bool isLoading;

  /// Last failure (`Failure.message` is a localization key).
  final Failure? error;

  /// The permission of the most recently *completed* request, with
  /// [requestCount] incremented each time so listeners can react to a
  /// request finishing even when the status did not change
  /// (e.g. permanently denied twice in a row).
  final AppPermission? lastRequested;
  final int requestCount;

  AppPermissionStatus? statusOf(AppPermission permission) =>
      statuses[permission];

  bool isGranted(AppPermission permission) =>
      statuses[permission]?.isGranted ?? false;

  bool isSkipped(AppPermission permission) => skipped.contains(permission);

  /// Granted or explicitly skipped: the flow may continue.
  bool canProceed(AppPermission permission) =>
      isGranted(permission) || isSkipped(permission);

  PermissionState copyWith({
    Map<AppPermission, AppPermissionStatus>? statuses,
    Set<AppPermission>? skipped,
    bool? isLoading,
    Failure? Function()? error,
    AppPermission? lastRequested,
    int? requestCount,
  }) {
    return PermissionState(
      statuses: statuses ?? this.statuses,
      skipped: skipped ?? this.skipped,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
      lastRequested: lastRequested ?? this.lastRequested,
      requestCount: requestCount ?? this.requestCount,
    );
  }

  @override
  List<Object?> get props => [
    statuses,
    skipped,
    isLoading,
    error,
    lastRequested,
    requestCount,
  ];
}
