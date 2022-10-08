import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:utopia/controller/disposable_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart' as userModel;
import 'package:utopia/services/api/api_services.dart';

class ArticlesController extends DisposableProvider {
  int selectedCategory = 0;
  final ApiServices _apiServices = ApiServices();
  ArticlesStatus articlesStatus = ArticlesStatus.nil;
  String? myUid = FirebaseAuth.instance.currentUser!.uid;
  List<Article> searchedArticles = [];
  List<userModel.User> searchedAuthors = [];

  Map<String, List<Article>> articles = {
    'For you': [],
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
    Map<String, List<Article>> fetchedArticles = {
      'For you': [],
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
      myUid ??= FirebaseAuth.instance.currentUser!.uid;
      await Future.delayed(const Duration(microseconds: 1));
      List<dynamic> following = [];
      notifyListeners();
      // Firstly fetch the current user details ( specifically followings)
      final currentUserResponse =
          await _apiServices.get(endUrl: 'users/$myUid.json');
      if (currentUserResponse != null) {
        following = userModel.User.fromJson(currentUserResponse.data).following;
      }

      for (dynamic followingUid in following) {
        // for every following user id we will check if they have posted any article.
        // If posted then we will traverse all his articles and save it in our local 'for you' category

        final Response? articlesResponse =
            await _apiServices.get(endUrl: 'articles/$followingUid.json');

        if (articlesResponse != null && articlesResponse.data != null) {
          Map<String, dynamic> articles = articlesResponse.data;
          for (var data in articles.values) {
            fetchedArticles['For you']!.add(Article.fromJson(data));
          }
        }
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

      // Sort all categories's articles according to published time

      for (var category in fetchedArticles.keys) {
        fetchedArticles[category]!.sort((first, second) =>
            second.articleCreated.compareTo(first.articleCreated));
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

  // search any article, user or articles related to some tags
  void search(String query) async {
    List<Article> tempSearchedArticles = [];
    List<userModel.User> tempSearchUsers = [];
    Logger logger = Logger("ArticeController - Search");
    if (query.isEmpty) {
      searchedArticles = [];
      searchedAuthors = [];
      notifyListeners();
      return;
    } else {
      articles.forEach((key, value) {
        // traverse each category

        if (key != 'For you') {
          // obviously all the articles in 'For you' category are derived from other categories
          for (Article art in value) {
            // traverse each article
            if (art.category.toLowerCase().startsWith(query.toLowerCase()) ||
                (query.length >= 4 &&
                    art.title.toLowerCase().contains(query.toLowerCase()))) {
              logger.info("Category = $key , article id = ${art.articleId}");
              tempSearchedArticles.add(art);
            } else {
              // traverse every tag
              for (dynamic tag in art.tags) {
                if (tag.toString().length >= 4 &&
                    tag
                        .toString()
                        .toLowerCase()
                        .startsWith(query.toLowerCase())) {
                  tempSearchedArticles.add(art);
                  break;
                }
              }
            }
          }
        }
      });
      try {
        final Response? userResponse =
            await _apiServices.get(endUrl: 'users.json');
        if (userResponse != null) {
          Map<String, dynamic> userDataMap = userResponse.data;
          for (var userData in userDataMap.values) {
            if (userModel.User.fromJson(userData)
                .name
                .toLowerCase()
                .startsWith(query.toLowerCase())) {
              tempSearchUsers.add(userModel.User.fromJson(userData));
            }
          }
        }
      } catch (error) {
        logger.shout(error);
      }
    }
    searchedArticles = tempSearchedArticles;
    searchedAuthors = tempSearchUsers;
    notifyListeners();
  }

  @override
  void disposeValues() {
    articles = {};
    myUid = null;
    searchedAuthors = [];
    articlesStatus = ArticlesStatus.nil;
    searchedArticles = [];
  }
}
