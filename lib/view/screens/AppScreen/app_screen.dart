import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:utopia/services/firebase/auth_services.dart';
import 'package:utopia/view/screens/AuthScreen/login_screen.dart';
import 'package:utopia/view/screens/AuthScreen/signup_screen.dart';

class AppScreen extends StatelessWidget {


  final Authservice _auth = Authservice(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async{
          final navigator= Navigator.of(context);
          await _auth.signOut();
         navigator.pushReplacementNamed('/auth');
        },
        child: Text('Logout')),
      ),
    );
  }
}
