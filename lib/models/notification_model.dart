class Notification {
  String type;
  DateTime createdOn;
  String authentication;
  String update;
  String deleteArticle;

  Notification({
    required this.type,
    required this.createdOn,
    required this.authentication,
    required this.update,
    required this.deleteArticle,
    
  });
}