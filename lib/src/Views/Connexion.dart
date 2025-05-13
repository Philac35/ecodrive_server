import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../Modules/Authentication/View/Form/Connexion/ConnexionForm.dart';
import 'package:ecodrive_server/src/Router/AppRouter.gr.dart';
import '../Modules/Authentication/View/Modal/CustomModalRoute.dart';

import 'Structure/Footer/Footer.dart';
import 'Structure/Header/Header.dart';
import 'Structure/Menu/FMenu.dart';

@RoutePage()
class Connexion extends StatelessWidget {
   ConnexionForm? connexionForm;



    Connexion({Key? key}) : super(key: key);
    Connexion.initialize({Key? key}) : super(key: key){
      {
        this.connexionForm= ConnexionForm();

      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        Header(),
// MenuBar
       FMenu(),

// Content below the MenuBar

          Positioned(
            top: MediaQuery.of(context).size.height * 0.18 + 50,
// Adjust based on MenuBar height
            left: 0,
            right: 0,
            bottom: 200,
            child: Container(
              color: Colors.white, // Example background for content below
// Scrollable content
              child: SingleChildScrollView(
                child: Column(children: []),
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
