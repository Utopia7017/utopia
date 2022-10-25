import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

import 'package:utopia/models/notification_model.dart';

likeArticle(String articleId, String myUid) async {
  try {
    await FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('likes')
        .doc(myUid)
        .set({'userId': myUid});
  } on FirebaseException catch (error) {
    rethrow;
  }
}

dislikeArticle(String articleId, String myUid) async {
  await FirebaseFirestore.instance
      .collection('articles')
      .doc(articleId)
      .collection('likes')
      .doc(myUid)
      .delete();
}

addComment(
    {String? comment,
    String? createdAt,
    String? userId,
    String? articleId}) async {
  var docId = await FirebaseFirestore.instance
      .collection('articles')
      .doc(articleId)
      .collection('comments')
      .add({
    'comment': comment,
    'createdAt': createdAt,
    'articleId': articleId,
    'userId': userId,
  });
  await FirebaseFirestore.instance
      .collection('articles')
      .doc(articleId)
      .collection('comments')
      .doc(docId.id)
      .update({'commentId': docId.id});
}

replyToThisComment({
  required String? reply,
  required String? myUId,
  required String? articleId,
  required String? commentId,
  required String? createdAt,
}) async {
  var docId = await FirebaseFirestore.instance
      .collection('articles')
      .doc(articleId)
      .collection('comments')
      .doc(commentId)
      .collection('replies')
      .add({
    'reply': reply,
    'createdAt': createdAt,
    'articleId': articleId,
    'myUid': myUId,
  });
  await FirebaseFirestore.instance
      .collection('articles')
      .doc(articleId)
      .collection('comments')
      .doc(commentId)
      .collection('replies')
      .doc(docId.id)
      .update({'replyId': docId.id});
}

notifyUserWhenLikedArticle(
    String currentUserId, String userId, String articleId) async {
  var notificationDB = FirebaseFirestore.instance
      .collection('notifications')
      .doc(userId)
      .collection('notification');

  Notification notification = Notification(
      notificationId: '',
      notifierId: currentUserId,
      read: false,
      articleId: articleId,
      type: 'like',
      createdOn: DateTime.now());

  if (userId != currentUserId) {
    var response = await notificationDB.add(notification.toJson());

    await notificationDB
        .doc(response.id)
        .update({'notificationId': response.id});
  }
}

notifyUserWhenCommentOnArticle(String currentUserId, String userId,
    String articleId, String? comment) async {
  var notificationDB = FirebaseFirestore.instance
      .collection('notifications')
      .doc(userId)
      .collection('notification');

  Notification notification = Notification(
      notificationId: '',
      comment: comment,
      notifierId: currentUserId,
      read: false,
      articleId: articleId,
      type: 'comment',
      createdOn: DateTime.now());

  if (userId != currentUserId) {
    var response = await notificationDB.add(notification.toJson());

    await notificationDB
        .doc(response.id)
        .update({'notificationId': response.id});
  }
}

notifyUserWhenRepliedOnMyComment(
    {required String currentUserId,
    required String userId,
    required String articleId,
    required String articleOwnerId,
    required String comment,
    required String commentOwnerId,
    required String commentId,
    required String reply}) async {
  var notificationDB = FirebaseFirestore.instance
      .collection('notifications')
      .doc(userId)
      .collection('notification');
  Notification notification = Notification(
      notificationId: '',
      comment: comment,
      notifierId: currentUserId,
      commentId: commentId,
      commentOwnerId: commentOwnerId,
      read: false,
      articleOwnerId: articleOwnerId,
      reply: reply,
      articleId: articleId,
      type: 'reply',
      createdOn: DateTime.now());

  if (userId != currentUserId) {
    var response = await notificationDB.add(notification.toJson());

    await notificationDB
        .doc(response.id)
        .update({'notificationId': response.id});
  }
}

notifyUserWhenFollowedUser(
  String currentUserId,
  String userId,
) async {
  var notificationDB = FirebaseFirestore.instance
      .collection('notifications')
      .doc(userId)
      .collection('notification');

  Notification notification = Notification(
      notificationId: '',
      notifierId: currentUserId,
      read: false,
      type: 'follow',
      createdOn: DateTime.now());

  var response = await notificationDB.add(notification.toJson());

  await notificationDB.doc(response.id).update({'notificationId': response.id});
}

readThisNotification(String currentUserId, String notificationId) async {
  var notificationDB = FirebaseFirestore.instance
      .collection('notifications')
      .doc(currentUserId)
      .collection('notification');

  await notificationDB.doc(notificationId).update({'read': true});
}

readAllNotifications(String currentUserId) async {
  Logger logger = Logger("readAll");
  var notificationDB = await FirebaseFirestore.instance
      .collection('notifications')
      .doc(currentUserId)
      .collection('notification')
      .get();

  for (QueryDocumentSnapshot<Map<String, dynamic>> doc in notificationDB.docs) {
    await readThisNotification(currentUserId, doc.id);
  }
}

deleteSingleNotification(String currentUserId, String notificationId) async {
  await FirebaseFirestore.instance
      .collection('notifications')
      .doc(currentUserId)
      .collection('notification')
      .doc(notificationId)
      .delete();
}

deleteAllNotifications(String currentUserId) async {
  Logger logger = Logger("deleteAllNotifications");
  var notificationDB = await FirebaseFirestore.instance
      .collection('notifications')
      .doc(currentUserId)
      .collection('notification')
      .get();

  for (QueryDocumentSnapshot<Map<String, dynamic>> doc in notificationDB.docs) {
    await deleteSingleNotification(currentUserId, doc.id);
  }
}
