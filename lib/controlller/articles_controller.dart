import 'package:flutter/cupertino.dart';
import 'package:utopia/models/article_model.dart';

class ArticlesController with ChangeNotifier {
  int selectedCategory = 0;
  Map<String, List<Article>> articles = {

  };

  selectCategory(int index) {
    selectedCategory = index;
    notifyListeners();
  }
}
