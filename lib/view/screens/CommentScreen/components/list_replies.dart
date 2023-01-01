import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/common_api_calls.dart';
import 'package:utopia/view/common_ui/comment_container.dart';
import 'package:utopia/view/shimmers/comment_shimmer.dart';

class ListReplies extends ConsumerWidget {
  final dynamic replyData;

  const ListReplies({super.key, required this.replyData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: replyData.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemBuilder: (context, index) {
        // Comment data extracted
        DateTime createdAt = DateTime.parse(replyData[index]['createdAt']);
        String reply = replyData[index]['reply'];
        return FutureBuilder(
          future: getUser(replyData[index]['myUid']),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if ((snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) &&
                snapshot.hasData) {
              return CommentContainer(
                  articleOwnerId: '',
                  shouldNavigate: false,
                  commentId: replyData[index]['replyId'] ?? '',
                  user: snapshot.data!,
                  comment: reply,
                  articleId: replyData[index]['articleId'],
                  createdAt: createdAt);
            } else {
              return const CommentShimmer();
            }
          },
        );
      },
    );
  }
}
