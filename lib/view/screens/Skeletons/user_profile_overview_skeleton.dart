import 'package:flutter/material.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/skeleton.dart';

class UserProfileOverviewSkeleton extends StatelessWidget {
  UserProfileOverviewSkeleton({Key? key}) : super(key: key);
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
        space,
        Skeleton(
            height: displayHeight(context) * 0.035,
            width: displayWidth(context) * 0.5),
        space,
        Skeleton(
            height: displayHeight(context) * 0.08,
            width: displayWidth(context) * 0.85),
        space,
        space,
        Container(
          height: displayHeight(context) * 0.1,
          // color: Colors.blue.shade100,
          width: displayWidth(context),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Skeleton(
                      height: displayHeight(context) * 0.02,
                      width: displayWidth(context) * 0.25),
                  space,
                  Skeleton(
                      height: displayHeight(context) * 0.04,
                      width: displayWidth(context) * 0.04),
                ],
              ),
              verticalSpace,
              Column(
                children: [
                  Skeleton(
                      height: displayHeight(context) * 0.02,
                      width: displayWidth(context) * 0.25),
                  space,
                  Skeleton(
                      height: displayHeight(context) * 0.04,
                      width: displayWidth(context) * 0.04),
                ],
              ),
              verticalSpace,
              Column(
                children: [
                  Skeleton(
                      height: displayHeight(context) * 0.02,
                      width: displayWidth(context) * 0.25),
                  space,
                  Skeleton(
                      height: displayHeight(context) * 0.04,
                      width: displayWidth(context) * 0.04),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
