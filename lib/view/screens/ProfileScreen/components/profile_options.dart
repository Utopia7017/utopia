import 'package:flutter/material.dart';

class ProfileOptions extends StatelessWidget {
  Widget tile(String label, Icon icon, Function() callback) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: ListTile(
        visualDensity: VisualDensity(),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
        leading: icon,
        onTap: callback,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        tile("Edit Profile", Icon(Icons.edit), () => null),
        tile("My Articles", Icon(Icons.book), () => null),
        tile("Blocked Authors", Icon(Icons.block_outlined), () => null),
        // Divider(),
      ],
    );
  }
}
