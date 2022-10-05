import 'package:flutter/material.dart';
import 'package:utopia/view/common_ui/skeleton.dart';

class NotificationBoxSkeleton extends StatelessWidget {
  const NotificationBoxSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Skeleton(height: 45, width: 40),
      title: Padding(
          padding: EdgeInsets.only(bottom: 12.0, top: 10),
          child: Skeleton(
            height: 12,
            width: 0,
          )),
      trailing: Skeleton(height: 40, width: 35),
      subtitle: Skeleton(height: 30, width: 0),
    );
  }
}
