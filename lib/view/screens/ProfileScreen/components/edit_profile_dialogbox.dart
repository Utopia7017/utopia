import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/user_controller.dart';

class EditProfileDialogbox extends StatefulWidget {
  String currentName;
  String currentBio;

  EditProfileDialogbox(
      {super.key, required this.currentName, required this.currentBio});

  @override
  State<EditProfileDialogbox> createState() => _EditProfileDialogboxState();
}

class _EditProfileDialogboxState extends State<EditProfileDialogbox> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    bioController = TextEditingController(text: widget.currentBio);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Profile"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name cannot be empty";
                    }
                    return null;
                  },
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  controller: nameController,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: TextFormField(
                  controller: bioController,
                  decoration: InputDecoration(
                    labelText: "Bio",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  expands: false,
                  maxLines: 2,
                  minLines: null,
                  maxLength: 120,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel",
              style: TextStyle(fontSize: 13, color: authBackground)),
        ),
        Consumer<UserController>(
          builder: (context, controller, child) {
            return TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  controller.updateProfile(
                      name: nameController.text, bio: bioController.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Updating profile...')));
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(fontSize: 13, color: authBackground),
              ),
            );
          },
        ),
      ],
    );
  }
}
