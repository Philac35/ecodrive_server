import 'dart:io';
import 'package:flutter/material.dart';

class StackTraceDeleteButton extends StatelessWidget {
  final String filePath;

  const StackTraceDeleteButton({Key? key, required this.filePath}) : super(key: key);

  void deleteFile(BuildContext context) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stack trace file deleted')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File already deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.delete),
      label: Text('Delete Stack Trace File'),
      onPressed: () => deleteFile(context),
    );
  }
}
