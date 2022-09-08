import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controlller/new_article_screen_controller.dart';
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
        floatingActionButton: Consumer<NewArticleScreenController>(
          builder: (context, controller, child) {
            return FloatingActionButton(
              onPressed: () {
                controller.addImageField();
              },
              backgroundColor: authBackground,
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: Colors.white,
              ),
            );
          },
        ),
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black54),
          backgroundColor: primaryBackgroundColor,
          actions: [
            Consumer<NewArticleScreenController>(
              builder: (context, controller, child) {
                return TextButton(
                    onPressed: () {
                      _logger.info("Publish Article");
                      controller.publishArticle();
                    },
                    child: const Text(
                      'Publish',
                      style: TextStyle(color: authBackground, fontSize: 15),
                    ));
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 12),
          child: Consumer<NewArticleScreenController>(
            builder: (context, controller, child) {
              if (controller.bodyComponents.isEmpty) {
                Future.delayed(const Duration(microseconds: 1))
                    .then((value) => controller.addTextField());
              }
              List<BodyComponent> bodyComponents = controller.bodyComponents;
              return ListView.builder(
                itemCount: bodyComponents.length,
                itemBuilder: (context, index) {
                  switch (bodyComponents[index].type) {
                    case "textfield":
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: bodyComponents[index].textFormField!,
                      );
                    case "image":
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: bodyComponents[index].img!,
                      );
                    default:
                      return Text("data");
                  }
                },
              );
            },
          ),
        ));
  }
}

class ArticleTextField extends StatelessWidget {
  final TextEditingController controller;
  ArticleTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      minLines: null,
      showCursor: true,
      cursorColor: Colors.black,
      controller: controller,
      expands: false,
      decoration: const InputDecoration(border: InputBorder.none),
    );
  }
}
