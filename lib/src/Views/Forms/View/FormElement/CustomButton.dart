import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';


class CustomButton extends StatefulWidget {
   //Icon? icon ;
  final String? text;
  final String nameId;
  final VoidCallback? onPressed;
  final Widget child;


  CustomButton({required this.nameId, this.text,
    //this.icon,
    required this.onPressed, required this.child,  ButtonStyle? style, Key? key}) : super(key: key);

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
          child: SizedBox(
            width:150,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isHovering ? Colors.blue[300] : Colors.white,
                //maximumSize: const Size(48, 150),
                //minimumSize: const Size(24, 50),
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
              child:Column(
                  children:[
                  //            widget!.icon!,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget!.text!),
                    )]) ,
            ),
          ),
        ),
      ),
    );
  }
}