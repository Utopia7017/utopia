import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/view/common_ui/comment_container.dart';

class ListComments extends StatelessWidget {
  final dynamic commentData;

  const ListComments({super.key, required this.commentData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: commentData.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemBuilder: (context, index) {
        // Comment data extracted
        DateTime createdAt = DateTime.parse(commentData[index]['createdAt']);
        String comment = commentData[index]['comment'];
        return Consumer<UserController>(
          builder: (context, value, child) {
            return FutureBuilder(
              future: value.getUser(commentData[index]['userId']),
              builder: (context, AsyncSnapshot<User?> snapshot) {
                if (snapshot.hasData) {
                  return CommentContainer(
                      userDp: snapshot.data!.dp,
                      userName: snapshot.data!.name,
                      userFollowers: snapshot.data!.followers.length,
                      comment: comment,
                      createdAt: createdAt);
                } else {
                  // TODO: Add Shimmer effect for comment box when loading
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          },
        );
      },
    );
  }
}
