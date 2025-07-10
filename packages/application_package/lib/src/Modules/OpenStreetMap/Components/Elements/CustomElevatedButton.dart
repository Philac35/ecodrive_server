import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const CustomElevatedButton({super.key, required this.onPressed, required this.child, this.style});

  @override
  _CustomElevatedButtonState createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: widget.onPressed != null ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: ElevatedButton(
        style: widget.style ?? ElevatedButton.styleFrom(
          backgroundColor: _isHovering ? Colors.blue[300] : Colors.white,
          maximumSize: const Size(48, 100),
          minimumSize: const Size(24, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: widget.onPressed != null
            ? () {
          print('Button pressed');
          widget.onPressed!();
        }
            : null,
        child: widget.child,
      ),
    );
  }
}
