import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controlller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/ProfileScreen/profile_screen.dart';
import '../../../services/firebase/auth_services.dart';
// import 'package:utopia/models/user_model.dart' as user;

class CustomDrawer extends StatelessWidget {
  final Logger _logger = Logger('CustomDrawer');

  final Authservice _auth = Authservice(FirebaseAuth.instance);

  drawerTile(String title, Icon icon, Function() callbackAction) {
    return ListTile(
      onTap: callbackAction,
      contentPadding: EdgeInsets.zero,
      leading: icon,
      visualDensity: VisualDensity(vertical: -0.5),
      minLeadingWidth: 1,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15.2,
            color: Colors.white, fontFamily: "Fira", letterSpacing: 0.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: displayWidth(context) * 0.3,
        padding: const EdgeInsets.only(left: 20, top: 25, right: 14),
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: CircleAvatar(
                        radius: displayWidth(context) * 0.13,
                        backgroundImage: const NetworkImage(
                            'https://i.pinimg.com/564x/17/b0/8f/17b08fc3ad0e62df60e15ef557ec3fe1.jpg'),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: Text(
                        '@${controller.user!.name}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Fira"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Follower detail box
                    Container(
                      height: displayHeight(context) * 0.08,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.user!.followers.length.toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                'Followers',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.user!.following.length.toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                'Following',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    drawerTile(
                        'Write new article',
                        const Icon(
                          size: 22,
                          Icons.edit,
                          color: Colors.white70,
                        ),
                        () => _logger.info("Add new article")),
                    drawerTile(
                        'Your articles',
                        const Icon(
                          size: 22,
                          Icons.book_sharp,
                          color: Colors.white70,
                        ),
                        () => Navigator.pushNamed(context, '/yourArticle')),
                    drawerTile(
                        'Search articles',
                        const Icon(
                          size: 22,
                          Icons.search_rounded,
                          color: Colors.white70,
                        ),
                        () => _logger.info("Search")),
                    drawerTile(
                        'Saved articles',
                        const Icon(
                          size: 22,
                          Icons.bookmark_add_outlined,
                          color: Colors.white70,
                        ),
                        () => _logger.info("Search")),
                    drawerTile(
                        'Notifications',
                        const Icon(
                          size: 22,
                          Icons.notifications_none_rounded,
                          color: Colors.white70,
                        ),
                        () => _logger.info("Notifications")),
                    drawerTile(
                        'Logout',
                        const Icon(
                          Icons.logout,
                          size: 22,
                          color: Colors.white70,
                        ), () async {
                      final navigator = Navigator.of(context);
                      await _auth.signOut();
                      navigator.pushReplacementNamed('/auth');
                    }),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
