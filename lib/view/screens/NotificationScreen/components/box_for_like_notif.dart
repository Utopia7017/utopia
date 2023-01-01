import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/services/firebase/notification_service.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/UserProfileScreen/user_profile_screen.dart';

class BoxForLikeNotification extends ConsumerWidget {
  final String notifierDp;
  final String articleId;
  final String notificationId;
  final String notifierName;
  final String notifierId;
  final Timestamp time;
  bool read;

  BoxForLikeNotification(
      {super.key,
      required this.notifierDp,
      required this.notificationId,
      required this.notifierName,
      required this.articleId,
      required this.notifierId,
      required this.read,
      required this.time});

  String myUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
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
    String createdOn = timeago.format(time.toDate());
    List<String> initials = notifierName.split(" ");
    String firstLetter = "", lastLetter = "";

    if (initials.length == 1) {
      firstLetter = initials[0].characters.first;
    } else {
      firstLetter = initials[0].characters.first;
      lastLetter = initials[1].characters.first;
    }
    return ListTile(
      onTap: () => readThisNotification(
          FirebaseAuth.instance.currentUser!.uid, notificationId),
      onLongPress: () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          confirmBtnText: "Delete",
          title: "Delete notification?",
          text: "Are you sure you want to delete this notification",
          onConfirmBtnTap: () {
            deleteSingleNotification(
                FirebaseAuth.instance.currentUser!.uid, notificationId);
            Navigator.pop(context);
          },
        );
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
      subtitle: Row(
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
      trailing: SizedBox(
        height: 25,
        width: 28,
        child: Builder(
          builder: (context) {
            if (dataController.myArticleState.fetchingMyArticleStatus ==
                FetchingMyArticle.NOT_FETCHED) {
              controller.fetchMyArticles(myUid);
            }
            switch (dataController.myArticleState.fetchingMyArticleStatus) {
              case FetchingMyArticle.NOT_FETCHED:
                return Image.asset(notificationLikeIcon,
                    height: 25, fit: BoxFit.cover);
              case FetchingMyArticle.FETCHING:
                return Image.asset(notificationLikeIcon,
                    height: 25, fit: BoxFit.cover);
              case FetchingMyArticle.FETCHED:
                int indexOfArticle = dataController
                    .myArticleState.publishedArticles
                    .indexWhere((element) => element.articleId == articleId);

                if (indexOfArticle == -1) {
                  deleteSingleNotification(myUid, notificationId);
                  return const SizedBox();
                } else {
                  String? imagePreview;

                  for (var body in dataController
                      .myArticleState.publishedArticles[indexOfArticle].body) {
                    if (body['type'] == 'image') {
                      imagePreview = body['image'];
                      break;
                    }
                  }
                  return (imagePreview != null)
                      ? CachedNetworkImage(
                          imageUrl: imagePreview, height: 25, fit: BoxFit.cover)
                      : Image.asset(defaultArticleImage,
                          height: 25, fit: BoxFit.cover);
                }
            }
          },
        ),
      ),
    );
  }
}
