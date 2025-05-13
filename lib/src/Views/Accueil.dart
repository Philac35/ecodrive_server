import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_html/flutter_html.dart';
import '../Modules/Authentication/View/Form/Connexion/ConnexionForm.dart';
import 'package:ecodrive_server/src/Router/AppRouter.gr.dart';
import '../Services/Parser/CSSParser.dart';
import 'HTML/TextEffect/OnMouseHoverSubmenuButton.dart';

import 'package:auto_route/auto_route.dart';

import 'Structure/Footer/Footer.dart';
import 'Structure/Header/Header.dart';
import 'Structure/Menu/FMenu.dart';


@RoutePage()
class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);


  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  String _stylecss = '';
  bool _isLoading = true;

  late ConnexionForm connexionForm;




  @override
  void initState() {
    super.initState();
    loadCSS();
    this.connexionForm= ConnexionForm();
  }

  Future<void> loadCSS() async {
    try {
      _stylecss = await rootBundle.loadString('styles/styles.css');
    } catch (e) {
      print('Error loading CSS: $e');
      // Handle the error appropriately
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var cssfile = CSSParser().parseDeclarations(this._stylecss);

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
                child: Column(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Html(
                        data: "</div class='page-content page-accueil'></div><h1>Bienvenue sur les pages d'administration de l'application Ecodrive!</h1> <br/>"
                            "<p>Mr Directeur Général vous souhaite une excellente journée !</p>",
                        style: cssfile,
                      ),
                      SizedBox(height: 20),  // Add some space between text and image
                      Align(
                        alignment: Alignment.center, // You can change alignment as needed
                        child: SizedBox(
                          width: 800,

                          child: Image.asset(
                            'images/Entreprise/rennes-siege-sociale.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ],
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: 40.0 , right:20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Html(
                            data: "<p>Nouveautés : Nous développons nos services, et mettons à votre disposition partout en France des bornes de recharge à proximité de nos bureaux et aux endroits stratégiques tels que gares, gares maritimes, aéroports.</p>",
                            style: CSSParser().parseDeclarations(this._stylecss),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            'images/Entreprise/bornes-recharge.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.only(top:40.0),
                    child: Html(
                        data:
                            "<p>Vous souhaitez nous poser vos questions, joindre un collègue de l'entreprise, un formulaire de contact est à votre disposition avec la liste des personnes pouvant être contactées.</p></div>",
                        style: cssfile),
                  ),
                ]),
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
