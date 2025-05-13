import 'package:stack_trace/stack_trace.dart';
import '../../Entity/StackFrame.dart';
class ParseStackTrace {
  final String stackTraceString;

  ParseStackTrace(this.stackTraceString);

  List<StackFrame> parse() {
    final parsed = Trace.parse(stackTraceString);
    return parsed.frames.map((frame) {
      final uri = frame.uri;
      final isFile = uri.scheme == 'file';
      final url = isFile ? uri.toString() : uri.toString();
      return StackFrame(
        file: uri.pathSegments.isNotEmpty ? uri.pathSegments.last : uri.toString(),
        line: frame.line ?? 0,
        column: frame.column ?? 0,
        url: url,
      );
    }).toList();
  }
}