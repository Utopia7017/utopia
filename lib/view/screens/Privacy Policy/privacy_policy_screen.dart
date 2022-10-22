import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({super.key});

  final normalTextStyle =
      TextStyle(color: Colors.black, fontSize: 14.6, fontFamily: "Open");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Privacy Policy",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: "Open",
              ),
            ),
            Text(
              "Effective Date : November 1, 2022",
              style: TextStyle(
                color: Colors.black,
                fontSize: 11,
                fontFamily: "Open",
              ),
            )
          ],
        ),
        iconTheme: const IconThemeData(color: authBackground),
        elevation: 0,
        backgroundColor: primaryBackgroundColor,
      ),
      backgroundColor: primaryBackgroundColor,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Your privacy is critical to us. Likewise, we have built up this Policy with the end goal you should see how we gather, utilize, impart and reveal and make utilization of individual data. The following blueprints our privacy policy.\n',
                style: normalTextStyle,
              ),
              Text(
                'i. Before or at the time of collecting personal information, we will identify the purposes for which information is being collected.\n\nii. We will gather and utilize individual data singularly with the target of satisfying those reasons indicated by us and for other good purposes, unless we get the assent of the individual concerned or as required by law.\n\niii. We will gather individual data by legal and reasonable means and, where fitting, with the information or assent of the individual concerned.\n\niv. We will protect individual data by security shields against misfortune or burglary, and also unapproved access, divulgence, duplicating, use or alteration.\n\nv. We will promptly provide customers with access to our policies and procedures for the administration of individual data.',
                style: normalTextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'We are focused on leading our business as per these standards with a specific end goal to guarantee that the privacy of individual data is secure and maintained.',
                style: normalTextStyle,
              ),
            ],
          )),
    );
  }
}
