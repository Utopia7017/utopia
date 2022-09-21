import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

likeArticle(String articleId, String myUid) async {
  await FirebaseFirestore.instance
      .collection('articles')
      .doc(articleId)
      .collection('likes')
      .doc(myUid)
      .set({'userId': myUid});
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

drawerTile(String title, Icon icon, Function() callbackAction) {
    return ListTile(
      onTap: callbackAction,
      contentPadding: EdgeInsets.zero,
      leading: icon,
      visualDensity: const VisualDensity(vertical: -0.5),
      minLeadingWidth: 1,
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 15.2,
            color: Colors.white,
            fontFamily: "Fira",
            letterSpacing: 0.6),
      ),
    );
  }

