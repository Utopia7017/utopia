import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/services/firebase/firebase_user_service.dart';
import 'package:utopia/view/screens/AppScreen/app_screen.dart';
import 'package:utopia/view/screens/AuthScreen/auth_screen.dart';

class UtopiaRoot extends StatelessWidget {
  bool internetConnected;
 UtopiaRoot({super.key,required this.internetConnected});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, notifier, child) {
        return notifier.user != null ? AppScreen(internetConnected) : Wrapper(internetConnected: internetConnected,);
      },
    );
  }
}

class Wrapper extends StatelessWidget {
  bool internetConnected;
  Wrapper({Key? key,required this.internetConnected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return AppScreen(internetConnected);
    } else {
      return const AuthScreen();
    }
  }
}
