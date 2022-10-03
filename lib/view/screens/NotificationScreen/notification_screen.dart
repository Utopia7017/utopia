import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/user_controller.dart';

import 'package:utopia/models/user_model.dart' as user;
import 'package:utopia/utils/device_size.dart';

class NotificationScreen extends StatelessWidget {
  // Notification box
  Widget boxForLikeNotification(String type, String notifierDp,
      String notifierName, String notifierId, Timestamp time) {
    String createdOn = timeago.format(time.toDate());

    RichText title = RichText(
        text: TextSpan(children: [
      TextSpan(
          text: notifierName,
          style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3)),
      const TextSpan(
          text: " liked your article",
          style: TextStyle(
              fontSize: 13.2, color: Colors.black54, letterSpacing: 0.35)),
    ]));
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: notifierDp,
        fit: BoxFit.fitWidth,
        height: 45,
        width: 40,
      ),
      title: Padding(padding: const EdgeInsets.only(bottom: 4.0), child: title),
      subtitle: Text(
        createdOn,
        style: const TextStyle(
            fontSize: 11.5,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontFamily: "Open"),
      ),
      trailing:
          Image.asset(notificationLikeIcon, height: 25, fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: authBackground,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Notification",
            style: TextStyle(fontFamily: "Open", fontSize: 14),
          ),
        ),
        body: Consumer<UserController>(
          builder: (context, userController, child) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .doc(userController.user!.userId)
                  .collection('notification')
                  .snapshots(),
              builder: (context, AsyncSnapshot notificationSnapshot) {
                if (notificationSnapshot.hasData) {
                  return ListView.builder(
                    itemCount: notificationSnapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: userController.getUser(notificationSnapshot
                            .data.docs[index]['notifierId']),
                        builder: (context,
                            AsyncSnapshot<user.User?> notifierUserSnapshot) {
                          if (notifierUserSnapshot.hasData) {
                            switch (notificationSnapshot.data.docs[index]
                                ['type']) {
                              case 'like':
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: boxForLikeNotification(
                                    notificationSnapshot.data.docs[index]
                                        ['type'],
                                    notifierUserSnapshot
                                        .data!.dp, // dp of the user
                                    notifierUserSnapshot
                                        .data!.name, // name of the user
                                    notifierUserSnapshot.data!
                                        .userId, // user id of the user who has done something
                                    notificationSnapshot.data.docs[index][
                                        'createdOn'], // date when this notification was created
                                  ),
                                );
                              case 'comment':
                                return Text('Comment box');
                              case 'follow':
                                return Text('Follow');
                              default:
                                return Text("default");
                            }
                          } else {
                            return const Center(
                              child: Text("Loading"),
                            );
                          }
                        },
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          notificationLargeIcon,
                          width: displayWidth(context) * 0.25,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Nothing here",
                          style: TextStyle(
                              // fontFamily: "Open",
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )
                      ],
                    ),
                  );
                }
              },
            );
          },
        ));
  }
}



/*

*/