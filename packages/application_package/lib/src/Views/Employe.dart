import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';

//import 'package:ecodrive_server/src/Modules/OpenStreetMap/OpenStreetMap.dart';
import 'package:flutter/material.dart';


import 'Components/ListVoyages.dart';
import 'Structure/Footer/Footer.dart';
import 'Structure/Header/Header.dart';
import 'Structure/Menu/FMenu.dart';



@RoutePage()
class Employe extends StatelessWidget {
  const Employe({super.key});




  //Choix des Employe disponibles fn de la localité de l'utilisateur, ou en fonction du lieux indiqué. choix par défault
  //Lien création de voyage  ac guard.  (connected as Driver.


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
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            Text("Liste des trajets disponibles",
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .primary)),
                           ListVoyages(),

                          Text("Modération des Trajets effectués, Réclamation client",
                              style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .primary)),

                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

// Sticky footer
          Footer(),
        ],
      ),
    );
  }
}
