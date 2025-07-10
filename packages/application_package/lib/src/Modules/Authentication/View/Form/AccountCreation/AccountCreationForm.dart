import 'package:application_package/src/Modules/Authentication/View/Form/Controller/AccountCreationController.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';



import 'package:shared_package/Services/HTMLService/HTMLService.dart';
import '../FormElement/FGenderRadio.dart';
import '../FormElement/FPhotoUploadField.dart';
import '../FormElement/FTextField.dart';
//import '../FormElement/PasswordTextField.dart';

// Define a custom Form widget.
class AccountCreationForm extends StatefulWidget {
  const AccountCreationForm({super.key});

  @override
  AccountCreationFormState createState() {
    return AccountCreationFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class AccountCreationFormState extends State<AccountCreationForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  late GlobalKey<FormState>  _formKey ;
   late AccountCreationController accountCreationController;
   final bool _passwordVisible =false;

  late HTMLService htmlService;


  AccountCreationFormState();

 


  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    accountCreationController = Get.find<AccountCreationController>();
    htmlService = HTMLService();
  }




  @override
  Widget build(BuildContext context) {

    if (kDebugMode) {
      print(" ConnexionForm key : ${_formKey.toString()}");
    }
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[

          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[ Center(
              child:Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FPhotoUploadField(key: ValueKey("Photo")),
                    SizedBox(height: 16),
                    FGenderRadio(key: ValueKey("Genre")),
                    SizedBox(height: 16),
                    FTextField(key:ValueKey('Prénom'),type:'text',text:'Prénom',textValidator:'Please, enter your Firstname'),
                    SizedBox(height: 16),
                    FTextField(key:ValueKey('Nom'),type:'text',text:'Nom',textValidator:'Please, enter your Lastname'),
                    SizedBox(height: 16),
                    FTextField(key:ValueKey('Username'),type:'text',text:'Nom d\'utilisateur',textValidator:'Please, enter your Usename'),
                    SizedBox(height: 16),
                    FTextField(key:ValueKey('Age'),type:'number',text:'Age',textValidator:'Please, enter your age'),
                    SizedBox(height: 16),
                    FTextField(key:ValueKey('Password'),type:'password',text:'Mot de Passe',isVisible:false),
                    SizedBox(height: 16),
                    FTextField(key:ValueKey('PasswordConfirmation'),type:'password',text:'Confirmation Mot de Passe',isVisible:false),
                    SizedBox(height: 14),
                    FTextField(key:ValueKey('Email'),type:'email',text:'Email',textValidator:'Please, enter your Email'),
                    SizedBox(height: 16),
                    FTextField(key:ValueKey('TypeVoie'),type:'text',text:'Type de voie'),
                    SizedBox(height: 16),
                    FTextField(key:ValueKey('Numéro'),text:'Numero',type:'number'),
                    SizedBox(height: 16),
                    FTextField(key:ValueKey('Adresse'),type:'text',text:'Adresse',textValidator:'Please, enter your Address'),
                    SizedBox(height: 16),
                    FTextField(key:ValueKey('ComplementAdresse'),type:'text',text:'Complément d\'adresse'),
                    SizedBox(height: 16),
                    FTextField(key:ValueKey('Code Postal'),type:'text',text:'Code Postal',textValidator:'Please, enter your Postcode'),
                    SizedBox(height: 16),
                    FTextField(key:ValueKey('Ville'),type:'text',text:'Ville', textValidator:'Please, enter your City'),
                    SizedBox(height: 16),
                    FTextField(key:ValueKey('Pays'),type:'text',text:'Pays',textValidator:'Please, enter your Country'),
                    FTextField(key:ValueKey('Role'),type:'text',text:'Role', placeholder:'Passager, Driver or Passager-Driver',textValidator:'Please, enter your Role : Passager,Driver or Passager-Driver '),  //Passager,Driver, Passager-Driver

                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _formKey.currentState?.reset();
                          },
                          child: const Text('Effacer'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();

                              if (_formKey.currentState!.validate()) { //Check is form's informations are valid

                                Future<bool> isSend= accountCreationController.send();
                                if(await isSend){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Send Acount Creation Informations')),
                                  );}else{ ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Account Creation Informations wasn\'t sent'), )); }
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processing Data')),
                              );
                            }
                          },
                          child: const Text('Envoyer'),
                        ),

                      ],
                    ),
                    SizedBox(height: 16),

                  ],
                ),
              ),
            )],
          )
        ],
      ),
    );
  }
}