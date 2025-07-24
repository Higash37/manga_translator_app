import 'package:flutter/material.dart';
import 'package:manga_translator_app/screens/manga_details_screen.dart';
import 'package:manga_translator_app/services/comic_service.dart';
import 'package:manga_translator_app/models/comic_model.dart';
import 'comic_list_screen.dart';
import 'quiz_screen.dart';
import 'learning_progress_screen.dart';
import 'vocabulary_builder_screen.dart';
import 'ai_translation_assistant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Comic> _comics = [];
  bool _isLoading = true;
  String _currentLanguage = 'ja';

  @override
  void initState() {
    super.initState();
    _loadComics();
  }

  Future<void> _loadComics() async {
    try {
      final comics = await ComicService.getComics();
      setState(() {
        _comics = comics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // フォールバック用のサンプルデータ
      _comics = [
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
            leading: Icon(Icons.home, color: Colors.blue[700]),
            title: Text('ホーム'),
            selected: true,
            selectedTileColor: Colors.blue[50],
            onTap: () => Navigator.pop(context),
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: isWide ? null : Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text('漫画翻訳アプリ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
            icon: Icon(Icons.language, color: Colors.white),
            onPressed: _toggleLanguage,
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          TextButton(
            onPressed: () {},
            child: Text('ログイン', style: TextStyle(color: Colors.white)),
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
                  // ヒーローセクション
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[600]!, Colors.blue[400]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '漫画で学ぶ語学学習',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '日本語・英語・中国語の漫画を読みながら楽しく学習しよう',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ComicListScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue[600],
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: Text('今すぐ始める', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),

                  // おすすめ漫画セクション
                  Row(
                    children: [
                      Text(
                        'おすすめ漫画',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ComicListScreen()),
                          );
                        },
                        child: Text('すべて見る'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // 漫画カード一覧
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : MediaQuery.of(context).size.width > 800 ? 3 : MediaQuery.of(context).size.width > 600 ? 2 : 1,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _comics.length,
                          itemBuilder: (context, index) {
                            final comic = _comics[index];
                            return _buildComicCard(comic);
                          },
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComicCard(Comic comic) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MangaDetailsScreen(comic: comic),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // カバー画像
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  comic.coverImageUrl ?? 'assets/pages/page001.png',
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
            // コンテンツ
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // タイトル
                  Text(
                    comic.getTitle(_currentLanguage),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  // 説明
                  Text(
                    comic.getDescription(_currentLanguage),
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  // メタ情報
                  Row(
                    children: [
                      Icon(Icons.language, size: 12, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        '${comic.languages.length}言語',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.book, size: 12, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        '${comic.episodeCount}話',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
