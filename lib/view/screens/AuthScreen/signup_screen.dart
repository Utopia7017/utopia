import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/auth_screen_controller.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/user_model.dart' as user;
import 'package:utopia/services/firebase/auth_services.dart' as firebase;
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/auth_textfields.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/view/screens/AppScreen/app_screen.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Form(
            key: _formKey,
            child: Consumer<AuthScreenController>(
              builder: (context, controller, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        controller.registrationPageIndex == 2
                            ? IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () =>
                                    controller.decreaseRegistrationPageIndex(),
                                icon: const Icon(
                                    Icons.keyboard_backspace_outlined),
                                color: Colors.white,
                              )
                            : const SizedBox(),
                        Text(
                          '( ${controller.registrationPageIndex.toString()}/2 )',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    controller.registrationPageIndex == 1
                        ? formPage(context)
                        : validateEmailPage(context)
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Form page - 1

  Widget formPage(BuildContext context) {
    return Column(
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
            if (val!.isEmpty) return "Email cannot be empty";
          },
        ),
        space,
        Consumer<AuthScreenController>(
          builder: (context, controller, child) {
            return AuthTextField(
              controller: passwordController,
              label: "Password",
              visible: controller.showSignupPasswprd,
              suffixIcon: IconButton(
                  onPressed: () {
                    controller.showSignupPasswprd
                        ? controller.signupOffVisibility()
                        : controller.signupOnVisibility();
                  },
                  icon: controller.showSignupPasswprd
                      ? const Icon(
                          Icons.visibility_off,
                          color: Colors.white60,
                        )
                      : const Icon(
                          Icons.visibility,
                          color: Colors.white60,
                        )),
              prefixIcon: const Icon(
                Icons.key,
                color: Colors.white60,
              ),
              validator: (val) {
                if (val!.isEmpty) return "Password cannot be empty";
              },
            );
          },
        ),
        space,
        Consumer<AuthScreenController>(
          builder: (context, controller, child) {
            return AuthTextField(
              controller: confirmPasswordController,
              label: "Confirm Password",
              visible: controller.showSignupConfirmPassword,
              suffixIcon: IconButton(
                  onPressed: () {
                    controller.showSignupConfirmPassword
                        ? controller.signupOffConfirmOffVisibility()
                        : controller.signupConfirmOnVisibility();
                  },
                  icon: controller.showSignupConfirmPassword
                      ? const Icon(Icons.visibility_off, color: Colors.white60)
                      : const Icon(
                          Icons.visibility,
                          color: Colors.white60,
                        )),
              prefixIcon: const Icon(
                Icons.security,
                color: Colors.white60,
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return "Textfield cannot be empty";
                } else if (passwordController.value !=
                    confirmPasswordController.value) {
                  return "password didn't match";
                } else {
                  return null;
                }
              },
            );
          },
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Consumer<AuthScreenController>(
              builder: (context, controller, child) {
                return IconButton(
                    onPressed: () {
                      if (controller.termsCondition) {
                        controller.declineTermsCondition();
                      } else {
                        controller.acceptTermsCondition();
                      }
                    },
                    icon: Icon(
                      controller.termsCondition
                          ? Icons.check_box
                          : Icons.check_box_outline_blank_outlined,
                      color: Colors.white60,
                    ));
              },
            ),
            const Text(
              'I accept all the Terms And Conditions ',
              style:
                  TextStyle(color: Colors.white60, fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            width: displayWidth(context) * 0.55,
            child: Consumer<AuthScreenController>(
              builder: (context, controller, child) {
                return MaterialButton(
                  onPressed: () async {
                    final sms = ScaffoldMessenger.of(context);
                    if (_formKey.currentState!.validate() &&
                        controller.signupStatus ==
                            AuthSignUpStatus.notLoading) {
                      if (controller.termsCondition) {
                        controller.startSigningUp();
                        final dynamic signupResponse = await _auth.signUp(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        controller.stopLogin();

                        if (signupResponse.runtimeType == UserCredential) {
                          // successfully created new account
                          controller.increaseRegistrationPageIndex();
                        } else {
                          sms.showSnackBar(
                            SnackBar(
                                content: Text(
                                  signupResponse!,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13.5),
                                ),
                                backgroundColor: authMaterialButtonColor),
                          );
                        }
                      } else {
                        sms.showSnackBar(const SnackBar(
                          content:
                              Text('Please accept the Terms And Conditions '),
                        ));
                      }
                    }
                  },
                  height: displayHeight(context) * 0.055,
                  color: authMaterialButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "Next",
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
    );
  }

  // Email validation page

  Widget validateEmailPage(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          verifyEmailIcon,
          height: displayHeight(context) * 0.25,
        ),
        const SizedBox(height: 20),
        const Text(
          "Please verify your email address",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: "Open"),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Text(
            "Almost there! We have sent a verification mail to ${emailController.text}. You need to verify your email address and then try to register.",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
              fontFamily: "Open",
            ),
          ),
        ),
        const SizedBox(height: 25),
        Center(
          child: SizedBox(
            width: displayWidth(context) * 0.55,
            child: Consumer<AuthScreenController>(
              builder: (context, controller, child) {
                return MaterialButton(
                  onPressed: () async {
                    controller.startSigningUp();
                    final navigator = Navigator.of(context);
                    final sms = ScaffoldMessenger.of(context);
                    final userController =
                        Provider.of<UserController>(context, listen: false);
                    await FirebaseAuth.instance.currentUser!.reload();
                    if (FirebaseAuth.instance.currentUser!.emailVerified) {
                      await userController.createUser(user.User(
                          draftArticles: [],
                          blocked: [],
                          emailVerified: false,
                          savedArticles: [],
                          cp: '',
                          name: nameController.text,
                          dp: '',
                          email: emailController.text,
                          followers: [],
                          userId: FirebaseAuth.instance.currentUser!.uid,
                          bio: '',
                          following: []));
                      controller.stopSigningUp();
                      navigator.pushReplacement(MaterialPageRoute(
                        builder: (context) => AppScreen(true),
                      ));
                    } else {
                      controller.stopSigningUp();
                      sms.showSnackBar(const SnackBar(
                          backgroundColor: authMaterialButtonColor,
                          content: Text(
                            "Please verify your email and try again !",
                            style: TextStyle(color: Colors.black),
                          )));
                    }
                  },
                  height: displayHeight(context) * 0.055,
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
    );
  }
}
