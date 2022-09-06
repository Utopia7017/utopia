import 'package:flutter/cupertino.dart';

class ArticlesController with ChangeNotifier {
  int selectedCategory = 0;
  Map<String, List<dynamic>> articles = {
    'For you': [],
    'Sports': [],
    'Education': [],
    'Travlel': [],
    'Programming': [],
    'Entertainment': [],
  };

  selectCategory(int index) {
    selectedCategory = index;
    notifyListeners();
  }
}
