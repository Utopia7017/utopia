import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/articles_controller.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/services/firebase/notification_service.dart';
import 'package:utopia/view/screens/CommentScreen/components/list_comments.dart';
import 'package:utopia/view/screens/DisplayArticleScreen/display_article_screen.dart';

class CommentScreen extends StatelessWidget {
  final String articleId;
  final String authorId;
  CommentScreen({super.key, required this.articleId, required this.authorId});
  final formKey = GlobalKey<FormState>();
  String myUserId = firebase.FirebaseAuth.instance.currentUser!.uid;
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
          Consumer<ArticlesController>(
            builder: (context, controller, child) {
              if (controller.articlesStatus == ArticlesStatus.nil) {
                controller.fetchArticles();
              }
              switch (controller.articlesStatus) {
                case ArticlesStatus.nil:
                  return const SizedBox();
                case ArticlesStatus.fetching:
                  return SizedBox();
                case ArticlesStatus.fetched:
                  late Article article;
                  for (var key in controller.articles.keys) {
                    List<Article> list = controller.articles[key]!;
                    int indexOfArticle = list.indexWhere((element) =>
                        element.articleId == articleId &&
                        element.authorId == authorId);
                    if (indexOfArticle != -1) {
                      article = list[indexOfArticle];
                      break;
                    }
                  }
                  return FutureBuilder<User?>(
                    future: Provider.of<UserController>(context, listen: false)
                        .getUser(authorId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return PopupMenuButton(
                          onSelected: (value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DisplayArticleScreen(
                                  article: article,
                                  author: snapshot.data!,
                                ),
                              )),
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: "View Article",
                              child: Text('View Article'),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  );
              }
            },
          )
        ],
      ),
      backgroundColor: primaryBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          return await Future.delayed(const Duration(seconds: 2));
        },
        backgroundColor: authBackground,
        color: Colors.white,
        child: Consumer<UserController>(
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
              userImage: controller.user != null &&
                      controller.user!.dp.isNotEmpty
                  ? controller.user!.dp
                  : 'https://play-lh.googleusercontent.com/nCVVCbeSI14qEvNnvvgkkbvfBJximn04qoPRw8GZjC7zeoKxOgEtjqsID_DDtNfkjyo',
              child: StreamBuilder(
                stream: commentStream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData &&
                      (snapshot.connectionState == ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done)) {
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
      ),
    );
  }
}
