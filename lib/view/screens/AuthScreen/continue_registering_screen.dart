import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/helper_widgets.dart';
import 'package:utopia/view/common_ui/auth_textfields.dart';
import 'package:utopia/models/user_model.dart' as user;
import 'package:utopia/view/screens/AppScreen/app_screen.dart';

class ContinueRegisteringScreen extends ConsumerStatefulWidget {
  final String emailProvided;
  ContinueRegisteringScreen({super.key, required this.emailProvided});

  @override
  ConsumerState<ContinueRegisteringScreen> createState() =>
      _ContinueRegisteringScreenState();
}

class _ContinueRegisteringScreenState
    extends ConsumerState<ContinueRegisteringScreen> {
  late TextEditingController emailController;

  TextEditingController nameController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.emailProvided);
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Row(
                children: const [
                  Text(
                    "Complete your registration",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      fontFamily: "Play",
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ],
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
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                  width: displayWidth(context) * 0.55,
                  child: MaterialButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        controller.startSigningUp();
                        final navigator = Navigator.of(context);

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
