import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/models/user_model.dart';

class FollowingScreen extends StatelessWidget {
  final User user;
  const FollowingScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: authBackground,
        title: const Text('Following',style: TextStyle(fontFamily: "Fira",fontSize: 15),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );;
  }
}
