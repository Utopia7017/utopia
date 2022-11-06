import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/UserProfileScreen/user_profile_screen.dart';
import 'package:utopia/view/shimmers/follower_shimmer.dart';

class FollowersScreen extends StatelessWidget {
  final User user;
  FollowersScreen({Key? key, required this.user}) : super(key: key);

  String currentuserid = firebase.FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: authBackground,
        title: const Text(
          'Followers',
          style: TextStyle(fontFamily: "Fira", fontSize: 15),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            return await Future.delayed(const Duration(seconds: 2));
          },
          backgroundColor: authBackground,
          color: Colors.white,
          child: Consumer<UserController>(
            builder: (context, controller, child) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    builder: (context, AsyncSnapshot<User?> snapshot) {
                      if (snapshot.hasData) {
                        User followerUser = snapshot.data!;
                        List<String> initials = followerUser.name.split(" ");
                        String firstLetter = "", lastLetter = "";

                        if (initials.length == 1) {
                          firstLetter = initials[0].characters.first;
                        } else {
                          firstLetter = initials[0].characters.first;
                          lastLetter = initials[1].characters.first;
                        }
                        return ListTile(
                          visualDensity: const VisualDensity(vertical: 2.5),
                          onTap: () {
                            if (currentuserid != followerUser.userId) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserProfileScreen(
                                        userId: followerUser.userId),
                                  ));
                            }
                          },
                          leading: (followerUser.dp.isEmpty)
                              ? CircleAvatar(
                                  backgroundColor: authMaterialButtonColor,
                                  child: Center(
                                    child: initials.length > 1
                                        ? Text(
                                            "$firstLetter.$lastLetter"
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          )
                                        : Text(
                                            firstLetter.toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      followerUser.dp),
                                ),
                          title: Row(
                            children: [
                              Text(followerUser.name),
                              const SizedBox(
                                width: 5,
                              ),
                              followerUser.isVerified
                                  ? Image.asset(
                                      verifyIcon,
                                      height: 17.5,
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          dense: true,
                          trailing: (currentuserid == user.userId)
                              ? MaterialButton(
                                  onPressed: () {
                                    controller.unFollowUser(
                                        userId: user.userId);
                                  },
                                  height: 30,
                                  color: authMaterialButtonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Remove',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                )
                              : null,
                        );
                      } else {
                        return const FollowerShimmer();
                      }
                    },
                    future: controller.getUser(user.followers[index]),
                  );
                },
                itemCount: user.followers.length,
              );
            },
          )),
    );
  }
}
