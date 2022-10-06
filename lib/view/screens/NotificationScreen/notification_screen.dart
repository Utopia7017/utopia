import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/models/user_model.dart' as user;
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/NotificationScreen/components/box_for_comment_notif.dart';
import 'package:utopia/view/screens/NotificationScreen/components/box_for_follow_notif.dart';
import 'package:utopia/view/screens/NotificationScreen/components/box_for_like_notif.dart';
import 'package:utopia/view/shimmers/notification_shimmer.dart';

class NotificationScreen extends StatelessWidget {
  final space = const Divider(
    indent: 15,
    endIndent: 15,
    color: Colors.grey,
    thickness: 0.1,
  );
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
                  .orderBy('createdOn', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot notificationSnapshot) {
                if (notificationSnapshot.hasData) {
                  if (notificationSnapshot.data.docs.isEmpty) {
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
                  } else {
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
                                  return Column(
                                    children: [
                                      BoxForLikeNotification(
                                        read: notificationSnapshot
                                            .data.docs[index]['read'],
                                        articleId: notificationSnapshot
                                            .data.docs[index]['articleId'],
                                        notifierDp: notifierUserSnapshot
                                            .data!.dp, // dp of the user
                                        notifierName: notifierUserSnapshot
                                            .data!.name, // name of the user
                                        notifierId: notifierUserSnapshot.data!
                                            .userId, // user id of the user who has done something
                                        time: notificationSnapshot
                                                .data.docs[index][
                                            'createdOn'], // date when this notification was created
                                      ),
                                      space,
                                    ],
                                  );
                                case 'comment':
                                  return Column(
                                    children: [
                                      BoxForCommentNotification(
                                        read: notificationSnapshot
                                            .data.docs[index]['read'],
                                        articleId: notificationSnapshot
                                            .data.docs[index]['articleId'],

                                        notifierDp: notifierUserSnapshot
                                            .data!.dp, // dp of the user
                                        notifierName: notifierUserSnapshot
                                            .data!.name, // name of the user
                                        notifierId: notifierUserSnapshot.data!
                                            .userId, // user id of the user who has done something
                                        time: notificationSnapshot
                                                .data.docs[index][
                                            'createdOn'], // time when this notification was created
                                        comment: notificationSnapshot
                                                .data.docs[index]
                                            ['comment'], // comment data
                                      ),
                                      space
                                    ],
                                  );
                                case 'follow':
                                  return Column(
                                    children: [
                                      BoxForFollowNotification(
                                        read: notificationSnapshot
                                            .data.docs[index]['read'],
                                        notifierDp: notifierUserSnapshot
                                            .data!.dp, // dp of the user
                                        notifierName: notifierUserSnapshot
                                            .data!.name, // name of the user
                                        notifierId: notifierUserSnapshot.data!
                                            .userId, // user id of the user who has done something
                                        time: notificationSnapshot
                                                .data.docs[index][
                                            'createdOn'], // date when this notification was created
                                      ),
                                      space
                                    ],
                                  );
                                default:
                                  return const Text("default");
                              }
                            } else {
                              return Column(
                                children: [
                                  const NotificationShimmer(),
                                  space,
                                ],
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                } else {
                  return ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          const NotificationShimmer(),
                          space,
                        ],
                      );
                    },
                  );
                }
              },
            );
          },
        ));
  }
}
