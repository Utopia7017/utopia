import 'package:flutter/cupertino.dart';
import 'package:utopia/models/article_model.dart';

class ArticlesController with ChangeNotifier {
  int selectedCategory = 0;
  Map<String, List<Article>> articles = {
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
