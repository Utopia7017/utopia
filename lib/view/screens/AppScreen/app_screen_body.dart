import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/firebase/auth_services.dart';

class AppScreenBody extends StatelessWidget {
  // const AppScreenBody({Key? key}) : super(key: key);
  final Authservice _auth = Authservice(FirebaseAuth.instance);
  @override
  Widget build(BuildContext context) {

    return  Center(
        child: TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await _auth.signOut();
              navigator.pushReplacementNamed('/auth');
            },
            child: Text('Logout')),

    );
  }
}

