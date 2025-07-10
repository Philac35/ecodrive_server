import 'dart:io';


import '../../Entity/StackFrame.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
// Example StackFrame class

class StackTraceWidget extends StatelessWidget {
  final List<StackFrame> frames;
  const StackTraceWidget({super.key, required this.frames});

  Future<void> openInVSCode(String filePath, int line, int column) async {
    await Process.run('code', ['--goto', '$filePath:$line:$column']);
  }

  bool isProjectFrame(StackFrame frame) => frame.url.startsWith('file://');

  @override
  Widget build(BuildContext context) {
    if (frames.isEmpty) {
      return Text('No stack trace available.', style: TextStyle(color: Colors.white));
    }
    return ListView.builder(
      itemCount: frames.length,
      itemBuilder: (context, index) {
        final frame = frames[index];
        final isProject = isProjectFrame(frame);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clickable URL
              Expanded(
                child: SelectableText.rich(
                  TextSpan(
                    text: frame.url,
                    style: TextStyle(
                      color: isProject ? Colors.blue.shade100 : Colors.white54,
                      decoration: TextDecoration.underline,
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final uri = Uri.tryParse(frame.url);
                        if (uri != null && await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                  ),
                ),
              ),
              // Button for project frames
              if (isProject)
                IconButton(
                  icon: Icon(Icons.open_in_new, color: Colors.yellowAccent),
                  tooltip: 'Open in VS Code',
                  onPressed: () {
                    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
                      openInVSCode(frame.file, frame.line, frame.column);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening in editor is only supported on desktop.')),
                      );
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
