import 'package:ecodrive_server/src/Router/AppRouter.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../ImageCamera/ImageCameraLite.dart';
import 'Form/AccountCreation/AccountCreationForm.dart';
import 'Form/Connexion/ConnexionForm.dart';

class AccountCreationModal extends StatefulWidget{


  AccountCreationModal();

  @override
  State<StatefulWidget> createState() {
    return AccountCreationModalState();
  }



}
class AccountCreationModalState extends State<AccountCreationModal> {
  @override
  Widget build(BuildContext context) {
    return    AlertDialog(
      title: Text("Création de compte"),
      content:Container(
        width:double.maxFinite,
        child:SingleChildScrollView(
          child:Column(
            children:[ AccountCreationForm(),
              SizedBox(
                width: 400, // Example width
                height: 150, // Example height
                child: ImageCameraLite()
              ), ]
          )
      ),), // Assuming ConnexionForm is your login form widget
         actions: [
        TextButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],

    );
  }




}