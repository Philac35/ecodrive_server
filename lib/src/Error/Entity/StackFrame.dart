class StackFrame {
  final String file;
  final int line;
  final int column;
  final String url;

  StackFrame({
    required this.file,
    required this.line,
    required this.column,
    required this.url,
  });
}