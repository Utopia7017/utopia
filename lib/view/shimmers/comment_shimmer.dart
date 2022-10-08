import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utopia/view/screens/Skeletons/comment_box_skeleton.dart';

class CommentShimmer extends StatelessWidget {
  const CommentShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black54,
      highlightColor: Colors.black,
      enabled: true,
      child: const CommentBoxSkeleton(),
    );
  }
}
