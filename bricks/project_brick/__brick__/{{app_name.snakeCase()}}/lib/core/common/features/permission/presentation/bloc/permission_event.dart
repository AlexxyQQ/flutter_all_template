part of 'permission_bloc.dart';

sealed class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  List<Object?> get props => [];
}

/// Reads the current OS status (and the persisted "skipped" flag).
final class PermissionChecked extends PermissionEvent {
  const PermissionChecked(this.permission);

  final AppPermission permission;

  @override
  List<Object?> get props => [permission];
}

/// Shows the OS prompt (or delegates to the notification module).
final class PermissionRequested extends PermissionEvent {
  const PermissionRequested(this.permission);

  final AppPermission permission;

  @override
  List<Object?> get props => [permission];
}

/// User chose "maybe later". Persisted; does NOT mark it granted.
final class PermissionSkipped extends PermissionEvent {
  const PermissionSkipped(this.permission);

  final AppPermission permission;

  @override
  List<Object?> get props => [permission];
}

/// Checks every [AppPermission].
final class AllPermissionsChecked extends PermissionEvent {
  const AllPermissionsChecked();
}

/// Opens the system settings page for the app (permanently denied flow).
final class PermissionSettingsOpened extends PermissionEvent {
  const PermissionSettingsOpened();
}
