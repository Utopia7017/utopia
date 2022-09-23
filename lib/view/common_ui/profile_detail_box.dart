import 'package:flutter/material.dart';

class ProfileDetailBox extends StatelessWidget {
  final int value;
  final String label;
  final Function() callback;
  const ProfileDetailBox(
      {super.key,
      required this.value,
      required this.label,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
