import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Onmouserhoverunderline extends StatefulWidget {
  final String text;
  final String url;

  const Onmouserhoverunderline({super.key, required this.text, required this.url});

  @override
  _HoverUnderlineTextState createState() => _HoverUnderlineTextState();
}

class _HoverUnderlineTextState extends State<Onmouserhoverunderline> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _isHovering = true),
      onExit: (event) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final Uri url = Uri.parse(widget.url);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            throw 'Could not launch ${widget.url}';
          }
        },
        child: Text(
          widget.text,
          style: TextStyle(
            decoration: _isHovering ? TextDecoration.underline : TextDecoration.none,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

// Usage example:
//OnMouseHoverUnderline({text = 'Visit Qwant', url = 'https://www.qwant.com'}) ;

