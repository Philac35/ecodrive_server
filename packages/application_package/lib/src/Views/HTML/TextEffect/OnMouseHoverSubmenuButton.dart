import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';


import 'package:ecodrive_server/src/Router/AppRouter.gr.dart'; // Import the generated router
class OnMouseHoverSubmenubutton extends StatefulWidget {
  final String text;
  final PageRouteInfo<dynamic> route; // Accept PageRouteInfo
  final Color defaultColor;
  final Color hoverColor;

  const OnMouseHoverSubmenubutton({
    Key? key,
    required this.text,
    required this.route,
    this.defaultColor = Colors.black,
    this.hoverColor = Colors.blue,
  }) : super(key: key);

  @override
  _OnMouseHoverSubmenubuttonState createState() =>
      _OnMouseHoverSubmenubuttonState();
}

class _OnMouseHoverSubmenubuttonState extends State<OnMouseHoverSubmenubutton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: () {
          context.router.push(widget.route); // Use the route here
        },
        child: Text(
          widget.text,
          style: TextStyle(
            color: isHovered ? widget.hoverColor : widget.defaultColor,
            decoration:
            isHovered ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}


/*
Must be use like this but doesn't work 19/02/2024 because Accueil() is not of type PageRouteInfo<dynamic>
It seams unsolvable. I let menu button without underline
 OnMouseHoverSubmenubutton(
                    text: 'Accueil',
                    route: Accueil()as PageRouteInfo, // Use the generated route class directly
                    defaultColor: Theme.of(context).colorScheme.primary,
                    hoverColor: Theme.of(context).colorScheme.secondary,
                  ),

 */