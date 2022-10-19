import 'package:flutter/material.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/skeleton.dart';

class UserFollowersDetailBoxSkeleton extends StatelessWidget {
  UserFollowersDetailBoxSkeleton({Key? key}) : super(key: key);
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
    return Column(
      children: [
        Skeleton(
          height: displayHeight(context) * 0.08,
          width: displayWidth(context) * 0.6,
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Skeleton(
              height: displayHeight(context) * 0.06,
              width: displayWidth(context) * 0.3,
            ),
            const SizedBox(width: 25),
            Skeleton(
              height: displayHeight(context) * 0.06,
              width: displayWidth(context) * 0.3,
            ),
          ],
        )
      ],
    );
  }
}
