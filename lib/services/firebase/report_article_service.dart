import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

reportArticle({required String articleId, required String reason}) async {
  Logger logger = Logger("report article");
  var firestoreDb = FirebaseFirestore.instance
      .collection('resports')
      .doc('articles')
      .collection('reports');
  try {
    var response = await firestoreDb.add({
      'articleId': articleId,
      'reason': reason,
      'reportId': '',
    });
    await firestoreDb.doc(response.id).update({'reportId': response.id});
  } on FirebaseException catch (error) {
    logger.shout(error.toString());
  }
}
