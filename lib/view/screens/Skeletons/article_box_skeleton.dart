import 'package:flutter/material.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/skeleton.dart';

class ArticleSkeleton extends StatelessWidget {
  const ArticleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // height: displayHeight(context) * 0.15,
          width: displayWidth(context),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: displayWidth(context) * 0.62,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Skeleton(height: 20, width: 100),
                    const SizedBox(height: 12),
                    const Skeleton(height: 16, width: 50),
                    const SizedBox(height: 12),
                    Skeleton(height: 50, width: displayWidth(context) * 0.62)
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child:
                    Skeleton(height: 100, width: displayWidth(context) * 0.26),
              )),
            ],
          ),
        ),
        Divider(
          color: Colors.black.withOpacity(0.04),
        ),
      ],
    );
  }
}
