import 'package:flutter/material.dart';
import 'Actions/IHM element/StackTraceWidget.dart';
import 'Entity/StackFrame.dart';
import 'Actions/Class/ParseStackTrace.dart';

//Display a stackTrace as List of clickable links
class StackTrackLinkedWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const StackTrackLinkedWidget({super.key, required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    final stackTraceString = errorDetails.stack?.toString() ?? '';
    List<StackFrame> frames = ParseStackTrace(stackTraceString).parse();

    return Scaffold(
      appBar: AppBar(
        title: Text('Error Screen', style: TextStyle(color: Colors.red)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.red.shade900,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                'ERROR:',
                style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8.0),
                child: SelectableText(
                  '${errorDetails.exception}',
                  style: TextStyle(color: Colors.yellow, fontSize: 16),
                ),
              ),
              SizedBox(height: 16),
              SelectableText(
                'STACK TRACE:',
                style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(height: 8),
              Expanded(child: StackTraceWidget(frames: frames)),
            ],
          ),
        ),
      ),
    );
  }
}
