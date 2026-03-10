part of 'permission_bloc.dart';

abstract class IPermissionEvent {}

class PermissionEventCheckNotificationPermission extends IPermissionEvent {}

class PermissionEventCheckLocationPermission extends IPermissionEvent {}

class PermissionEventCheckCameraPermission extends IPermissionEvent {}

class PermissionEventCheckMicrophonePermission extends IPermissionEvent {}

class PermissionEventCheckStoragePermission extends IPermissionEvent {}

class PermissionEventRequestNotificationPermission extends IPermissionEvent {}

class PermissionEventRequestLocationPermission extends IPermissionEvent {}

class PermissionEventRequestCameraPermission extends IPermissionEvent {}

class PermissionEventRequestMicrophonePermission extends IPermissionEvent {}

class PermissionEventRequestStoragePermission extends IPermissionEvent {}

class PermissionEventSkipNotificationPermission extends IPermissionEvent {}

class PermissionEventSkipLocationPermission extends IPermissionEvent {}

class PermissionEventSkipCameraPermission extends IPermissionEvent {}

class PermissionEventSkipMicrophonePermission extends IPermissionEvent {}

class PermissionEventSkipStoragePermission extends IPermissionEvent {}

// ── Contacts ──
class PermissionEventCheckContactsPermission extends IPermissionEvent {}
class PermissionEventRequestContactsPermission extends IPermissionEvent {}
class PermissionEventSkipContactsPermission extends IPermissionEvent {}

// ── Calendar ──
class PermissionEventCheckCalendarPermission extends IPermissionEvent {}
class PermissionEventRequestCalendarPermission extends IPermissionEvent {}
class PermissionEventSkipCalendarPermission extends IPermissionEvent {}

// ── Bluetooth ──
class PermissionEventCheckBluetoothPermission extends IPermissionEvent {}
class PermissionEventRequestBluetoothPermission extends IPermissionEvent {}
class PermissionEventSkipBluetoothPermission extends IPermissionEvent {}

// ── Phone ──
class PermissionEventCheckPhonePermission extends IPermissionEvent {}
class PermissionEventRequestPhonePermission extends IPermissionEvent {}
class PermissionEventSkipPhonePermission extends IPermissionEvent {}

// ── Activity Recognition ──
class PermissionEventCheckActivityRecognitionPermission extends IPermissionEvent {}
class PermissionEventRequestActivityRecognitionPermission extends IPermissionEvent {}
class PermissionEventSkipActivityRecognitionPermission extends IPermissionEvent {}

class PermissionEventCheckAllPermissions extends IPermissionEvent {}

class SetFcmToken extends IPermissionEvent {}
