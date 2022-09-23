import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/article_category_constants.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/article_detail_textfield.dart';

class ArticleDetailDialog extends StatelessWidget {
  String? dropdownValue;
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController tag1Controller = TextEditingController();
  TextEditingController tag2Controller = TextEditingController();
  TextEditingController tag3Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 2),
      backgroundColor: Colors.white,
      title: const Text(
        "Add Article Details",
        style: TextStyle(fontFamily: "Fira"),
      ),
      content: SizedBox(
        width: displayWidth(context) * 0.8,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArticleDetailTextField(
                  controller: titleController,
                  label: "Tittle of article",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Title cannot be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                Consumer<MyArticlesController>(
                  builder: (context, controller, child) {
                    return DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return "Please select any category";
                        }
                        if (value.toString().isEmpty) {
                          return "Please select any category";
                        }
                        return null;
                      },
                      onChanged: (String? selected) {
                        controller.changeCategory(selected!);
                      },
                      isExpanded: true,
                      value: dropdownValue,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 12, right: 10),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white54),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      hint: const Text("Select Category"),
                      items: articleCategoriesForPublishing
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Add 3 tags",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                ArticleDetailTextField(
                    controller: tag1Controller,
                    label: "Tag 1",
                    validator: (p0) => null,
                    prefixIcon: Icon(Icons.auto_fix_high_rounded)),
                const SizedBox(height: 14),
                ArticleDetailTextField(
                  controller: tag2Controller,
                  label: "Tag 2",
                  validator: (p0) => null,
                  prefixIcon: Icon(Icons.auto_fix_high_rounded),
                ),
                const SizedBox(height: 14),
                ArticleDetailTextField(
                  controller: tag3Controller,
                  label: "Tag 2",
                  validator: (p0) => null,
                  prefixIcon: Icon(Icons.auto_fix_high_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: EdgeInsets.only(right: 20, top: 0, bottom: 8),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel",
                style: TextStyle(
                    color: Color(0xfb40B5AD),
                    fontSize: 16,
                    letterSpacing: 0.5)),
          ),
        ),
        Consumer<MyArticlesController>(
          builder: (context, controller, child) {
            List<String> tags = [
              tag1Controller.text,
              tag2Controller.text,
              tag3Controller.text
            ];
            return TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  controller.publishArticle(
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      title: titleController.text,
                      tags: tags);
                  Navigator.pop(context);
                }
              },
              child: const Text("Publish Article",
                  style: TextStyle(
                      color: Color(0xfb40B5AD),
                      fontSize: 16,
                      letterSpacing: 0.2)),
            );
          },
        ),
      ],
    );
  }
}
