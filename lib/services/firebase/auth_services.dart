import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart'; // Temporarily disabled

class Authservice {
  // Create an instance of firebase authentication.
  final FirebaseAuth _auth;

  Authservice(this._auth);

//sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  /// It signs in the user with the email and password provided.
  ///
  /// Args:
  ///   email (String): The email address of the user.
  ///   password (String): The user's password.
  ///
  /// Returns:
  ///   The return type is dynamic.
  Future<dynamic> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential? userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("error in login $e");
      return e.message;
    }
  }

  /// It creates a new user with the given email and password, sends an email verification, and returns
  /// the userCredential
  ///
  /// Args:
  ///   email (String): The email address of the user.
  ///   password (String): The password for the new account.
  ///
  /// Returns:
  ///   The return type is dynamic.

  Future<dynamic> signUp({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential? userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<dynamic> googleLogin() async {
    try {
      // Temporarily disable Google Sign-In due to API changes in version 7.2.0
      // TODO: Fix Google Sign-In implementation for new API
      return "Google Sign-In temporarily disabled due to API changes";

      /*
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();
      if (gUser != null) {
        final GoogleSignInAuthentication gauth = await gUser.authentication;
        final AuthCredential gCred = GoogleAuthProvider.credential(
            accessToken: gauth.accessToken, idToken: gauth.idToken);
        final UserCredential userCredential =
            await auth.signInWithCredential(gCred);
        return userCredential;
      } else {
        return null;
      }
      */
    } catch (e) {
      return e.toString();
    }
  }
}
