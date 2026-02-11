import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  filter: _AppFilter(),
  printer: PrettyPrinter(
    methodCount: 1,
    colors: false,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.none,
  ),
);

class _AppFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (event.level == Level.trace) {
      return kDebugMode;
    }

    return true;
  }
}
