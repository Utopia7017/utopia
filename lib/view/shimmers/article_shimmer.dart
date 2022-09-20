import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/Skeletons/article_box_skeleton.dart';

class ShimmerForArticles extends StatelessWidget {
  const ShimmerForArticles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black54,
      highlightColor: Colors.black,
      enabled: true,
      child: ArticleSkeleton(),
    );
  }
}
