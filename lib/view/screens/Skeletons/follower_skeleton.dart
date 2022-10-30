import 'package:flutter/material.dart';

import '../../common_ui/skeleton.dart';

class FollowerSkeleton extends StatelessWidget {
  const FollowerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Skeleton(height: 35, width: 37),
      title: Skeleton(
            height: 27,
            width: 80,
          ),
      trailing: Skeleton(height: 30, width: 95),
    );
  }
}