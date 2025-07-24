import 'package:flutter/material.dart';
import 'package:manga_translator_app/models/comic_model.dart';
import 'package:manga_translator_app/screens/reader_screen.dart';
import 'comic_list_screen.dart';
import 'quiz_screen.dart';

class MangaDetailsScreen extends StatefulWidget {
  final Comic comic;

  const MangaDetailsScreen({
    super.key,
    required this.comic,
  });

  @override
  State<MangaDetailsScreen> createState() => _MangaDetailsScreenState();
}

class _MangaDetailsScreenState extends State<MangaDetailsScreen> {
  String _currentLanguage = 'ja';
  int _selectedTabIndex = 0;
  List<Map<String, dynamic>> _episodes = [];

  @override
  void initState() {
    super.initState();
    _loadEpisodes();
  }

  void _loadEpisodes() {
    // サンプルエピソードデータ
    _episodes = [
      {
        'id': 'episode_1',
        'episodeId': 1,
        'title': {
          'ja': '第1話 冒険の始まり',
          'en': 'Episode 1: The Beginning of Adventure',
          'zh': '第1話 冒險的開始',
        },
        'description': {
          'ja': '主人公の冒険が始まる第1話です。',
          'en': 'Episode 1 where the hero\'s adventure begins.',
          'zh': '主角冒險開始的第1話。',
        },
        'pageCount': 3,
        'date': '2025/07/21',
        'isFree': true,
        'thumbnail': 'assets/pages/page001.png',
      },
      {
        'id': 'episode_2',
        'episodeId': 2,
        'title': {
          'ja': '第2話 新しい仲間',
          'en': 'Episode 2: New Friends',
          'zh': '第2話 新朋友',
        },
        'description': {
          'ja': '主人公が新しい仲間と出会う第2話です。',
          'en': 'Episode 2 where the hero meets new friends.',
          'zh': '主角遇到新朋友的第2話。',
        },
        'pageCount': 4,
        'date': '2025/07/07',
        'isFree': true,
        'thumbnail': 'assets/pages/page002.png',
      },
      {
        'id': 'episode_3',
        'episodeId': 3,
        'title': {
          'ja': '第3話 最初の戦い',
          'en': 'Episode 3: First Battle',
          'zh': '第3話 第一次戰鬥',
        },
        'description': {
          'ja': '主人公の最初の戦いが描かれる第3話です。',
          'en': 'Episode 3 featuring the hero\'s first battle.',
          'zh': '主角第一次戰鬥的第3話。',
        },
        'pageCount': 5,
        'date': '2025/06/23',
        'isFree': false,
        'points': 40,
        'thumbnail': 'assets/pages/page003.png',
      },
    ];
  }

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'ja' ? 'en' : 'ja';
    });
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[700],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_stories, color: Colors.white, size: 40),
                SizedBox(height: 12),
                Text(
                  '漫画語学学習アプリ',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
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
                    comicId: widget.comic.id,
                    episodeId: 'episode_1',
                    comicTitle: widget.comic.getTitle(_currentLanguage),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.translate, color: Colors.blue[500]),
            title: Text('翻訳切り替え'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.assessment, color: Colors.blue[400]),
            title: Text('学習進捗'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.book, color: Colors.blue[300]),
            title: Text('単語帳作成'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.psychology, color: Colors.blue[200]),
            title: Text('AI翻訳支援'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: isWide ? IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ) : Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          widget.comic.title[_currentLanguage] ?? widget.comic.title['ja']!,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[600],
        actions: [
          if (!isWide) IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: Icon(Icons.language, color: Colors.white),
            onPressed: _toggleLanguage,
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      drawer: isWide ? null : _buildDrawer(),
      body: Row(
        children: [
          if (isWide) SizedBox(width: 240, child: _buildDrawer()),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // プロモーション画像
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.teal, Colors.white, Colors.red],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        // 左側のカバー画像
                        Container(
                          width: 200,
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              widget.comic.coverImageUrl ?? 'assets/pages/page001.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 64,
                                    color: Colors.grey[600],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // 右側の詳細情報
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.comic.getTitle(_currentLanguage),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  widget.comic.getDescription(_currentLanguage),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2,
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Icon(Icons.language, color: Colors.white, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      '${widget.comic.languages.length}言語対応',
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                    SizedBox(width: 20),
                                    Icon(Icons.book, color: Colors.white, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      '${widget.comic.episodeCount}話',
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // タブ切り替え
                  Row(
                    children: [
                      _buildTab('エピソード', 0),
                      SizedBox(width: 16),
                      _buildTab('コミックス', 1),
                    ],
                  ),

                  SizedBox(height: 16),

                  // 操作ボタン
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_episodes.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReaderScreen(
                                    comic: widget.comic,
                                    episodeId: _episodes[0]['id'],
                                  ),
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.play_arrow, size: 20),
                          label: Text(_currentLanguage == 'ja' ? '読む' : 'Read'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.keyboard_arrow_up, size: 16),
                        label: Text(_currentLanguage == 'ja' ? '1話から' : 'From Episode 1'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.grey[800],
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // エピソード一覧
                  if (_selectedTabIndex == 0) _buildEpisodeList(),
                  if (_selectedTabIndex == 1) _buildComicList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[700] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodeList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _episodes.length,
      itemBuilder: (context, index) {
        final episode = _episodes[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  episode['thumbnail'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.image, color: Colors.grey[600]),
                    );
                  },
                ),
              ),
            ),
            title: Text(
              episode['title'][_currentLanguage] ?? episode['title']['ja'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(episode['description'][_currentLanguage] ?? episode['description']['ja']),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${episode['pageCount']}ページ',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(width: 12),
                    Text(
                      episode['date'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    if (!episode['isFree']) ...[
                      SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${episode['points']}P',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.orange[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            trailing: episode['isFree']
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _currentLanguage == 'ja' ? '無料' : 'Free',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Icon(Icons.lock, color: Colors.grey[400]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReaderScreen(
                    comic: widget.comic,
                    episodeId: episode['id'],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildComicList() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.book, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            _currentLanguage == 'ja' ? 'コミックス一覧は準備中です' : 'Comic list is coming soon',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
} 