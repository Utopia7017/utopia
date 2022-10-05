import 'package:cloud_firestore/cloud_firestore.dart';

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
    'userId': userId,
  });
  await FirebaseFirestore.instance
      .collection('articles')
      .doc(articleId)
      .collection('comments')
      .doc(docId.id)
      .update({'commentId': docId.id});
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

  var response = await notificationDB.add(notification.toJson());

  await notificationDB.doc(response.id).update({'notificationId': response.id});
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

  var response = await notificationDB.add(notification.toJson());

  await notificationDB.doc(response.id).update({'notificationId': response.id});
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
