import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/services/firebase/notification_service.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/CommentScreen/comment_screen.dart';

class FloatingButtonForArticleOptions extends StatefulWidget {
  final Article article;
  final bool isVisible;
  const FloatingButtonForArticleOptions(
      {Key? key, required this.isVisible, required this.article})
      : super(key: key);

  @override
  State<FloatingButtonForArticleOptions> createState() =>
      _FloatingButtonForArticleOptionsState();
}

class _FloatingButtonForArticleOptionsState
    extends State<FloatingButtonForArticleOptions> {
  String myUserId = FirebaseAuth.instance.currentUser!.uid;

  bool loadingForLikeProcess = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 750),
        height: widget.isVisible ? displayHeight(context) * 0.21 : 0.0,
        width: displayWidth(context) * 0.1,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Like Article
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: StreamBuilder(
                    // Like stream
                    stream: FirebaseFirestore.instance
                        .collection('articles')
                        .doc(widget.article.articleId)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      int alreadyLiked = -1;

                      if (snapshot.hasData) {
                        List<dynamic> likes = snapshot.data.docs;
                        alreadyLiked = likes.indexWhere(
                          (element) => element['userId'] == myUserId,
                        );
                        return InkWell(
                          onTap: () async {
                            if (!loadingForLikeProcess) {
                              if (alreadyLiked == -1) {
                                // Not liked yet

                                setState(() {
                                  loadingForLikeProcess = true;
                                });
                                await likeArticle(
                                    widget.article.articleId, myUserId);
                                notifyUserWhenLikedArticle(
                                    myUserId,
                                    widget.article.authorId,
                                    widget.article.articleId);
                                setState(() {
                                  loadingForLikeProcess = false;
                                });
                              } else {
                                // Already liked
                                setState(() {
                                  loadingForLikeProcess = true;
                                });
                                await dislikeArticle(
                                    widget.article.articleId, myUserId);
                                setState(() {
                                  loadingForLikeProcess = false;
                                });
                              }
                            }
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                (alreadyLiked == -1)
                                    ? likeNotPressedIcon
                                    : likePressedIcon,
                                height: 18,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(likes.length.toString())
                            ],
                          ),
                        );
                      }
                      return Image.asset(
                        (alreadyLiked == -1)
                            ? likeNotPressedIcon
                            : likePressedIcon,
                        height: 18,
                      );
                    }),
              ),
            ),

            // Comment article
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentScreen(
                            articleId: widget.article.articleId,
                            authorId: widget.article.authorId,
                          ),
                        ));
                  },
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('articles')
                          .doc(widget.article.articleId)
                          .collection('comments')
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Image.asset(commentArticleIcon, height: 18),
                              Text(
                                snapshot.data.docs.length.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Image.asset(commentArticleIcon, height: 18),
                              const Text('0'),
                            ],
                          );
                        }
                      }),
                ),
              ),
            ),

            // Save article
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Consumer<UserController>(
                builder: (context, userController, child) {
                  return Consumer<MyArticlesController>(
                    builder: (context, myArticleController, child) {
                      int index = myArticleController.savedArticlesDetails
                          .indexWhere((element) =>
                              element.articleId == widget.article.articleId &&
                              element.authorId == widget.article.authorId);

                      return InkWell(
                          onTap: () {
                            if (index != -1) {
                              // user has already saved this article
                              // call method to unsave this article
                              myArticleController.unsaveArticle(
                                articleId: widget.article.articleId,
                                authorId: widget.article.authorId,
                              );
                              userController.unSaveArticle(
                                  authorId: widget.article.authorId,
                                  articleId: widget.article.articleId);
                            } else {
                              // user has not saved this article
                              // call method to save this article
                              myArticleController.saveArticle(
                                  article: widget.article);
                              userController.saveArticle(
                                  authorId: widget.article.authorId,
                                  articleId: widget.article.articleId);
                            }
                          },
                          child: Image.asset(
                              index != -1 ? saveArticleIcon : unsaveArticleIcon,
                              height: 18));
                    },
                  );
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}
