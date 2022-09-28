import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/calender_constant.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/helper_widgets.dart';
import 'package:utopia/view/screens/CommentScreen/comment_screen.dart';
import 'package:utopia/view/screens/DisplayArticleScreen/display_article_screen.dart';
import 'package:utopia/view/shimmers/article_shimmer.dart';

class ArticleBox extends StatefulWidget {
  final Article? article;
  ArticleBox({required this.article});

  @override
  State<ArticleBox> createState() => _ArticleBoxState();
}

class _ArticleBoxState extends State<ArticleBox> {
  bool loadingForLikeProcess = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userController, child) {
        // To get the current user details -> user 'userController.user!'
        String? imagePreview;
        for (Map<String, dynamic> body in widget.article!.body) {
          if (body['type'] == "image") {
            imagePreview = body['image'];
            break;
          }
        }
        dynamic articlePreview = widget.article!.body
            .firstWhere((element) => element['type'] == "text");

        return FutureBuilder<User?>(
          future: userController.getUser(widget.article!.authorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // To get the author detail use -> snapshot.data!
              User? author = snapshot.data!;
              List<String> initials = author.name.split(" ");
              String firstLetter = "", lastLetter = "";

              if (initials.length == 1) {
                firstLetter = initials[0].characters.first;
              } else {
                firstLetter = initials[0].characters.first;
                lastLetter = initials[1].characters.first;
              }
              return Consumer<MyArticlesController>(
                builder: (context, myArticlesController, child) {
                  if (myArticlesController.fetchingSavedArticlesStatus ==
                      FetchingSavedArticles.nil) {
                    myArticlesController
                        .fetchSavedArticles(userController.user!);
                  }

                  switch (myArticlesController.fetchingSavedArticlesStatus) {
                    case FetchingSavedArticles.nil:
                      return const Center(
                        child: Text("Nil data"),
                      );
                    case FetchingSavedArticles.fetching:
                      return const ShimmerForArticles();
                    case FetchingSavedArticles.fetched:
                      int index = myArticlesController.savedArticlesDetails
                          .indexWhere((element) =>
                              element.articleId == widget.article!.articleId &&
                              element.authorId == widget.article!.authorId);
                      return Column(
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayArticleScreen(
                                      article: widget.article!, author: author),
                                )),
                            child: Container(
                              // height: displayHeight(context) * 0.16,
                              width: displayWidth(context),
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: displayWidth(context) * 0.62,
                                    // color: Colors.yellow.shade100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Display picture of author
                                            (author.dp.isEmpty)
                                                ? CircleAvatar(
                                                    backgroundColor:
                                                        authMaterialButtonColor,
                                                    radius: 12,
                                                    child: Center(
                                                      child: initials.length > 1
                                                          ? Text(
                                                              "$firstLetter.$lastLetter"
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          : Text(
                                                              firstLetter
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                    ),
                                                  )
                                                : CircleAvatar(
                                                    radius: 12,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            author.dp),
                                                  ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              author.name,
                                              style: const TextStyle(
                                                  fontFamily: "Open",
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.w300),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          widget.article!.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontFamily: "Open",
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.6,
                                              fontSize: 14.5,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          articlePreview['text'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontFamily: "Fira",
                                              fontSize: 12.5,
                                              color: Colors.black54),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${calender[widget.article!.articleCreated.month]!} ${widget.article!.articleCreated.day}, ${widget.article!.articleCreated.year}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade500),
                                            ),
                                            SizedBox(
                                                width: displayWidth(context) *
                                                    0.08),

                                            // Like article
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0),
                                              child: StreamBuilder(
                                                  // Like stream
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('articles')
                                                      .doc(widget
                                                          .article!.articleId)
                                                      .collection('likes')
                                                      .snapshots(),
                                                  builder: (context,
                                                      AsyncSnapshot snapshot) {
                                                    int alreadyLiked = -1;

                                                    if (snapshot.hasData) {
                                                      List<dynamic> likes =
                                                          snapshot.data.docs;
                                                      alreadyLiked =
                                                          likes.indexWhere(
                                                        (element) =>
                                                            element['userId'] ==
                                                            userController
                                                                .user!.userId,
                                                      );

                                                      return InkWell(
                                                        onTap: () async {
                                                          if (!loadingForLikeProcess) {
                                                            if (alreadyLiked ==
                                                                -1) {
                                                              // Not liked yet
                                                              setState(() {
                                                                loadingForLikeProcess =
                                                                    true;
                                                              });
                                                              await likeArticle(
                                                                  widget
                                                                      .article!
                                                                      .articleId,
                                                                  userController
                                                                      .user!
                                                                      .userId);
                                                              setState(() {
                                                                loadingForLikeProcess =
                                                                    false;
                                                              });
                                                            } else {
                                                              // Already liked
                                                              setState(() {
                                                                loadingForLikeProcess =
                                                                    true;
                                                              });

                                                              await dislikeArticle(
                                                                  widget
                                                                      .article!
                                                                      .articleId,
                                                                  userController
                                                                      .user!
                                                                      .userId);
                                                              setState(() {
                                                                loadingForLikeProcess =
                                                                    false;
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
                                            const SizedBox(
                                              width: 28,
                                            ),

                                            // Comment article
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 2.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CommentScreen(
                                                          articleId: widget
                                                              .article!
                                                              .articleId,
                                                        ),
                                                      ));
                                                },
                                                child: Image.asset(
                                                    commentArticleIcon,
                                                    height: 18),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 28,
                                            ),
                                            // Save article
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 2.0),
                                              child: InkWell(
                                                onTap: () {
                                                  if (index != -1) {
                                                    // user has already saved this article
                                                    // call method to unsave this article
                                                    myArticlesController
                                                        .unsaveArticle(
                                                      articleId: widget
                                                          .article!.articleId,
                                                      authorId: widget
                                                          .article!.authorId,
                                                    );
                                                    userController
                                                        .unSaveArticle(
                                                            authorId: widget
                                                                .article!
                                                                .authorId,
                                                            articleId: widget
                                                                .article!
                                                                .articleId);
                                                  } else {
                                                    // user has not saved this article
                                                    // call method to save this article
                                                    myArticlesController
                                                        .saveArticle(
                                                            article:
                                                                widget.article);
                                                    userController.saveArticle(
                                                        authorId: widget
                                                            .article!.authorId,
                                                        articleId: widget
                                                            .article!
                                                            .articleId);
                                                  }
                                                },
                                                child: Image.asset(
                                                    index != -1
                                                        ? saveArticleIcon
                                                        : unsaveArticleIcon,
                                                    height: 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  (imagePreview != null)
                                      ? Expanded(
                                          child: CachedNetworkImage(
                                            imageUrl: imagePreview,
                                            errorWidget: (context, url, error) {
                                              return const Text(
                                                "Could not load image",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 10),
                                              );
                                            },
                                            placeholder: (context, url) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      authMaterialButtonColor,
                                                ),
                                              );
                                            },
                                            width: displayWidth(context) * 0.25,
                                            height:
                                                displayHeight(context) * 0.12,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      : Expanded(
                                          child: Image.asset(
                                            defaultArticleImage,
                                            width: displayWidth(context) * 0.25,
                                            height:
                                                displayHeight(context) * 0.12,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 2,
                            thickness: 1.2,
                            color: Colors.black.withOpacity(0.04),
                          ),
                        ],
                      );
                  }
                },
              );
            } else {
              return const ShimmerForArticles();
            }
          },
        );
      },
    );
  }
}
