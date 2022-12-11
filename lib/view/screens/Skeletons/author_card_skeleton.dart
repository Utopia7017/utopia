import 'package:flutter/material.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/skeleton.dart';

class AuthorCardSkeleton extends StatelessWidget {
  const AuthorCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: displayHeight(context),
      width: displayWidth(context),
      child: Column(
        children: [
          Skeleton(
              height: displayHeight(context) * 0.15,
              width: displayWidth(context)),
          SizedBox(
            height: 10,
          ),
          Skeleton(height: 10, width: displayWidth(context) * 0.35),
          SizedBox(
            height: 15,
          ),
          Skeleton(height: 15, width: displayWidth(context) * 0.45),
          SizedBox(
            height: 10,
          ),
          Skeleton(height: 15, width: displayWidth(context) * 0.45),
          SizedBox(
            height: 10,
          ),
          Skeleton(height: 15, width: displayWidth(context) * 0.45),
          SizedBox(
            height: 10,
          ),
          Skeleton(height: 30, width: displayWidth(context) * 0.25),
        ],
      ),
    );
  }
}
