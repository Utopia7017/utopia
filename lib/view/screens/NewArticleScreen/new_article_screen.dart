import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/utils/image_picker.dart';
import 'package:utopia/view/screens/NewArticleScreen/components/article_detail_dialog.dart';

import '../../../utils/article_body_component.dart';

class NewArticleScreen extends StatefulWidget {
  NewArticleScreen({Key? key}) : super(key: key);

  @override
  State<NewArticleScreen> createState() => _NewArticleScreenState();
}

class _NewArticleScreenState extends State<NewArticleScreen> {
  final Logger _logger = Logger("NewArticleScreen");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // This widget helps us catching the back button press event.
      onWillPop: () async {
        //TODO: Show dialog box asking user to save draft before navigating back.
        return true;
      },
      child: Scaffold(
          floatingActionButton: Consumer<MyArticlesController>(
            builder: (context, controller, child) {
              return FloatingActionButton(
                onPressed: () async {
                  XFile? imageFile = await pickImage(context);
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
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black54),
            backgroundColor: primaryBackgroundColor,
            actions: [
              Consumer<MyArticlesController>(
                builder: (context, controller, child) {
                  switch (controller.uploadingStatus) {
                    case ArticleUploadingStatus.uploading:
                      return const SizedBox();
                    case ArticleUploadingStatus.notUploading:
                      return TextButton(
                          onPressed: () {
                            if (controller.validateArticleBody()) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ArticleDetailDialog();
                                },
                                useSafeArea: true,
                              );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  'Article cannot be empty',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: authBackground,
                              ));
                            }
                          },
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                                color: Color(0xfb40B5AD),
                                fontSize: 15,
                                letterSpacing: 0.5),
                          ));
                  }
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 12),
            child: Consumer<MyArticlesController>(
              builder: (context, controller, child) {
                if (controller.bodyComponents.isEmpty) {
                  Future.delayed(const Duration(microseconds: 1))
                      .then((value) => controller.addTextField());
                }
                List<BodyComponent> bodyComponents = controller.bodyComponents;
                switch (controller.uploadingStatus) {
                  case ArticleUploadingStatus.uploading:
                    return const Center(
                        child: CircularProgressIndicator(
                      color: authMaterialButtonColor,
                    ));
                  case ArticleUploadingStatus.notUploading:
                    return ListView.builder(
                      itemCount: bodyComponents.length,
                      itemBuilder: (context, index) {
                        switch (bodyComponents[index].type) {
                          case "text":
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: bodyComponents[index].textFormField!,
                            );
                          case "image":
                            return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    bodyComponents[index].imageProvider!,
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: authBackground,
                                        child: IconButton(
                                            iconSize: 18,
                                            color: authMaterialButtonColor,
                                            onPressed: () {
                                              controller.removeImage(controller
                                                  .bodyComponents
                                                  .sublist(
                                                      index - 1, index + 2));
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                            )),
                                      ),
                                    )
                                  ],
                                ));

                          default:
                            return Text("data");
                        }
                      },
                    );
                }
              },
            ),
          )),
    );
  }
}
