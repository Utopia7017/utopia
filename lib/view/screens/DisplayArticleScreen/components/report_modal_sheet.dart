import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/common_api_calls.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/skeleton.dart';

class ReportModalSheet extends ConsumerWidget {
  final String articleId;
  final String articleOwnerId;
  ReportModalSheet(
      {super.key, required this.articleId, required this.articleOwnerId});

  final String myUid = FirebaseAuth.instance.currentUser!.uid;
  final List<String> reasons = [
    "I don't like it",
    "Hate Speech",
    "Violence or dangerous",
    "Nudity or sexual activity",
    "Scam or fraud",
    "False information",
    "This is spam",
  ];

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
    void report(String reason) {
      reportArticle(articleOwnerId, articleId, myUid, reason);
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
          Column(
            children: [
              for (String reason in reasons)
                ListTile(
                  onTap: () {
                    report(
                      reason,
                    );

                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        onConfirmBtnTap: () {
                         controller.fetchArticles();
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        title: "Successfully Reported");
                  },
                  visualDensity: const VisualDensity(vertical: -4),
                  title: Text(
                    reason,
                    style: const TextStyle(
                      fontSize: 14.5,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
