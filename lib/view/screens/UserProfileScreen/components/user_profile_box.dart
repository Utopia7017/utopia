import 'package:firebase_auth/firebase_auth.dart' as firebaseuser;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/display_full_image.dart';
import 'package:utopia/view/common_ui/profile_detail_box.dart';
import 'package:utopia/view/screens/FollowersScreen/followers_screen.dart';
import 'package:utopia/view/screens/FollowingScreen/following_screen.dart';
import 'package:utopia/view/shimmers/user_follower_detail_shimmer.dart';
import '../../../../controller/articles_controller.dart';

class UserProfileBox extends StatelessWidget {
  final User user;
  UserProfileBox({
    super.key,
    required this.user,
  });

  String myUid = firebaseuser.FirebaseAuth.instance.currentUser!.uid;

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
    return Column(
      children: [
        SizedBox(
          height: displayHeight(context) * 0.58,
          width: displayWidth(context),
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  if (user.cp.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayFullImage(
                              caption: user.name, imageurl: user.cp),
                        ));
                  }
                },
                child: (user.cp.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: user.cp,
                        height: displayHeight(context) * 0.25,
                        width: displayWidth(context),
                        fit: BoxFit.fitWidth,
                      )
                    : Container(
                        height: displayHeight(context) * 0.25,
                        color: const Color.fromARGB(
                            255, 2, 1, 17), // rgba(2,1,17,255)
                        child: Image.asset(
                          'assets/images/utopia_banner.png',
                          width: displayWidth(context),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
              ),
              Positioned(
                  top: displayHeight(context) * 0.03,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_outlined),
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                  )),
              Positioned(
                left: displayWidth(context) * 0.05,
                right: displayWidth(context) * 0.05,
                top: displayHeight(context) * 0.18,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 1,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    height: displayHeight(context) * 0.38,
                    width: displayWidth(context) * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // user dp
                            InkWell(
                              onTap: () {
                                if (user.dp.isNotEmpty) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DisplayFullImage(
                                            caption: user.name,
                                            imageurl: user.dp),
                                      ));
                                }
                              },
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height: displayHeight(context) * 0.12,
                                      width: displayWidth(context) * 0.22,
                                      alignment: Alignment.center,
                                      child: initials.length > 1
                                          ? Text(
                                              "$firstLetter.$lastLetter"
                                                  .toUpperCase(),
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
                                        height: displayHeight(context) * 0.12,
                                        width: displayWidth(context) * 0.22,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: displayWidth(context) * 0.04,
                            ),
                            // user name and bio
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // color: Colors.red.shade100,
                                  constraints: BoxConstraints.tightForFinite(
                                    width: displayWidth(context) * 0.5,
                                  ),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          user.name,
                                          // "jkshkhkdhdkhkhhdshkfhjkdshfkhdskjhfkjdhkjfhjkhfkjhskfhdkjshfkjdhskfjhdskhfksdhfkshdkfhksdhkfhd",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                            // fontFamily: "Fira",
                                            fontSize: 18,
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
                                  height: 6,
                                ),
                                (user.bio.isNotEmpty)
                                    ? SizedBox(
                                        height: displayHeight(context) * 0.1,
                                        width: displayWidth(context) * 0.55,
                                        // color: Colors
                                        //     .blue.shade100,
                                        child: Text(
                                          user.bio,
                                          style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 12.2,
                                              wordSpacing: 0.4),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Consumer<UserController>(
                          builder: (context, userController, child) {
                            if (userController.followingUserStatus ==
                                FollowingUserStatus.no) {
                              return FutureBuilder(
                                future: Provider.of<ArticlesController>(context)
                                    .fetchThisUsersArticles(user.userId),
                                builder: (context,
                                    AsyncSnapshot<List<Article>> snapshot) {
                                  if (snapshot.hasData) {
                                    return Column(
                                      children: [
                                        Container(
                                          height: displayHeight(context) * 0.08,
                                          width: displayWidth(context) * 0.6,
                                          decoration: BoxDecoration(
                                              color: Colors.blue.shade100
                                                  .withOpacity(0.25),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          padding: const EdgeInsets.only(
                                              top: 4,
                                              left: 12,
                                              right: 12,
                                              bottom: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ProfileDetailBox(
                                                value: user.following.length,
                                                label: "Followings",
                                                callback: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FollowingScreen(
                                                              user: user),
                                                    )),
                                              ),
                                              ProfileDetailBox(
                                                value: user.followers.length,
                                                label: "Followers",
                                                callback: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FollowersScreen(
                                                              user: user),
                                                    )),
                                              ),
                                              ProfileDetailBox(
                                                value: snapshot.data!.length,
                                                label: "Articles",
                                                callback: () {},
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width:
                                                  displayWidth(context) * 0.3,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  elevation:
                                                      MaterialStateProperty.all(
                                                          2.5),
                                                  shape:
                                                      MaterialStateProperty.all(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8))),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.redAccent
                                                              .withOpacity(
                                                                  0.8)),
                                                ),
                                                onPressed: () {
                                                  QuickAlert.show(
                                                    context: context,
                                                    type:
                                                        QuickAlertType.confirm,
                                                    confirmBtnText: "Yes",
                                                    text: userController
                                                            .user!.blocked
                                                            .contains(
                                                                user.userId)
                                                        ? "Are you sure you want to unblock this user?"
                                                        : "Are you sure you want to block this user?",
                                                    title: userController
                                                            .user!.blocked
                                                            .contains(
                                                                user.userId)
                                                        ? "Confirm unblocking"
                                                        : "Confirm blocking",
                                                    onConfirmBtnTap: () {
                                                      if (userController
                                                          .user!.blocked
                                                          .contains(
                                                              user.userId)) {
                                                        userController
                                                            .unBlockThisUser(
                                                                user.userId);
                                                      } else {
                                                        userController
                                                            .blockThisUser(
                                                                user.userId);
                                                        userController
                                                            .unFollowUser(
                                                                userId: user
                                                                    .userId);
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  userController.user!.blocked
                                                          .contains(user.userId)
                                                      ? "Unblock"
                                                      : "Block",
                                                  style: TextStyle(
                                                      fontFamily: "",
                                                      letterSpacing: 0.4,
                                                      color: Colors.white
                                                          .withOpacity(0.85)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 25),
                                            SizedBox(
                                                width:
                                                    displayWidth(context) * 0.3,
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all(2.5),
                                                    shape: MaterialStateProperty
                                                        .all(RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8))),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                                authBackground),
                                                  ),
                                                  onPressed: () {
                                                    if (userController
                                                            .followingUserStatus ==
                                                        FollowingUserStatus
                                                            .no) {
                                                      if (user.followers
                                                          .contains(myUid)) {
                                                        userController
                                                            .unFollowUser(
                                                                userId: user
                                                                    .userId);
                                                      } else {
                                                        userController
                                                            .followUser(
                                                                userId: user
                                                                    .userId);
                                                      }
                                                    }
                                                  },
                                                  child: Text(
                                                    user.followers
                                                            .contains(myUid)
                                                        ? "Unfollow"
                                                        : "Follow",
                                                    style: TextStyle(
                                                        fontFamily: "",
                                                        letterSpacing: 0.4,
                                                        color: Colors.white
                                                            .withOpacity(0.85)),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ],
                                    );
                                  } else {
                                    return UserFollowerDetailShimmer();
                                  }
                                },
                              );
                            } else {
                              return UserFollowerDetailShimmer();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
