import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'comic_list_screen.dart';
import 'manga_details_screen.dart';
import '../models/comic_model.dart';
import '../services/comic_service.dart';

class QuizHomeScreen extends StatefulWidget {
  const QuizHomeScreen({super.key});

  @override
  State<QuizHomeScreen> createState() => _QuizHomeScreenState();
}

class _QuizHomeScreenState extends State<QuizHomeScreen> {
  int _currentCarouselIndex = 0;
  List<Comic> _comics = [];
  bool _isLoadingComics = true;
  final List<Map<String, dynamic>> _carouselItems = [
    {
      'title': '漫画を読んで楽しく語学学習！ストーリーに沿ったクイズで理解度チェック',
      'icon': Icons.auto_stories,
      'color': Colors.blue,
    },
    {
      'title': '吹き出しの翻訳をタップで切り替え。日本語・英語・中国語対応',
      'icon': Icons.translate,
      'color': Colors.green,
    },
    {
      'title': '各話の最後に理解度クイズ！セリフや文法を楽しく復習',
      'icon': Icons.quiz,
      'color': Colors.orange,
    },
  ];

  List<Map<String, dynamic>> _mainFeatures = [];

  @override
  void initState() {
    super.initState();
    _initializeMainFeatures();
    _loadComics();
  }

  Future<void> _loadComics() async {
    try {
      final comics = await ComicService.getComics();
      setState(() {
        _comics = comics;
        _isLoadingComics = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingComics = false;
      });
    }
  }

  void _initializeMainFeatures() {
    _mainFeatures = [
      {
        'title': '漫画を読む',
        'description': '多言語対応の漫画を読んで語学学習',
        'icon': Icons.auto_stories,
        'color': Colors.blue[700]!,
        'buttonText': '漫画を読む',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ComicListScreen()),
          );
        },
      },
      {
        'title': '理解度クイズ',
        'description': '漫画の内容に基づいた理解度チェック',
        'icon': Icons.quiz,
        'color': Colors.blue[600]!,
        'buttonText': 'クイズを解く',
        'onTap': () {
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
      },
      {
        'title': '翻訳切り替え',
        'description': '日本語・英語・中国語で吹き出しを切り替え',
        'icon': Icons.translate,
        'color': Colors.blue[500]!,
        'buttonText': '言語を選択',
        'onTap': () {},
      },
      {
        'title': '学習進捗',
        'description': '読んだ話数とクイズ正答率を管理',
        'icon': Icons.assessment,
        'color': Colors.blue[400]!,
        'buttonText': '進捗を見る',
        'onTap': () {},
      },
      {
        'title': '単語帳作成',
        'description': '漫画から学んだ単語をオリジナル単語帳に',
        'icon': Icons.book,
        'color': Colors.blue[300]!,
        'buttonText': '単語帳を作る',
        'onTap': () {},
      },
      {
        'title': 'AI翻訳支援',
        'description': '分からない表現をAIが翻訳サポート',
        'icon': Icons.psychology,
        'color': Colors.blue[200]!,
        'buttonText': 'AIに聞く',
        'onTap': () {},
      },
    ];
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
                    comicId: 'manga001',
                    episodeId: 'episode_1',
                    comicTitle: '冒険の始まり',
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
    final crossAxisCount = MediaQuery.of(context).size.width > 1200 ? 3 : MediaQuery.of(context).size.width > 800 ? 2 : 1;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: isWide ? null : Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text('漫画語学学習アプリ', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(icon: Icon(Icons.search, color: Colors.white), onPressed: () {}),
          IconButton(icon: Icon(Icons.person, color: Colors.white), onPressed: () {}),
          IconButton(icon: Icon(Icons.settings, color: Colors.white), onPressed: () {}),
        ],
      ),
      drawer: isWide ? null : _buildDrawer(),
      body: Row(
        children: [
          if (isWide) SizedBox(width: 240, child: _buildDrawer()),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // カルーセルセクション
                  Container(
                    height: 120,
                    child: Stack(
                      children: [
                        PageView.builder(
                          onPageChanged: (index) {
                            setState(() {
                              _currentCarouselIndex = index;
                            });
                          },
                          itemCount: _carouselItems.length,
                          itemBuilder: (context, index) {
                            final item = _carouselItems[index];
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: item['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: item['color'].withOpacity(0.3),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Icon(
                                      item['icon'],
                                      color: item['color'],
                                      size: 32,
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        item['title'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),

                  // メイン機能グリッド
                  Text(
                    'MAIN FEATURES',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 24),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _mainFeatures.length,
                    itemBuilder: (context, index) {
                      final feature = _mainFeatures[index];
                      return _buildFeatureCard(feature);
                    },
                  ),

                  SizedBox(height: 40),

                  // 漫画一覧セクション
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
                            MaterialPageRoute(
                              builder: (context) => ComicListScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'すべて見る',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // 漫画カード一覧
                  _isLoadingComics
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          height: 280,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _comics.length,
                            itemBuilder: (context, index) {
                              final comic = _comics[index];
                              return _buildComicCard(comic);
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // アイコン
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: feature['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(feature['icon'], color: feature['color'], size: 24),
            ),
            SizedBox(height: 16),

            // タイトル
            Text(
              feature['title'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),

            // 説明
            Expanded(
              child: Text(
                feature['description'],
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 16),

            // ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: feature['onTap'],
                style: ElevatedButton.styleFrom(
                  backgroundColor: feature['color'],
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 36),
                ),
                child: Text(
                  feature['buttonText'],
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComicCard(Comic comic) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 16),
      child: Card(
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
                height: 160,
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
                      comic.getTitle('ja'),
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
                      comic.getDescription('ja'),
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
      ),
    );
  }
}
