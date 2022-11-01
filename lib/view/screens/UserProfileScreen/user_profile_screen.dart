import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/ProfileScreen/components/top_articles_list.dart';

import 'components/user_profile_box.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;
  UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  final space = const SizedBox(height: 10);
  final verticalSpace = VerticalDivider(
    indent: 12,
    endIndent: 12,
    thickness: 0.5,
    color: Colors.grey.shade400,
    width: 15,
  );
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: SizedBox(
            height: displayHeight(context),
            width: displayWidth(context),
            child: FutureBuilder(
              future: Provider.of<UserController>(context).getUser(userId),
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
                  // TODO : return shimmer effect for whole screen
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ));
  }
}
