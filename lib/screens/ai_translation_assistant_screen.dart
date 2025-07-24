import 'package:flutter/material.dart';
import 'dart:math';
import 'home_screen.dart';
import 'comic_list_screen.dart';
import 'quiz_screen.dart';
import 'learning_progress_screen.dart';
import 'vocabulary_builder_screen.dart';

class AITranslationAssistantScreen extends StatefulWidget {
  @override
  _AITranslationAssistantScreenState createState() => _AITranslationAssistantScreenState();
}

class _AITranslationAssistantScreenState extends State<AITranslationAssistantScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _processController;
  
  String _sourceLanguage = 'ja';
  String _targetLanguage = 'en';
  String _translationMode = 'cognitive'; // cognitive, literal, contextual
  
  final TextEditingController _sourceController = TextEditingController();
  String _translationResult = '';
  bool _isTranslating = false;
  
  // 認知プロセス分析データ
  Map<String, dynamic> _cognitiveAnalysis = {};
  List<Map<String, dynamic>> _errorAnalysis = [];
  List<Map<String, dynamic>> _transferPatterns = [];

  // モック翻訳データ
  final Map<String, dynamic> _mockTranslationData = {
    'sourceText': '友達と一緒に公園で遊んだ。',
    'translations': {
      'literal': 'Friend and together park at played.',
      'contextual': 'I played with my friend at the park.',
      'cognitive': 'I played with my friend in the park.',
    },
    'cognitiveProcess': {
      'lexicalAccess': 0.85,
      'syntacticParsing': 0.72,
      'semanticMapping': 0.91,
      'pragmaticInference': 0.68,
      'crossLinguisticTransfer': 0.76,
    },
    'errorPatterns': [
      {
        'type': 'word_order',
        'severity': 'medium',
        'explanation': '日本語のSOV語順から英語のSVO語順への転移',
        'suggestion': '英語の基本語順SVO（主語-動詞-目的語）を意識しましょう',
      },
      {
        'type': 'particle_omission',
        'severity': 'low',
        'explanation': '日本語の助詞「で」の英語前置詞への対応',
        'suggestion': '場所を表す「で」は通常「in」「at」で表現されます',
      },
    ],
    'transferAnalysis': [
      {'pattern': 'L1_interference', 'frequency': 0.34, 'improvement': 0.12},
      {'pattern': 'positive_transfer', 'frequency': 0.58, 'improvement': 0.23},
      {'pattern': 'overgeneralization', 'frequency': 0.28, 'improvement': 0.18},
    ],
  };

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _processController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeController.forward();
    _loadMockData();
  }

  void _loadMockData() {
    setState(() {
      _sourceController.text = _mockTranslationData['sourceText'];
      _translationResult = _mockTranslationData['translations'][_translationMode];
      _cognitiveAnalysis = _mockTranslationData['cognitiveProcess'];
      _errorAnalysis = List<Map<String, dynamic>>.from(_mockTranslationData['errorPatterns']);
      _transferPatterns = List<Map<String, dynamic>>.from(_mockTranslationData['transferAnalysis']);
    });
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple[700]!, Colors.indigo[600]!],
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
                  'AI認知翻訳支援',
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
            leading: Icon(Icons.psychology, color: Colors.deepPurple[600]),
            title: Text('AI翻訳支援'),
            selected: true,
            selectedTileColor: Colors.deepPurple[50],
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationInterface() {
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
              Icon(Icons.translate, color: Colors.deepPurple[600], size: 24),
              SizedBox(width: 8),
              Text(
                '認知翻訳インターフェース',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[800],
                ),
              ),
              Spacer(),
              _buildLanguageSelector(),
            ],
          ),
          SizedBox(height: 20),
          
          // 翻訳モード選択
          Row(
            children: [
              Expanded(child: _buildModeButton('literal', '逐語翻訳', Colors.orange)),
              SizedBox(width: 8),
              Expanded(child: _buildModeButton('contextual', '文脈翻訳', Colors.blue)),
              SizedBox(width: 8),
              Expanded(child: _buildModeButton('cognitive', '認知翻訳', Colors.purple)),
            ],
          ),
          SizedBox(height: 20),

          // 入力エリア
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '原文 (${_getLanguageLabel(_sourceLanguage)})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _sourceController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '翻訳したいテキストを入力してください...',
                  ),
                  onChanged: (text) {
                    // リアルタイム翻訳トリガー
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // 翻訳ボタン
          Center(
            child: ElevatedButton.icon(
              onPressed: _isTranslating ? null : _performTranslation,
              icon: _isTranslating 
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Icon(Icons.psychology),
              label: Text(_isTranslating ? '認知処理中...' : '認知翻訳実行'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[600],
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ),
          SizedBox(height: 16),

          // 結果エリア
          if (_translationResult.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '翻訳結果 (${_getLanguageLabel(_targetLanguage)})',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _translationResult,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: _sourceLanguage,
            underline: SizedBox(),
            items: [
              DropdownMenuItem(value: 'ja', child: Text('日本語')),
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'zh', child: Text('中文')),
            ],
            onChanged: (value) {
              setState(() {
                _sourceLanguage = value!;
              });
            },
          ),
        ),
        SizedBox(width: 8),
        Icon(Icons.arrow_forward, color: Colors.grey[600]),
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: _targetLanguage,
            underline: SizedBox(),
            items: [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'ja', child: Text('日本語')),
              DropdownMenuItem(value: 'zh', child: Text('中文')),
            ],
            onChanged: (value) {
              setState(() {
                _targetLanguage = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModeButton(String mode, String label, Color color) {
    bool isSelected = _translationMode == mode;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _translationMode = mode;
          _translationResult = _mockTranslationData['translations'][mode];
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? color : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCognitiveProcessAnalysis() {
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
              Icon(Icons.psychology, color: Colors.indigo[600], size: 24),
              SizedBox(width: 8),
              Text(
                '認知プロセス分析',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[800],
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Kroll & Stewart モデル',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.indigo[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          ..._cognitiveAnalysis.entries.map((entry) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getCognitiveProcessLabel(entry.key),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${(entry.value * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getCognitiveProcessColor(entry.value),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: entry.value,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getCognitiveProcessColor(entry.value),
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

  Widget _buildErrorAnalysis() {
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
              Icon(Icons.error_outline, color: Colors.red[600], size: 24),
              SizedBox(width: 8),
              Text(
                'エラー分析・改善提案',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          ..._errorAnalysis.map((error) {
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getErrorSeverityColor(error['severity']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getErrorSeverityColor(error['severity']).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getErrorSeverityColor(error['severity']),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getErrorTypeLabel(error['type']),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          error['severity'].toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    error['explanation'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.green[600], size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            error['suggestion'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildTransferPatternAnalysis() {
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
              Icon(Icons.compare_arrows, color: Colors.teal[600], size: 24),
              SizedBox(width: 8),
              Text(
                '言語転移パターン分析',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Odlin転移理論',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.teal[700],
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
              animation: _processController,
              builder: (context, child) {
                return CustomPaint(
                  painter: TransferPatternPainter(_transferPatterns, _processController.value),
                  size: Size.infinite,
                );
              },
            ),
          ),
          SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('L1干渉', Colors.red[600]!),
              _buildLegendItem('正の転移', Colors.green[600]!),
              _buildLegendItem('過度般化', Colors.orange[600]!),
            ],
          ),
        ],
      ),
    );
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

  String _getLanguageLabel(String code) {
    switch (code) {
      case 'ja': return '日本語';
      case 'en': return 'English';
      case 'zh': return '中文';
      default: return code;
    }
  }

  String _getCognitiveProcessLabel(String process) {
    switch (process) {
      case 'lexicalAccess': return '語彙アクセス';
      case 'syntacticParsing': return '統語解析';
      case 'semanticMapping': return '意味写像';
      case 'pragmaticInference': return '語用推論';
      case 'crossLinguisticTransfer': return '言語間転移';
      default: return process;
    }
  }

  Color _getCognitiveProcessColor(double value) {
    if (value >= 0.8) return Colors.green[600]!;
    if (value >= 0.6) return Colors.orange[600]!;
    return Colors.red[600]!;
  }

  String _getErrorTypeLabel(String type) {
    switch (type) {
      case 'word_order': return '語順エラー';
      case 'particle_omission': return '助詞脱落';
      case 'tense_confusion': return '時制混同';
      default: return type;
    }
  }

  Color _getErrorSeverityColor(String severity) {
    switch (severity) {
      case 'high': return Colors.red[600]!;
      case 'medium': return Colors.orange[600]!;
      case 'low': return Colors.yellow[700]!;
      default: return Colors.grey[600]!;
    }
  }

  void _performTranslation() {
    setState(() {
      _isTranslating = true;
    });

    _processController.forward().then((_) {
      Future.delayed(Duration(milliseconds: 1500), () {
        setState(() {
          _isTranslating = false;
          _translationResult = _mockTranslationData['translations'][_translationMode];
        });
        _processController.reset();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: Text('AI認知翻訳支援'),
        backgroundColor: Colors.deepPurple[700],
        elevation: 0,
        leading: isWide ? null : Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: isWide ? null : _buildDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple[50]!, Colors.indigo[50]!],
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
                        'AI認知翻訳支援システム',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '言語転移理論・翻訳認知プロセス・エラー分析による高度翻訳支援',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 24),

                      // 翻訳インターフェース
                      _buildTranslationInterface(),
                      SizedBox(height: 24),

                      // 分析結果行
                      Row(
                        children: [
                          Expanded(child: _buildCognitiveProcessAnalysis()),
                          SizedBox(width: 16),
                          Expanded(child: _buildTransferPatternAnalysis()),
                        ],
                      ),
                      SizedBox(height: 24),

                      // エラー分析
                      _buildErrorAnalysis(),
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
    _processController.dispose();
    _sourceController.dispose();
    super.dispose();
  }
}

// 言語転移パターンを描画するカスタムペインター
class TransferPatternPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double animationValue;

  TransferPatternPainter(this.data, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [Colors.red[600]!, Colors.green[600]!, Colors.orange[600]!];
    
    for (int i = 0; i < data.length; i++) {
      final centerX = size.width / 2;
      final centerY = size.height / 2;
      final radius = (size.width / 4) * data[i]['frequency'] * animationValue;
      
      final paint = Paint()
        ..color = colors[i % colors.length].withOpacity(0.7)
        ..style = PaintingStyle.fill;

      // 円を描画
      canvas.drawCircle(
        Offset(
          centerX + (i - 1) * 60,
          centerY + sin(i * 2 * pi / 3) * 30,
        ),
        radius,
        paint,
      );

      // ラベル
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${(data[i]['frequency'] * 100).toStringAsFixed(0)}%',
          style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          centerX + (i - 1) * 60 - textPainter.width / 2,
          centerY + sin(i * 2 * pi / 3) * 30 - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 