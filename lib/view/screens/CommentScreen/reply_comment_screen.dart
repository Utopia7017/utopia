import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseUser;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/articles_controller.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/services/firebase/notification_service.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/comment_container.dart';
import 'package:utopia/view/screens/CommentScreen/components/list_replies.dart';
import 'package:utopia/view/screens/DisplayArticleScreen/display_article_screen.dart';

class ReplyCommentScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                        element.authorId == articleOwnerId);
                    if (indexOfArticle != -1) {
                      article = list[indexOfArticle];
                      break;
                    }
                  }
                  return FutureBuilder<User?>(
                    future: Provider.of<UserController>(context, listen: false)
                        .getUser(articleOwnerId),
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
        child: Consumer<UserController>(
          builder: (context, userController, child) {
            return CommentBox(
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
              userImage: CachedNetworkImageProvider(userController.user !=
                          null &&
                      userController.user!.dp.isNotEmpty
                  ? userController.user!.dp
                  : 'https://firebasestorage.googleapis.com/v0/b/utopia-a7a8a.appspot.com/o/res%2Fprofile.png?alt=media&token=6f5c39a1-ffe0-441e-b6e3-cfdd3609e24d'),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
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
            );
          },
        ),
      ),
    );
  }
}
