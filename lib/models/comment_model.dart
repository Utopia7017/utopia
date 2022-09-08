class Comment {
  final String commentId;
  final String articleId;
  final String comment;
  final String userId;
  Comment(
      {required this.comment,
      required this.commentId,
      required this.articleId,
      required this.userId});

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'articleId': articleId,
      'comment': comment,
      'userId': userId,
    };
  }

  factory Comment.fromjson(Map<String, dynamic> json) {
    return Comment(
        comment: json['comment'],
        commentId: json['commentId'],
        articleId: json['articleId'],
        userId: json['userId']);
  }
}
