import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controlller/user_controller.dart';
import 'package:utopia/models/comment_model.dart';
// import 'package:utopia/models/comment_model.dart';

class CommentScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        elevation: 0,
        backgroundColor: authBackground,
        iconTheme: IconThemeData(color: primaryBackgroundColor),
      ),
      backgroundColor: primaryBackgroundColor,
      body: Container(
        child: Consumer<UserController>(
          builder: (context, controller, child) {
            return CommentBox(
              withBorder: true,
              errorText: 'Comment cannot be blank',
              commentController: commentController,
              labelText: "Write your comment",
              sendWidget:
                  const Icon(Icons.send_sharp, size: 30, color: authBackground),
              backgroundColor: Colors.white,
              formKey: formKey,
              textColor: Colors.black87,
              userImage: controller.user != null &&
                      controller.user!.dp.isNotEmpty
                  ? controller.user!.dp
                  : 'https://play-lh.googleusercontent.com/nCVVCbeSI14qEvNnvvgkkbvfBJximn04qoPRw8GZjC7zeoKxOgEtjqsID_DDtNfkjyo',
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('articles')
                    .doc('2DCkMOdli6kpjgdUDpLN')
                    .collection('comments')
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Center(
                        child: Text("Trying to connect"),
                      );
                    case ConnectionState.waiting:
                      return const Center(
                        child: Text("Trying to fetch data"),
                      );
                    case ConnectionState.active:
                      return Text("Active");
                    case ConnectionState.done:
                      return Text("Connected");
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
