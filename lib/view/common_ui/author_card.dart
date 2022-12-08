import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/UserProfileScreen/user_profile_screen.dart';

class AuthorCard extends StatelessWidget {
  User user;
  AuthorCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    List<String> initials = user.name.split(" ");
    String firstLetter = "", lastLetter = "";

    if (initials.length == 1) {
      firstLetter = initials[0].characters.first;
    } else {
      firstLetter = initials[0].characters.first;
      lastLetter = initials[1].characters.first;
    }
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(userId: user.userId),
            ));
      },
      child: Container(
        width: displayWidth(context) * 0.6,
        // height: displayHeight(context) * 0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: displayHeight(context) * 0.26,
              // color: Colors.blue,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: user.cp.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: user.cp,
                              height: displayHeight(context) * 0.2,
                              width: displayWidth(context),
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/utopia_banner.png',
                              height: displayHeight(context) * 0.2,
                              width: displayWidth(context),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    top: displayHeight(context) * 0.15,
                    child: (user.dp.isEmpty)
                        ? Container(
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0xfb7F7FD5),
                                      Color(0xfb86A8E7),
                                      Color(0xfb91EAE4),
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight),
                                borderRadius: BorderRadius.circular(10)),
                            height: displayHeight(context) * 0.1,
                            width: displayWidth(context) * 0.2,
                            alignment: Alignment.center,
                            child: initials.length > 1
                                ? Text(
                                    "$firstLetter.$lastLetter".toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  )
                                : Text(
                                    firstLetter.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: user.dp,
                              height: displayHeight(context) * 0.1,
                              width: displayWidth(context) * 0.2,
                              fit: BoxFit.cover,
                            ),
                          ),
                  )
                ],
              ),
            ),
            Container(
              // color: Colors.red.shade100,
              constraints: BoxConstraints.tightForFinite(
                width: displayWidth(context) * 0.5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Fira",
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  (user.isVerified)
                      ? Image.asset(
                          verifyIcon,
                          height: 15,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              // color: Colors.blue.shade100,
              height: displayHeight(context) * 0.07,
              padding: const EdgeInsets.only(left: 6.0, right: 6.0),
              child: Text(
                user.bio,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.blueGrey, fontSize: 13.5, wordSpacing: 0.4),
              ),
            ),
            Consumer<UserController>(
              builder: (context, userController, child) {
                return SizedBox(
                  width: displayWidth(context) * 0.32,
                  child: MaterialButton(
                    height: displayHeight(context) * 0.04,
                    onPressed: () {
                      if (userController.followingUserStatus ==
                          FollowingUserStatus.no) {
                        if (user.followers
                            .contains(userController.user!.userId)) {
                          userController.unFollowUser(userId: user.userId);
                        } else {
                          userController.followUser(userId: user.userId);
                        }
                      }
                    },
                    color: authBackground,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      user.followers.contains(userController.user!.userId)
                          ? "Unfollow"
                          : "Follow",
                      style: TextStyle(
                          fontFamily: "",
                          letterSpacing: 0.4,
                          fontSize: 13.5,
                          color: Colors.white.withOpacity(0.85)),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
