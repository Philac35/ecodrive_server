import 'package:ecodrive_server/src/Views/Forms/Controler/ContactFormController.dart';
import 'package:flutter/cupertino.dart';

import 'package:ecodrive_server/src/Views/Forms/View/FormElement/FTextField.dart';
import 'package:ecodrive_server/src/Views/Forms/View/FormElement/CustomButton.dart';

import 'package:get/get.dart';

class ContactForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContactFormState();
  }
}

class ContactFormState extends State<ContactForm> {
  late ContactFormController contactForm;
  late Map<String, TextEditingController> textEditingMap;

  @override
  void initState() {
    super.initState();
    contactForm = Get.find<ContactFormController>();
    ChangeNotifier notifier;
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        children: [
          FTextField(
              key: ValueKey('contact_nom'),
              name: 'Nom',
              text: "Nom",
              type: "text",
              placeholder: "Veuillez entrer votre nom!",
              textValidator: "Le champ ne contient pas un nom valide"),
          SizedBox(height: 16),
          FTextField(
              key: ValueKey('contact_prenom'),
              name: 'Prénom',
              text: "Prénom",
              type: "text",
              placeholder: "Veuillez entrer votre prénom!",
              textValidator: "Le champ ne contient pas un ^prénom valide"),
          SizedBox(height: 16),
          FTextField(
              key: ValueKey('contact_email'),
              name: 'Email',
              text: "Votre Email",
              type: "email",
              placeholder: "Veuillez entrer votre adresse mail!",
              textValidator: "Le champ ne contient pas un email valide"),
          SizedBox(height: 16),
          FTextField(
              key: ValueKey('contact_subject'), 
              name: 'Subject',
              text: "Objet",
              type: "text",
              placeholder: "Veuillez entrer l'objet de votre email!",
              textValidator: "Le champ ne contient pas un objet valide"),
          SizedBox(height: 16),
          FTextField(
              key: ValueKey('contact_message'),
              name: 'Message',
              text: "Votre message",
              type: "text",
              placeholder: "Veuillez entrer votre message!",
              minLine: 6,
              maxLine: 12,
              textValidator: "Le champ ne contient pas un message valide"),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                nameId: 'delete',
                text: "Supprimer",
                onPressed: () {
                  contactForm.delete();
                  debugPrint('Delete');
                },
                child: widget,
              ),
              CustomButton(
                nameId: 'send',
                text: "Envoyer",
                onPressed: () {
                  contactForm.send();
                  debugPrint('SubmitForm');
                },
                child: widget,
              )
            ],
          ),
          SizedBox(height: 16),
          Obx(
            () => contactForm.isEmailSent.value
                ? Text("Email a été envoyé")
                : i != 0
                    ? Text("Email n'a pas été envoyé")
                    : SizedBox.shrink(),
          )
        ],
      ),
    ));
   
  }
}
