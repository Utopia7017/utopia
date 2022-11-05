import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';

class RequestVerification extends StatelessWidget {
  RequestVerification({super.key});
  Logger _logger = Logger("RequestVerificationScreen");

  requestForVerification() async {
    try {} catch (error) {
      _logger.shout(error.toString());
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
          const Text(
            'Apply for Utopia verification',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30, fontFamily: "open", fontWeight: FontWeight.bold),
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
                'While applying for verification users must have more than 50 articles and 100 + followers . If the user meets our requirements then the user will be verified',
                style: TextStyle(fontSize: 16, fontFamily: "open")),
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            color: authMaterialButtonColor,
            child: const Text('Request verification'),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
