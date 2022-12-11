import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utopia/view/screens/Skeletons/author_card_skeleton.dart';

class ShimmerForAuthorCard extends StatelessWidget {
  const ShimmerForAuthorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black54,
      highlightColor: Colors.black,
      enabled: true,
      child: const AuthorCardSkeleton(),
    );
  }
}