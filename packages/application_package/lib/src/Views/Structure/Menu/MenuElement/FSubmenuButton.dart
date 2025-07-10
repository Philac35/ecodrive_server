import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class FSubmenuButton extends StatefulWidget{

  String textMenu;
  PageRouteInfo page;
  FSubmenuButton(this.page,this.textMenu, {super.key});

  @override
  State<StatefulWidget> createState() {
    return  _FSubmenuButtonState();
  }
}

class _FSubmenuButtonState extends State<FSubmenuButton>{
  @override
  Widget build(BuildContext context) {
   return   SubmenuButton(
     menuChildren: [
       /* Submenu items */
     ],
     child: InkWell(
       onTap: () {
         try{
         AutoRouter.of(context).push(widget.page);}catch(e, stackTrace) {
           debugPrint('Error navigating to ${widget.page.routeName}: $e');
           debugPrint('Stack trace: $stackTrace');}
       },
       child: Text(
         widget.textMenu,
         style: TextStyle(
             color: Theme
                 .of(context)
                 .colorScheme
                 .primary),
       ),
     ),
   );
  }
}