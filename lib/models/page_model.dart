import 'bubble_model.dart';

class MangaPage {
  final int pageId;
  final String imageUrl;
  final List<Bubble> bubbles;

  MangaPage({
    required this.pageId,
    required this.imageUrl,
    required this.bubbles,
  });

  factory MangaPage.fromJson(Map<String, dynamic> json) {
    return MangaPage(
      pageId: json['pageId'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      bubbles: (json['bubbles'] ?? []).map<Bubble>((b) => Bubble.fromJson(b)).toList(),
    );
  }
} 