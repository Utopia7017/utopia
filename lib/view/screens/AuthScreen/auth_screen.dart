import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/device_size.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({Key? key}) : super(key: key);
  final space = const SizedBox(height: 30);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(stateController.notifier);
    final displayController = ref.watch(stateController);
    return Scaffold(
      backgroundColor: authBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                loginLogo,
                height: MediaQuery.of(context).size.height * 0.6,
                fit: BoxFit.contain,
              ),
              const Text(
                "Hey! Welcome",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontFamily: "Play",
                    letterSpacing: 1.2,
                    color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                "We keep connecting ideas and people",
                style: TextStyle(color: Colors.white),
              ),
              space,
              Center(
                child: SizedBox(
                  width: displayWidth(context) * 0.83,
                  child: MaterialButton(
                    height: displayHeight(context) * 0.055,
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    color: Colors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 15.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  width: displayWidth(context) * 0.83,
                  child: MaterialButton(
                    height: displayHeight(context) * 0.055,
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 15.5,
                      ),
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
