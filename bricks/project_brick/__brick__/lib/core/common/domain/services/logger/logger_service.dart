import 'dart:async';
import 'dart:developer' as developer; // <-- Added dart:developer
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../entities/failure.dart';
import '../files/file_log_output_service.dart';
import '../network/dio_service.dart';

abstract class ILoggerService {
  void d(String message, {String? name});
  void i(String message, {String? name});
  void e(String message, {dynamic error, StackTrace? stackTrace, String? name});
  Future<void> startPeriodicUpload();
  Future<void> uploadLogs({bool force = false});
}

@LazySingleton(as: ILoggerService)
class AppLogger implements ILoggerService {
  AppLogger() {
    _logger = Logger(
      printer: PrettyPrinter(methodCount: 0),
      output: MultiOutput([ConsoleOutput(), FileLogOutput()]),
    );
  }
  // 1. Static Getter for the instance from GetIt
  static AppLogger get _instance => GetIt.I<ILoggerService>() as AppLogger;

  // 2. Static Methods for direct access
  static void debug(String message, {String? name}) =>
      _instance.d(message, name: name);
  static void info(String message, {String? name}) =>
      _instance.i(message, name: name);
  static void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? name,
  }) => _instance.e(message, error: error, stackTrace: stackTrace, name: name);

  late final Logger _logger;
  Timer? _uploadTimer;

  String _format(String message, String? name) {
    return name != null ? '[$name] $message' : message;
  }

  // --- LOGGING METHODS ---

  @override
  void d(String message, {String? name}) {
    // Uses dart:developer log for Debug logs.
    // This will appear in console/DevTools but skip the file logger.
    developer.log(message, name: name ?? 'DEBUG');
  }

  @override
  void i(String message, {String? name}) {
    // Uses the logger package for Info logs
    _logger.i(_format(message, name));
  }

  @override
  void e(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? name,
  }) {
    // Uses the logger package for Error logs
    _logger.e(_format(message, name), error: error, stackTrace: stackTrace);
  }

  // --- UPLOAD LOGIC ---

  @override
  Future<void> startPeriodicUpload() async {
    _uploadTimer?.cancel();
    _uploadTimer = Timer.periodic(const Duration(minutes: 15), (timer) async {
      await _uploadLogs();
    });
    await _uploadLogs();
  }

  bool _isTodayFile(String path) {
    final now = DateTime.now();
    return path.contains(DateFormat('yyyy-MM-dd').format(now));
  }

  Future<void> _uploadSingleFile(File file) async {
    try {
      final String fileName = file.path.split('/').last;

      final FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
        'device_id': 'unique_device_id_here',
        'platform': Platform.operatingSystem,
      });

      final response = await ApiHandler.post(
        url: 'https://your-server.com/api/logs/upload',
        data: formData,
        onSuccess: (data) async {
          await file.delete();
          debugPrint('✅ Uploaded and deleted log: $fileName');
        },
        onError: (error) {
          debugPrint('❌ Error uploading specific log file ($file): $error');
          return const Failure(message: 'Failed to upload log');
        },
      );
    } catch (e) {
      debugPrint('❌ Error uploading specific log file ($file): $e');
    }
  }

  @override
  Future<void> uploadLogs({bool force = false}) async {
    debugPrint('➡️ Starting log upload sequence (Force: $force)...');
    await _uploadLogs(forceUpload: force);
  }

  Future<void> _uploadLogs({bool forceUpload = false}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logDir = Directory('${directory.path}/app_logs');

      if (!await logDir.exists()) {
        return;
      }

      final files = logDir.listSync().whereType<File>().toList();
      if (files.isEmpty) {
        return;
      }

      for (var file in files) {
        final isToday = _isTodayFile(file.path);
        if (isToday && !forceUpload) {
          continue;
        }

        await _uploadSingleFile(file);
      }
    } catch (e) {
      debugPrint('❌ Failed to process logs for upload: $e');
    }
  }
}
