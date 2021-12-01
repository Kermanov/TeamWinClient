import 'package:logger/logger.dart';

Logger getLogger(Type classType) {
  return Logger(printer: _ApplicationLogPrinter(classType));
}

class _ApplicationLogPrinter extends LogPrinter {
  final String className;
  _ApplicationLogPrinter(Type classType)
      : assert(classType != null),
        className = classType.toString();

  @override
  List<String> log(LogEvent event) {
    return [
      "[${DateTime.now()}] [${event.level}] $className. ${event.message}"
    ];
  }
}
