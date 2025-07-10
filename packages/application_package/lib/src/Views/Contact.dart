import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import 'package:ecodrive_server/src/Router/AppRouter.gr.dart';
import 'Forms/Controler/ContactFormController.dart';
import 'Forms/View/ContactForm.dart';
import 'Structure/Footer/Footer.dart';
import 'Structure/Header/Header.dart';
import 'Structure/Menu/FMenu.dart';

@RoutePage()
class Contact extends StatelessWidget {
  const Contact({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //Initialize the ContactFormController as a singleton:

    debugPrint('ContactFormController registered');


    return Scaffold(
      body: Stack(
        children: [
      Header(),

// MenuBar
      FMenu(),

// Content below the MenuBar

      Positioned(
        top: MediaQuery
            .of(context)
            .size
            .height * 0.18 + 50,
// Adjust based on MenuBar height
        left: 0,
        right: 0,
        bottom: 200,
        child: Container(
          color: Colors.white, // Example background for content below
// Scrollable content


          child:LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ContactForm(),
                      // Other widgets
                    ],
                  ),
                ),
              );
            },
          ),
      ),
    ),


// Sticky footer
    Footer(),
    ],
    ),
    );
  }
}
