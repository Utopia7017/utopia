import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/constants/string_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/utils/all_controllers.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/helper_widgets.dart';
import 'package:utopia/view/screens/FollowersScreen/followers_screen.dart';
import 'package:utopia/view/screens/FollowingScreen/following_screen.dart';
import '../../../services/firebase/auth_services.dart';

class CustomDrawer extends StatefulWidget {
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final Logger _logger = Logger('CustomDrawer');

  final Authservice _auth = Authservice(FirebaseAuth.instance);

  bool aboutUtopiaOpen = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: displayWidth(context) * 0.3,
        padding: const EdgeInsets.only(left: 20, right: 14),
        child: Consumer<UserController>(
          builder: (context, controller, child) {
            if (controller.profileStatus == ProfileStatus.nil) {
              controller.setUser(FirebaseAuth.instance.currentUser!.uid);
            }

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
                  child:
                      CircularProgressIndicator(color: authMaterialButtonColor),
                );
              case ProfileStatus.fetched:
                if (controller.user != null) {
                  List<String> initials = controller.user!.name.split(" ");
                  String firstLetter = "", lastLetter = "";

                  if (initials.length == 1) {
                    firstLetter = initials[0].characters.first;
                  } else {
                    firstLetter = initials[0].characters.first;
                    lastLetter = initials[1].characters.first;
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: ListView(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: displayWidth(context) * 0.12,
                                backgroundColor: Colors.white,
                                child: (controller.user!.dp.isEmpty)
                                    ? CircleAvatar(
                                        backgroundColor:
                                            authMaterialButtonColor,
                                        radius: displayWidth(context) * 0.115,
                                        child: Center(
                                          child: initials.length > 1
                                              ? Text(
                                                  "$firstLetter.$lastLetter"
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                )
                                              : Text(
                                                  firstLetter.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: displayWidth(context) * 0.115,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                controller.user!.dp),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                          child: Container(
                            // color: Colors.yellow.shade100,
                            constraints: BoxConstraints.tightForFinite(
                              width: displayWidth(context) * 0.6,
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '@${controller.user!.name}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: "Fira"),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                (controller.user!.isVerified)
                                    ? Image.asset(
                                        verifyIcon,
                                        height: 17.5,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Follower detail box
                        Container(
                          // color: Colors.red.shade100,
                          height: displayHeight(context) * 0.06,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FollowersScreen(
                                            user: controller.user!),
                                      ));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.user!.followers.length
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    const Text(
                                      'Followers',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Open",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FollowingScreen(
                                            user: controller.user!),
                                      ));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.user!.following.length
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    const Text(
                                      'Following',
                                      style: TextStyle(
                                        fontFamily: "Open",
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Notification count

                        ListTile(
                          onTap: () =>
                              Navigator.pushNamed(context, '/notifications'),
                          contentPadding: EdgeInsets.zero,
                          leading: Image.asset(
                            notificationIcon,
                            height: 20,
                            color: Colors.grey,
                          ),
                          visualDensity: const VisualDensity(vertical: -3.5),
                          minLeadingWidth: 1,
                          title: const Text(
                            'Notifications',
                            style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.white,
                                fontFamily: "Fira",
                                letterSpacing: 0.6),
                          ),
                          trailing: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('notifications')
                                .doc(controller.user!.userId)
                                .collection('notification')
                                .where('read', isEqualTo: false)
                                .snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                int numberOfNewNotification =
                                    snapshot.data.docs.length;

                                if (numberOfNewNotification == 0) {
                                  return const SizedBox();
                                } else {
                                  return CircleAvatar(
                                    radius: 9,
                                    backgroundColor: Colors.red.shade400,
                                    child: Text(
                                      numberOfNewNotification.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  );
                                }
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                        drawerTile(
                          'Popular Authors',
                          popularAuthorIcon,
                          () => Navigator.pushNamed(context, '/popAuthors'),
                        ),
                        drawerTile('Write new article', newArticleIcon,
                            () => Navigator.pushNamed(context, '/newArticle')),
                        drawerTile('My articles', myArticlesIcon,
                            () => Navigator.pushNamed(context, '/myArticles')),
                        drawerTile('Search articles', searchIcon,
                            () => Navigator.pushNamed(context, '/search')),
                        drawerTile(
                            'Saved articles',
                            saveArticleIcon,
                            () =>
                                Navigator.pushNamed(context, '/savedArticles')),

                        drawerTile(
                            'Blocked users',
                            blockedUsersIcon,
                            () =>
                                Navigator.pushNamed(context, '/blockedUsers')),

                        ListTile(
                          onTap: () {
                            setState(() {
                              aboutUtopiaOpen = !aboutUtopiaOpen;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: Image.asset(
                            aboutUsIcon,
                            height: 20,
                            color: Colors.grey,
                          ),
                          visualDensity: const VisualDensity(vertical: -3),
                          minLeadingWidth: 1,
                          title: const Text(
                            'About Utopia',
                            style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.white,
                                fontFamily: "Fira",
                                letterSpacing: 0.6),
                          ),
                          trailing: IconButton(
                              splashRadius: 12,
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  aboutUtopiaOpen = !aboutUtopiaOpen;
                                });
                              },
                              icon: Icon(aboutUtopiaOpen
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down)),
                        ),

                        (aboutUtopiaOpen)
                            ? Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  children: [
                                    drawerTile(
                                        'Privacy policy',
                                        privacyPolicyIcon,
                                        () => Navigator.pushNamed(
                                            context, '/privacyPolicy')),
                                    drawerTile(
                                        'Terms of use',
                                        termsIcon,
                                        () => Navigator.pushNamed(
                                            context, '/terms')),
                                    drawerTile(
                                        'Help',
                                        helpIcon,
                                        () => Navigator.pushNamed(
                                            context, '/help')),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        drawerTile(
                            'Rate us on Play store',
                            playStoreIcon,
                            () => openUrl(
                                'https://play.google.com/store/apps/details?id=com.starcoding.utopia')),

                        /// The above code is a function that is called when the user clicks on the
                        /// logout button.
                        drawerTile('Logout', logoutIcon, () async {
                          final navigator = Navigator.of(context);
                          AppProviders.disposeAllDisposableProviders(context);
                          final SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          await preferences.setBool(
                              loginStatePreference, false);
                          await preferences.setString(loginPerformedBy, "");
                          await _auth.signOut();
                          navigator.pushReplacementNamed('/auth');
                        }),
                        SizedBox(height: displayHeight(context) * 0.06),

                        // Made with love in India message
                        Row(
                          children: [
                            const Text(
                              "Made with ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Fira",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.favorite,
                              size: 13,
                              color: Colors.pink.shade400,
                            ),
                            const Text(
                              " in India",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Fira",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
            }
          },
        ),
      ),
    );
  }
}
