import 'package:flutter/material.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/skeleton.dart';

class MyFollowersBoxSkeleton extends StatelessWidget {
  MyFollowersBoxSkeleton({Key? key}) : super(key: key);
  final space = const SizedBox(height: 10);
  final verticalSpace = VerticalDivider(
    indent: 12,
    endIndent: 12,
    thickness: 0.5,
    color: Colors.grey.shade400,
    width: 15,
  );
  @override
  Widget build(BuildContext context) {
    return Skeleton(
      height: displayHeight(context) * 0.08,
      width: displayWidth(context) * 0.6,
    );
  }
}
