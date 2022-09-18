import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/calender_constant.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controlller/user_controller.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/helper_widgets.dart';
import 'package:utopia/view/screens/CommentScreen/comment_screen.dart';
import 'package:utopia/view/screens/DisplayArticleScreen/display_article_screen.dart';

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
      builder: (context, controller, child) {
        String? imagePreview;
        for (Map<String, dynamic> body in widget.article!.body) {
          if (body['type'] == "image") {
            imagePreview = body['image'];
            break;
          }
        }
        dynamic articlePreview = widget.article!.body
            .firstWhere((element) => element['type'] == "text");
        print('first text : ${articlePreview['text']}');
        Future<User?> user = controller.getUser(widget.article!.authorId);
        return FutureBuilder<User?>(
          future: controller.getUser(widget.article!.authorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              User? user = snapshot.data!;
              return Column(
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayArticleScreen(
                              article: widget.article!, author: user),
                        )),
                    child: Container(
                      // height: displayHeight(context) * 0.16,
                      width: displayWidth(context),
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: displayWidth(context) * 0.62,
                            // color: Colors.yellow.shade100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const CircleAvatar(
                                      radius: 12,
                                      backgroundImage: AssetImage(
                                          "assets/icons/profile.png"),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      user.name,
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
                                      fontSize: 15.4,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  articlePreview['text'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: "Fira",
                                      fontSize: 13.5,
                                      color: Colors.black54),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${calender[widget.article!.articleCreated.month]!} ${widget.article!.articleCreated.day}, ${widget.article!.articleCreated.year}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500),
                                    ),
                                    SizedBox(
                                        width: displayWidth(context) * 0.08),

                                    // Like article
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: StreamBuilder(
                                          // Like stream
                                          stream: FirebaseFirestore.instance
                                              .collection('articles')
                                              .doc(widget.article!.articleId)
                                              .collection('likes')
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            int alreadyLiked = -1;

                                            if (snapshot.hasData) {
                                              List<dynamic> likes =
                                                  snapshot.data.docs;
                                              alreadyLiked = likes.indexWhere(
                                                (element) =>
                                                    element['userId'] ==
                                                    controller.user!.userId,
                                              );
                                              return InkWell(
                                                onTap: () async {
                                                  if (!loadingForLikeProcess) {
                                                    if (alreadyLiked == -1) {
                                                      // Not liked yet
                                                      print(
                                                          "Called from not Liked yet if part");
                                                      setState(() {
                                                        loadingForLikeProcess =
                                                            true;
                                                      });
                                                      await likeArticle(
                                                          widget.article!
                                                              .articleId,
                                                          controller
                                                              .user!.userId);
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
                                                      print(
                                                          "Called from already Liked else part");
                                                      await dislikeArticle(
                                                          widget.article!
                                                              .articleId,
                                                          controller
                                                              .user!.userId);
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
                                      padding:
                                          const EdgeInsets.only(bottom: 2.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CommentScreen(
                                                      articleId: widget.article!.articleId,
                                                    ),
                                              ));
                                        },
                                        child: Image.asset(commentArticleIcon,
                                            height: 18),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 28,
                                    ),
                                    // Save article
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 2.0),
                                      child: Image.asset(saveArticleIcon,
                                          height: 18),
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
                                        child: CircularProgressIndicator(
                                          color: authMaterialButtonColor,
                                        ),
                                      );
                                    },
                                    width: displayWidth(context) * 0.25,
                                    height: displayHeight(context) * 0.12,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Expanded(
                                  child: Image.asset(
                                    defaultArticleImage,
                                    width: displayWidth(context) * 0.25,
                                    height: displayHeight(context) * 0.12,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2,
                    thickness: 1.5,
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}
