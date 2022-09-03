import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:utopia/view/screens/AppScreen/app_screen.dart';
import 'package:utopia/view/screens/AuthScreen/auth_screen.dart';
import 'package:utopia/view/screens/AuthScreen/signup_screen.dart';

/*
  Project Name : Utoppia - 
  Project Authors : { Subhojeet Sahoo, Gurudev Singh , Vishal Mahato , Abhishek Kumar }
  Creation Date : 2nd Sep, 2022
  Project Aim : Building Blogging application for learning purpose.
*/

void main() async {
  // logger configuration
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint(
        '${record.loggerName} -> ${record.level.name}: ${record.message}');
  });
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Logger("Root").fine("Utopia Initialised");
  runApp(Utopia());
}

class Utopia extends StatelessWidget {
  const Utopia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen();
    );
  }
}
