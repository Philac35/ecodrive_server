import 'package:flutter/cupertino.dart';
import './FormElement/FTextField.dart';

class VoyageFormInitial extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return VoyageFormInitialState();
  }



}

class VoyageFormInitialState extends State<VoyageFormInitial>{



  @override
  Widget build(BuildContext context) {
      return Container(
          child:Center(
              child:Column(
                children: [
                    FTextField(name:'LieuDeDepart',text:"Départ", type:"text", placeholder:"Veuillez entrer une Ville de départ"),
                    SizedBox(height:16),
                    FTextField(),
                ],
              )));



  }





}