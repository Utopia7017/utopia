import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart' as userModel;
import 'package:utopia/services/api/api_services.dart';

class ArticlesController with ChangeNotifier {
  int selectedCategory = 0;
  final ApiServices _apiServices = ApiServices();
  ArticlesStatus articlesStatus = ArticlesStatus.nil;
  final String myUid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, List<Article>> articles = {
    'For you':[],
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
      'For you':[],
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
      List<dynamic> following = [];
      notifyListeners();
      // Firstly fetch the current user details ( specifically followings)
      final currentUserResponse = await _apiServices.get(endUrl: 'users/$myUid.json');
      if(currentUserResponse!=null){
        following = userModel.User.fromJson(currentUserResponse.data).following;
      }
      
      for(dynamic followingUid in following){
        // for every following user id we will check if they have posted any article.
        // If posted then we will traverse all his articles and save it in our local 'for you' category
        
        final articlesResponse = await _apiServices.get(endUrl: 'articles/$followingUid.json');
        if(articlesResponse!=null){
          Map<String, dynamic> articles = articlesResponse.data;
          for(var data in articles.values){
            fetchedArticles['For you']!.add(Article.fromJson(data));
          }
        }
      }
      
      // Sort them according to published time
      
      if(fetchedArticles['For you']!.isNotEmpty){
        fetchedArticles['For you']!.sort((first,second) => first.articleCreated.compareTo(second.articleCreated));
      }
      
      
      
      final Response? response =
          await _apiServices.get(endUrl: 'articles.json');
      // fetching articles for categories
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

      // fetching articles for 'For you' -> select articles which are published by user's following


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
