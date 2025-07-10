import 'package:flutter/material.dart';

class Header extends StatelessWidget{
  const Header({super.key});




  @override
  Widget build(BuildContext context) {
   return // Background content
     Container(

       color: Colors.white, // Add a background color for the entire page if needed
      child:Stack(
      children:[Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: MediaQuery.of(context).size.height * 0.25,
// Space above the MenuBar
        child: Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'images/front-bleu.png',
              ),
            )),
      ),
// Logo positioned inside the colored space
       Positioned(
         top: MediaQuery.of(context).size.height *
             0.05, // Adjust logo position within the space
         left: 20,
         child: Image.asset(
           'images/logo.png',
           width: 64,
           height: 64,
           fit: BoxFit.cover,
         ),
       ),

      ])

     );


  }






}