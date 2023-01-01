import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/services/firebase/notification_service.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/common_api_calls.dart';
import 'package:utopia/view/screens/CommentScreen/components/list_comments.dart';
import 'package:utopia/view/screens/DisplayArticleScreen/display_article_screen.dart';

class CommentScreen extends ConsumerWidget {
  final String articleId;
  final String authorId;
  CommentScreen({super.key, required this.articleId, required this.authorId});
  final formKey = GlobalKey<FormState>();
  String myUserId = firebase.FirebaseAuth.instance.currentUser!.uid;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);

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
          Builder(
            builder: (context) {
              if (dataController.articleState.articlesStatus ==
                  ArticlesStatus.NOT_FETCHED) {
                controller.fetchArticles();
              }
              switch (dataController.articleState.articlesStatus) {
                case ArticlesStatus.NOT_FETCHED:
                  return const SizedBox();
                case ArticlesStatus.FETCHING:
                  return const SizedBox();
                case ArticlesStatus.FETCHED:
                  late Article article;
                  for (var key in dataController.articleState.articles.keys) {
                    List<Article> list =
                        dataController.articleState.articles[key]!;
                    int indexOfArticle = list.indexWhere((element) =>
                        element.articleId == articleId &&
                        element.authorId == authorId);
                    if (indexOfArticle != -1) {
                      article = list[indexOfArticle];
                      break;
                    }
                  }
                  return FutureBuilder<User?>(
                    future: getUser(authorId),
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
                        return const SizedBox();
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
        child: CommentBox(
          sendButtonMethod: () async {
            // add the comment to firestore db
            if (commentController.text.trim().isNotEmpty) {
              await addComment(
                  articleId: articleId,
                  comment: commentController.text.trim(),
                  createdAt: DateTime.now().toString(),
                  userId: myUserId);

              // notify the user
              await notifyUserWhenCommentOnArticle(
                  myUserId, authorId, articleId, commentController.text.trim());
              commentController.clear();
            }
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
          userImage: dataController.userState.user != null &&
                  dataController.userState.user!.dp.isNotEmpty
              ? dataController.userState.user!.dp
              : 'https://firebasestorage.googleapis.com/v0/b/utopia-a7a8a.appspot.com/o/res%2Fprofile.png?alt=media&token=6f5c39a1-ffe0-441e-b6e3-cfdd3609e24d',
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
        ),
      ),
    );
  }
}
