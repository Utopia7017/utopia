import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controlller/new_article_screen_controller.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image_picker/image_picker.dart';

class NewArticleScreen extends StatefulWidget {
  NewArticleScreen({Key? key}) : super(key: key);

  @override
  State<NewArticleScreen> createState() => _NewArticleScreenState();
}

class _NewArticleScreenState extends State<NewArticleScreen> {
  final Logger _logger = Logger("NewArticleScreen");
  final picker = ImagePicker();
  List<String> articles = [];

  TextEditingController textEditingController = TextEditingController();

  Future<XFile?> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Consumer<NewArticleScreenController>(
          builder: (context, controller, child) {
            return FloatingActionButton(
              onPressed: () async {
                //FIXME: Add permission handler to request for camera and gallery permission before uploading any image @alpha17-2  
                XFile? imageFile = await pickImage();
                if (imageFile != null) {
                  controller.addImageField(imageFile);
                }
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
