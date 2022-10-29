import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/DisplayArticleScreen/display_article_screen.dart';
import 'package:utopia/view/screens/EditDraftScreen/edit_draft_screen.dart';

class DraftArticleBox extends StatefulWidget {
  final Article? article;
  DraftArticleBox({required this.article});

  @override
  State<DraftArticleBox> createState() => _DraftArticleBoxState();
}

class _DraftArticleBoxState extends State<DraftArticleBox> {
  bool loadingForLikeProcess = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(builder: (context, userController, child) {
      // To get the current user details -> user 'userController.user!'
      User author = userController.user!;
      List<String> initials = author.name.split(" ");
      String firstLetter = "", lastLetter = "";
      String? imagePreview;
      if (initials.length == 1) {
        firstLetter = initials[0].characters.first;
      } else {
        firstLetter = initials[0].characters.first;
        lastLetter = initials[1].characters.first;
      }

      for (Map<String, dynamic> body in widget.article!.body) {
        if (body['type'] == "image") {
          imagePreview = body['image'];
          break;
        }
      }
      dynamic articlePreview = widget.article!.body
          .firstWhere((element) => element['type'] == "text");

      return Consumer<MyArticlesController>(
        builder: (context, myArticleController, child) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  myArticleController.clearFullForm();
                  for (Map<String, dynamic> body in widget.article!.body) {
                    if (body['type'] == 'text') {
                      myArticleController.addTextField(body['text']);
                    } else {
                      myArticleController.addImageField(null, body['image']);
                    }
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditDraftScreen(
                            draftId: widget.article!.articleId,
                            authorId: widget.article!.articleId),
                      ));
                },
                child: Container(
                  // height: displayHeight(context) * 0.16,
                  width: displayWidth(context),
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                )
                                              : Text(
                                                  firstLetter.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
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
                                        color: Colors.black87, fontSize: 10),
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
              Divider(
                height: 2,
                thickness: 1.2,
                color: Colors.black.withOpacity(0.04),
              ),
            ],
          );
        },
      );
    });
  }
}
