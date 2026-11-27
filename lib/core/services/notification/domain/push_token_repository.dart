import '../../../error/typedef.dart';

/// Registers this device's push token with the backend.
abstract interface class IPushTokenRepository {
  ResultFuture<void> register({required String token});

  ResultFuture<void> unregister({required String token});
}
