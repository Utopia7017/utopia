class Notification {
  final String notificationId;
  final String type; // [ like,comment,follow ]
  final DateTime createdOn;
  final String notifierId;
  String? articleId;
  String? comment;
  bool read;

  Notification({
    required this.notificationId,
    required this.notifierId,
    required this.type,
    this.comment,
    required this.createdOn,
    this.articleId,
    required this.read,
  });

  Map<String, dynamic> toJson() {
    return {
      'notificationId': '',
      'comment': '',
      'read': false,
      'createdOn': createdOn,
      'notifierId': notifierId,
      'type': type,
      'articleId': articleId,
    };
  }
}
