import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

class QuizService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // エピソードのクイズを取得
  static Future<List<Quiz>> getEpisodeQuizzes(
    String comicId,
    String episodeId,
  ) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('comics')
          .doc(comicId)
          .collection('episodes')
          .doc(episodeId)
          .collection('quizzes')
          .orderBy('order')
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return Quiz.fromJson(data);
        }).toList();
      }

      // Firestoreにデータがない場合のフォールバック
      return _getSampleQuizzes(comicId, episodeId);
    } catch (e) {
      print('Error loading quizzes from Firestore: $e');
      // エラーが発生した場合のフォールバック用のサンプルクイズ
      return _getSampleQuizzes(comicId, episodeId);
    }
  }

  // クイズ結果を送信
  static Future<bool> submitQuizResult(QuizResult result) async {
    try {
      await _firestore.collection('quiz_results').add({
        'quizId': result.quizId,
        'userId': 'dev_user_123', // TODO: 実際のユーザーIDを使用
        'selectedIndex': result.selectedIndex,
        'isCorrect': result.isCorrect,
        'answeredAt': result.answeredAt,
        'timeSpent': result.timeSpent,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Quiz result submitted successfully');
      return true;
    } catch (e) {
      print('Error submitting quiz result: $e');
      return false;
    }
  }

  // サンプルクイズデータ
  static List<Quiz> _getSampleQuizzes(String comicId, String episodeId) {
    return [
      Quiz(
        id: 'quiz_001',
        comicId: comicId,
        episodeId: episodeId,
        question: '「行きたい！！私を海に連れてって！！」の「行きたい」の正しい文法は？',
        choices: ['行きたい（正しい）', '行きしたい（間違い）', '行くたい（間違い）', '行きたがる（間違い）'],
        correctIndex: 0,
        explanation: '「行きたい」は「行く」の連用形「行き」＋「たい」の正しい形です。「行きしたい」は文法的に間違いです。',
        type: 'grammar',
        context: {
          'dialogue': '行きたい！！私を海に連れてって！！',
          'character': '主人公',
          'scene': '海に行きたいと訴える場面',
        },
      ),
      Quiz(
        id: 'quiz_002',
        comicId: comicId,
        episodeId: episodeId,
        question: '「私を海に連れてって！！」の「連れてって」の正しい表記は？',
        choices: ['連れてって（正しい）', '連れて行って（正しい）', '連れてって（間違い）', '連れてって（間違い）'],
        correctIndex: 1,
        explanation: '「連れてって」は「連れて行って」の口語的表現です。正式な表記では「連れて行って」が正しいです。',
        type: 'grammar',
        context: {
          'dialogue': '行きたい！！私を海に連れてって！！',
          'character': '主人公',
          'scene': '海に行きたいと訴える場面',
        },
      ),
      Quiz(
        id: 'quiz_003',
        comicId: comicId,
        episodeId: episodeId,
        question: '「冒険の始まりだ！」の「だ」の品詞は？',
        choices: ['助動詞', '形容詞', '動詞', '副詞'],
        correctIndex: 0,
        explanation: '「だ」は断定の助動詞です。「冒険の始まりだ」は「冒険の始まりである」という意味を表します。',
        type: 'grammar',
        context: {
          'dialogue': '冒険の始まりだ！',
          'character': '主人公',
          'scene': '冒険が始まる場面',
        },
      ),
    ];
  }
}
