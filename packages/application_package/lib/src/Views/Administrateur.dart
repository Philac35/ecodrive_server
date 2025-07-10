import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';

import 'Components/ListVoyages.dart';
import 'Structure/Footer/Footer.dart';
import 'Structure/Header/Header.dart';
import 'Structure/Menu/FMenu.dart';
//import '../Router/AppRouter.gr.dart' show VoyageCreation;
//OpenMap Imports
//import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

@RoutePage()
class Administrateur extends StatelessWidget {
  const Administrateur({super.key});




  //Choix des Administrateur disponibles fn de la localité de l'utilisateur, ou en fonction du lieux indiqué. choix par défault
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
                            Text("Tableau de bord",
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .primary)),
                            Text("Graphique des trajets effectués",
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .primary)),
                            Text("Graphique du chiffre d'affaire",
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .primary)),

                            Text("Nombre et Liste des trajets disponibles",
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .primary)),
                           ListVoyages(),
                           InkWell(onTap:  () {try{
                             //        AutoRouter.of(context).push(VoyageCreation());
                              }catch(e, stackTrace) {
                              //debugPrint('Error navigating to ${VoyageCreation.page}: $e');
                              debugPrint('Stack trace: $stackTrace');}
                            },
                          child: Text(
                           "Créez un Trajet",
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary),
                          )),


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
