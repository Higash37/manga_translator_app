import 'package:flutter/material.dart';
import '../models/comic_model.dart';
import '../services/comic_service.dart';
import 'manga_details_screen.dart';
import 'package:flutter/foundation.dart';
import 'home_screen.dart';
import 'quiz_screen.dart';
import 'learning_progress_screen.dart';
import 'vocabulary_builder_screen.dart';
import 'ai_translation_assistant_screen.dart';

class ComicListScreen extends StatefulWidget {
  const ComicListScreen({super.key});

  @override
  State<ComicListScreen> createState() => _ComicListScreenState();
}

class _ComicListScreenState extends State<ComicListScreen> {
  List<Comic> comics = [];
  bool isLoading = true;
  String currentLanguage = 'ja'; // デフォルトは日本語

  @override
  void initState() {
    super.initState();
    _loadComics();
  }

  Future<void> _loadComics() async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedComics = await ComicService.getComics();
      setState(() {
        comics = loadedComics;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('漫画の読み込みに失敗しました: $e')),
        );
      }
    }
  }

  void _toggleLanguage() {
    setState(() {
      if (currentLanguage == 'ja') {
        currentLanguage = 'en';
      } else if (currentLanguage == 'en') {
        currentLanguage = 'zh';
      } else {
        currentLanguage = 'ja';
      }
    });
  }

  Widget _buildJumplaComicCard(Comic comic) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaDetailsScreen(comic: comic),
          ),
        );
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.blue[100]!, width: 1),
        ),
        child: Row(
          children: [
            // カバー画像
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
              child: Image.asset(
                comic.coverImageUrl ?? 'assets/pages/page001.png',
                width: 100,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 120,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            comic.getTitle(currentLanguage),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            currentLanguage == 'ja' ? '無料' : currentLanguage == 'en' ? 'Free' : '免費',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comic.getDescription(currentLanguage),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.language, size: 16, color: Colors.blue[400]),
                        const SizedBox(width: 4),
                        Text(
                          '${comic.languages.length}言語',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.book, size: 16, color: Colors.blue[400]),
                        const SizedBox(width: 4),
                        Text(
                          '${comic.episodeCount}話',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                          ),
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
    );
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
            selected: true,
            selectedTileColor: Colors.blue[50],
            onTap: () => Navigator.pop(context),
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
      appBar: AppBar(
        leading: isWide ? null : Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          currentLanguage == 'ja' ? '漫画一覧' : 
          currentLanguage == 'en' ? 'Comic List' : '漫畫列表',
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              currentLanguage == 'ja' ? Icons.language : 
              currentLanguage == 'en' ? Icons.translate : Icons.abc,
            ),
            onPressed: _toggleLanguage,
            tooltip: '言語切り替え',
          ),
        ],
      ),
      drawer: isWide ? null : _buildDrawer(),
      body: Row(
        children: [
          if (isWide) SizedBox(
            width: 240,
            child: _buildDrawer(),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadComics,
                    child: comics.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.book_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentLanguage == 'ja' ? '漫画が見つかりません' :
                                  currentLanguage == 'en' ? 'No comics found' : '找不到漫畫',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: comics.length,
                            itemBuilder: (context, index) {
                              final comic = comics[index];
                              return _buildJumplaComicCard(comic);
                            },
                          ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleLanguage,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        child: Text(
          currentLanguage.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
} 