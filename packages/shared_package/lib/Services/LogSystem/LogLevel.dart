import 'package:logging/logging.dart';

enum LogLevel{
  all,
  verbose,
  trace,
  debug,
  info,
  warning,
  error,
  wtf,
  fatal,
  nothing,
  off
}

void main() {
  List<LogLevel> levels = LogLevel.values;
  print(levels); // Output: [LogLevel.all, MyLogLevel.verbose, ...]
}

Level parseLevel(LogLevel logLevel) {

  switch (logLevel) {
    case LogLevel.debug:
      return Level.FINE;
    case LogLevel.info:
      return Level.INFO;
    case LogLevel.warning:
      return Level.WARNING;
    case LogLevel.error:
      return Level.SEVERE;
    case LogLevel.verbose:
      return Level.FINER;
    case LogLevel.fatal:
      return Level.SHOUT;
    case LogLevel.trace:
      return Level.FINEST;
    case LogLevel.all:
      return Level.ALL;
    default:
    // Handle cases that don't have a direct mapping
      return Level.FINE; // Default to debug for unmapped levels
  }}