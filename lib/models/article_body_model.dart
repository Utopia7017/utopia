class ArticleBody {
  ArticleBody({
    required this.type,
    this.image,
    this.imageCaption,
    this.text,
  });
  final String type;
  final String? image;
  final String? imageCaption;
  final String? text;

  factory ArticleBody.fromJson(Map<String, dynamic> json) {
    return ArticleBody(
      type: json['type'],
      image: json['image'],
      imageCaption: json['imageCaption'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'imageCaption':imageCaption,
      'image': image,
      'text': text,
    };
  }
}
