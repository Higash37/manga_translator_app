import 'package:flutter/material.dart';
import 'dart:math';
import 'home_screen.dart';
import 'comic_list_screen.dart';
import 'quiz_screen.dart';
import 'learning_progress_screen.dart';
import 'ai_translation_assistant_screen.dart';

class VocabularyBuilderScreen extends StatefulWidget {
  @override
  _VocabularyBuilderScreenState createState() => _VocabularyBuilderScreenState();
}

class _VocabularyBuilderScreenState extends State<VocabularyBuilderScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _cardController;
  
  String _selectedCategory = '全て';
  String _selectedDifficulty = '全て';
  String _learningMode = 'flashcard'; // flashcard, association, memory_palace
  
  // モックデータ（実際はFirestoreから取得）
  final List<Map<String, dynamic>> _vocabularyData = [
    {
      'word': '友情',
      'reading': 'ゆうじょう',
      'meaning': 'friendship',
      'context': '主人公と仲間の深い友情が描かれている',
      'episodicMemory': '漫画の第3話で初めて登場',
      'semanticConnections': ['仲間', '信頼', '絆'],
      'difficulty': 'medium',
      'category': '感情',
      'acquisitionStage': 'recognition', // recognition, comprehension, production
      'memoryStrength': 0.73,
      'lastReviewed': DateTime.now().subtract(Duration(days: 2)),
      'reviewCount': 5,
      'correctRate': 0.8,
    },
    {
      'word': '冒険',
      'reading': 'ぼうけん',
      'meaning': 'adventure',
      'context': '新しい世界への冒険が始まる',
      'episodicMemory': '漫画の第1話のタイトル',
      'semanticConnections': ['旅', '挑戦', '発見'],
      'difficulty': 'easy',
      'category': '行動',
      'acquisitionStage': 'production',
      'memoryStrength': 0.92,
      'lastReviewed': DateTime.now().subtract(Duration(days: 1)),
      'reviewCount': 8,
      'correctRate': 0.95,
    },
    {
      'word': '諦める',
      'reading': 'あきらめる',
      'meaning': 'to give up',
      'context': '困難に直面しても決して諦めない',
      'episodicMemory': '主人公の決意を表すシーン',
      'semanticConnections': ['断念', '放棄', '挫折'],
      'difficulty': 'hard',
      'category': '心理',
      'acquisitionStage': 'comprehension',
      'memoryStrength': 0.45,
      'lastReviewed': DateTime.now().subtract(Duration(days: 5)),
      'reviewCount': 3,
      'correctRate': 0.6,
    },
  ];

  List<Map<String, dynamic>> get _filteredVocabulary {
    return _vocabularyData.where((word) {
      bool categoryMatch = _selectedCategory == '全て' || word['category'] == _selectedCategory;
      bool difficultyMatch = _selectedDifficulty == '全て' || word['difficulty'] == _selectedDifficulty;
      return categoryMatch && difficultyMatch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeController.forward();
    _cardController.forward();
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal[700]!, Colors.cyan[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.book, color: Colors.white, size: 40),
                SizedBox(height: 12),
                Text(
                  '認知語彙習得システム',
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
            leading: Icon(Icons.book, color: Colors.teal[600]),
            title: Text('単語帳作成'),
            selected: true,
            selectedTileColor: Colors.teal[50],
            onTap: () => Navigator.pop(context),
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

  Widget _buildLearningModeSelector() {
    return Container(
      padding: EdgeInsets.all(16),
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
          Text(
            '🧠 学習モード選択',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildModeCard(
                  'flashcard',
                  'フラッシュカード',
                  '基本的な記憶定着',
                  Icons.flip_to_front,
                  Colors.blue,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildModeCard(
                  'association',
                  '連想記憶',
                  '意味ネットワーク構築',
                  Icons.account_tree,
                  Colors.purple,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildModeCard(
                  'memory_palace',
                  '記憶宮殿',
                  '空間記憶活用',
                  Icons.location_city,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard(String mode, String title, String description, IconData icon, Color color) {
    bool isSelected = _learningMode == mode;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _learningMode = mode;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey[700],
              ),
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVocabularyStats() {
    int totalWords = _vocabularyData.length;
    int masteredWords = _vocabularyData.where((w) => w['acquisitionStage'] == 'production').length;
    double averageStrength = _vocabularyData.map((w) => w['memoryStrength'] as double).reduce((a, b) => a + b) / totalWords;
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal[50]!, Colors.cyan[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 語彙習得統計',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('総語彙数', totalWords.toString(), Icons.library_books, Colors.teal),
              ),
              Expanded(
                child: _buildStatItem('習得済み', masteredWords.toString(), Icons.check_circle, Colors.green),
              ),
              Expanded(
                child: _buildStatItem('記憶強度', '${(averageStrength * 100).toStringAsFixed(0)}%', Icons.psychology, Colors.purple),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
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
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildVocabularyList() {
    return Container(
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
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  '📚 語彙リスト',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
                Spacer(),
                _buildFilterDropdown(),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _filteredVocabulary.length,
            itemBuilder: (context, index) {
              return _buildVocabularyCard(_filteredVocabulary[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.teal[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: _selectedCategory,
            underline: SizedBox(),
            items: ['全て', '感情', '行動', '心理'].map((category) {
              return DropdownMenuItem(value: category, child: Text(category));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
        ),
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.teal[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: _selectedDifficulty,
            underline: SizedBox(),
            items: ['全て', 'easy', 'medium', 'hard'].map((difficulty) {
              return DropdownMenuItem(value: difficulty, child: Text(difficulty));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDifficulty = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVocabularyCard(Map<String, dynamic> word, int index) {
    Color stageColor = _getAcquisitionStageColor(word['acquisitionStage']);
    
    return AnimatedBuilder(
      animation: _cardController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _cardController.value)),
          child: Opacity(
            opacity: _cardController.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: stageColor, width: 4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  word['word'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  word['reading'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              word['meaning'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: stageColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getAcquisitionStageLabel(word['acquisitionStage']),
                              style: TextStyle(
                                fontSize: 10,
                                color: stageColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          CircularProgressIndicator(
                            value: word['memoryStrength'],
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(stageColor),
                            strokeWidth: 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  
                  // 文脈情報
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.article, size: 16, color: Colors.blue[600]),
                            SizedBox(width: 4),
                            Text(
                              '文脈',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          word['context'],
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // エピソード記憶
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.movie, size: 16, color: Colors.purple[600]),
                            SizedBox(width: 4),
                            Text(
                              'エピソード記憶',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          word['episodicMemory'],
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // 意味的連想
                  Wrap(
                    spacing: 8,
                    children: (word['semanticConnections'] as List<String>).map((connection) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.teal[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          connection,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.teal[700],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 12),
                  
                  // 学習統計
                  Row(
                    children: [
                      _buildMiniStat('復習回数', word['reviewCount'].toString(), Icons.refresh),
                      SizedBox(width: 16),
                      _buildMiniStat('正答率', '${(word['correctRate'] * 100).toStringAsFixed(0)}%', Icons.check),
                      SizedBox(width: 16),
                      _buildMiniStat('最終復習', _getLastReviewedText(word['lastReviewed']), Icons.schedule),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          '$label: $value',
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
        ),
      ],
    );
  }

  String _getAcquisitionStageLabel(String stage) {
    switch (stage) {
      case 'recognition': return '認識';
      case 'comprehension': return '理解';
      case 'production': return '産出';
      default: return stage;
    }
  }

  Color _getAcquisitionStageColor(String stage) {
    switch (stage) {
      case 'recognition': return Colors.orange[600]!;
      case 'comprehension': return Colors.blue[600]!;
      case 'production': return Colors.green[600]!;
      default: return Colors.grey[600]!;
    }
  }

  String _getLastReviewedText(DateTime lastReviewed) {
    final difference = DateTime.now().difference(lastReviewed).inDays;
    if (difference == 0) return '今日';
    if (difference == 1) return '昨日';
    return '${difference}日前';
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: Text('認知語彙習得システム'),
        backgroundColor: Colors.teal[700],
        elevation: 0,
        leading: isWide ? null : Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // 新しい単語追加ダイアログ
            },
          ),
        ],
      ),
      drawer: isWide ? null : _buildDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[50]!, Colors.cyan[50]!],
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
                        '認知語彙習得システム',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '意味記憶・エピソード記憶統合による効率的語彙学習',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 24),

                      // 学習モード選択
                      _buildLearningModeSelector(),
                      SizedBox(height: 24),

                      // 統計情報
                      _buildVocabularyStats(),
                      SizedBox(height: 24),

                      // 語彙リスト
                      _buildVocabularyList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 学習セッション開始
        },
        backgroundColor: Colors.teal[600],
        icon: Icon(Icons.play_arrow),
        label: Text('学習開始'),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _cardController.dispose();
    super.dispose();
  }
} 