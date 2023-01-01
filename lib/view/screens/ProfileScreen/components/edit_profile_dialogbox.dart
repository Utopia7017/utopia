import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/helper_widgets.dart';

displayBox({
  required WidgetRef ref,
  required BuildContext context,
  required String currentName,
  required String currentBio,
}) {
  final controller = ref.watch(stateController.notifier);
  final dataController = ref.watch(stateController);
  TextEditingController currentNameController =
      TextEditingController(text: currentName);
  TextEditingController currentBioController =
      TextEditingController(text: currentBio);
  final formKey = GlobalKey<FormState>();
  QuickAlert.show(
    context: context,
    type: QuickAlertType.custom,
    showCancelBtn: true,
    onConfirmBtnTap: () {
      if (formKey.currentState!.validate()) {
        controller.updateProfile(
            name: currentNameController.text, bio: currentBioController.text);
        Navigator.pop(context);
        showCustomSnackBar(context: context, text: 'Updating profile...');
      }
    },
    title: "Update Profile",
    widget: SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5, left: 5, top: 10),
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
                controller: currentNameController,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5, left: 5),
              child: TextFormField(
                controller: currentBioController,
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
  );
}
