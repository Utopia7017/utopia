class Report {
  Report({
    required this.reportId,
    required this.reason,
    required this.type,
    this.articleId,
    required this.reportCreated,
    required this.reporterId,
    this.userToReport,
  });
  String reportId;
  final String reason;
  final String type; // artcile or profile
  String? articleId;
  final DateTime reportCreated;
  String? userToReport;
  final String reporterId;

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
        reportId: json['reportId'],
        reason: json['reason'],
        type: json['type'],
        articleId: json['articleId'] ?? '',
        reportCreated: DateTime.parse(json['reportCreated']),
        reporterId: json['reporterId'],
        userToReport: json['userToReport'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'reason': reason,
      'type': type,
      'articleId': articleId,
      'reportCreated': reportCreated.toString(),
      'reporterId': reporterId,
      'userToReport': userToReport,
    };
  }

  updateReportId(rid) {
    reportId = rid;
  }
}