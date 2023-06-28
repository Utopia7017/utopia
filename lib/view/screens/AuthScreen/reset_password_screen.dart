import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/view/common_ui/auth_textfields.dart';

class ResetPasswordScreen extends StatelessWidget {
  // const ResetPasswordScreen({super.key});
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: authBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Form(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Reset Password",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Play",
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
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
            

          ],
        )),
      ),
    );
  }
}
