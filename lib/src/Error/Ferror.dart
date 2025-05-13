import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Ferror extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  Ferror({required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text('Error Screen', style:TextStyle(color:Colors.red))),
      body: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SelectableText(
            'ERROR: ${errorDetails.exception} \n \nSTACK TRACE: ${errorDetails.stack}',
            style: TextStyle(color: Colors.yellow),

          ),
        ),
      ),
    );
  }
}