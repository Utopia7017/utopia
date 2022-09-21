import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/profile_detail_box.dart';

class UserProfileOverView extends StatelessWidget {
  final User user;
  UserProfileOverView({Key? key, required this.user}) : super(key: key);

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
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: "Fira",
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        space,
        user.bio.isNotEmpty
            ? Text(
                user.bio,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            : const SizedBox(),
        user.bio.isNotEmpty ? space : const SizedBox(),
        SizedBox(
          width: displayWidth(context) * 0.35,
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(6),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
              backgroundColor: MaterialStateProperty.all(authBackground),
            ),
            onPressed: () {
              // TODO: Implement a method to follow / unfollow user
            },
            child: Text(
              "Follow",
              style: TextStyle(
                  fontFamily: "",
                  letterSpacing: 0.4,
                  color: Colors.white.withOpacity(0.85)),
            ),
          ),
        ),
        const SizedBox(height: 15),
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
              ProfileDetailBox(
                  value: user.following.length,
                  label: "Following",
                  callback: () => null),
              verticalSpace,
              ProfileDetailBox(
                  value: user.followers.length,
                  label: "Followers",
                  callback: () => null),
              verticalSpace,
              ProfileDetailBox(
                  value: 0, label: "Articles", callback: () => null),
            ],
          ),
        )
      ],
    );
  }
}
