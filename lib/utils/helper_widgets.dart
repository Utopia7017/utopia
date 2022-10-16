import 'package:flutter/material.dart';

drawerTile(String title, String icon, Function() callbackAction) {
  return ListTile(
    onTap: callbackAction,
    contentPadding: EdgeInsets.zero,
    leading: Image.asset(
      icon,
      height: 20,
      color: Colors.grey,
    ),
    visualDensity: const VisualDensity(vertical: -3),
    minLeadingWidth: 1,
    title: Text(
      title,
      style: const TextStyle(
          fontSize: 13.5,
          color: Colors.white,
          fontFamily: "Fira",
          letterSpacing: 0.6),
    ),
  );
}
