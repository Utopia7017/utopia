import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseUser;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/services/firebase/notification_service.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/common_api_calls.dart';
import 'package:utopia/view/common_ui/comment_container.dart';
import 'package:utopia/view/screens/CommentScreen/components/list_replies.dart';
import 'package:utopia/view/screens/DisplayArticleScreen/display_article_screen.dart';

class ReplyCommentScreen extends ConsumerWidget {
  final String commentId;
  final User commentOwner;
  final String articleId;
  String articleOwnerId;
  final String originalComment;
  final DateTime createdAt;

  ReplyCommentScreen(
      {super.key,
      required this.originalComment,
      required this.commentId,
      required this.commentOwner,
      required this.articleOwnerId,
      required this.createdAt,
      required this.articleId});

  final formKey = GlobalKey<FormState>();
  String myUserId = firebaseUser.FirebaseAuth.instance.currentUser!.uid;
  TextEditingController replyCommentController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
    var repliesStream = FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .orderBy('createdAt', descending: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: authBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Reply to ${commentOwner.name}",
          style: const TextStyle(fontFamily: "Open", fontSize: 14),
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
                        element.authorId == articleOwnerId);
                    if (indexOfArticle != -1) {
                      article = list[indexOfArticle];
                      break;
                    }
                  }
                  return FutureBuilder<User?>(
                    future: getUser(articleOwnerId),
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
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return await Future.delayed(const Duration(seconds: 2));
        },
        backgroundColor: authBackground,
        color: Colors.white,
        child: CommentBox(
          sendButtonMethod: () async {
            if (replyCommentController.text.trim().isNotEmpty) {
              // add reply to the previous comment

              await replyToThisComment(
                  reply: replyCommentController.text.trim(),
                  myUId: myUserId,
                  articleId: articleId,
                  commentId: commentId,
                  createdAt: DateTime.now().toString());

              // notify the user owner
              await notifyUserWhenRepliedOnMyComment(
                  currentUserId: myUserId,
                  userId: commentOwner.userId,
                  reply: replyCommentController.text.trim(),
                  articleId: articleId,
                  articleOwnerId: articleOwnerId,
                  comment: originalComment,
                  commentId: commentId,
                  commentOwnerId: commentOwner.userId);

              replyCommentController.clear();
            }
          },
          withBorder: true,
          errorText: 'Comment cannot be blank',
          commentController: replyCommentController,
          labelText: "Write your reply",
          sendWidget:
              const Icon(Icons.send_sharp, size: 30, color: authBackground),
          backgroundColor: Colors.white,
          formKey: formKey,
          textColor: Colors.black87,
          userImage: dataController.userState.user != null &&
                  dataController.userState.user!.dp.isNotEmpty
              ? dataController.userState.user!.dp
              : 'https://firebasestorage.googleapis.com/v0/b/utopia-a7a8a.appspot.com/o/res%2Fprofile.png?alt=media&token=6f5c39a1-ffe0-441e-b6e3-cfdd3609e24d',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            child: Column(
              children: [
                // Display the original comment
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CommentContainer(
                      articleOwnerId: articleOwnerId,
                      shouldNavigate: false,
                      commentId: commentId,
                      user: commentOwner,
                      articleId: articleId,
                      comment: originalComment,
                      createdAt: createdAt),
                ),
                Expanded(
                  child: StreamBuilder(
                    // Add comment replies stream
                    stream: repliesStream,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        dynamic replyData = snapshot.data.docs;
                        return ListReplies(
                          replyData: replyData,
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
