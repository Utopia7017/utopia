import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:quickalert/quickalert.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/models/user_model.dart';

class RequestVerification extends StatelessWidget {
  User currentUser;
  int publishedArticles;
  RequestVerification(
      {super.key, required this.currentUser, required this.publishedArticles});
  final Logger _logger = Logger("RequestVerificationScreen");

  requestForVerification(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('verification-request')
          .doc(currentUser.userId)
          .set({
        'userId': currentUser.userId,
        'docId': '',
      });
    } catch (error) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          showCancelBtn: false,
          title: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: authBackground,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          'Request verification',
          style: TextStyle(fontFamily: "Open", fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Apply for Utopia verification',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: "open",
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Image.asset(
            verifyIcon,
            height: 60,
            width: 90,
          ),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
            child: Text(
                'Verified accounts have green ticks next to their names to show that Utopia has confirmed they are real presence of public figures.',
                style: TextStyle(fontSize: 16, fontFamily: "open")),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Text(
                'While applying for verification users must have more than 50 articles and 100+ followers. If the user meets our requirements then the user will be verified',
                style: TextStyle(fontSize: 16, fontFamily: "open")),
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            elevation: 2.5,
            color: authMaterialButtonColor,
            child: const Text('Request Verification'),
            onPressed: () {
              if (!currentUser.isVerified &&
                  currentUser.followers.length > 100 &&
                  publishedArticles > 50) {
                requestForVerification(context);
              } else {
                if (currentUser.isVerified) {
                  QuickAlert.show(
                      context: context,
                      showCancelBtn: false,
                      type: QuickAlertType.error,
                      title: "You are already verified");
                } else {
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      showCancelBtn: false,
                      title:
                          "It seems you currently do not meet the coditions for gettong verified.");
                }
              }
            },
          )
        ],
      ),
    );
  }
}
