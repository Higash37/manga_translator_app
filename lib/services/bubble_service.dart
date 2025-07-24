import 'package:cloud_firestore/cloud_firestore.dart';

class BubbleService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> postTranslation({
    required String bubbleId,
    required String lang,
    required String text,
    required String comment,
  }) async {
    try {
      // bubbleIdからcomicId, episodeId, pageId, bubbleIndexを抽出
      final parts = bubbleId.split('/');
      if (parts.length != 4) {
        throw Exception('Invalid bubbleId format');
      }

      final comicId = parts[0];
      final episodeId = parts[1];
      final pageId = parts[2];
      final bubbleIndex = int.parse(parts[3]);

      // 翻訳データをFirestoreに保存
      await _firestore
          .collection('comics')
          .doc(comicId)
          .collection('episodes')
          .doc(episodeId)
          .collection('pages')
          .doc(pageId)
          .collection('bubbles')
          .doc(bubbleIndex.toString())
          .collection('translations')
          .add({
        'userId': 'dev_user_123', // TODO: 実際のユーザーIDを使用
        'lang': lang,
        'text': text,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Translation posted successfully');
    } catch (e) {
      print('Error posting translation: $e');
      throw Exception('翻訳案の投稿に失敗しました');
    }
  }

  static Future<void> postReview({
    required String bubbleId,
    required int score,
    required String comment,
  }) async {
    try {
      // bubbleIdからcomicId, episodeId, pageId, bubbleIndexを抽出
      final parts = bubbleId.split('/');
      if (parts.length != 4) {
        throw Exception('Invalid bubbleId format');
      }

      final comicId = parts[0];
      final episodeId = parts[1];
      final pageId = parts[2];
      final bubbleIndex = int.parse(parts[3]);

      // レビューデータをFirestoreに保存
      await _firestore
          .collection('comics')
          .doc(comicId)
          .collection('episodes')
          .doc(episodeId)
          .collection('pages')
          .doc(pageId)
          .collection('bubbles')
          .doc(bubbleIndex.toString())
          .collection('reviews')
          .add({
        'userId': 'dev_user_123', // TODO: 実際のユーザーIDを使用
        'score': score,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Review posted successfully');
    } catch (e) {
      print('Error posting review: $e');
      throw Exception('レビューの投稿に失敗しました');
    }
  }
}
