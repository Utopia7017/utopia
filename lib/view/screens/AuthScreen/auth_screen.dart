import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/auth_screen_controller.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/services/api/api_services.dart';
import 'package:utopia/services/firebase/auth_services.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/models/user_model.dart' as um;
import 'package:utopia/view/screens/AppScreen/app_screen.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);
  final space = const SizedBox(height: 30);
  final Authservice _auth = Authservice(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: authBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                loginLogo,
                height: MediaQuery.of(context).size.height * 0.35,
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
              // SizedBox(
              //   height: displayHeight(context) * 0.07,
              // ),
              SizedBox(
                height: displayHeight(context) * 0.14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(
                      child: Divider(
                        color: authMaterialButtonColor,
                        indent: 15,
                        endIndent: 15,
                      ),
                    ),
                    Text(
                      "OR",
                      style: TextStyle(
                        color: authMaterialButtonColor,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: authMaterialButtonColor,
                        indent: 15,
                        endIndent: 15,
                      ),
                    ),
                  ],
                ),
              ),

              Consumer<AuthScreenController>(
                builder: (context, controller, child) {
                  switch (controller.loginStatus) {
                    case AuthLoginStatus.loading:
                      return const CircularProgressIndicator(
                        color: authMaterialButtonColor,
                      );
                    case AuthLoginStatus.notloading:
                      return Center(
                        child: FloatingActionButton.extended(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          icon: Image.asset(
                            "assets/images/googlelogo.png",
                            width: 21,
                            height: 21,
                          ),
                          label: const Text(
                            "Sign in with Google",
                            style: TextStyle(
                                fontSize: 12.5,
                                fontFamily: "Open",
                                letterSpacing: 0.5),
                          ),
                          onPressed: () async {
                            final userProvider = Provider.of<UserController>(
                                context,
                                listen: false);
                            final nav = Navigator.of(context);
                            controller.startLogin();
                            final gres = await _auth.googleLogin();
                            controller.stopLogin();

                            if (gres.runtimeType == UserCredential) {
                              UserCredential gresCred = gres as UserCredential;
                              final Response? response = await ApiServices()
                                  .get(
                                      endUrl:
                                          'users/${gresCred.user!.uid}.json');
                              if (response == null || response.data == null) {
                                um.User user = um.User(
                                    name: gresCred.user!.displayName!,
                                    dp: gresCred.user!.photoURL!,
                                    email: gresCred.user!.email!,
                                    blockedBy: [],
                                    blocked: [],
                                    followers: [],
                                    userId: gresCred.user!.uid,
                                    bio: 'I am new to Utopia',
                                    cp: '',
                                    draftArticles: [],
                                    savedArticles: [],
                                    isVerified: true,
                                    following: []);
                                await userProvider.createUser(user);
                              }

                              nav.pushReplacement(MaterialPageRoute(
                                builder: (context) => AppScreen(true),
                              ));
                            } else {}
                          },
                        ),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
