import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/utils/device_size.dart';

class SaveDraftDialog extends StatelessWidget {
  SaveDraftDialog({super.key});

  TextEditingController titleController = TextEditingController();
  final String myUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyArticlesController>(
      builder: (context, myArtilcleController, child) {
        return AlertDialog(
          title: const Text(
            "Save this as draft ?",
            style: TextStyle(fontFamily: "Open", fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Do you wish to save this article as draft ?",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: displayHeight(context) * 0.065,
                  child: TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(hintText: "Draft title"),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No")),
            TextButton(
                onPressed: () {
                  myArtilcleController.draftMyArticle(
                      userId: myUid, title: titleController.text, tags: []);
                  Navigator.pop(context);
                },
                child: const Text("Yes")),
          ],
        );
      },
    );
  }
}
