import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comic_model.dart';
import '../models/page_model.dart';

class ComicService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<Comic>> getComics() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('comics').get();
      
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // ドキュメントIDを追加
          return Comic.fromJson(data);
        }).toList();
      }

      // Firestoreにデータがない場合のフォールバックデータ
      return _getFallbackComics();
    } catch (e) {
      print('Error loading comics from Firestore: $e');
      // エラーが発生した場合のフォールバックデータ
      return _getFallbackComics();
    }
  }

  static Future<Comic?> getComic(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection('comics').doc(id).get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Comic.fromJson(data);
      }

      return null;
    } catch (e) {
      print('Error loading comic from Firestore: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getEpisodes(String comicId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('comics')
          .doc(comicId)
          .collection('episodes')
          .orderBy('episodeId')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error loading episodes from Firestore: $e');
      return [];
    }
  }

  static Future<List<MangaPage>> getPages(
    String comicId,
    String episodeId,
  ) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('comics')
          .doc(comicId)
          .collection('episodes')
          .doc(episodeId)
          .collection('pages')
          .orderBy('pageId')
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return MangaPage.fromJson(data);
        }).toList();
      }

      // フォールバックとして空のページリストを返す
      return [];
    } catch (e) {
      print('Error loading pages from Firestore: $e');
      return [];
    }
  }

  // フォールバック用のサンプルデータ
  static List<Comic> _getFallbackComics() {
    return [
      Comic(
        id: 'manga001',
        title: {
          'ja': '冒険の始まり',
          'en': 'The Beginning of Adventure',
          'zh': '冒險的開始',
        },
        description: {
          'ja': '主人公の冒険が始まる物語',
          'en': 'A story where the hero\'s adventure begins',
          'zh': '主角冒險開始的故事',
        },
        coverImage: 'assets/pages/page001.png',
        episodeCount: 1,
        languages: ['ja', 'en', 'zh'],
      ),
      Comic(
        id: 'manga002',
        title: {'ja': 'SPY×FAMILY', 'en': 'SPY×FAMILY', 'zh': '間諜家家酒'},
        description: {
          'ja': '凄腕スパイ×特殊家族コメディ',
          'en': 'Master Spy x Special Family Comedy',
          'zh': '超級間諜×特殊家庭喜劇',
        },
        coverImage: 'assets/pages/page002.png',
        episodeCount: 120,
        languages: ['ja', 'en', 'zh'],
      ),
      Comic(
        id: 'manga003',
        title: {'ja': 'ONE PIECE', 'en': 'ONE PIECE', 'zh': '海賊王'},
        description: {
          'ja': '海賊王を目指す冒険',
          'en': 'Adventure to become the Pirate King',
          'zh': '成為海賊王的冒險',
        },
        coverImage: 'assets/pages/page003.png',
        episodeCount: 1000,
        languages: ['ja', 'en', 'zh'],
      ),
    ];
  }
}
