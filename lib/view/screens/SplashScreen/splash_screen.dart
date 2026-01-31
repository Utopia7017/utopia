import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/view/screens/UtopiaRoot/utopia_root.dart';
import 'package:in_app_update/in_app_update.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (!kDebugMode) {
      checkForUpdate();
    } else {
      navigateToHome();
    }
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) async {
      // print(info.packageName);
      // print(info.availableVersionCode);

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        AppUpdateResult updateResult =
            await InAppUpdate.performImmediateUpdate();

        if (updateResult == AppUpdateResult.userDeniedUpdate ||
            updateResult == AppUpdateResult.inAppUpdateFailed) {
          await Future.delayed(const Duration(seconds: 2));
          checkForUpdate();
        } else {
          navigateToHome();
        }
      } else {
        navigateToHome();
      }
    }).catchError((e) {
      if (kDebugMode) {
        print("Update check error: " + e.toString());
      }
      navigateToHome();
    });
  }

  navigateToHome() async {
    if (mounted) {
      final navigator = Navigator.of(context);
      bool internetConnection =
          await InternetConnectionChecker.createInstance().hasConnection;

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
