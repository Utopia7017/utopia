import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:utopia/view/screens/AboutUtopiaScreens/terms_of_use_screen.dart';
import 'package:utopia/view/screens/AuthScreen/auth_screen.dart';
import 'package:utopia/view/screens/AuthScreen/login_screen.dart';
import 'package:utopia/view/screens/AuthScreen/signup_screen.dart';
import 'package:utopia/view/screens/BlockedUsersScreen/blocked_users_screen.dart';
import 'package:utopia/view/screens/MyArticlesScreen/my_articles_screen.dart';
import 'package:utopia/view/screens/NewArticleScreen/new_article_screen.dart';
import 'package:utopia/view/screens/NotificationScreen/notification_screen.dart';
import 'package:utopia/view/screens/AboutUtopiaScreens/privacy_policy_screen.dart';
import 'package:utopia/view/screens/ProfileScreen/profile_screen.dart';
import 'package:utopia/view/screens/SavedArticlesScreen/saved_article_screen.dart';
import 'package:utopia/view/screens/SearchScreen/search_screen.dart';
import 'package:utopia/view/screens/SplashScreen/splash_screen.dart';
import 'controller/articles_controller.dart';
import 'controller/auth_screen_controller.dart';
import 'controller/my_articles_controller.dart';
import 'controller/user_controller.dart';
import 'services/firebase/auth_services.dart';
import 'services/firebase/firebase_user_service.dart';
import 'utils/global_context.dart';
import 'package:flutter/services.dart';

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
  ErrorWidget.builder = (FlutterErrorDetails details) => Material(
        color: Colors.green.shade200,
        child: Center(
          child: Text(
            details.exception.toString(),
            style: const TextStyle(
              fontFamily: "Fira",
              color: Colors.white,
            ),
          ),
        ),
      );
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
        ChangeNotifierProvider(
          create: (context) => ArticlesController(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyArticlesController(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: GlobalContext.contextKey, // global context
        debugShowCheckedModeBanner: false,
        routes: {
     
          '/auth': (context) => const AuthScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/newArticle': (context) => NewArticleScreen(),
          '/myArticles': (context) => MyArticleScreen(),
          '/savedArticles': (context) => SavedArticlesScreen(),
          '/search': (context) => SearchScreen(),
          '/notifications': (context) => NotificationScreen(),
          '/blockedUsers':(context) => BlockedUsersScreen(),
          '/privacyPolicy':(context) => PrivacyPolicyScreen(),
          '/terms':(context) => TermsOfUseScreen(),
        },

        home: const SplashScreen(),
        // home: NoConnectionScreen(),
      ),
    );
  }
}
