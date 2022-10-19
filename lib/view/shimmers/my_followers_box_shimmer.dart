import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utopia/view/screens/Skeletons/my_followers_box_skeleton.dart';

class  MyFollowerBoxShimmer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.black54,
        highlightColor: Colors.black,
        enabled: true,
        child: MyFollowersBoxSkeleton());
  }
}
