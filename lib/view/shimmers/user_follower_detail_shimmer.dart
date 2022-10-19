import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utopia/view/screens/Skeletons/notification_box_skeleton.dart';
import 'package:utopia/view/screens/Skeletons/user_follower_detail_skeleton.dart';

class  UserFollowerDetailShimmer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.black54,
        highlightColor: Colors.black,
        enabled: true,
        child: UserFollowersDetailBoxSkeleton());
  }
}
