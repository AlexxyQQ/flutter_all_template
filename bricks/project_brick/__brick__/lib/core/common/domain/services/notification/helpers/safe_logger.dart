import 'package:flutter/foundation.dart';
// Adjust this import to point to your actual LoggerService interface
import '../../logger/logger_service.dart';

class SafeLogger implements ILoggerService {
  @override
  void d(String message, {String? name}) {
    debugPrint('[NotificationService] DEBUG: $message');
  }

  @override
  void e(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? name,
  }) {
    debugPrint('[NotificationService] ERROR: $message $error');
  }

  @override
  void i(String message, {String? name}) {
    debugPrint('[NotificationService] INFO: $message');
  }

  @override
  Future<void> startPeriodicUpload() async {}

  @override
  Future<void> uploadLogs({bool force = false}) async {}
}
