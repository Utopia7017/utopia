class ArticleBody {
  ArticleBody({
    required this.type,
    this.image,
    this.text,
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
