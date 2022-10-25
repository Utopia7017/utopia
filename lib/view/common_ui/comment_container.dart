import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:utopia/models/user_model.dart';
import 'package:utopia/view/screens/CommentScreen/reply_comment_screen.dart';

class CommentContainer extends StatelessWidget {
  final String commentId;
  final String articleOwnerId;
  final User user;
  final String comment;
  final DateTime createdAt;
  final String articleId;
  final bool shouldNavigate;
  int? numberOfreplies;

  CommentContainer({
    super.key,
    required this.commentId,
    required this.shouldNavigate,
    required this.user,
    required this.articleOwnerId,
    required this.articleId,
    required this.comment,
    this.numberOfreplies,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    List<String> initials = user.name.split(" ");
    String firstLetter = "", lastLetter = "";

    if (initials.length == 1) {
      firstLetter = initials[0].characters.first;
    } else {
      firstLetter = initials[0].characters.first;
      lastLetter = initials[1].characters.first;
    }

    return InkWell(
      onLongPress: () {
        // TODO: prompt a dialog box and ask user if he/she wants to delete the comment.
        //Also make sure that user can delete only thier own comment by checking current user id and comment user id
        // @kaizer111
      },
      onTap: () {
        if (shouldNavigate) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReplyCommentScreen(
                    articleOwnerId: articleOwnerId,
                    
                    createdAt: createdAt,
                    originalComment: comment,
                    commentId: commentId,
                    commentOwner: user,
                    articleId: articleId),
              ));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  (user.dp.isNotEmpty)
                      ? CircleAvatar(
                          backgroundColor: authMaterialButtonColor,
                          backgroundImage: CachedNetworkImageProvider(user.dp),
                        )
                      : CircleAvatar(
                          backgroundColor: authMaterialButtonColor,
                          child: initials.length > 1
                              ? Text(
                                  "$firstLetter.$lastLetter".toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                )
                              : Text(
                                  firstLetter.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                        ),
                  const SizedBox(width: 10),
                  Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                timeago.format(createdAt),
                style: const TextStyle(color: Colors.black54),
              )
            ],
          ),
          const SizedBox(height: 15),
          Text(
            comment,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (shouldNavigate)
                  ? (numberOfreplies! > 0)
                      ? Text(
                          '${numberOfreplies!.toString()} replies',
                          style: const TextStyle(
                              fontFamily: "Open",
                              fontSize: 12,
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold),
                        )
                      : const SizedBox()
                  : const SizedBox(),
            ],
          ),
          const Divider(
            // height: 15,
            thickness: 0.25,
          ),
        ],
      ),
    );
  }
}
