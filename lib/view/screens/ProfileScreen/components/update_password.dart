import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/services/firebase/auth_services.dart';
import 'package:utopia/view/common_ui/auth_textfields.dart';

class UpdatePasswordScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  final Authservice _auth = Authservice(FirebaseAuth.instance);

  Future<void> changeAccountPassword(String emailId, String oldPassword,
      String newPassword, User user, BuildContext context) async {
    try {
      // try matching the current password, if wrong compiler goes to catch part
      var isOldPasswordCorrect = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailId, password: oldPassword);

      // Update password
      user.updatePassword(newPassword).then((value) => QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "Password changed"));
    } on FirebaseAuthException catch (error) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Something went wrong",
          text: error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: authBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: authBackground,
        title: const Text(
          'Update password',
          style: TextStyle(fontFamily: "Open"),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 130),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthTextField(
                  controller: emailController,
                  label: "Email",
                  visible: true,
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.white60,
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                AuthTextField(
                  controller: oldPasswordController,
                  label: "Old password",
                  visible: false,
                  prefixIcon: const Icon(
                    Icons.key,
                    color: Colors.white60,
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                AuthTextField(
                  controller: newPasswordController,
                  label: "New password",
                  visible: false,
                  prefixIcon: const Icon(
                    Icons.key,
                    color: Colors.white60,
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: MaterialButton(
                    color: authMaterialButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onPressed: () async {
                      changeAccountPassword(
                          emailController.text,
                          oldPasswordController.text,
                          newPasswordController.text,
                          _auth.auth.currentUser!,
                          context);
                    },
                    child: const Text(
                      'Update Password',
                      style: TextStyle(fontFamily: "open"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
