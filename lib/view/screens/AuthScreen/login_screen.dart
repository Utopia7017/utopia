import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/auth_screen_controller.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/services/firebase/auth_services.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/helper_widgets.dart';
import 'package:utopia/view/common_ui/auth_textfields.dart';
import 'package:utopia/view/screens/AppScreen/app_screen.dart';
import 'package:utopia/view/screens/AuthScreen/continue_registering_screen.dart';
import 'package:utopia/view/screens/AuthScreen/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final Logger _logger = Logger("LoginScreen");
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final Authservice _auth = Authservice(FirebaseAuth.instance);

  final space = const SizedBox(height: 30);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: authBackground,
      appBar: AppBar(
        backgroundColor: authBackground,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: _formKey,
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
                Consumer<AuthScreenController>(
                  builder: (context, controller, child) {
                    return AuthTextField(
                      controller: passwordController,
                      label: "Password",
                      visible: controller.showLoginPassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.showLoginPassword
                              ? controller.loginOffVisibility()
                              : controller.loginOnVisibility();
                        },
                        icon: controller.showLoginPassword
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.white60,
                              )
                            : const Icon(Icons.visibility,
                                color: Colors.white60),
                      ),
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
                    );
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: SizedBox(
                    width: displayWidth(context) * 0.55,
                    child: Consumer<AuthScreenController>(
                      builder: (context, controller, child) {
                        return MaterialButton(
                          height: displayHeight(context) * 0.055,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final navigator = Navigator.of(context);
                              final sms = ScaffoldMessenger.of(context);

                              controller.startLogin();
                              var loginResponse = await _auth.signIn(
                                  email: emailController.text,
                                  password: passwordController.text);
                              controller.stopLogin();
                              if (loginResponse.runtimeType == UserCredential) {
                                if ((loginResponse as UserCredential)
                                    .user!
                                    .emailVerified) {
                                  navigator.pushReplacement(MaterialPageRoute(
                                    builder: (context) => AppScreen(true),
                                  ));
                                } else {
                                  navigator.push(MaterialPageRoute(
                                    builder: (context) =>
                                        ContinueRegisteringScreen(
                                            emailProvided:
                                                loginResponse.user!.email!),
                                  ));
                                  // showCustomSnackBar(
                                  //     context: context,
                                  //     text: "Please verify your email first");
                                }
                              } else {
                                showCustomSnackBar(
                                    context: context, text: loginResponse!);
                              }
                            }
                          },
                          color: authMaterialButtonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Login",
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
                    switch (controller.loginStatus) {
                      case AuthLoginStatus.loading:
                        return const Center(
                          child: CircularProgressIndicator(
                            color: authMaterialButtonColor,
                          ),
                        );
                      case AuthLoginStatus.notloading:
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
