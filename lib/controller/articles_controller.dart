import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:utopia/controller/disposable_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/article_report_model.dart';
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

  Future<void> fetchArticles() async {
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
      List<dynamic> blocked = [];
      notifyListeners();
      // Firstly fetch the current user details ( specifically followings)
      final currentUserResponse =
          await _apiServices.get(endUrl: 'users/$myUid.json');
      if (currentUserResponse != null) {
        following = userModel.User.fromJson(currentUserResponse.data).following;
        blocked = userModel.User.fromJson(currentUserResponse.data).blocked;
      }

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
          if (blocked.contains(userId)) {
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

  Future<List<Article>> fetchThisUsersArticles(String uid) async {
    Logger logger = Logger('FetchThisUserArticle');
    List<Article> articles = [];
    try {
      final Response? response =
          await _apiServices.get(endUrl: 'articles/$uid.json');
      if (response != null && response.data != null) {
        Map<String, dynamic> articleData = response.data;
        if (articleData.isNotEmpty) {
          for (var art in articleData.values) {
            articles.add(Article.fromJson(art));
          }
        }
      }
    } catch (error) {}
    return articles;
  }

  reportArticle(String articleOwnerId, String articleId, String myId,
      String reason) async {
    Logger logger = Logger("Report Article Method");
    try {
      Report report = Report(
          articleId: articleId,
          userToReport: articleOwnerId,
          reportId: '',
          reason: reason,
          type: 'article',
          reportCreated: DateTime.now(),
          reporterId: myId);
      final Response? response = await _apiServices.post(
          endUrl: 'reports/$myUid.json', data: report.toJson());
      if (response != null) {
        final String id = response.data['name'];
        final Response? updateResponse = await _apiServices
            .update(endUrl: 'reports/$myUid/$id.json', data: {'reportId': id});
        if (updateResponse != null) {
          report.updateReportId(id);
        }
      }
    } catch (e) {
      logger.shout(e);
    }
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
