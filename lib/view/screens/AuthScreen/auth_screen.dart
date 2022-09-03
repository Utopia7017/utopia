import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/view/screens/AuthScreen/login_screen.dart';
import 'package:utopia/view/screens/AuthScreen/signup_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  final space = const SizedBox(height: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: authBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/image.png",
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
                  width: MediaQuery.of(context).size.width * 0.83,
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height * 0.055,
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
                  width: MediaQuery.of(context).size.width * 0.83,
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height * 0.055,
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
