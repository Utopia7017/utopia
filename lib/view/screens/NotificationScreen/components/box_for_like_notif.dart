import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:utopia/constants/image_constants.dart';

class BoxForLikeNotification extends StatelessWidget {
  final String notifierDp;
  final String notifierName;
  final String notifierId;
  final Timestamp time;

  BoxForLikeNotification(
      {super.key,
      required this.notifierDp,
      required this.notifierName,
      required this.notifierId,
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
          text: " liked your article",
          style: TextStyle(
              fontSize: 13.2, color: Colors.black54, letterSpacing: 0.35)),
    ]));
    String createdOn = timeago.format(time.toDate());
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: notifierDp,
        fit: BoxFit.fitWidth,
        height: 45,
        width: 40,
      ),
      title: Padding(padding: const EdgeInsets.only(bottom: 4.0), child: title),
      subtitle: Text(
        createdOn,
        style: const TextStyle(
            fontSize: 11.5,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontFamily: "Open"),
      ),
      trailing:
          Image.asset(notificationLikeIcon, height: 25, fit: BoxFit.cover),
    );
  }
}
