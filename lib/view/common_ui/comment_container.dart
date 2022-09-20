import 'package:flutter/material.dart';
import 'package:utopia/constants/calender_constant.dart';

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
                    backgroundImage: NetworkImage(userDp),
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
