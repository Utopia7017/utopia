import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/services/firebase/firebase_user_service.dart';
import 'package:utopia/view/screens/AppScreen/app_screen.dart';
import 'package:utopia/view/screens/AuthScreen/auth_screen.dart';

class UtopiaRoot extends StatelessWidget {
  const UtopiaRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, notifier, child) {
        return notifier.user != null ? AppScreen() : const Wrapper();
      },
    );
  }
}


class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return AppScreen();
    } else {
      return const AuthScreen();
    }
  }
}

