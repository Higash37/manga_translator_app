class Bubble {
  final String comicId;
  final String episodeId;
  final String pageId;
  final int bubbleIndex;
  final List<double> position;
  final List<double> size;
  final Map<String, String> text;
  final List<BubbleTranslation> translations;
  final List<BubbleReview> reviews;

  Bubble({
    required this.comicId,
    required this.episodeId,
    required this.pageId,
    required this.bubbleIndex,
    required this.position,
    required this.size,
    required this.text,
    required this.translations,
    required this.reviews,
  });

  factory Bubble.fromJson(Map<String, dynamic> json) {
    return Bubble(
      comicId: json['comicId'] ?? '',
      episodeId: json['episodeId'] ?? '',
      pageId: json['pageId'] ?? '',
      bubbleIndex: json['bubbleIndex'] ?? 0,
      position: List<double>.from(json['position'].map((v) => v.toDouble())),
      size: List<double>.from(json['size'].map((v) => v.toDouble())),
      text: Map<String, String>.from(json['text'] ?? {}),
      translations: (json['translations'] ?? [])
          .map<BubbleTranslation>((t) => BubbleTranslation.fromJson(t))
          .toList(),
      reviews: (json['reviews'] ?? [])
          .map<BubbleReview>((r) => BubbleReview.fromJson(r))
          .toList(),
    );
  }

  // bubbleId生成
  static String generateBubbleId(
    String comicId,
    String episodeId,
    String pageId,
    int bubbleIndex,
  ) {
    return '$comicId/$episodeId/$pageId/$bubbleIndex';
  }
}

class BubbleTranslation {
  final String userId;
  final String lang;
  final String text;
  final String comment;

  BubbleTranslation({
    required this.userId,
    required this.lang,
    required this.text,
    required this.comment,
  });

  factory BubbleTranslation.fromJson(Map<String, dynamic> json) {
    return BubbleTranslation(
      userId: json['userId'] ?? '',
      lang: json['lang'] ?? '',
      text: json['text'] ?? '',
      comment: json['comment'] ?? '',
    );
  }
}

class BubbleReview {
  final String userId;
  final int score;
  final String comment;

  BubbleReview({
    required this.userId,
    required this.score,
    required this.comment,
  });

  factory BubbleReview.fromJson(Map<String, dynamic> json) {
    return BubbleReview(
      userId: json['userId'] ?? '',
      score: json['score'] ?? 0,
      comment: json['comment'] ?? '',
    );
  }
}
