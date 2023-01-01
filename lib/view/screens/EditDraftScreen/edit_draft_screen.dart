import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/article_body_component.dart';
import 'package:utopia/utils/common_api_calls.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/helper_widgets.dart';
import 'package:utopia/utils/image_picker.dart';
import 'package:utopia/view/screens/NewArticleScreen/components/article_detail_dialog.dart';

class EditDraftScreen extends ConsumerWidget {
  const EditDraftScreen(
      {super.key, required this.draftId, required this.authorId});

  final String draftId;
  final String authorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            XFile? imageFile = await pickImage(context);
            if (imageFile != null) {
              CroppedFile? croppedFile = await cropImage(File(imageFile.path));
              if (croppedFile != null) {
                controller.addImageField(croppedFile, null);
              }
            }
          },
          backgroundColor: authBackground,
          child: const Icon(
            Icons.add_a_photo_outlined,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          title: const Text(
            "New Article",
            style: TextStyle(
                fontFamily: "Open", fontSize: 14, color: Colors.black),
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black54),
          backgroundColor: primaryBackgroundColor,
          actions: [
            Builder(
              builder: (context) {
                switch (dataController.myArticleState.articleUploadingStatus) {
                  case ArticleUploadingStatus.UPLOADING:
                    return const SizedBox();
                  case ArticleUploadingStatus.NOT_UPLOADING:
                    return IconButton(
                      color: const Color(0xfb40B5AD),
                      icon: const Icon(Icons.arrow_forward_sharp),
                      onPressed: () {
                        if (validateArticleBody(
                            dataController.myArticleState.bodyComponents)) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ArticleDetailDialog();
                            },
                            useSafeArea: true,
                          );
                        } else {
                          showCustomSnackBar(
                              context: context,
                              text: "Article cannot be empty");
                        }
                      },
                    );
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 12),
          child: Builder(
            builder: (context) {
              if (dataController.myArticleState.bodyComponents.isEmpty) {
                Future.delayed(const Duration(microseconds: 1))
                    .then((value) => controller.addTextField(null));
              }
              List<BodyComponent> bodyComponents =
                  dataController.myArticleState.bodyComponents;
              switch (dataController.myArticleState.articleUploadingStatus) {
                case ArticleUploadingStatus.UPLOADING:
                  return const Center(
                      child: CircularProgressIndicator(
                    color: authMaterialButtonColor,
                  ));
                case ArticleUploadingStatus.NOT_UPLOADING:
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      bodyComponents[index].imageProvider!,
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25.0, right: 25),
                                        child: SizedBox(
                                          height:
                                              displayHeight(context) * 0.055,
                                          child: TextFormField(
                                            maxLines: 1,
                                            maxLength: 50,
                                            style: const TextStyle(
                                                fontFamily: "Open",
                                                fontSize: 13),
                                            textAlign: TextAlign.center,
                                            decoration: const InputDecoration(
                                                alignLabelWithHint: true,
                                                border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey)),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                focusColor: Colors.black54,
                                                hintText: "Add caption"),
                                            controller: bodyComponents[index]
                                                .imageCaption,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: authBackground,
                                      child: IconButton(
                                          iconSize: 18,
                                          color: authMaterialButtonColor,
                                          onPressed: () {
                                            controller.removeImage(
                                                dataController.myArticleState
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
                          return const Text("data");
                      }
                    },
                  );
              }
            },
          ),
        ));
  }
}
