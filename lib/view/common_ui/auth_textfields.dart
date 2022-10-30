import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool visible;
  final Icon prefixIcon;
  final suffixIcon;
  int? maxLength;
  String? Function(String?)? validator;

  AuthTextField(
      {required this.controller,
      required this.label,
      required this.visible,
      required this.prefixIcon,
      this.suffixIcon,
      this.maxLength,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLength: maxLength,
      obscureText: !visible,
      cursorColor: Colors.white30,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        counterStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: authTextBoxColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: authTextBoxBorderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: authTextBoxBorderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: authTextBoxBorderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
