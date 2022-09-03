import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:utopia/controlller/auth_screen_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/services/firebase/auth_services.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/auth_textfields.dart';
import 'package:utopia/constants/color_constants.dart';

class SignUpScreen extends StatelessWidget {
  final Logger _logger = Logger("SignUpScreen");

  TextEditingController emailController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final Authservice _auth = Authservice(FirebaseAuth.instance);
  final space = const SizedBox(height: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: authBackground,
        elevation: 0,
      ),
      backgroundColor: authBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create an account",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      fontFamily: "Play",
                      letterSpacing: 1.2,
                      color: Colors.white),
                ),
                const SizedBox(height: 40),
                AuthTextField(
                  controller: nameController,
                  label: "Name",
                  visible: true,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.white60,
                  ),
                  validator: (val) {
                    if (val!.isEmpty) return "Name cannot be empty";
                  },
                ),
                space,
                AuthTextField(
                  controller: emailController,
                  label: "Email",
                  visible: true,
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.white60,
                  ),
                  validator: (val) {
                    // TODO : Implement the email validator using regex @Abhi-kr21
                    if (val!.isEmpty) return "Email cannot be empty";
                  },
                ),
                space,
                AuthTextField(
                  controller: passwordController,
                  label: "Password",
                  visible: false,
                  prefixIcon: const Icon(
                    Icons.key,
                    color: Colors.white60,
                  ),
                  validator: (val) {
                    if (val!.isEmpty) return "Password cannot be empty";
                  },
                ),
                space,
                AuthTextField(
                  controller: confirmPasswordController,
                  label: "Confirm Password",
                  visible: false,
                  prefixIcon: const Icon(
                    Icons.security,
                    color: Colors.white60,
                  ),
                  validator: (val) {
                    if (val!.isEmpty) return "Confirm Password cannot be empty";
                  },
                ),
                space,
                Center(
                  child: SizedBox(
                    width: displayWidth(context) * 0.55,
                    child: Consumer<AuthScreenController>(
                      builder: (context, controller, child) {
                        return MaterialButton(
                          height: displayHeight(context) * 0.055,
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                controller.status ==
                                    AuthSignUpStatus.notLoading) {
                              _logger.info("Form validated");
                              controller.startLoding();
                              final singupResponse = await _auth.signUp(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  context: context);
                              controller.stopLoding();
                              if (singupResponse == 'valid') {
                                _logger.info("Registration successfull");
                              }
                            }
                          },
                          color: authMaterialButtonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(fontSize: 15.5),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                space,
                Consumer<AuthScreenController>(
                  builder: (context, controller, child) {
                    switch (controller.status) {
                      case AuthSignUpStatus.loading:
                        return const Center(
                          child: CircularProgressIndicator(
                            color: authMaterialButtonColor,
                          ),
                        );
                      case AuthSignUpStatus.notLoading:
                        return const SizedBox();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
