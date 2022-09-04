import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:utopia/utils/device_size.dart';
import '../../../services/firebase/auth_services.dart';

class CustomDrawer extends StatelessWidget {
  final Logger _logger = Logger('CustomDrawer');

  final Authservice _auth = Authservice(FirebaseAuth.instance);

  drawerTile(String title, Icon icon, Function() callbackAction) {
    return ListTile(
      onTap: callbackAction,
      contentPadding: EdgeInsets.zero,
      leading: icon,
      minLeadingWidth: 1,
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.white70, fontFamily: "Fira", letterSpacing: 0.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: displayWidth(context) * 0.3,
        padding: const EdgeInsets.only(left: 20, top: 25, right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: displayWidth(context) * 0.13,
              backgroundImage: const NetworkImage(
                  'https://i.pinimg.com/564x/17/b0/8f/17b08fc3ad0e62df60e15ef557ec3fe1.jpg'),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              '@Subhojeet Sahoo',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: "Fira"),
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
                    children: const [
                      Text(
                        '50',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
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
                    children: const [
                      Text(
                        '158',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
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
                  Icons.edit,
                  color: Colors.white70,
                ),
                () => _logger.info("Add new article")),
            drawerTile(
                'Your articles',
                const Icon(
                  Icons.book_sharp,
                  color: Colors.white70,
                ),
                () => _logger.info("Your articles")),
            drawerTile(
                'Search articles',
                const Icon(
                  Icons.search_rounded,
                  color: Colors.white70,
                ),
                () => _logger.info("Search")),
            drawerTile(
                'Notifications',
                const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white70,
                ),
                () => _logger.info("Notifications")),
            drawerTile(
                'Logout',
                const Icon(
                  Icons.logout,
                  color: Colors.white70,
                ), () async {
              final navigator = Navigator.of(context);
              await _auth.signOut();
              navigator.pushReplacementNamed('/auth');
            }),
          ],
        ),
      ),
    );
  }
}
