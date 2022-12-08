import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';

class PopularAuthors extends StatelessWidget {
  const PopularAuthors({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: authBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Popular Authors",
          style: TextStyle(fontFamily: "Open", fontSize: 14),
        ),
      ),
    );
  }
}
