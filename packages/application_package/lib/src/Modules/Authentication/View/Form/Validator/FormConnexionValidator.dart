import 'package:application_package/src/Modules/Authentication/View/Form/FormElement/FTextField.dart';

class FormConnexionValidator{
  late String value;
  late String Type;
  late FTextField component;

  FormConnexionValidator(this.component);




  validator(String type,String value) {
    switch (type) {
      case 'text': checkDefault(value)   ;
      case 'password':checkPassword(value)     ;
      case 'email': checkEmail(value)       ;
      default :
        checkDefault(value);
    }
  }


  checkDefault(String value){  if (value.isEmpty) {
    if(component.textValidator!=null || component.textValidator !=''){
      if(value.length<=3){}
      return component.textValidator;
    }
    else{
      return 'The field is empty';
    }

  }}

  checkEmail(String value) {
    if (value.isEmpty) {
      if(component.textValidator!=null || component.textValidator !=''){
        var reg=RegExp(".*?@.*?.[a-z]{2,3}");

        if(value.length<=3){return component.textValidator;}
        else if (value.contains(reg)==false){
          return "The field email doesn't contain a valid Email of pattern identifiant@smtp.tld";
        }

      }
      else{
        return 'The field is empty';
      }

    }}

  checkPassword(value){
    if(component.textValidator!=null || component.textValidator !=''){
    var regUpperCase=RegExp("[A-Z]+");
    var regSpecialChar= RegExp("[^A-Za-z]+");  

      if(value.length< 8 && value.contains(regUpperCase)==false && value.contains(regSpecialChar)==false ){
        return component.textValidator;
      }
    }
    else{
      return 'The field is empty';
    }

  }




}