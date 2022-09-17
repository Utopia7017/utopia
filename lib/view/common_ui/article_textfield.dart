import 'package:flutter/material.dart';

class ArticleTextField extends StatelessWidget {
  final TextEditingController controller;
  ArticleTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      minLines: null,
      showCursor: true,
      cursorColor: Colors.black,
      controller: controller,
      expands: false,
      decoration: const InputDecoration(border: InputBorder.none),
    );
  }
}
