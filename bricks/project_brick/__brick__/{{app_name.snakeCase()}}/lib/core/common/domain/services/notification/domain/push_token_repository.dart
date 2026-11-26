import '../../../../../../config/constants/type_defs/typedef.dart';

/// Registers this device's push token with the backend.
abstract interface class PushTokenRepository {
  ResultFuture<void> register(String token);

  ResultFuture<void> unregister(String token);
}
