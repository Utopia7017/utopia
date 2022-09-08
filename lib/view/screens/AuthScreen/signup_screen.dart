import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:utopia/controlller/auth_screen_controller.dart';
import 'package:utopia/controlller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/user_model.dart' as user;
import 'package:utopia/services/firebase/auth_services.dart' as firebase;
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
  final firebase.Authservice _auth =
      firebase.Authservice(FirebaseAuth.instance);
  final space = const SizedBox(height: 30);
  bool ischecked = false;

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    if (val!.isEmpty)
                    {
                      return "Textfield cannot be empty";
                    } 
                    else if(passwordController.value != confirmPasswordController.value)
                    {
                      return "password didn't match" ;
                    } 
                    else 
                    return null;
                  },
                ),
                space,
                Row(
                  children: [
                    Consumer<AuthScreenController>(
                      builder: (context, controller, child) {
                        return IconButton(
                          onPressed: () {
                            if(controller.termsCondition ){
                              controller.declineTermsCondition();
                            }
                            else
                            {
                              controller.acceptTermsCcondition();
                            }

                          },
                           icon:Icon(controller.termsCondition? Icons.check_box : Icons.check_box_outline_blank_outlined) );
                      },
                    ),
                Text('I accept all the Terms And Conditions ',style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold),)
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: SizedBox(
                    width: displayWidth(context) * 0.55,
                    child: Consumer<AuthScreenController>(
                      builder: (context, controller, child) {
                        return MaterialButton(
                          height: displayHeight(context) * 0.055,
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                controller.signupStatus ==
                                    AuthSignUpStatus.notLoading) {
                              final navigator = Navigator.of(context);
                              final sms = ScaffoldMessenger.of(context);
                              final userController =
                                  Provider.of<UserController>(context,
                                      listen: false);
                              _logger.info("Form validated");
                              controller.startSigningUp();
                              final dynamic signupResponse = await _auth.signUp(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  context: context);
                              controller.stopSigningUp();
                              if (signupResponse.runtimeType ==
                                  UserCredential) {
                                // successfully created new account
                                await userController.createUser(user.User(
                                    name: nameController.text,
                                    dp: '',
                                    email: emailController.text,
                                    followers: [],
                                    userId: signupResponse.user.uid,
                                    bio: '',
                                    following: []));
                                navigator.pushReplacementNamed('/app');
                              } else {
                                sms.showSnackBar(
                                  SnackBar(
                                      content: Text(
                                        signupResponse!,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.5),
                                      ),
                                      backgroundColor: authMaterialButtonColor),
                                );
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
                    switch (controller.signupStatus) {
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
