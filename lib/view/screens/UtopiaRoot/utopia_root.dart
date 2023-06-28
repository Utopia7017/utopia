import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utopia/constants/string_constants.dart';
import 'package:utopia/view/screens/AppScreen/app_screen.dart';
import 'package:utopia/view/screens/AuthScreen/auth_screen.dart';

class UtopiaRoot extends StatelessWidget {
  bool internetConnected;
  UtopiaRoot({super.key, required this.internetConnected});
  Future<SharedPreferences> getPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPreferences(),
      builder: (context, AsyncSnapshot<SharedPreferences> preferences) {
        if (preferences.connectionState == ConnectionState.active ||
            preferences.connectionState == ConnectionState.done) {
          if (preferences.hasData && preferences.data != null) {
            if (preferences.data!.containsKey(loginStatePreference) &&
                preferences.data!.getBool(loginStatePreference)!) {
              return AppScreen(internetConnected);
            } else {
              return AuthScreen();
            }
          } else {
            return AuthScreen();
          }
        }
        return AuthScreen();
      },
    );
  }
}
