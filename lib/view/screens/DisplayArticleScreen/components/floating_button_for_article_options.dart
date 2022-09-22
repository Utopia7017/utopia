import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/helper_widgets.dart';
import 'package:utopia/view/screens/CommentScreen/comment_screen.dart';

class FloatingButtonForArticleOptions extends StatefulWidget {
  final Article article;
  final bool isVisible;
  FloatingButtonForArticleOptions(
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
        height: widget.isVisible ? displayHeight(context) * 0.2 : 0.0,
        width: displayWidth(context) * 0.1,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Like Article
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
                                print("Called from not Liked yet if part");
                                setState(() {
                                  loadingForLikeProcess = true;
                                });
                                await likeArticle(
                                    widget.article.articleId, myUserId);
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
                          child: Image.asset(
                            (alreadyLiked == -1)
                                ? likeNotPressedIcon
                                : likePressedIcon,
                            height: 18,
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
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentScreen(
                            articleId: widget.article.articleId,
                          ),
                        ));
                  },
                  child: Image.asset(commentArticleIcon, height: 18),
                ),
              ),
            ),

            // Save article
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(saveArticleIcon, height: 18),
            )),
          ],
        ),
      ),
    );
  }
}
