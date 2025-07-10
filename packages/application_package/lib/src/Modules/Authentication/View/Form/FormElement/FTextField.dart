
import 'package:application_package/src/Modules/Authentication/View/Form/Validator/FormConnexionValidator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:application_package/src/Modules/Authentication/View/Form/Controller/ControllerFormInterface.dart';
import '../Controller/ConnexionFormController.dart';


class FTextField extends StatefulWidget {

  late String? name;
  late String? text;
  late String? placeholder;
  late String? textValidator;
  late String? type='text'; //text/number/datetime/password
  bool? isVisible;
  late int? maxLine;
  late int? minLine;

  @override
  late Key key;

  FTextField({this.name,this.text,this.type,this.textValidator,this.placeholder,this.minLine,this.maxLine,required this.key, bool? isVisible}):super(key:key);

  @override
  FTextFieldState createState() {
    return FTextFieldState();
  }
}

class FTextFieldState extends State<FTextField> {

  //TODO Authentifiaction module need either ConnexionFormController or AccountCreationController. it will be to manage


  //final contactFormController = ContactFormController.to; //try to fetch a singleton

  late TextEditingController textEditing;
  late bool _isVisible;
  late bool isPasswordField=false;
  late ControllerFormInterface  controller;

  FTextFieldState();

  @override
  void initState() {
    super.initState();


    if(widget.type== 'password'){ isPasswordField=true;}
    if(widget.type== 'password' && widget.isVisible ==true){_isVisible=true;}
    else if( widget.type== 'password' && widget.isVisible ==false){_isVisible=false;}
    else if(widget.type== 'password'){_isVisible=false;}
    else{ _isVisible= true;}


    //if used in Connexion/CreateAccount
    controller = Get.find<ConnexionFormController>();
    // Register field
    controller.registerField(widget.key, widget.text!);

    textEditing = TextEditingController();

/*
    // Add listener to update the field value in the controller
    textEditing.addListener(() {
      contactFormController.updateField(widget.key!, textEditing.text);
      debugPrint('FTextField L48,TextEditingController listener called: ${textEditing.text}');
      debugPrint('FTextField L49,Field values in listener: ${contactFormController.fieldValues.entries.toString()}');
        //debugPrint(  contactFormController.obs.value.fieldValues.entries.toString());
    });
*/
  }

  @override
  void dispose() {
    textEditing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.clearField.value) {
        textEditing.clear();
        // Schedule the flag reset after the current frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.clearField.value = false;
        });
      }
      return TextFormField(
        controller: textEditing,
        obscureText: !_isVisible,
        maxLines: widget.maxLine ?? 1,
        minLines: widget.minLine ?? 1,

        decoration: InputDecoration(
          labelText: widget.text,
          hintText: widget.placeholder,
          suffixIcon: isPasswordField? IconButton(
            icon: Icon(
              _isVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
          ): null ,


          labelStyle: Theme
              .of(context)
              .textTheme
              .bodyMedium,
          hintStyle: TextStyle(color: Theme
              .of(context)
              .colorScheme
              .secondary),
          border: UnderlineInputBorder(),

        ),
        validator: FormConnexionValidator(widget).validator(
            widget.type!, textEditing.value.toString()),
        onChanged: (value) {

          controller.updateField(widget.key, value);
          debugPrint('FTextField L81,onChanged called: $value');
          debugPrint(
              'FTextField L82,Field values in onChanged: ${controller.fieldValues.entries.toString()}');
          //Obx(() => Text(controller.fieldValues[widget.key]?.value ?? ''));
        },
      );
    });
  }

}










