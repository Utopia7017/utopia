import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:utopia/controlller/articles_controller.dart';
import 'package:utopia/controlller/auth_screen_controller.dart';
import 'package:utopia/controlller/user_controller.dart';
import 'package:utopia/view/screens/AppScreen/app_screen.dart';
import 'package:utopia/view/screens/AuthScreen/auth_screen.dart';
import 'package:utopia/view/screens/AuthScreen/login_screen.dart';
import 'package:utopia/view/screens/AuthScreen/signup_screen.dart';
import 'package:utopia/view/screens/NewArticleScreen/new_article_screen.dart';
import 'services/firebase/auth_services.dart';
import 'services/firebase/firebase_user_service.dart';

/*
  Project Name : Utoppia - 
  Project Authors : { Subhojeet Sahoo, Vishal Mahato , Abhishek Kumar }
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
    return MultiProvider(
      providers: [
        // Auth Controllers
        ChangeNotifierProvider(
          create: (context) => AuthNotifier(),
        ),
        Provider<Authservice>(
            create: (_) => Authservice(FirebaseAuth.instance)),
        StreamProvider(
          create: (context) => context.read<Authservice>().austhStateChanges,
          initialData: null,
        ),
        // Screen Controllers
        ChangeNotifierProvider(
          create: (context) => AuthScreenController(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserController(),
        ),
        ChangeNotifierProvider(create: (context) => ArticlesController(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/auth': (context) => AuthScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/app': (context) => AppScreen(),
          '/newArticle':(context) => NewArticleScreen(),
        },
        home: Consumer<AuthNotifier>(
          builder: (context, notifier, child) {
            return notifier.user != null ? AppScreen() : const Wrapper();
          },
        ),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return AppScreen();
    } else {
      return const AuthScreen();
    }
  }
}
