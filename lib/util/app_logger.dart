// Package imports:
import 'package:logger/logger.dart';

/// [This widget prints the logs]

class AppLogger {
  final bool _showLog = true;
  final logger = Logger(
    printer: PrettyPrinter(
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  void logVerbose(dynamic msg) {
    if (_showLog) logger.t(msg);
  }

  void logDebug(dynamic msg) {
    if (_showLog) logger.d(msg);
  }

  void logInfo(dynamic msg) {
    if (_showLog) logger.i(msg);
  }

  void logWarning(dynamic msg) {
    if (_showLog) logger.w(msg);
  }

  void logError(dynamic msg) {
    if (_showLog) logger.e(msg);
  }

  void logErrorTrace(dynamic msg, {dynamic error, StackTrace? stackTrace}) {
    if (_showLog) logger.e(msg, error: error, stackTrace: stackTrace);
  }

  void logWTF(dynamic msg) {
    if (_showLog) logger.f(msg);
  }
}
