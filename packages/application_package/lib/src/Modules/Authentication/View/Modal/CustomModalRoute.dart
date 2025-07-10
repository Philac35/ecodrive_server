import 'package:flutter/material.dart';



class CustomModalRoute<T extends Widget> extends PageRoute<T> {
  final T child;

  CustomModalRoute({required this.child,
    required super.settings});

  @override
  Color? get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Modal';

  @override
  Widget buildPage(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
