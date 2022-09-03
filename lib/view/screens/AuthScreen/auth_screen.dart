import 'package:flutter/material.dart';
import 'package:utopia/view/screens/AuthScreen/login_screen.dart';
import 'package:utopia/view/screens/AuthScreen/signup_screen.dart';

import '../../../constants/color_constants.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  final space = const SizedBox(height: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: authBackground,
      body: Column(
        children: [
          Image.asset(
            "assets/image.png",
            height: 500,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          const Text(
            "Hey! Welcome",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Play",
                letterSpacing: 1.2,
                color: Colors.white),
          ),
          Text(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                color: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Login ",
                  style: TextStyle(fontSize: 15.5),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.83,
              child: MaterialButton(
                height: MediaQuery.of(context).size.height * 0.055,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "I already have an account",
                  style: TextStyle(
                    fontSize: 15.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
