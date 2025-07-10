import 'package:flutter/material.dart';

class FGenderRadio extends StatefulWidget{
  const FGenderRadio({super.key});

  @override
  State<StatefulWidget> createState() {
        return FGenderRadioState();
  }



}
class FGenderRadioState extends State<FGenderRadio> {
  String? _selectedGender;

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
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
        ),
        Text(label),
      ],
    );
  }
}


