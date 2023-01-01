import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:utopia/services/firebase/auth_services.dart';
import 'package:utopia/services/firebase/firebase_user_service.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/view/screens/AppScreen/app_screen.dart';
import 'package:utopia/view/screens/AuthScreen/auth_screen.dart';

class UtopiaRoot extends ConsumerWidget {
  bool internetConnected;
  final Authservice _auth = Authservice(FirebaseAuth.instance);
  UtopiaRoot({super.key, required this.internetConnected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
 
    return StreamBuilder(
      stream: _auth.austhStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AppScreen(internetConnected);
          // return AppScreen(internetConnected);
        } else {
          return AuthScreen();
        }
      },
    );
  }
}

class Wrapper extends StatelessWidget {
  bool internetConnected;
  Wrapper({Key? key, required this.internetConnected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null && firebaseUser.emailVerified) {
      return AppScreen(internetConnected);
    } else {
      return const AuthScreen();
    }
  }
}
