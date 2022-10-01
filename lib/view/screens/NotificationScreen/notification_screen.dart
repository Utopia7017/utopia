import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';

class NotificationScreen extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: authBackground,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Notification",
          style: TextStyle(fontFamily: "Open", fontSize: 14),
        ),
      ),
    );
  }
}

  // Future-builder
  // Stream-builder 
  // State management -> Provider ()
  // Architecture -> MVC vs MvVM 
  // API Integration -> Get , Post , Put , Delete 
  // 
