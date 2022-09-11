import 'package:flutter/material.dart';
import 'package:utopia/utils/device_size.dart';

class ArticleDetailDialog extends StatelessWidget {
  List<String> items = <String>[
    "travel",
    "communication",
    "flutter",
    "Javascript",
    "nodejs"
  ];
  String dropdownValue = "travel";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Publish New Article"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: displayWidth(context) * 0.99,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Tittle of article",
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white54),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Select category of article"),
            SizedBox(
              height: 10,
            ),
            DropdownButton<String>(
              onChanged: (String? newValue) {
                dropdownValue = newValue!;
              },
              value: dropdownValue,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Add 3 tags",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Enter the tag",
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white54),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Enter the tag",
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white54),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Enter the tag",
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white54),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {},
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }
}
