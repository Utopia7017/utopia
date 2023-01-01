import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/article_report_model.dart';
import 'package:utopia/models/user_model.dart' as userModel;
import 'package:utopia/services/api/api_services.dart';

class ArticleState {
  int selectedCategory;
  final ApiServices _apiServices = ApiServices();
  ArticlesStatus articlesStatus = ArticlesStatus.NOT_FETCHED;
  String? myUid = "";
  List<Article> searchedArticles;
  List<userModel.User> searchedAuthors;

  Map<String, List<Article>> articles;

  /// A constructor that takes in all the values and assigns them to the class variables.
  ArticleState({
    required this.articles,
    required this.articlesStatus,
    required this.myUid,
    required this.selectedCategory,
    required this.searchedAuthors,
    required this.searchedArticles,
  });

  /// A factory constructor that returns an instance of ArticleState.
  ///
  /// Returns:
  ///   A new ArticleState object with the default values.
  factory ArticleState.initArticleState() {
    return ArticleState(
        articles: {
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
        },
        articlesStatus: ArticlesStatus.NOT_FETCHED,
        myUid: "",
        selectedCategory: 0,
        searchedAuthors: [],
        searchedArticles: []);
  }

  /// A function that returns a new ArticleState object with the updated values.
  ///
  /// Args:
  ///   articles (Map<String, List<Article>>): A map of articles, where the key is the category id and
  /// the value is a list of articles.
  ///   articlesStatus (ArticlesStatus): This is the status of the articles. It can be either loading,
  /// success, or error.
  ///   myUid (String): The uid of the current user.
  ///   selectedCategory (int): The category that is currently selected.
  ///   searchedAuthors (List<userModel.User>): List of authors that match the search query.
  ///   searchedArticles (List<Article>): This is a list of articles that are returned from the search
  /// query.
  ///
  /// Returns:
  ///   A new instance of ArticleState with the updated values.
  ArticleState _updateState({
    Map<String, List<Article>>? articles,
    ArticlesStatus? articlesStatus,
    String? myUid,
    int? selectedCategory,
    List<userModel.User>? searchedAuthors,
    List<Article>? searchedArticles,
  }) {
    return ArticleState(
        articles: articles ?? this.articles,
        articlesStatus: articlesStatus ?? this.articlesStatus,
        myUid: myUid ?? this.myUid,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        searchedAuthors: searchedAuthors ?? this.searchedAuthors,
        searchedArticles: searchedArticles ?? this.searchedArticles);
  }

  /// When the user clicks the button, we want to start loading articles.
  ///
  /// Returns:
  ///   A new instance of the ArticleState class.
  ArticleState startLoadingArticles() {
    return _updateState(articlesStatus: ArticlesStatus.FETCHING);
  }

  /// If the articlesStatus is currently FETCHING, then change it to FETCHED.
  ///
  /// Returns:
  ///   A new instance of the ArticleState class.
  ArticleState stopLoadingArticles() {
    return _updateState(articlesStatus: ArticlesStatus.FETCHED);
  }

  /// It fetches all the articles from the database and sorts them according to the categories and the
  /// time of publishing
  ///
  /// Args:
  ///   currentUser (userModel): The current user's data.
  ///
  /// Returns:
  ///   A Future<ArticleState> is being returned.
  Future<ArticleState> fetchArticles(userModel.User currentUser) async {
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
      // articlesStatus = ArticlesStatus.fetching;
      myUid ??= FirebaseAuth.instance.currentUser!.uid;
      await Future.delayed(const Duration(microseconds: 1));
      List<dynamic> following = [];
      List<dynamic> blocked = [];
      List<dynamic> blockedBy = [];

      following = currentUser.following;
      blocked = currentUser.blocked;
      blockedBy = currentUser.blockedBy;

      // get reports

      final reportResponse =
          await _apiServices.get(endUrl: 'reports/$myUid.json');

      List<Report> reportArticles = [];
      if (reportResponse != null && reportResponse.data != null) {
        logger.info(reportResponse.data);
        Map<String, dynamic> data = reportResponse.data;
        for (var reportData in data.values) {
          Report rep = Report.fromJson(reportData);
          if (rep.type == "article") {
            reportArticles.add(rep);
          }
        }
      }

      for (dynamic followingUid in following) {
        // for every following user id we will check if they have posted any article.
        // If posted then we will traverse all his articles and save it in our local 'for you' category

        final Response? articlesResponse =
            await _apiServices.get(endUrl: 'articles/$followingUid.json');

        if (articlesResponse != null && articlesResponse.data != null) {
          Map<String, dynamic> articles = articlesResponse.data;
          for (var data in articles.values) {
            Article article = Article.fromJson(data);
            int foundInBlockedReports = reportArticles.indexWhere((element) =>
                element.articleId == article.articleId &&
                element.userToReport == article.authorId);
            if (foundInBlockedReports == -1) {
              // not reported
              fetchedArticles['For you']!.add(article);
            }
          }
        }
      }

      final Response? response =
          await _apiServices.get(endUrl: 'articles.json');
      // fetching articles for categories
      if (response != null && response.data != null) {
        Map<String, dynamic> articlesByUsers = response.data;

        // fetched articles by user id ( for every user as key we will get a list of articles as value)

        for (var userId in articlesByUsers.keys) {
          if (blocked.contains(userId) || blockedBy.contains(userId)) {
            continue;
          } else {
            Map<String, dynamic> arts = articlesByUsers[userId];
            for (var data in arts.values) {
              Article article = Article.fromJson(data);
              int foundInBlockedReports = reportArticles.indexWhere((element) =>
                  element.articleId == article.articleId &&
                  element.userToReport == article.authorId);
              if (foundInBlockedReports == -1) {
                fetchedArticles[article.category]!.add(article);
              }
            }
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
    return _updateState(articles: articles);
    // articlesStatus = ArticlesStatus.fetched;
  }

  /// It sets the selectedCategory to the index of the category that was selected.
  ///
  /// Args:
  ///   index (int): The index of the category to select.
  selectCategory(int index) {
    selectedCategory = index;
  }

  /// It searches for articles and authors based on the query
  ///
  /// Args:
  ///   query (String): The search query
  ///
  /// Returns:
  ///   A Future<ArticleState> is being returned.
  Future<ArticleState> search(String query) async {
    List<Article> tempSearchedArticles = [];
    List<userModel.User> tempSearchUsers = [];
    Logger logger = Logger("ArticeController - Search");
    if (query.isEmpty) {
      searchedArticles = [];
      searchedAuthors = [];
      return _updateState(
          searchedArticles: searchedArticles, searchedAuthors: searchedAuthors);
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
    return _updateState(
        searchedArticles: searchedArticles, searchedAuthors: searchedAuthors);
  }
}
