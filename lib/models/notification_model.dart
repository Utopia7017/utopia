class Notification {
  final String notificationId;
  final String type; // [ like,comment,follow ,reply]
  final DateTime createdOn;
  final String notifierId;
  String? articleId;
  String? comment;
  String? reply;
  String? articleOwnerId;
  String? commentOwnerId;
  String? commentId;
  bool read;

  Notification({
    required this.notificationId,
    required this.notifierId,
    required this.type,
    this.comment,
    this.commentOwnerId,
    this.commentId,
    this.reply,
    this.articleOwnerId,
    required this.createdOn,
    this.articleId,
    required this.read,
  });

  Map<String, dynamic> toJson() {
    return {
      'notificationId': '',
      'commentOwnerId':commentOwnerId,
      'commentId':commentId,
      'comment': comment,
      'articleOwnerId': articleOwnerId,
      'read': false,
      'reply': reply,
      'createdOn': createdOn,
      'notifierId': notifierId,
      'type': type,
      'articleId': articleId,
    };
  }
}
