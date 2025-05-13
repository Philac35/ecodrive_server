import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
 final String text;

   PasswordTextField({super.key, required this.text});

  @override
  PasswordTextFieldState createState() {
    return PasswordTextFieldState();
  }
}

class PasswordTextFieldState extends State<PasswordTextField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelText: widget.text,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Merci d\'entrer votre mot de passe';
        }
        return null;
      },
    );
  }
}
