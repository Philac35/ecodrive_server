import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Footer extends StatefulWidget{



  @override
  State<StatefulWidget> createState() {
   return FooterState();
  }

}

class FooterState extends State<Footer>{


  @override
  Widget build(BuildContext context) {
   return     Positioned(
     bottom: 0,
     left: 0,
     right: 0,
     child: Container(
       height: 150,
       color: Theme.of(context).colorScheme.secondary,
       child: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Center(
               child: InkWell(
                 onTap: () {
                   AutoRouter.of(context).pushNamed('/mentionslegales');
                 },
                 child: Text(
                   "",
                   style: TextStyle(
                       color: Theme.of(context).colorScheme.primary),
                 ),
               ),
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 // Other footer content on the left
                 Text('', style: TextStyle(color: Colors.white)),

                 // Copyright text on the right
                 Text(
                   'Copyright 2025@Ecodrive',
                   style: TextStyle(color: Colors.white),
                 ),
               ],
             ),
           ],
         ),
       ),
     ),
   );
  }



}