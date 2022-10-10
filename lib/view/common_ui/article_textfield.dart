import 'package:flutter/material.dart';

class ArticleTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isFirstTextBox;
  ArticleTextField({required this.controller, required this.isFirstTextBox});

  @override
  Widget build(BuildContext context) {
    return isFirstTextBox
        ? TextFormField(
            maxLines: null,
            minLines: null,
            showCursor: true,
            cursorColor: Colors.black,
            controller: controller,
            expands: false,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Start writing...",
              hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
            ),
          )
        : TextFormField(
            maxLines: null,
            minLines: null,
            showCursor: true,
            cursorColor: Colors.black,
            controller: controller,
            expands: false,
            decoration: const InputDecoration(
                border: InputBorder.none, hintText: "Write here"),
          );
  }
}
