import 'package:flutter/material.dart';

abstract class DisposableProvider with ChangeNotifier {
  void disposeValues();
}