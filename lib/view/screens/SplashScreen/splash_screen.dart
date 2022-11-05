import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/view/screens/UtopiaRoot/utopia_root.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  navigateToHome() async {
    if (mounted) {
      final navigator = Navigator.of(context);
      bool internetConnection = await InternetConnectionChecker().hasConnection;

      await Future.delayed(const Duration(seconds: 1));
      navigator.pushReplacement(MaterialPageRoute(
        builder: (context) => UtopiaRoot(internetConnected: internetConnection),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: authBackground,
      body: Center(
        child: Image.asset(splashGif),
      ),
    );
  }
}
