import 'dart:convert';
import 'package:ecodrive_server/src/Services/LogSystem/LogSystemBDD.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../AccountCreationModal.dart';
import '../Controller/ConnexionFormController.dart';
import '../FormElement/FTextField.dart' as ftext;
//import '../FormElement/PasswordTextField.dart';


// Define a custom Form widget.
class ConnexionForm extends StatefulWidget {
  const ConnexionForm({super.key});


  @override
  ConnexionFormState createState() {
    return ConnexionFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class ConnexionFormState extends State<ConnexionForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  late GlobalKey<FormState>  _formKey ;
  late bool _passwordVisible =false;
  late ConnexionFormController connexionFormController;


  ConnexionFormState(){
    _formKey= GlobalKey<FormState>() ;
     connexionFormController=Get.find<ConnexionFormController>();
     if(connexionFormController != null){debugPrint("connexionFormController exist!");}else{debugPrint("connexionFormController is null!");} 

  }





  @override
  Widget build(BuildContext context) {

    if (kDebugMode) {
      print(" ConnexionForm key : ${_formKey.toString()}");
    }
    // Build a Form widget using the _formKey created above.
    return Form(
      key: this._formKey, 
      
      child: ConstrainedBox(
         constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ftext.FTextField(key: ValueKey('Username'),name:'username',text:'Enter your username',type:'text'),
                  SizedBox(height: 16),
                  ftext.FTextField(key: ValueKey('Password'),name:'password',text:'Enter your password',type:'password', isVisible: _passwordVisible),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          _formKey.currentState?.save();

                          if (_formKey.currentState!.validate()) { //Check is form's informations are valid
                             Future<bool> isSendAuthentication=     connexionFormController.send();
                          if(await isSendAuthentication){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Send Indentification Informations')),
                            );}else{ ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Indentification Informations wasn\'t sent'), )); };
                          }
                        },
                        child: const Text('Envoyer'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                        },
                        child: const Text('Effacer'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AccountCreationModal();
                        },
                      );
                    },
                    child: const Text('Creer un compte'),
                  ),
                ],
              ),
            ),


      ),
    );
  }
}