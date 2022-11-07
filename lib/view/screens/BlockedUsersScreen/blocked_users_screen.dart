import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseUser;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/UserProfileScreen/user_profile_screen.dart';
import 'package:utopia/view/shimmers/follower_shimmer.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: authBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Blocked users",
          style: TextStyle(fontFamily: "Open", fontSize: 14),
        ),
      ),
      body: SafeArea(
        child: Consumer<UserController>(
          builder: (context, userController, child) {
            if (userController.profileStatus == ProfileStatus.nil) {
              userController
                  .setUser(firebaseUser.FirebaseAuth.instance.currentUser!.uid);
            }
            switch (userController.profileStatus) {
              case ProfileStatus.nil:
                return const Text("Pull to refresh");
              case ProfileStatus.loading:
                // Todo : add shimmer effect for this screen
                return const FollowerShimmer();

              case ProfileStatus.fetched:
                if (userController.user!.blocked.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          noArticleFoundIcon,
                          height: displayHeight(context) * 0.1,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "No users found",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontFamily: "Open"),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 6),
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: userController
                          .getUser(userController.user!.blocked[index]),
                      builder: (context, AsyncSnapshot<User?> snapshot) {
                        if (snapshot.hasData) {
                          User blockedUser = snapshot.data!;
                          List<String> initials = blockedUser.name.split(" ");
                          String firstLetter = "", lastLetter = "";

                          if (initials.length == 1) {
                            firstLetter = initials[0].characters.first;
                          } else {
                            firstLetter = initials[0].characters.first;
                            lastLetter = initials[1].characters.first;
                          }
                          return ListTile(
                            onTap: () {},
                            leading: (blockedUser.dp.isEmpty)
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
                                        blockedUser.dp),
                                  ),
                            title: Row(
                              children: [
                                Text(blockedUser.name),
                                const SizedBox(
                                  width: 5,
                                ),
                                blockedUser.isVerified
                                    ? Image.asset(
                                        verifyIcon,
                                        height: 17.5,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            dense: true,
                            trailing: MaterialButton(
                              elevation: 1,
                              onPressed: () {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  confirmBtnText: "Yes",
                                  text:
                                      "Are you sure you want to unblock this user?",
                                  title: "Confirm unblocking",
                                  onConfirmBtnTap: () {
                                    userController
                                        .unBlockThisUser(blockedUser.userId);

                                    Navigator.pop(context);
                                  },
                                );
                              },
                              height: 30,
                              color: authMaterialButtonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Unblock',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const FollowerShimmer();
                        }
                      },
                    );
                  },
                  itemCount: userController.user!.blocked.length,
                );
            }
          },
        ),
      ),
    );
  }
}
