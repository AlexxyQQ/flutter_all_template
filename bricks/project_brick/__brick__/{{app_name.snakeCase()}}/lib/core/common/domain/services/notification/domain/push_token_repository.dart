import '../../../../../../config/constants/type_defs/typedef.dart';

/// Registers this device's push token with the backend.
abstract interface class PushTokenRepository {
  ResultFuture<void> register({required String token});

  ResultFuture<void> unregister({required String token});
}
