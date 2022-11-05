import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:utopia/constants/color_constants.dart';

class HelpScreen extends StatefulWidget {
  HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  TextEditingController messageController = TextEditingController();

  String type = "Feedback";

  suggestFeebback(
    String emailId,
  ) async {
    await FirebaseFirestore.instance
        .collection('feedbacks')
        .doc(emailId)
        .collection('feedbacks')
        .add({
      'message': messageController.text,
      'email': emailId,
      'type': type,
    });
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: "Successfully submitted feedback");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: authBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Help & Support",
          style: TextStyle(fontFamily: "Open", fontSize: 15),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.live_help_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 15, 10, 10),
              child: Text(
                'Reach us',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: "open"),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                "Our app is open source and support reproducible builds. This means that anyone can independently verify that our code on Github is the exact same code that was used to build the app you download from Play Store. Developers are welcome to check out and contribute to our app on Github.",
                style: TextStyle(fontFamily: "Open", fontSize: 14.5),
              ),
            ),
            const Divider(
              height: 15,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: authBackground,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.discord,
                            color: Colors.white,
                          )),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Discord',
                      style: TextStyle(fontFamily: "Open"),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: authBackground,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.facebook,
                            color: Colors.white,
                          )),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Facebook',
                      style: TextStyle(fontFamily: "Open"),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: authBackground,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.email,
                            color: Colors.white,
                          )),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Email',
                      style: TextStyle(fontFamily: "Open"),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: authBackground,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            FontAwesomeIcons.github,
                            color: Colors.white,
                          )),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Github',
                      style: TextStyle(fontFamily: "Open"),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 2, 30, 2),
              child: DropdownButtonFormField(
                isExpanded: true,
                value: type,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white54),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: [
                  'Feedback',
                  'Complaints',
                  "Suggetions (Features / Fix bugs)"
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    type = value.toString();
                  });
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 2, 30, 2),
              child: TextFormField(
                controller: messageController,
                maxLines: 6,
                decoration: InputDecoration(
                    hintText: 'Enter your message here',
                    hintStyle: const TextStyle(fontFamily: "open"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 2, 30, 2),
              child: TextFormField(
                initialValue: FirebaseAuth.instance.currentUser!.email,
                readOnly: true,
                decoration: InputDecoration(
                    hintStyle: const TextStyle(fontFamily: "Open"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: MaterialButton(
                color: authMaterialButtonColor,
                onPressed: () async {
                  await suggestFeebback(
                      FirebaseAuth.instance.currentUser!.email!);
                },
                child: const Text(
                  'Submit Feedback',
                  style: TextStyle(
                      fontFamily: "Open", fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
