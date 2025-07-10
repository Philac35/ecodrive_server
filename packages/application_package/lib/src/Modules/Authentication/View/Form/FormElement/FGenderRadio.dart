import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Controller/AccountCreationController.dart';
import '../Controller/ControllerFormInterface.dart';

class FGenderRadio extends StatefulWidget{

  late String? name;
  late Key key;
  FGenderRadio({this.name,required this.key}):super(key:key);

  @override
  State<StatefulWidget> createState() {
        return FGenderRadioState();
  }



}
class FGenderRadioState extends State<FGenderRadio> {
  String? _selectedGender;
  late ControllerFormInterface  controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AccountCreationController>();
  }



  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(left: 12),
       child:Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Genre",
          style: Theme.of(context).textTheme.bodyMedium, // Use the same style as FTextField labels
        ),
        SizedBox(height: 8),
        _buildRadio('M', 'Male'),
        _buildRadio('IEL', 'Non-binary'),
        _buildRadio('F', 'Female'),
      ],
    ),);
  }

  Widget _buildRadio(String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: _selectedGender,
          onChanged: (String? value) {
            setState(() {


                controller.updateField(widget.key!, value!);
              _selectedGender = value;
            });
          },
        ),
        Text(label),
      ],
    );
  }
}


