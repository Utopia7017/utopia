import 'package:utopia/models/article_body_model.dart';
import 'package:utopia/models/article_report_model.dart';

class Article {
  final String articleId;
  final String authorId;
  final List<dynamic> body;
  final DateTime articleCreated;
  final List<Report> reports;
  final List<dynamic> tags;
  final String title;
  final String category;

  Article({
    required this.body,
    required this.tags,
    required this.reports,
    required this.articleCreated,
    required this.articleId,
    required this.authorId,
    required this.title,
    required this.category,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      category: json['category'],
      title: json['title'],
      body: json['body'],
      tags: json['tags'] ?? [],
      reports: json['reports'] ?? [],
      articleCreated: DateTime.parse(json['articleCreated']),
      articleId: json['articleId'],
      authorId: json['authorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'articleCreated': articleCreated.toString(),
      'articleId': articleId,
      'authorId': authorId,
      'reports': [],
      'tags': tags,
      'title': title,
      'category': category,
    };
  }
}
