import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:utopia/constants/image_constants.dart';

class BoxForCommentNotification extends StatelessWidget {
  final String notifierDp;
  final String notifierName;
  final String notifierId;
  final Timestamp time;
  final String comment;

  BoxForCommentNotification(
      {super.key,
      required this.notifierDp,
      required this.notifierName,
      required this.notifierId,
      required this.comment,
      required this.time});

  @override
  Widget build(BuildContext context) {
    RichText title = RichText(
        text: TextSpan(children: [
      TextSpan(
          text: notifierName,
          style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3)),
      const TextSpan(
          text: " commented on your article",
          style: TextStyle(
              fontSize: 13.2, color: Colors.black54, letterSpacing: 0.35)),
    ]));

    List<String> initials = notifierName.split(" ");
    String firstLetter = "", lastLetter = "";

    if (initials.length == 1) {
      firstLetter = initials[0].characters.first;
    } else {
      firstLetter = initials[0].characters.first;
      lastLetter = initials[1].characters.first;
    }
    String createdOn = timeago.format(time.toDate());
    
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: notifierDp,
        fit: BoxFit.fitWidth,
        height: 45,
        width: 40,
      ),
      title: Padding(
          padding: const EdgeInsets.only(bottom: 4.0, top: 4), child: title),
      // isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black87.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: "Open",
            ),
          ),
          const SizedBox(height: 4),
          Text(
            createdOn,
            style: const TextStyle(
                fontSize: 11.5,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontFamily: "Open"),
          ),
        ],
      ),
      trailing:
          Image.asset(notificationCommentIcon, height: 30, fit: BoxFit.cover),
    );
  }
}
