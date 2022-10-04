import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/user_controller.dart';

import 'package:utopia/models/user_model.dart' as user;
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/NotificationScreen/components/box_for_comment_notif.dart';
import 'package:utopia/view/screens/NotificationScreen/components/box_for_like_notif.dart';

class NotificationScreen extends StatelessWidget {
  // Notification box

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
                                  child: BoxForLikeNotification(
                                   
                                    notifierDp: notifierUserSnapshot
                                        .data!.dp, // dp of the user
                                    notifierName: notifierUserSnapshot
                                        .data!.name, // name of the user
                                    notifierId: notifierUserSnapshot.data!
                                        .userId, // user id of the user who has done something
                                    time: notificationSnapshot.data.docs[index][
                                        'createdOn'], // date when this notification was created
                                  ),
                                );
                              case 'comment':
                                return BoxForCommentNotification(
                                     notifierDp: notifierUserSnapshot
                                        .data!.dp, // dp of the user
                                    notifierName: notifierUserSnapshot
                                        .data!.name, // name of the user
                                    notifierId: notifierUserSnapshot.data!
                                        .userId, // user id of the user who has done something
                                    time: notificationSnapshot.data.docs[index][
                                        'createdOn'], 
                                    
                                   );
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