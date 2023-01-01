import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/common_api_calls.dart';
import 'package:utopia/view/screens/UserProfileScreen/user_profile_screen.dart';
import 'package:utopia/view/shimmers/follower_shimmer.dart';

import '../../../utils/device_size.dart';

class FollowersScreen extends ConsumerWidget {
  final User user;
  FollowersScreen({Key? key, required this.user}) : super(key: key);

  String currentuserid = firebase.FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
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
            child: dataController.userState.followingUserStatus ==
                    FollowingUserStatus.YES
                ? const FollowerShimmer()
                : user.followers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              noArticleFoundIcon,
                              height: displayHeight(context) * 0.1,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "No followers found",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Open"),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                            builder: (context, AsyncSnapshot<User?> snapshot) {
                              if (snapshot.hasData) {
                                User followerUser = snapshot.data!;
                                List<String> initials =
                                    followerUser.name.split(" ");
                                String firstLetter = "", lastLetter = "";

                                if (initials.length == 1) {
                                  firstLetter = initials[0].characters.first;
                                } else {
                                  firstLetter = initials[0].characters.first;
                                  lastLetter = initials[1].characters.first;
                                }
                                return ListTile(
                                  visualDensity:
                                      const VisualDensity(vertical: 2.5),
                                  onTap: () {
                                    if (currentuserid != followerUser.userId) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfileScreen(
                                                    userId:
                                                        followerUser.userId),
                                          ));
                                    }
                                  },
                                  leading: (followerUser.dp.isEmpty)
                                      ? CircleAvatar(
                                          backgroundColor:
                                              authMaterialButtonColor,
                                          child: Center(
                                            child: initials.length > 1
                                                ? Text(
                                                    "$firstLetter.$lastLetter"
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    firstLetter.toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  ),
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
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
                                            controller.removeFollower(
                                                followerUser.userId,
                                                currentuserid);
                                          },
                                          height: 30,
                                          color: authMaterialButtonColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
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
                            future: getUser(user.followers[index]),
                          );
                        },
                        itemCount: user.followers.length,
                      )));
  }
}
