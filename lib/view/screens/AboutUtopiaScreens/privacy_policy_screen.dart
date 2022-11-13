import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final normalTextStyle = TextStyle(
      color: Colors.grey.shade700, fontSize: 14.6, fontFamily: "Open");

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
              "Effective Date : November 5, 2022",
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
              'Utopia built the Utopia app as an Open Source app. This SERVICE is provided by Utopia at no cost and is intended for use as is.This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.\n\nIf you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.\n\nThe terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Utopia unless otherwise defined in this Privacy Policy.\n',
              style: normalTextStyle,
            ),
            Text(
              'Information Collection and Use\n\nFor a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to email. The information that we request will be retained by us and used as described in this privacy policy.\nThe app does use third-party services that may collect information used to identify you.',
              style: normalTextStyle,
            ),
            Text(
              '\nLog Data\n\nWe want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.\n\nCookies\n\nCookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device\'s internal memory.This Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.',
              style: normalTextStyle,
            ),
            Text(
              '\nService Providers\n\nWe may employ third-party companies and individuals due to the following reasons:',
              style: normalTextStyle,
            ),
            Text(
              '\ni. To facilitate our Service\nii. To provide the Service on our behalf\niii. To perform Service-related services',
              style: normalTextStyle,
            ),
            Text(
              '\nSecurity We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.',
              style: normalTextStyle,
            ),
            Text(
              '\nChanges to This Privacy Policy \n\nWe may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.This policy is effective as of 2022-11-05',
              style: normalTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
