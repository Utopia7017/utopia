import 'package:cloud_firestore/cloud_firestore.dart';

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