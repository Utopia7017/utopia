class ArticleBody {
  ArticleBody({
    required this.type,
    required this.image,
    required this.text,
  });
  final String type;
  final String? image;
  final String? text;

  factory ArticleBody.fromJson(Map<String, dynamic> json) {
    return ArticleBody(
      type: json['type'],
      image: json['image'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'image': image,
      'text': text,
    };
  }
}
