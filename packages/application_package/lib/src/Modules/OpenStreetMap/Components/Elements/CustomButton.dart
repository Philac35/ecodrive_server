import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';


class CustomButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const CustomButton({super.key, required this.onPressed, required this.child,  ButtonStyle? style});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: GestureDetector(
        onTap: widget.onPressed,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          cursor: widget.onPressed != null ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isHovering ? Colors.blue[300] : Colors.white,
              maximumSize: const Size(48, 48),
              minimumSize: const Size(24, 32),
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
        ),
      ),
    );
  }
}