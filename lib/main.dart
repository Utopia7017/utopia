import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:utopia/configs/provider_logger.dart';
import 'package:utopia/view/screens/AboutUtopiaScreens/help_screen.dart';
import 'package:utopia/view/screens/AboutUtopiaScreens/terms_of_use_screen.dart';
import 'package:utopia/view/screens/AuthScreen/auth_screen.dart';
import 'package:utopia/view/screens/AuthScreen/login_screen.dart';
import 'package:utopia/view/screens/AuthScreen/signup_screen.dart';
import 'package:utopia/view/screens/BlockedUsersScreen/blocked_users_screen.dart';
import 'package:utopia/view/screens/MyArticlesScreen/my_articles_screen.dart';
import 'package:utopia/view/screens/NewArticleScreen/new_article_screen.dart';
import 'package:utopia/view/screens/NotificationScreen/notification_screen.dart';
import 'package:utopia/view/screens/AboutUtopiaScreens/privacy_policy_screen.dart';
import 'package:utopia/view/screens/PopularAuthors/popular_authors.dart';
import 'package:utopia/view/screens/ProfileScreen/profile_screen.dart';
import 'package:utopia/view/screens/SavedArticlesScreen/saved_article_screen.dart';
import 'package:utopia/view/screens/SearchScreen/search_screen.dart';
import 'package:utopia/view/screens/SplashScreen/splash_screen.dart';
import 'utils/global_context.dart';
import 'package:flutter/services.dart';

/*
  Project Name : Utoppia - 
  Project Authors : Subhojeet Sahoo, Vishal Mahato , Abhishek Kumar 
  Creation Date : 2nd Sep, 2022

  
  Copyright © 2022 Utopia
  Being Open Source doesn't mean you can just make a copy of the app and upload it on playstore or sell
  a closed source copy of the same.
  
  Read the following carefully:
  1. Any copy of a software under GPL must be under same license. So you can't upload the app on a closed source
  app repository like PlayStore/AppStore without distributing the source code.
  
  2. You can't sell any copied/modified version of the app under any "non-free" license.
   You must provide the copy with the original software or with instructions on how to obtain original software,
   should clearly state all changes, should clearly disclose full source code, should include same license
   and all copyrights should be retained.
  In simple words, You can ONLY use the source code of this app for `Open Source` Project under `GPL v3.0` or later
  with all your source code CLEARLY DISCLOSED on any code hosting platform like GitHub, with clear INSTRUCTIONS on
  how to obtain the original software, should clearly STATE ALL CHANGES made and should RETAIN all copyrights.
  
  Use of this software under any "non-free" license is NOT permitted.

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
  runApp(ProviderScope(
    observers: [
      ProviderLogger(),
    ],
    child: const Utopia(),
  ));
}

class Utopia extends StatelessWidget {
  const Utopia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      navigatorKey: GlobalContext.contextKey, // global context
      debugShowCheckedModeBanner: false,
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/newArticle': (context) => NewArticleScreen(),
        '/myArticles': (context) => MyArticleScreen(),
        '/popAuthors': (context) => PopularAuthors(),
        '/savedArticles': (context) => SavedArticlesScreen(),
        '/search': (context) => SearchScreen(),
        '/notifications': (context) => NotificationScreen(),
        '/blockedUsers': (context) => BlockedUsersScreen(),
        '/privacyPolicy': (context) => PrivacyPolicyScreen(),
        '/terms': (context) => TermsOfUseScreen(),
        '/help': (context) => HelpScreen(),
      },

      home: const SplashScreen(),
      // home: NoConnectionScreen(),
    );
  }
}
