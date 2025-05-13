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
class Credits extends StatefulWidget {
  const Credits({Key? key}) : super(key: key);


  @override
  _CreditsState createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
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
                        data: '''</div class='page-content page-Credits'></div><h1>Crédits</h1> <br/>
                            <h2>Je remercie :</h2>
                        <ul>
                        <li>la Région Bretagne pour le soutient apporté</li>
                      <li>le Département d'Ille et Vilaine</li>
                      <li>l'organisme de formation STUDI , Mr Pierre Charvet son Directeur Général </li> 
                      </ul>


                      <ul>
                      <li>Mr Grégory Renuy Responsable de la formation</li>
                      <li>Mr Clémence Majoulet, Responsable pédagogique</li>
                      <li>Les formateur de la filière Graduate Développeur</li>

                      <li>Et particulièrement Mr Ala Atrash pour ses indiquations salutaires.</li>
                      <li>Mr Nathan Delhore, pour ses cours sur les BDD.</li>
                      <li>Mr Christian Lohez</li>


                      <li>...</li>
                      </ul>

                      <h2>Images</h2>
                      <ul>
                      <ul><h3>Photos</h3>
                      
                      <li>Photo: <a href='https://easydiffusion.github.io/' alt='EasyDiffusion'>EasyDiffusion</a> </li>
                      </ul>
                      <ul><h3>Icones et logos</h3>
                      <li><a href="https://www.flaticon.com" alt="https://www.flaticon.com">https://www.flaticon.com</a></li> 
                      
                      </ul>

                      <h2>Solutions Technique</h2>
                      <ul>
                      <ul><h3>Langage</h3>
                      <li><a href="https://dart.dev" alt="langage Dart">Dart</a></li>
                      <li><a href="https://flutter.dev" alt="framework Flutter">Flutter</a></li>
                      <li>Le MIT, Apache Foundation,  pour les licences de nombreux packages </li>
                      </ul>
                        <div class="logoBretagne"><iframe  width="40%" height="166" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/722522275&color=5a9eaa"></iframe><div style="font-size: 10px; color: #cccccc;line-break: anywhere;word-break: normal;overflow: hidden;white-space: nowrap;text-overflow: ellipsis; font-family: Interstate,Lucida Grande,Lucida Sans Unicode,Lucida Sans,Garuda,Verdana,Tahoma,sans-serif;font-weight: 100;"><a href="https://soundcloud.com/user-619930250-277401226" title="Région Bretagne" target="_blank" style="color: #cccccc; text-decoration: none;">Région Bretagne</a> · <a href="https://soundcloud.com/user-619930250-277401226/region-bretagne-v1-sonnerie-autres-formats" title="Region Bretagne - Identité sonore" target="_blank" style="color: #cccccc; text-decoration: none;">Region Bretagne</a></div></div>''',
                        style: cssfile,
                      ),
                      SizedBox(height: 20),  // Add some space between text and image



                ]),
                ]),
              )),
            ),
          Footer(),
        ])

// Sticky footer

      );

  }
}
