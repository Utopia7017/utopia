import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/services/firebase/notification_service.dart';
import 'package:utopia/view/screens/CommentScreen/components/list_comments.dart';

class CommentScreen extends StatelessWidget {
  final String articleId;
  final String authorId;
  CommentScreen({super.key, required this.articleId, required this.authorId});
  final formKey = GlobalKey<FormState>();
  String myUserId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var commentStream = FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: authBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Comments",
          style: TextStyle(fontFamily: "Open", fontSize: 14),
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context) => [
            PopupMenuItem(child: Text('View Article')),
          ],)
        ],
      ),
      backgroundColor: primaryBackgroundColor,
      body: Consumer<UserController>(
        builder: (context, controller, child) {
          return CommentBox(
            sendButtonMethod: () async {
              // add the comment to firestore db
              await addComment(
                  articleId: articleId,
                  comment: commentController.text,
                  createdAt: DateTime.now().toString(),
                  userId: myUserId);

              // notify the user
              notifyUserWhenCommentOnArticle(
                  myUserId, authorId, articleId, commentController.text);
              commentController.clear();
            },
            withBorder: true,
            errorText: 'Comment cannot be blank',
            commentController: commentController,
            labelText: "Write your comment",
            sendWidget:
                const Icon(Icons.send_sharp, size: 30, color: authBackground),
            backgroundColor: Colors.white,
            formKey: formKey,
            textColor: Colors.black87,
            userImage: controller.user != null && controller.user!.dp.isNotEmpty
                ? controller.user!.dp
                : 'https://play-lh.googleusercontent.com/nCVVCbeSI14qEvNnvvgkkbvfBJximn04qoPRw8GZjC7zeoKxOgEtjqsID_DDtNfkjyo',
            child: StreamBuilder(
              stream: commentStream,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  dynamic commentData = snapshot.data.docs;
                  return ListComments(
                    articleOwnerId: authorId,
                    commentData: commentData,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
