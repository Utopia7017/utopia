import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/view/common_ui/auth_textfields.dart';

class LoginScreen extends StatelessWidget {
  final Logger _logger = Logger("LoginScreen");
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final space = const SizedBox(height: 30);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: authBackground,
      appBar: AppBar(
        backgroundColor: authBackground,
        elevation: 0,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  fontFamily: "Play",
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
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
              space,
              AuthTextField(
                controller: passwordController,
                label: "Password",
                visible: false,
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
                height: 40,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height * 0.055,
                    onPressed: () {},
                    color: authMaterialButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text("Login",style: TextStyle(fontSize: 15.5),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
