import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/common_api_calls.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/ProfileScreen/components/top_articles_list.dart';
import 'package:utopia/view/shimmers/profile_screen_shimmer.dart';
import 'components/user_profile_box.dart';

class UserProfileScreen extends ConsumerWidget {
  final String userId;
  UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: SizedBox(
            height: displayHeight(context),
            width: displayWidth(context),
            child: FutureBuilder(
              future: getUser(userId),
              builder: (context, AsyncSnapshot<User?> userSnapshot) {
                // If user is fetched
                if (userSnapshot.hasData) {
                  User thisUser = userSnapshot.data!;
                  return SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile box
                        UserProfileBox(user: thisUser),
                        const SizedBox(height: 10),
                        // Recent Articles or Top 10 articles
                        TopArticlesList(user: thisUser),
                      ],
                    ),
                  );
                }
                // if user is not fetched
                else {
                  return const ProfileScreenShimmer();
                }
              },
            ),
          ),
        ));
  }
}
