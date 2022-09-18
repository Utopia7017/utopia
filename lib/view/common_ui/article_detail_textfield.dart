import 'package:flutter/material.dart';
import 'package:utopia/utils/device_size.dart';

class ArticleDetailTextField extends StatelessWidget {
  final TextEditingController controller;
  String? Function(String?)? validator;
  final String label;
  final Icon? prefixIcon;

  ArticleDetailTextField(
      {required this.controller,
      required this.label,
        required this.validator,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: label,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54),
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
