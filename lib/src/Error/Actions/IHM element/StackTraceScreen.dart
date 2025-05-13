import 'package:flutter/material.dart';

class StackTraceScreen extends StatelessWidget {
  final String stackTrace;

  const StackTraceScreen({Key? key, required this.stackTrace}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stack Trace')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SelectableText(
          stackTrace,
          style: TextStyle(fontFamily: 'monospace'),
        ),
      ),
    );
  }
}

/*
To use it :
ElevatedButton(
  onPressed: () {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => StackTraceScreen(stackTrace: details.stack.toString()),
    ));
  },
  child: Text('View Full Stack Trace'),
),

 */
