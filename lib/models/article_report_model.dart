class Report {
  const Report({
    required this.reportId,
    required this.reason,
    required this.type,
    required this.articleId,
    required this.reportCreated,
    required this.reporterId,
  });
  final String reportId;
  final String reason;
  final String type;
  final String articleId;
  final DateTime reportCreated;
  final String reporterId;

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportId: json['reportId'],
      reason: json['reason'],
      type: json['type'],
      articleId: json['articleId'],
      reportCreated: json['reportCreated'],
      reporterId: json['reporterId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'reason': reason,
      'type': type,
      'articleId': articleId,
      'reportCreated': reportCreated,
      'reporterId': reporterId,
    };
  }

  static Report fromDomain(Report domain) {
    return Report(
      reportId: domain.reportId,
      reason: domain.reason,
      type: domain.type,
      articleId: domain.articleId,
      reportCreated: domain.reportCreated,
      reporterId: domain.reporterId,
    );
  }
}
