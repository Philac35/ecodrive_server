import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class StackTraceToClipboardButton extends StatelessWidget{
  final FlutterErrorDetails errorDetails;

const StackTraceToClipboardButton(this.errorDetails, {super.key});

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: errorDetails.stack.toString()));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Stack trace copied to clipboard')));
      },
      child: Text('Copy Stack Trace'),
    );

  }

}