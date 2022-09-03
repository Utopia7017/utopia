import 'package:flutter/material.dart';

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
        fillColor: Color.fromARGB(
          255,
          54,
          55,
          59,
        ),
        prefixIcon: prefixIcon,
        labelText: label,
        labelStyle: TextStyle(color: Colors.white60),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
