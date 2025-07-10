import 'package:auto_route/auto_route.dart';
import 'package:application_package/src/Views/Structure/Menu/MenuElement/FSubmenuButton.dart';
import 'package:flutter/material.dart';


import '../../../Router/AppRouter.gr.dart';


class FMenu extends StatefulWidget {
  const FMenu({super.key});

  @override
  _FMenuState createState() => _FMenuState();
}

class _FMenuState extends State<FMenu> {
  @override
  Widget build(BuildContext context) {
// MenuBar
    return Positioned(
      top: MediaQuery.of(context).size.height *  0.2, // Position MenuBar below the colored space
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white, // Optional background for the MenuBar
        child: MenuBar(
          children: [
            FSubmenuButton(Accueil() as PageRouteInfo, "Accueil"),
            FSubmenuButton(Administrateur() as PageRouteInfo, "Administrateur"),
            FSubmenuButton(Employe(), "Employés"),
            FSubmenuButton(Contact() as PageRouteInfo, "Contact"),
            FSubmenuButton(Credits() as PageRouteInfo<Object?>, "Crédits"),
            // FSubmenuButton(Connexion(onResult: (isLog) {  }) as PageRouteInfo, "Connexion"),

          ],
        ),
      ),
    );
  }
}
