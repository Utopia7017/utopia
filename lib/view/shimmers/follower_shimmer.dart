import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utopia/view/screens/Skeletons/follower_skeleton.dart';

class FollowerShimmer extends StatelessWidget {
  const FollowerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.black54,
        highlightColor: Colors.black,
        enabled: true,
        child: const FollowerSkeleton());
  }
}