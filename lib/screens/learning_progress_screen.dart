import 'package:flutter/material.dart';
import 'dart:math';
import 'home_screen.dart';
import 'comic_list_screen.dart';
import 'quiz_screen.dart';
import 'vocabulary_builder_screen.dart';
import 'ai_translation_assistant_screen.dart';

class LearningProgressScreen extends StatefulWidget {
  @override
  _LearningProgressScreenState createState() => _LearningProgressScreenState();
}

class _LearningProgressScreenState extends State<LearningProgressScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _chartController;
  String _selectedTimeRange = '1週間';
  String _selectedAnalysisType = '記憶定着度';

  // モックデータ（実際はFirestoreから取得）
  final Map<String, dynamic> _learningData = {
    'totalStudyTime': 1250, // 分
    'completedLessons': 28,
    'averageAccuracy': 0.847,
    'streakDays': 12,
    'vocabularyLearned': 156,
    'retentionRate': 0.73,
    'cognitiveLoad': 0.65, // 認知負荷指数
    'learningEfficiency': 0.82, // 学習効率
  };

  final List<Map<String, dynamic>> _forgettingCurveData = [
    {'day': 0, 'retention': 1.0, 'reviewed': false},
    {'day': 1, 'retention': 0.58, 'reviewed': false},
    {'day': 2, 'retention': 0.44, 'reviewed': true},
    {'day': 7, 'retention': 0.35, 'reviewed': false},
    {'day': 14, 'retention': 0.25, 'reviewed': true},
    {'day': 30, 'retention': 0.21, 'reviewed': false},
  ];

  final List<Map<String, dynamic>> _spacingEffectData = [
    {'interval': 1, 'retention': 0.58, 'optimal': false},
    {'interval': 3, 'retention': 0.72, 'optimal': true},
    {'interval': 7, 'retention': 0.85, 'optimal': true},
    {'interval': 14, 'retention': 0.78, 'optimal': true},
    {'interval': 30, 'retention': 0.65, 'optimal': false},
  ];

  final List<Map<String, dynamic>> _cognitiveTypeProgress = [
    {'type': 'episodic_memory', 'progress': 0.85, 'sessions': 15},
    {'type': 'semantic_understanding', 'progress': 0.72, 'sessions': 12},
    {'type': 'pragmatic_inference', 'progress': 0.68, 'sessions': 8},
    {'type': 'emotional_recognition', 'progress': 0.91, 'sessions': 18},
    {'type': 'temporal_sequencing', 'progress': 0.76, 'sessions': 10},
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _chartController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeController.forward();
    _chartController.forward();
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo[700]!, Colors.blue[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.analytics, color: Colors.white, size: 40),
                SizedBox(height: 12),
                Text(
                  '学習分析ダッシュボード',
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
            leading: Icon(Icons.quiz, color: Colors.blue[600]),
            title: Text('理解度クイズ'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(
                    comicId: 'manga001',
                    episodeId: 'episode_1',
                    comicTitle: '冒険の始まり',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assessment, color: Colors.indigo[600]),
            title: Text('学習進捗'),
            selected: true,
            selectedTileColor: Colors.indigo[50],
            onTap: () => Navigator.pop(context),
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

  Widget _buildOverviewCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildMetricCard(
          '総学習時間',
          '${(_learningData['totalStudyTime'] / 60).toStringAsFixed(1)}h',
          Icons.schedule,
          Colors.blue,
          '今週: +3.2h',
        ),
        _buildMetricCard(
          '記憶定着率',
          '${(_learningData['retentionRate'] * 100).toStringAsFixed(1)}%',
          Icons.psychology,
          Colors.purple,
          'エビングハウス曲線対比',
        ),
        _buildMetricCard(
          '学習効率',
          '${(_learningData['learningEfficiency'] * 100).toStringAsFixed(1)}%',
          Icons.trending_up,
          Colors.green,
          '認知負荷最適化済み',
        ),
        _buildMetricCard(
          '連続学習日数',
          '${_learningData['streakDays']}日',
          Icons.local_fire_department,
          Colors.orange,
          'スペーシング効果活用',
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Spacer(),
              Icon(Icons.trending_up, color: Colors.green, size: 12),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey[500],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildForgettingCurveChart() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.memory, color: Colors.red[600], size: 24),
              SizedBox(width: 8),
              Text(
                '忘却曲線分析',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'エビングハウス理論',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: AnimatedBuilder(
              animation: _chartController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ForgettingCurvePainter(_forgettingCurveData, _chartController.value),
                  size: Size.infinite,
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildLegendItem('記憶保持率', Colors.red[600]!),
              SizedBox(width: 20),
              _buildLegendItem('復習ポイント', Colors.blue[600]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpacingEffectChart() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: Colors.green[600], size: 24),
              SizedBox(width: 8),
              Text(
                'スペーシング効果最適化',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '分散学習理論',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: AnimatedBuilder(
              animation: _chartController,
              builder: (context, child) {
                return CustomPaint(
                  painter: SpacingEffectPainter(_spacingEffectData, _chartController.value),
                  size: Size.infinite,
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildLegendItem('最適間隔', Colors.green[600]!),
              SizedBox(width: 20),
              _buildLegendItem('要改善', Colors.orange[600]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCognitiveTypeProgress() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.purple[600], size: 24),
              SizedBox(width: 8),
              Text(
                '認知タイプ別習得状況',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ..._cognitiveTypeProgress.map((data) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getCognitiveTypeLabel(data['type']),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${(data['progress'] * 100).toStringAsFixed(0)}% (${data['sessions']}回)',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: data['progress'],
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getCognitiveTypeColor(data['type']),
                    ),
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

  Color _getCognitiveTypeColor(String type) {
    switch (type) {
      case 'episodic_memory': return Colors.blue[600]!;
      case 'semantic_understanding': return Colors.green[600]!;
      case 'pragmatic_inference': return Colors.orange[600]!;
      case 'emotional_recognition': return Colors.purple[600]!;
      case 'temporal_sequencing': return Colors.teal[600]!;
      default: return Colors.grey[600]!;
    }
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[50]!, Colors.blue[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber[600], size: 24),
              SizedBox(width: 8),
              Text(
                'AI学習最適化提案',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildRecommendationItem(
            '語用推論の強化',
            '文脈理解が68%です。漫画の会話シーンを重点的に学習することをお勧めします。',
            Icons.chat_bubble,
            Colors.orange,
          ),
          _buildRecommendationItem(
            '復習タイミング最適化',
            '次回復習は2日後が最適です。忘却曲線に基づいた効率的な記憶定着が期待できます。',
            Icons.schedule,
            Colors.blue,
          ),
          _buildRecommendationItem(
            '認知負荷調整',
            '現在の負荷は65%です。難易度を少し上げて学習効率を向上させましょう。',
            Icons.trending_up,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String title, String description, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
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
        title: Text('学習進捗分析'),
        backgroundColor: Colors.indigo[700],
        elevation: 0,
        leading: isWide ? null : Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedTimeRange = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: '1週間', child: Text('1週間')),
              PopupMenuItem(value: '1ヶ月', child: Text('1ヶ月')),
              PopupMenuItem(value: '3ヶ月', child: Text('3ヶ月')),
            ],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(_selectedTimeRange),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: isWide ? null : _buildDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo[50]!, Colors.blue[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: [
            if (isWide) Container(width: 280, child: _buildDrawer()),
            Expanded(
              child: FadeTransition(
                opacity: _fadeController,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ヘッダー
                      Text(
                        '認知科学的学習分析ダッシュボード',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'エビングハウス忘却曲線・スペーシング効果・認知負荷理論に基づく最適化',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 24),

                      // 概要カード
                      _buildOverviewCards(),
                      SizedBox(height: 20),

                      // チャート行
                      Row(
                        children: [
                          Expanded(child: _buildForgettingCurveChart()),
                          SizedBox(width: 12),
                          Expanded(child: _buildSpacingEffectChart()),
                        ],
                      ),
                      SizedBox(height: 20),

                      // 認知タイプ進捗と推奨事項
                      Row(
                        children: [
                          Expanded(child: _buildCognitiveTypeProgress()),
                          SizedBox(width: 12),
                          Expanded(child: _buildRecommendations()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _chartController.dispose();
    super.dispose();
  }
}

// 忘却曲線を描画するカスタムペインター
class ForgettingCurvePainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double animationValue;

  ForgettingCurvePainter(this.data, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red[600]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    for (int i = 0; i < data.length; i++) {
      final x = (data[i]['day'] / 30) * size.width * animationValue;
      final y = size.height - (data[i]['retention'] * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // 復習ポイントを描画
    final reviewPaint = Paint()
      ..color = Colors.blue[600]!
      ..style = PaintingStyle.fill;

    for (var point in data) {
      if (point['reviewed']) {
        final x = (point['day'] / 30) * size.width * animationValue;
        final y = size.height - (point['retention'] * size.height);
        canvas.drawCircle(Offset(x, y), 6, reviewPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// スペーシング効果を描画するカスタムペインター
class SpacingEffectPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double animationValue;

  SpacingEffectPainter(this.data, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / (data.length * 2);
    
    for (int i = 0; i < data.length; i++) {
      final x = i * (size.width / data.length) + barWidth / 2;
      final barHeight = data[i]['retention'] * size.height * animationValue;
      final y = size.height - barHeight;
      
      final paint = Paint()
        ..color = data[i]['optimal'] ? Colors.green[600]! : Colors.orange[600]!
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(x - barWidth / 2, y, barWidth, barHeight),
        paint,
      );

      // 間隔ラベル
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${data[i]['interval']}日',
          style: TextStyle(fontSize: 10, color: Colors.grey[700]),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height + 5));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 