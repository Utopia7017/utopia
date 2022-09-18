import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/utils/helper_widgets.dart';

class CommentScreen extends StatelessWidget {
  final String articleId;
  CommentScreen({required this.articleId});
  final formKey = GlobalKey<FormState>();
  String myUserId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        elevation: 0,
        backgroundColor: authBackground,
        iconTheme: IconThemeData(color: primaryBackgroundColor),
      ),
      backgroundColor: primaryBackgroundColor,
      body: Container(
        child: Consumer<UserController>(
          builder: (context, controller, child) {
            return CommentBox(
              sendButtonMethod: () async {
                await addComment(
                    articleId: articleId,
                    comment: commentController.text,
                    createdAt: DateTime.now().toString(),
                    userId: myUserId);
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
              userImage: controller.user != null &&
                      controller.user!.dp.isNotEmpty
                  ? controller.user!.dp
                  : 'https://play-lh.googleusercontent.com/nCVVCbeSI14qEvNnvvgkkbvfBJximn04qoPRw8GZjC7zeoKxOgEtjqsID_DDtNfkjyo',
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('articles')
                    .doc(articleId)
                    .collection('comments')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text("Connection established");
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
      ),
    );
  }
}
