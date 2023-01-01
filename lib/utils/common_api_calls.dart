import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/article_report_model.dart';
import 'package:utopia/services/api/api_services.dart';
import 'package:utopia/utils/article_body_component.dart';

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

/// It fetches all the articles of a user, and then checks if the current user has reported any of them.
/// If the current user has reported any of them, it removes them from the list
///
/// Args:
///   myUid (String): The current user's uid
///   uid (String): The user id of the user whose articles you want to fetch.
///
/// Returns:
///   A list of articles
Future<List<Article>> fetchThisUsersArticles(String myUid, String uid) async {
  Logger logger = Logger('FetchThisUserArticle');
  ApiServices _apiServices = ApiServices();
  List<Article> articles = [];
  try {
    // get reports
    final Response? reportResponse =
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
    final Response? response =
        await _apiServices.get(endUrl: 'articles/$uid.json');

    if (response != null && response.data != null) {
      Map<String, dynamic> articleData = response.data;
      if (articleData.isNotEmpty) {
        for (var art in articleData.values) {
          int foundInReports = reportArticles.indexWhere((element) =>
              element.articleId == Article.fromJson(art).articleId &&
              element.userToReport == Article.fromJson(art).authorId);
          if (foundInReports == -1) {
            // if current user has not reported this article
            articles.add(Article.fromJson(art));
          }
        }
      }
    }
  } catch (error) {
    debugPrint(error.toString());
  }
  articles.sort(
    (a, b) => b.articleCreated.compareTo(a.articleCreated),
  );
  return articles;
}

/// It reports an article.
///
/// Args:
///   articleOwnerId (String): The id of the user who owns the article
///   articleId (String): The id of the article to be reported
///   myId (String): The id of the user who is reporting the article
///   reason (String): The reason for reporting the article
reportArticle(String articleOwnerId, String articleId, String myUid,
    String reason) async {
  Logger logger = Logger("Report Article Method");
  ApiServices _apiServices = ApiServices();
  try {
    Report report = Report(
        articleId: articleId,
        userToReport: articleOwnerId,
        reportId: '',
        reason: reason,
        type: 'article',
        reportCreated: DateTime.now(),
        reporterId: myUid);
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
}

  /// If the textEditingController is not null and the text is not empty, return true
  ///
  /// Returns:
  ///   A boolean value.
  bool validateArticleBody(List<BodyComponent> bodyComponents) {
    for (BodyComponent bc in bodyComponents) {
      if (bc.type == 'text') {
        if (bc.textEditingController != null &&
            bc.textEditingController!.text.trim().isNotEmpty) {
          return true;
        }
      }
    }
    return false;
  }