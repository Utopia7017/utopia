import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/controller/articles_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/skeleton.dart';

class ReportModalSheet extends StatelessWidget {
  final String articleId;
  final String articleOwnerId;
  ReportModalSheet(
      {super.key, required this.articleId, required this.articleOwnerId});

  final String myUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    void report(String reason) {
      Provider.of<ArticlesController>(context, listen: false)
          .reportArticle(articleOwnerId, articleId, myUid, reason);
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Skeleton(height: 6, width: displayWidth(context) * 0.3),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Report Article",
            style: TextStyle(
                color: Colors.red, fontSize: 15, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Please specify why you are reporting this article.",
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          ListTile(
            onTap: () => report(
              "I don't like it",
            ),
            visualDensity: const VisualDensity(vertical: -4),
            title: const Text(
              "I don't like it",
              style: TextStyle(
                fontSize: 14.5,
              ),
            ),
          ),
          ListTile(
            onTap: () => report(
              "Hate Speech",
            ),
            visualDensity: const VisualDensity(vertical: -4),
            title: const Text(
              "Hate Speech",
              style: TextStyle(
                fontSize: 14.5,
              ),
            ),
          ),
          ListTile(
            onTap: () => report(
              "Violence or dangerous",
            ),
            visualDensity: const VisualDensity(vertical: -4),
            title: const Text(
              "Violence or dangerous",
              style: TextStyle(
                fontSize: 14.5,
              ),
            ),
          ),
          ListTile(
            onTap: () => report(
              "Nudity or sexual activity",
            ),
            visualDensity: const VisualDensity(vertical: -4),
            title: const Text(
              "Nudity or sexual activity",
              style: TextStyle(
                fontSize: 14.5,
              ),
            ),
          ),
          ListTile(
            onTap: () => report("Scam or fraud"),
            visualDensity: const VisualDensity(vertical: -4),
            title: const Text(
              "Scam or fraud",
              style: TextStyle(
                fontSize: 14.5,
              ),
            ),
          ),
          ListTile(
            onTap: () => report("False information"),
            visualDensity: const VisualDensity(vertical: -4),
            title: const Text(
              "False information",
              style: TextStyle(
                fontSize: 14.5,
              ),
            ),
          ),
          ListTile(
            onTap: () => report(
              "This is spam",
            ),
            visualDensity: const VisualDensity(vertical: -4),
            title: const Text(
              "This is spam",
              style: TextStyle(
                fontSize: 14.5,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
