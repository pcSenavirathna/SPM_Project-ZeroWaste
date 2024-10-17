import 'package:logger/logger.dart';

class AppLogger {
  static final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void printError(String error) {
    logger.e(DateTime.now(), error: error);
  }

  static void printInfo(String msg) {
    logger.i(DateTime.now(), error: msg);
  }
}
