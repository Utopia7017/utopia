import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/utils/device_size.dart';

class NewArticleScreen extends StatefulWidget {
  NewArticleScreen({Key? key}) : super(key: key);

  @override
  State<NewArticleScreen> createState() => _NewArticleScreenState();
}

class _NewArticleScreenState extends State<NewArticleScreen> {
  final Logger _logger = Logger("NewArticleScreen");

  List<String> articles = [];

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
        backgroundColor: primaryBackgroundColor,
        actions: [
          TextButton(
              onPressed: () {
                _logger.info("Publish Article");
              },
              child: const Text(
                'Publish',
                style: TextStyle(color: authBackground, fontSize: 15),
              )),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 12),
            child: TextFormField(
              controller: textEditingController,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Your article..."),
            ),
          )),
          Container(
            color: Colors.grey.shade200,
            height: displayHeight(context) * 0.06,
            width: displayWidth(context),
            child: IconButton(
              onPressed: () {
                if (textEditingController.text.isNotEmpty) {
                  _logger.info("Valid text");

                  articles.add(textEditingController.text);
                  
                }
              },
              icon: Icon(Icons.add_a_photo_rounded),
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
