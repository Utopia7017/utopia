import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/view/common_ui/comment_container.dart';
import 'package:utopia/view/shimmers/comment_shimmer.dart';

class ListComments extends StatelessWidget {
  final dynamic commentData;
  final String articleOwnerId;

  const ListComments({super.key, required this.commentData, required this.articleOwnerId});

  Future<int> getNumberOfReplies(String articleId, String commentId) async {
    int replies = 0;
    var docData = await FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .get();
    replies = docData.size;
    return replies;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: commentData.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemBuilder: (context, index) {
        // Comment data extracted
        DateTime createdAt = DateTime.parse(commentData[index]['createdAt']);
        String comment = commentData[index]['comment'];
        return Consumer<UserController>(
          builder: (context, value, child) {
            return FutureBuilder(
              future: value.getUser(commentData[index]['userId']),
              builder: (context, AsyncSnapshot<User?> snapshot) {
                if ((snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) &&
                    snapshot.hasData) {
                  return FutureBuilder(
                    future: getNumberOfReplies(commentData[index]['articleId'],
                        commentData[index]['commentId'] ?? ''),
                    builder: (context, AsyncSnapshot<int> replySnapshot) {
                      if ((replySnapshot.connectionState ==
                                  ConnectionState.active ||
                              replySnapshot.connectionState ==
                                  ConnectionState.done) &&
                          replySnapshot.hasData) {
                        return CommentContainer(
                          articleOwnerId: articleOwnerId,
                            numberOfreplies: replySnapshot.data,
                            shouldNavigate: true,
                            commentId: commentData[index]['commentId'] ?? '',
                            user: snapshot.data!,
                            comment: comment,
                            articleId: commentData[index]['articleId'],
                            createdAt: createdAt);
                      } else {
                        return const CommentShimmer();
                      }
                    },
                  );
                } else {
                  return const CommentShimmer();
                }
              },
            );
          },
        );
      },
    );
  }
}
