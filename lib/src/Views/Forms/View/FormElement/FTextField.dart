
import 'dart:io';

import 'package:ecodrive_server/src/Views/Forms/Validator/FormContactValidator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';

import 'package:get/get_core/src/get_main.dart';

import 'package:ecodrive_server/src/Views/Forms/Controler/ContactFormController.dart';

class FTextField extends StatefulWidget {

  late String? name;
  late String? text;
  late String? placeholder;
  late String? textValidator;
  late String? type='text'; //text/number/datetime/password
  late bool isVisible;
  late int? maxLine;
  late int? minLine; 
  


  FTextField({this.name,this.text,this.type,this.textValidator,this.placeholder,bool? isVisible,this.minLine,this.maxLine,Key? key}):isVisible=true,super(key:key);

  @override
  FTextFieldState createState() { 
    return FTextFieldState(); 
  }
}

class FTextFieldState extends State<FTextField> {
  late bool _isVisible ;
  //final contactFormController = ContactFormController.to; //try to fetch a singleton
  final contactFormController = Get.find<ContactFormController>();

  late TextEditingController textEditing;

  FTextFieldState();

  @override
  void initState() {
    super.initState();
//In state widget can't be null, it seams that null check on widget is not relevent
    _isVisible=widget.isVisible ?? true;
    if(widget.type== 'password' && _isVisible ==true){_isVisible=true;}
    else if( widget.type== 'password' && _isVisible ==false){_isVisible=false;}
    else if(widget.type== 'password'){_isVisible=false;}
    else{ _isVisible= true;} 

    // Register field
    debugPrint('Initializing field with key: ${widget.key} and text: ${widget.text}');
    contactFormController.registerField(widget.key!, widget.text!);
    textEditing = TextEditingController();

    /*
    // Add listener to update the field value in the controller
    textEditing.addListener(() {
      contactFormController.updateField(widget.key!, textEditing.text);
      debugPrint('FTextField L48,TextEditingController listener called: ${textEditing.text}');
      debugPrint('FTextField L49,Field values in listener: ${contactFormController.fieldValues.entries.toString()}');
        //debugPrint(  contactFormController.obs.value.fieldValues.entries.toString());
    });*/
    /*
    myController.addListener(() {
      controller.updateField(widget.fieldKey, myController.text);
    }); */
  }

  @override
  void dispose() {
    textEditing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (contactFormController.clearField.value) {
        textEditing.clear();
        // Schedule the flag reset after the current frame
        // else it doesn't take care of async and doesn't clear the fields
        WidgetsBinding.instance.addPostFrameCallback((_) {
          contactFormController.clearField.value = false;
        });
      };
      return TextFormField(
        controller: textEditing,
        maxLines: widget.maxLine ?? 1,
        minLines: widget.minLine ?? 1,
        obscureText: !_isVisible,
        decoration: InputDecoration(
          labelText: widget.text,
          hintText: widget.placeholder,
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
        validator: FormContactValidator(widget).validator(
            widget.type!, textEditing.value.toString()),
        onSaved:(value)=> widget.name=value?? '',
        onChanged: (value) {
          debugPrint('FTextField L103,onChanged Component key: ${widget.key.toString()}');
          contactFormController.updateField(widget.key!, value);
          debugPrint('FTextField L105,onChanged called: $value');
          debugPrint(
              'FTextField L107,Field values in onChanged: ${contactFormController
                  !.fieldValues.entries.toString()}');
          //Obx(() => Text(controller.fieldValues[widget.key]?.value ?? ''));
        },
      );
    });
  }

}










