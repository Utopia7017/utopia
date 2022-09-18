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
