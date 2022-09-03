import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool visible;
  final Icon prefixIcon;
  String? Function(String?)? validator;

  AuthTextField(
      {required this.controller,
      required this.label,
      required this.visible,
      required this.prefixIcon,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: !visible,
      decoration: InputDecoration(
        filled: true,
        fillColor: authTextBoxColor,
        prefixIcon: prefixIcon,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color:authTextBoxBorderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder:  OutlineInputBorder(
          borderSide: const BorderSide(color: authTextBoxBorderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: authTextBoxBorderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
