import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controlller/user_controller.dart';
import 'package:utopia/enums/enums.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  final space = const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryBackgroundColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        backgroundColor: primaryBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Consumer<UserController>(
            builder: (context, controller, child) {
              switch (controller.profileStatus) {
                case ProfileStatus.nil:
                  return Center(
                    child: MaterialButton(
                      color: authMaterialButtonColor,
                      onPressed: () {
                        controller
                            .setUser(FirebaseAuth.instance.currentUser!.uid);
                      },
                      child: const Text('Refresh Profile'),
                    ),
                  );
                case ProfileStatus.loading:
                  return const Center(
                    child: CircularProgressIndicator(
                        color: authMaterialButtonColor),
                  );
                case ProfileStatus.fetched:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () {},
                          child: const CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(
                                'https://i.pinimg.com/564x/17/b0/8f/17b08fc3ad0e62df60e15ef557ec3fe1.jpg'),
                          ),
                        ),
                      ),
                      space,
                      Text(
                        controller.user!.name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        controller.user!.email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      space,
                      Text(
                        controller.user!.bio,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      space,
                      space,
                      MaterialButton(
                        onPressed: () {},
                        child: Text("Follow"),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 45.3, vertical: 20),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  controller.user!.following.length.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Following",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 18,
                            ),
                            Text(
                              "|",
                              style: TextStyle(
                                  fontSize: 30, color: Colors.blueGrey),
                            ),
                            SizedBox(
                              width: 18,
                            ),
                            Column(
                              children: [
                                Text(
                                  controller.user!.followers.length.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Followers",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey),
                                ),
                              ],
                            ),
                            SizedBox(width: 18),
                            Text(
                              "|",
                              style: TextStyle(
                                  fontSize: 30, color: Colors.blueGrey),
                            ),
                            SizedBox(width: 18),
                            Column(
                              children: [
                                Text(
                                  "35",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Articles",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
