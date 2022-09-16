import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/services/api/api_services.dart';

class ArticlesController with ChangeNotifier {
  int selectedCategory = 0;
  final ApiServices _apiServices = ApiServices();
  ArticlesStatus articlesStatus = ArticlesStatus.nil;
  Map<String, List<Article>> articles = {
    'Autobiography': [],
    'Biography': [],
    'Business': [],
    'Education': [],
    'Entertainment': [],
    'Fiction': [],
    'Food': [],
    'History': [],
    'Literature': [],
    'Non-fiction': [],
    'Photography': [],
    'Science': [],
    'Sports': [],
    'Technology': [],
  };

  void fetchArticles() async {
    Logger logger = Logger("FetchArticles");
    List<Article> temp = [];
    Map<String, List<Article>> fetchedArticles = {
      'Autobiography': [],
      'Biography': [],
      'Business': [],
      'Education': [],
      'Entertainment': [],
      'Fiction': [],
      'Food': [],
      'History': [],
      'Literature': [],
      'Non-fiction': [],
      'Photography': [],
      'Science': [],
      'Sports': [],
      'Technology': [],
    };

    try {
      articlesStatus = ArticlesStatus.fetching;
      await Future.delayed(const Duration(microseconds: 1));
      notifyListeners();
      final Response? response =
          await _apiServices.get(endUrl: 'articles.json');
      if (response != null) {
        Map<String, dynamic> articlesByUsers = response.data;

        // fetched articles by user id ( for every user as key we will get a list of articles as value)

        for (var userId in articlesByUsers.keys) {
          Map<String, dynamic> arts = articlesByUsers[userId];
          for (var data in arts.values) {
            Article article = Article.fromJson(data);
            fetchedArticles[article.category]!.add(article);
          }
        }
      }
    } catch (error) {
      logger.shout(error.toString());
    }
    articles = fetchedArticles;
    articlesStatus = ArticlesStatus.fetched;
    notifyListeners();
  }

  selectCategory(int index) {
    selectedCategory = index;
    notifyListeners();
  }
}
