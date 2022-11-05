import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/services/firebase/auth_services.dart';
import 'package:utopia/utils/all_controllers.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/global_context.dart';
import 'package:utopia/utils/helper_widgets.dart';
import 'package:utopia/utils/image_picker.dart';
import 'package:utopia/view/common_ui/display_full_image.dart';
import 'package:utopia/view/common_ui/profile_detail_box.dart';
import 'package:utopia/view/screens/FollowersScreen/followers_screen.dart';
import 'package:utopia/view/screens/FollowingScreen/following_screen.dart';
import 'package:utopia/view/screens/MyArticlesScreen/my_articles_screen.dart';
import 'package:utopia/view/screens/ProfileScreen/components/edit_profile_dialogbox.dart';
import 'package:utopia/view/screens/ProfileScreen/components/request_verification.dart';
import 'package:utopia/view/screens/ProfileScreen/components/update_password.dart';
import 'package:utopia/view/shimmers/my_followers_box_shimmer.dart';
import '../../../../controller/articles_controller.dart';

class ProfileBox extends StatelessWidget {
  final User user;
  ProfileBox({
    super.key,
    required this.user,
  });

  final textStyle = const TextStyle(fontFamily: "Open", fontSize: 15);
  final Authservice _auth = Authservice(firebase.FirebaseAuth.instance);

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
                onTap: () async {
                  // update cover photo
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            (user.cp.isNotEmpty)
                                ? ListTile(
                                    visualDensity:
                                        const VisualDensity(vertical: -2),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DisplayFullImage(
                                                    caption: user.name,
                                                    imageurl: user.cp),
                                          ));
                                    },
                                    title: Text(
                                      'View Cover Photo',
                                      style: textStyle,
                                    ),
                                  )
                                : const SizedBox(),
                            ListTile(
                              visualDensity: const VisualDensity(vertical: -2),
                              onTap: () async {
                                final sms = ScaffoldMessenger.of(context);
                                final userController =
                                    Provider.of<UserController>(context,
                                        listen: false);
                                XFile? pickCoverPhoto =
                                    await pickImage(context);
                                if (pickCoverPhoto != null) {
                                  CroppedFile? croppedFile = await cropImage(
                                      File(pickCoverPhoto.path));
                                  if (croppedFile != null) {
                                    userController
                                        .changeCoverPhoto(croppedFile);
                                  } else {
                                    // nothing to be done
                                  }
                                } else {
                                  sms.showSnackBar(const SnackBar(
                                      content: Text("No image picked")));
                                }
                              },
                              title: Text(
                                'Change Cover Photo',
                                style: textStyle,
                              ),
                            ),
                            (user.cp.isNotEmpty)
                                ? ListTile(
                                    visualDensity:
                                        const VisualDensity(vertical: -2),
                                    onTap: () {
                                      final userController =
                                          Provider.of<UserController>(context,
                                              listen: false);
                                      userController.removeCp();
                                      Navigator.pop(context);
                                    },
                                    title: Text(
                                      'Remove Cover Photo',
                                      style: textStyle,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      );
                    },
                  );
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
                top: displayHeight(context) * 0.03,
                right: displayWidth(context) * 0.01,
                child: Consumer<MyArticlesController>(
                  builder: (context, controller, child) {
                    return PopupMenuButton(
                      onSelected: (value) async {
                        if (value == "Update Password") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdatePasswordScreen(),
                              ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestVerification(
                                    currentUser: user,
                                    publishedArticles:
                                        controller.publishedArticles.length),
                              ));
                        }
                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                            value: "Update Password",
                            child: Text('Update Password')),
                        PopupMenuItem(
                          value: "Request Verification",
                          child: Text('Request Verification'),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Positioned(
                left: displayWidth(context) * 0.05,
                right: displayWidth(context) * 0.05,
                top: displayHeight(context) * 0.18,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 0.5,
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
                              onTap: () async {
                                // update dp
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          (user.dp.isNotEmpty)
                                              ? ListTile(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          vertical: -2),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DisplayFullImage(
                                                                  caption:
                                                                      user.name,
                                                                  imageurl:
                                                                      user.dp),
                                                        ));
                                                  },
                                                  title: Text(
                                                    'View Profile Photo',
                                                    style: textStyle,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          ListTile(
                                            visualDensity: const VisualDensity(
                                                vertical: -2),
                                            onTap: () async {
                                              final sms =
                                                  ScaffoldMessenger.of(context);
                                              final userController =
                                                  Provider.of<UserController>(
                                                      context,
                                                      listen: false);
                                              XFile? pickDisplayPhoto =
                                                  await pickImage(context);
                                              if (pickDisplayPhoto != null) {
                                                CroppedFile? croppedFile =
                                                    await cropImage(File(
                                                        pickDisplayPhoto.path));
                                                if (croppedFile != null) {
                                                  userController
                                                      .changeDisplayPhoto(
                                                          croppedFile);
                                                } else {
                                                  // nothing to be done
                                                }
                                              } else {
                                                sms.showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "No image picked")));
                                              }
                                            },
                                            title: Text(
                                              'Change Profile Photo',
                                              style: textStyle,
                                            ),
                                          ),
                                          (user.dp.isNotEmpty)
                                              ? ListTile(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          vertical: -2),
                                                  onTap: () {
                                                    final userController =
                                                        Provider.of<
                                                                UserController>(
                                                            context,
                                                            listen: false);
                                                    userController.removeDp();
                                                    Navigator.pop(context);
                                                  },
                                                  title: Text(
                                                    'Remove Profile Photo',
                                                    style: textStyle,
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    );
                                  },
                                );
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
                                      height: displayHeight(context) * 0.13,
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
                                        height: displayHeight(context) * 0.13,
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
                                              // fontFamily:
                                              //     "Open",
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
                          builder: (context, value, child) {
                            return FutureBuilder(
                              future: Provider.of<ArticlesController>(context)
                                  .fetchThisUsersArticles(user.userId),
                              builder: (context,
                                  AsyncSnapshot<List<Article>> snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    height: displayHeight(context) * 0.08,
                                    width: displayWidth(context) * 0.6,
                                    decoration: BoxDecoration(
                                        color: Colors.blue.shade100
                                            .withOpacity(0.25),
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.only(
                                        top: 4, left: 12, right: 12, bottom: 4),
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
                                                    FollowingScreen(user: user),
                                              )),
                                        ),
                                        ProfileDetailBox(
                                          value: user.followers.length,
                                          label: "Followers",
                                          callback: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FollowersScreen(user: user),
                                              )),
                                        ),
                                        ProfileDetailBox(
                                          value: snapshot.data!.length,
                                          label: "Articles",
                                          callback: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyArticleScreen())),
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  return MyFollowerBoxShimmer();
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: displayWidth(context) * 0.5,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(3),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              backgroundColor:
                                  MaterialStateProperty.all(authBackground),
                            ),
                            onPressed: () {
                              displayBox(
                                  context: context,
                                  currentBio: user.bio,
                                  currentName: user.name);
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return EditProfileDialogbox(
                              //         currentName: user.name,
                              //         currentBio: user.bio);
                              //   },
                              // );
                            },
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                  fontFamily: "",
                                  letterSpacing: 0.4,
                                  color: Colors.white.withOpacity(0.85)),
                            ),
                          ),
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
