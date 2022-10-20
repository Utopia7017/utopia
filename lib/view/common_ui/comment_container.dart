import 'package:flutter/material.dart';
import 'package:utopia/constants/calender_constant.dart';
import 'package:utopia/constants/color_constants.dart';

class CommentContainer extends StatelessWidget {
  final String userName;
  final int userFollowers;
  final String userDp;
  final String comment;
  final DateTime createdAt;

  CommentContainer({
    super.key,
    required this.userDp,
    required this.userName,
    required this.userFollowers,
    required this.comment,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    bool hasPicture = userDp.isNotEmpty;

    String? initials;

    if (!hasPicture) {
      if (userName.length == 1) {
        initials = userName.characters.first;
      } else {
        final split = userName.split(" ");
        initials = "${split[0].characters.first}.${split[1].characters.first}";
      }
    }

    return InkWell(
      onLongPress: () {
        // TODO: prompt a dialog box and ask user if he/she wants to delete the comment.
        //Also make sure that user can delete only thier own comment by checking current user id and comment user id
        // @kaizer111
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: authMaterialButtonColor,
                    backgroundImage: hasPicture ? NetworkImage(userDp) : null,
                    child: !hasPicture
                        ? Center(
                            child: Text(
                              initials!.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    userName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              // TODO: Show year if current year does not match created year
              Text(
                '${calender[createdAt.month]} ${createdAt.day}',
                style: const TextStyle(color: Colors.black54),
              )
            ],
          ),
          const SizedBox(height: 15),
          Text(
            comment,
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            // height: 15,
            thickness: 0.25,
          ),
        ],
      ),
    );
  }
}
