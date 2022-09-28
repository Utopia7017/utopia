class SavedArticle {
  final String authorId;
  final String articleId;

  SavedArticle({required this.authorId, required this.articleId});

  factory SavedArticle.fromJson(Map<String, dynamic> json) {
    return SavedArticle(
        authorId: json['authorId'], articleId: json['articleId']);
  }

  Map<String, dynamic> toJson() {
    return {'authorId': authorId, 'articleId': articleId};
  }
}
