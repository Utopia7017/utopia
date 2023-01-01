import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/ProfileScreen/components/profile_box.dart';
import 'package:utopia/view/screens/ProfileScreen/components/top_articles_list.dart';
import 'package:utopia/view/shimmers/profile_screen_shimmer.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  final space = const SizedBox(height: 10);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SizedBox(
          height: displayHeight(context),
          width: displayWidth(context),
          child: Builder(
            builder: (context) {
              if (dataController.userState.profileStatus ==
                  ProfileStatus.NOT_FETCHED) {
                controller.setUser(FirebaseAuth.instance.currentUser!.uid);
              }

              switch (dataController.userState.profileStatus) {
                case ProfileStatus.NOT_FETCHED:
                  return RefreshIndicator(
                    onRefresh: () => controller
                        .setUser(FirebaseAuth.instance.currentUser!.uid),
                    child: ListView(
                      children: const [
                        Center(
                          child: Text('Swipe to fetch profile'),
                        ),
                      ],
                    ),
                  );
                case ProfileStatus.FETCHING:
                  return const ProfileScreenShimmer();
                case ProfileStatus.FETCHED:
                  // Profile is fetched
                  switch (dataController.userState.userUploadingImage) {
                    // user is uploading image
                    case UserUploadingImage.LOADING:
                      return const ProfileScreenShimmer();
                    // user is not not uploading image
                    case UserUploadingImage.NOT_LOADING:
                      return RefreshIndicator(
                        color: authBackground,
                        onRefresh: () => controller
                            .setUser(FirebaseAuth.instance.currentUser!.uid),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile box
                            ProfileBox(user: dataController.userState.user!),
                            const SizedBox(height: 10),
                            // Recent Articles or Top 10 articles
                            TopArticlesList(
                                user: dataController.userState.user!),
                          ],
                        ),
                      );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
