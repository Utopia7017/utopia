import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/user_model.dart' as user;
import 'package:utopia/services/firebase/auth_services.dart' as firebase;
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/helper_widgets.dart';
import 'package:utopia/view/common_ui/auth_textfields.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/view/screens/AboutUtopiaScreens/terms_of_use_screen.dart';
import 'package:utopia/view/screens/AppScreen/app_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  final String? alreadyProvidedEmail;
  SignUpScreen({this.alreadyProvidedEmail});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  WidgetRef get ref => super.ref;

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
  void initState() {
    super.initState();
    if (widget.alreadyProvidedEmail != null) {
      emailController =
          TextEditingController(text: widget.alreadyProvidedEmail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    dataController.authState.registrationPageIndex == 2
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () =>
                                controller.decreaseRegistrationPageIndex(),
                            icon: const Icon(Icons.keyboard_backspace_outlined),
                            color: Colors.white,
                          )
                        : const SizedBox(),
                    Text(
                      '( ${dataController.authState.registrationPageIndex.toString()}/2 )',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                dataController.authState.registrationPageIndex == 1
                    ? formPage(context)
                    : validateEmailPage(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Form page - 1
  Widget formPage(BuildContext context) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
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
          maxLength: 20,
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
        const SizedBox(
          height: 10,
        ),
        AuthTextField(
          readOnly: widget.alreadyProvidedEmail != null ? true : false,
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
        AuthTextField(
          controller: passwordController,
          label: "Password",
          visible: dataController.authState.showSignupPassword,
          suffixIcon: IconButton(
              onPressed: () {
                dataController.authState.showSignupPassword
                    ? controller.signupOffVisibility()
                    : controller.signupOnVisibility();
              },
              icon: dataController.authState.showSignupPassword
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
        ),
        space,
        AuthTextField(
          controller: confirmPasswordController,
          label: "Confirm Password",
          visible: dataController.authState.showSignupConfirmPassword,
          suffixIcon: IconButton(
              onPressed: () {
                dataController.authState.showSignupConfirmPassword
                    ? controller.signupConfirmOffVisibility()
                    : controller.signupConfirmOnVisibility();
              },
              icon: dataController.authState.showSignupConfirmPassword
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
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  if (dataController.authState.termsCondition) {
                    controller.declineTermsCondition();
                  } else {
                    controller.acceptTermsCondition();
                  }
                },
                icon: Icon(
                  dataController.authState.termsCondition
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_outlined,
                  color: Colors.white60,
                )),
            Row(
              children: [
                const Text(
                  'I accept the',
                  style: TextStyle(
                      color: Colors.white60, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsOfUseScreen(),
                        ));
                  },
                  child: const Text(
                    'Terms and conditions',
                    style: TextStyle(color: authMaterialButtonColor),
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
              width: displayWidth(context) * 0.55,
              child: MaterialButton(
                onPressed: () async {
                  // final sms = ScaffoldMessenger.of(context);
                  if (_formKey.currentState!.validate() &&
                      dataController.authState.signupStatus ==
                          AuthSignUpStatus.NOT_LOADING) {
                    if (dataController.authState.termsCondition) {
                      controller.startSigningUp();
                      final dynamic signupResponse = await _auth.signUp(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      controller.stopSigningUp();

                      if (signupResponse.runtimeType == UserCredential) {
                        // successfully created new account
                        controller.increaseRegistrationPageIndex();
                      } else {
                        showCustomSnackBar(
                            context: context, text: signupResponse);
                      }
                    } else {
                      showCustomSnackBar(
                          context: context,
                          text: 'Please accept the Terms And Conditions ');
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
              )),
        ),
        space,
        dataController.authState.signupStatus == AuthSignUpStatus.LOADING
            ? const Center(
                child: CircularProgressIndicator(
                  color: authMaterialButtonColor,
                ),
              )
            : const SizedBox()
      ],
    );
  }

  // Email validation page -2
  Widget validateEmailPage(BuildContext context) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
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
            "Almost there! We have sent a verification mail to ${emailController.text}. You need to verify your email address and then try to register.\n\n (Do check your spam folders as well)",
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
            child: MaterialButton(
              onPressed: () async {
                controller.startSigningUp();
                final navigator = Navigator.of(context);
                final sms = ScaffoldMessenger.of(context);

                await FirebaseAuth.instance.currentUser!.reload();
                if (FirebaseAuth.instance.currentUser!.emailVerified) {
                  await controller.createUser(user.User(
                      blockedBy: [],
                      draftArticles: [],
                      blocked: [],
                      isVerified: false,
                      savedArticles: [],
                      cp: '',
                      name: nameController.text.trim(),
                      dp: '',
                      email: emailController.text,
                      followers: [],
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      bio: 'I am new to Utopia',
                      following: []));
                  controller.stopSigningUp();
                  navigator.pushReplacement(MaterialPageRoute(
                    builder: (context) => AppScreen(true),
                  ));
                } else {
                  controller.stopSigningUp();

                  showCustomSnackBar(
                      context: context,
                      text: "Please verify your email and try again !");
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
            ),
          ),
        ),
        space,
        dataController.authState.signupStatus == AuthSignUpStatus.LOADING
            ? const Center(
                child: CircularProgressIndicator(
                  color: authMaterialButtonColor,
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
