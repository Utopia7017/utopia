import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utopia/view/screens/Skeletons/rec_article_skeleton.dart';

class RecentArticleShimmer extends StatelessWidget {
  const RecentArticleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.black54,
        highlightColor: Colors.black,
        enabled: true,
        child: const RecentArticleSkeleton());
  }
}
