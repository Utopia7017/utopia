import 'package:flutter/material.dart';

class EditProfileDialogbox extends StatefulWidget {
  String currentName;
  String currentBio;

  EditProfileDialogbox({required this.currentName, required this.currentBio});

  @override
  State<EditProfileDialogbox> createState() => _EditProfileDialogboxState();
}

class _EditProfileDialogboxState extends State<EditProfileDialogbox> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    bioController = TextEditingController(text: widget.currentBio);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: Text("Edit Profile"),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: TextFormField(
                  validator: (value) {
                  if(value!.isEmpty) {
                    return "Name cannot be empty";
                  }
                  return null;

                  },
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white54),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  controller: nameController,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: TextFormField(
                  controller: bioController,
                  decoration: InputDecoration(
                    labelText: "Bio",
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white54),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  expands: false,
                  maxLines: null,
                  minLines: null,
                  maxLength: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 130),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){

                        }
                      },
                      child: Text("Save Changes"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
