import 'package:flutter/cupertino.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/skeleton.dart';
import 'package:utopia/view/screens/MyArticlesScreen/my_articles_screen.dart';
import 'package:utopia/view/screens/Skeletons/rec_article_skeleton.dart';

class ProfileScreenSkeleton extends StatelessWidget {
  const ProfileScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          children: [
            Skeleton(
                height: displayHeight(context) * 0.58,
                width: displayWidth(context)),
            Positioned(
                left: displayWidth(context) * 0.05,
                right: displayWidth(context) * 0.05,
                top: displayHeight(context) * 0.18,
                child: Skeleton(
                    height: displayHeight(context) * 0.38,
                    width: displayWidth(context) * 0.9)),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          height: displayHeight(context) * 0.35,
          width: displayWidth(context),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: RecentArticleSkeleton(),
              );
            },
            itemCount: 4,
          ),
        )
      ],
    );
  }
}
