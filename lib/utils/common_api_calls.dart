import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/services/api/api_services.dart';

import '../models/user_model.dart';

/// It takes a user id as a parameter, makes a GET request to the Firebase database, and returns a User
/// object if the request is successful
///
/// Args:
///   uid (String): The user's unique ID.
///
/// Returns:
///   A Future<User?>
Future<User?> getUser(String uid) async {
  try {
    final response = await ApiServices().get(endUrl: 'users/$uid.json');
    if (response != null) {
      return User.fromJson(response.data);
    }
  } catch (error) {
    return null;
  }
  return null;
}

/// It fetches the article detail from the firebase database.
///
/// Args:
///   authorId (String): The author's id.
///   articleId (String): The id of the article you want to get.
///
/// Returns:
///   A Future<Article>
Future<Article> getArticleDetail(
    {required String authorId, required String articleId}) async {
  late Article article;
  Logger logger = Logger("GetArticleDetail");
  try {
    final Response? articleResponse =
        await ApiServices().get(endUrl: 'articles/$authorId/$articleId.json');
    if (articleResponse != null) {
      article = Article.fromJson(articleResponse.data);
    }
  } catch (error) {
    logger.shout(error.toString());
  }
  return article;
}
