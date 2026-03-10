import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FileLogOutput extends LogOutput {
  File? _logFile;

  @override
  Future<void> init() async {
    await _initializeFile();
    super.init();
  }

  Future<void> _initializeFile() async {
    final directory = await getApplicationDocumentsDirectory();
    // final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // DateTime.now().toString() returns "2024-01-26 12:00:00.000"
    // We just take the first 10 characters.
    final date = DateTime.now().toIso8601String().split('T').first;
    // We store logs in a specific 'logs' subdirectory
    final logDir = Directory('${directory.path}/app_logs');

    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }

    _logFile = File('${logDir.path}/log_$date.txt');
  }

  @override
  void output(OutputEvent event) async {
    if (_logFile == null) {
      await _initializeFile();
    }

    // Loop through lines (logger might split a message into multiple lines)
    for (var line in event.lines) {
      await _logFile?.writeAsString(
        '${DateTime.now().toIso8601String()}: $line\n',
        mode: FileMode.append,
      );
    }
  }
}
