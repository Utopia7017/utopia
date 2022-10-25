import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseUser;
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/services/firebase/notification_service.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/CommentScreen/reply_comment_screen.dart';
import 'package:utopia/view/screens/UserProfileScreen/user_profile_screen.dart';

class BoxForReplyNotification extends StatelessWidget {
  final String notificationId;
  final String notifierDp;
  final String notifierName;
  final String notifierId;
  final Timestamp time;
  final String reply;
  final String originalComment;
  final String articleId;
  final String originalCommentId;
  final User commentOwner;
  final String articleOwnerId;
  bool read;

  BoxForReplyNotification(
      {super.key,
      required this.notifierDp,
      required this.notificationId,
      required this.notifierName,
      required this.read,
      required this.articleOwnerId,
      required this.notifierId,
      required this.reply,
      required this.articleId,
      required this.time,
      required this.originalComment,
      required this.originalCommentId,
      required this.commentOwner});

  @override
  Widget build(BuildContext context) {
    RichText title = RichText(
        text: TextSpan(children: [
      TextSpan(
          text: notifierName,
          style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3)),
      const TextSpan(
          text: " replied to your comment",
          style: TextStyle(
              fontSize: 13.2, color: Colors.black54, letterSpacing: 0.35)),
    ]));

    List<String> initials = notifierName.split(" ");
    String firstLetter = "", lastLetter = "";

    if (initials.length == 1) {
      firstLetter = initials[0].characters.first;
    } else {
      firstLetter = initials[0].characters.first;
      lastLetter = initials[1].characters.first;
    }
    String createdOn = timeago.format(time.toDate());

    return ListTile(
      onTap: () {
        readThisNotification(
            firebaseUser.FirebaseAuth.instance.currentUser!.uid,
            notificationId);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReplyCommentScreen(
                    originalComment: originalComment,
                    commentId: originalCommentId,
                    commentOwner: commentOwner,
                    articleOwnerId: articleOwnerId,
                    createdAt: time.toDate(),
                    articleId: articleId)));
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Remove '),
                content: const Text(
                  'Are you sure you want to remove  this notification?',
                  style: TextStyle(fontSize: 14),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteSingleNotification(
                          firebaseUser.FirebaseAuth.instance.currentUser!.uid,
                          notificationId);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Remove',
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              );
            });
      },
      leading: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(userId: notifierId),
            )),
        child: (notifierDp.isEmpty)
            ? Container(
                height: 40,
                width: 35,
                color: authMaterialButtonColor,
                child: Center(
                  child: initials.length > 1
                      ? Text(
                          "$firstLetter.$lastLetter".toUpperCase(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
                      : Text(
                          firstLetter.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                ),
              )
            : CachedNetworkImage(
                imageUrl: notifierDp,
                fit: BoxFit.fitWidth,
                height: 45,
                width: 40,
              ),
      ),
      title: Padding(
          padding: const EdgeInsets.only(bottom: 4.0, top: 4), child: title),
      // isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reply,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black87.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: "Open",
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                createdOn,
                style: const TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Open"),
              ),
              SizedBox(
                width: displayWidth(context) * 0.05,
              ),
              (!read)
                  ? Image.asset(
                      newNotification,
                      height: 20,
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
      trailing:
          Image.asset(replyNotificationIcon, height: 30, fit: BoxFit.cover),
    );
  }
}
