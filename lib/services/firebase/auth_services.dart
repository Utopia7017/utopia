import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Authservice {
  // Create an instance of firebase authentication.
  final FirebaseAuth _auth;

  Authservice(this._auth);

  Stream<User?> get austhStateChanges => _auth.authStateChanges();

//sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

//sign in with email and password  !!
  Future<dynamic> signIn(
      {required String email, required String password}) async {
    try {
      print("reaching here");
      UserCredential? userCredential =  await _auth.signInWithEmailAndPassword(email: email, password: password);
      print(userCredential.toString());
      return userCredential;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<dynamic> signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
     
      UserCredential? userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
