import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utopia/view/screens/Skeletons/comment_box_skeleton.dart';
import 'package:utopia/view/screens/Skeletons/profile_screen_skeleton.dart';

class ProfileScreenShimmer extends StatelessWidget {
  const ProfileScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black54,
      highlightColor: Colors.black,
      enabled: true,
      child: const ProfileScreenSkeleton(),
    );
  }
}
