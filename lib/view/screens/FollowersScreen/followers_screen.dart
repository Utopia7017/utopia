import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/models/user_model.dart';

class FollowersScreen extends StatelessWidget {
  final User user;
  const FollowersScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: authBackground,
        title: const Text('Followers',style: TextStyle(fontFamily: "Fira",fontSize: 15),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}
