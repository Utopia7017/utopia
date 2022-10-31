import 'package:flutter/material.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/skeleton.dart';

class RecentArticleSkeleton extends StatelessWidget {
  const RecentArticleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Skeleton(
          width: displayWidth(context) * 0.4,
          height: displayHeight(context) * 0.18,
        ),
        const SizedBox(
          height: 10,
        ),
        Skeleton(
          height: displayHeight(context) * 0.03,
          width: displayWidth(context) * 0.4,
        ),
        const SizedBox(
          height: 10,
        ),
        Skeleton(
          height: displayHeight(context) * 0.015,
          width: displayWidth(context) * 0.4,
        ),
        const SizedBox(
          height: 5,
        ),
        Skeleton(
          height: displayHeight(context) * 0.015,
          width: displayWidth(context) * 0.4,
        ),
        const SizedBox(
          height: 5,
        ),
        Skeleton(
          height: displayHeight(context) * 0.015,
          width: displayWidth(context) * 0.4,
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
