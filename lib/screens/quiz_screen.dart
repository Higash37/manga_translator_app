import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'home_screen.dart';
import 'comic_list_screen.dart';
import 'learning_progress_screen.dart';
import 'vocabulary_builder_screen.dart';
import 'ai_translation_assistant_screen.dart';

class QuizScreen extends StatefulWidget {
  final String comicId;
  final String episodeId;
  final String comicTitle;

  const QuizScreen({
    Key? key,
    required this.comicId,
    required this.episodeId,
    required this.comicTitle,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<int> _selectedAnswers = [];
  List<int> _reactionTimes = [];
  late DateTime _questionStartTime;
  bool _isAnswered = false;
  bool _showResults = false;
  late AnimationController _progressController;
  late AnimationController _fadeController;

  // 認知科学的指標
  List<Map<String, dynamic>> _cognitiveMetrics = [];
  double _averageReactionTime = 0;
  double _accuracyRate = 0;
  List<double> _learningCurve = [];

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '主人公が最初に訪れた場所はどこですか？',
      'options': ['図書館', '公園', '学校', '商店街'],
      'correctAnswer': 0,
      'cognitiveType': 'episodic_memory', // エピソード記憶
      'difficulty': 'easy',
    },
    {
      'question': 'この漫画で「友情」を表現している場面はどれですか？',
      'options': ['キャラクターが一人で歩く', '二人が一緒に笑う', '背景に花が描かれる', '文字が大きく表示される'],
      'correctAnswer': 1,
      'cognitiveType': 'semantic_understanding', // 意味理解
      'difficulty': 'medium',
    },
    {
      'question': '文脈から推測すると、「頑張って」の感情的ニュアンスは？',
      'options': ['励まし', '命令', '皮肉', '無関心'],
      'correctAnswer': 0,
      'cognitiveType': 'pragmatic_inference', // 語用論的推論
      'difficulty': 'hard',
    },
    {
      'question': 'キャラクターの表情から読み取れる感情は？',
      'options': ['喜び', '悲しみ', '怒り', '驚き'],
      'correctAnswer': 0,
      'cognitiveType': 'emotional_recognition', // 感情認識
      'difficulty': 'medium',
    },
    {
      'question': '物語の時系列で正しい順序は？',
      'options': ['朝→昼→夜', '夜→朝→昼', '昼→夜→朝', '朝→夜→昼'],
      'correctAnswer': 0,
      'cognitiveType': 'temporal_sequencing', // 時系列理解
      'difficulty': 'easy',
    },
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _startQuestion();
  }

  void _startQuestion() {
    _questionStartTime = DateTime.now();
    _isAnswered = false;
    _fadeController.forward();
  }

  void _selectAnswer(int selectedIndex) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      final reactionTime = DateTime.now().difference(_questionStartTime).inMilliseconds;
      _reactionTimes.add(reactionTime);
      _selectedAnswers.add(selectedIndex);

      final isCorrect = selectedIndex == _questions[_currentQuestionIndex]['correctAnswer'];
      if (isCorrect) _score++;

      // 認知科学的メトリクス記録
      _cognitiveMetrics.add({
        'questionIndex': _currentQuestionIndex,
        'isCorrect': isCorrect,
        'reactionTime': reactionTime,
        'cognitiveType': _questions[_currentQuestionIndex]['cognitiveType'],
        'difficulty': _questions[_currentQuestionIndex]['difficulty'],
        'timestamp': DateTime.now(),
      });

      _updateLearningMetrics();
    });

    Timer(Duration(seconds: 2), _nextQuestion);
  }

  void _updateLearningMetrics() {
    // 平均反応時間計算
    _averageReactionTime = _reactionTimes.reduce((a, b) => a + b) / _reactionTimes.length;
    
    // 正答率計算
    _accuracyRate = _score / (_currentQuestionIndex + 1);
    
    // 学習曲線更新（移動平均）
    _learningCurve.add(_accuracyRate);
  }

  void _nextQuestion() {
    _fadeController.reset();
    
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _progressController.animateTo((_currentQuestionIndex + 1) / _questions.length);
      _startQuestion();
    } else {
      _showResults = true;
      _progressController.animateTo(1.0);
      setState(() {});
    }
  }

  Widget _buildCognitiveAnalytics() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[50]!, Colors.blue[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🧠 認知パフォーマンス分析',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purple[800],
            ),
          ),
          SizedBox(height: 20),
          
          // メトリクスカード
          Row(
            children: [
              Expanded(child: _buildMetricCard('正答率', '${(_accuracyRate * 100).toStringAsFixed(1)}%', Icons.psychology, Colors.green)),
              SizedBox(width: 12),
              Expanded(child: _buildMetricCard('平均反応時間', '${_averageReactionTime.toStringAsFixed(0)}ms', Icons.timer, Colors.orange)),
            ],
          ),
          SizedBox(height: 16),
          
          // 認知タイプ別分析
          _buildCognitiveTypeAnalysis(),
          SizedBox(height: 16),
          
          // 学習曲線
          _buildLearningCurve(),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCognitiveTypeAnalysis() {
    Map<String, List<bool>> typeResults = {};
    
    for (var metric in _cognitiveMetrics) {
      String type = metric['cognitiveType'];
      if (!typeResults.containsKey(type)) {
        typeResults[type] = [];
      }
      typeResults[type]!.add(metric['isCorrect']);
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '認知タイプ別パフォーマンス',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple[800],
            ),
          ),
          SizedBox(height: 12),
          ...typeResults.entries.map((entry) {
            final accuracy = entry.value.where((correct) => correct).length / entry.value.length;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      _getCognitiveTypeLabel(entry.key),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: LinearProgressIndicator(
                      value: accuracy,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        accuracy > 0.8 ? Colors.green : accuracy > 0.6 ? Colors.orange : Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${(accuracy * 100).toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _getCognitiveTypeLabel(String type) {
    switch (type) {
      case 'episodic_memory': return 'エピソード記憶';
      case 'semantic_understanding': return '意味理解';
      case 'pragmatic_inference': return '語用推論';
      case 'emotional_recognition': return '感情認識';
      case 'temporal_sequencing': return '時系列理解';
      default: return type;
    }
  }

  Widget _buildLearningCurve() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '学習曲線（正答率推移）',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple[800],
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 100,
            child: CustomPaint(
              painter: LearningCurvePainter(_learningCurve),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple[700]!, Colors.blue[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.psychology, color: Colors.white, size: 40),
                SizedBox(height: 12),
                Text(
                  '認知学習分析システム',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.blue[700]),
            title: Text('ホーム'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.auto_stories, color: Colors.blue[700]),
            title: Text('漫画を読む'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComicListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.quiz, color: Colors.purple[600]),
            title: Text('理解度クイズ'),
            selected: true,
            selectedTileColor: Colors.purple[50],
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.assessment, color: Colors.blue[400]),
            title: Text('学習進捗'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LearningProgressScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.book, color: Colors.blue[300]),
            title: Text('単語帳作成'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VocabularyBuilderScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.psychology, color: Colors.blue[200]),
            title: Text('AI翻訳支援'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AITranslationAssistantScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: Text('認知科学的理解度テスト'),
        backgroundColor: Colors.purple[700],
        elevation: 0,
        leading: isWide ? null : Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: isWide ? null : _buildDrawer(),
      body: Row(
        children: [
          if (isWide) Container(width: 280, child: _buildDrawer()),
          Expanded(
            child: _showResults ? _buildResultsScreen() : _buildQuizScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[50]!, Colors.blue[50]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // プログレスバー
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('問題 ${_currentQuestionIndex + 1}/${_questions.length}'),
                    Text('正答率: ${_score > 0 ? ((_score / (_currentQuestionIndex + 1)) * 100).toStringAsFixed(1) : "0.0"}%'),
                  ],
                ),
                SizedBox(height: 8),
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _progressController.value,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[600]!),
                    );
                  },
                ),
              ],
            ),
          ),

                     Expanded(
             child: FadeTransition(
               opacity: _fadeController,
               child: SingleChildScrollView(
                 padding: EdgeInsets.all(20),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                                         // 問題カード
                     Container(
                       padding: EdgeInsets.all(20),
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(16),
                         boxShadow: [
                           BoxShadow(
                             color: Colors.black.withOpacity(0.08),
                             blurRadius: 8,
                             offset: Offset(0, 3),
                           ),
                         ],
                       ),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.purple[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getCognitiveTypeLabel(_questions[_currentQuestionIndex]['cognitiveType']),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.purple[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(_questions[_currentQuestionIndex]['difficulty']),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _questions[_currentQuestionIndex]['difficulty'].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                                                     SizedBox(height: 16),
                           Text(
                             _questions[_currentQuestionIndex]['question'],
                             style: TextStyle(
                               fontSize: 18,
                               fontWeight: FontWeight.bold,
                               color: Colors.grey[800],
                             ),
                           ),
                        ],
                      ),
                    ),

                                         SizedBox(height: 16),

                     // 選択肢
                     ...List.generate(
                       _questions[_currentQuestionIndex]['options'].length,
                       (index) => Padding(
                         padding: EdgeInsets.only(bottom: 12),
                         child: _buildAnswerOption(index),
                       ),
                     ),
                     
                     // 下部に余白を追加
                     SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy': return Colors.green;
      case 'medium': return Colors.orange;
      case 'hard': return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget _buildAnswerOption(int index) {
    final isSelected = _selectedAnswers.length > _currentQuestionIndex && _selectedAnswers[_currentQuestionIndex] == index;
    final isCorrect = index == _questions[_currentQuestionIndex]['correctAnswer'];
    
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    
    if (_isAnswered) {
      if (isCorrect) {
        backgroundColor = Colors.green[50]!;
        borderColor = Colors.green;
      } else if (isSelected && !isCorrect) {
        backgroundColor = Colors.red[50]!;
        borderColor = Colors.red;
      }
    }

    return GestureDetector(
      onTap: () => _selectAnswer(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: borderColor,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                _questions[_currentQuestionIndex]['options'][index],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
            if (_isAnswered && isCorrect)
              Icon(Icons.check_circle, color: Colors.green, size: 24),
            if (_isAnswered && isSelected && !isCorrect)
              Icon(Icons.cancel, color: Colors.red, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 総合結果カード
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple[600]!, Colors.blue[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.psychology, color: Colors.white, size: 60),
                SizedBox(height: 16),
                Text(
                  'テスト完了！',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${widget.comicTitle}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '$_score',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '正解数',
                          style: TextStyle(color: Colors.white.withOpacity(0.9)),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${(_accuracyRate * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '正答率',
                          style: TextStyle(color: Colors.white.withOpacity(0.9)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // 認知科学的分析
          _buildCognitiveAnalytics(),

          SizedBox(height: 24),

          // アクションボタン
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.refresh),
                  label: Text('もう一度挑戦'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[600],
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.home),
                  label: Text('ホームに戻る'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}

// 学習曲線を描画するカスタムペインター
class LearningCurvePainter extends CustomPainter {
  final List<double> data;

  LearningCurvePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.purple[600]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i] * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // データポイントを描画
    final pointPaint = Paint()
      ..color = Colors.purple[600]!
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i] * size.height);
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 