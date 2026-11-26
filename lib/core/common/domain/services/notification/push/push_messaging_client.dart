import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

/// Thin seam over `FirebaseMessaging` (static/singleton plugin API) so the
/// notification service can be unit-tested and the plugin is only touched
/// after `Firebase.initializeApp`.
abstract interface class PushMessagingClient {
  Future<String?> getToken();

  Future<void> deleteToken();

  /// Returns whether the user authorized (or provisionally authorized) push.
  Future<bool> requestPermission();

  Stream<RemoteMessage> get onMessage;

  Stream<String> get onTokenRefresh;

  /// [handler] must be a top-level `@pragma('vm:entry-point')` function.
  void registerBackgroundHandler({required BackgroundMessageHandler handler});
}

@LazySingleton(as: PushMessagingClient)
class FirebasePushMessagingClient implements PushMessagingClient {
  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  @override
  Future<String?> getToken() => _messaging.getToken();

  @override
  Future<void> deleteToken() => _messaging.deleteToken();

  @override
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  void registerBackgroundHandler({required BackgroundMessageHandler handler}) =>
      FirebaseMessaging.onBackgroundMessage(handler);
}
