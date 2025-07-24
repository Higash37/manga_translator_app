import 'package:flutter/material.dart';
import 'package:manga_translator_app/models/comic_model.dart';
import 'package:manga_translator_app/screens/quiz_screen.dart';
import 'comic_list_screen.dart';
import '../models/page_model.dart';
import '../models/bubble_model.dart';
import '../services/comic_service.dart';
import '../services/bubble_service.dart';
import 'dart:async';

class ReaderScreen extends StatefulWidget {
  final Comic comic;
  final String episodeId;

  const ReaderScreen({super.key, required this.comic, required this.episodeId});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  int _currentPageIndex = 0;
  String _currentLanguage = 'ja';
  bool _showControls = true;
  List<MangaPage> _pages = [];
  bool _showNavigationHint = false;
  String? _highlightedBubbleId;

  @override
  void initState() {
    super.initState();
    _loadPages();
  }

  void _loadPages() async {
    // Firestoreから取得
    final pages = await ComicService.getPages(
      widget.comic.id,
      widget.episodeId,
    );
    setState(() {
      _pages = pages;
    });
  }

  Future<void> _reloadCurrentPage() async {
    final pages = await ComicService.getPages(
      widget.comic.id,
      widget.episodeId,
    );
    setState(() {
      _pages = pages;
    });
  }

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'ja' ? 'en' : 'ja';
    });
  }

  void _nextPage() {
    if (_currentPageIndex < _pages.length - 1) {
      setState(() {
        _currentPageIndex++;
      });
    } else {
      // 最後のページの場合、クイズを表示
      _showQuiz();
    }
  }

  void _previousPage() {
    if (_currentPageIndex > 0) {
      setState(() {
        _currentPageIndex--;
      });
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
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
                    episodeId: widget.episodeId,
                    comicTitle: widget.comic.getTitle(_currentLanguage),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.translate, color: Colors.blue[500]),
            title: Text('翻訳切り替え'),
            onTap: () {
              _toggleLanguage();
              Navigator.pop(context);
            },
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

  void _showQuiz() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('エピソード完了'),
          content: Text('このエピソードを読み終えました。クイズに挑戦しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('戻る'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      comicId: widget.comic.id,
                      episodeId: widget.episodeId,
                      comicTitle: widget.comic.title[_currentLanguage] ?? widget.comic.title['ja']!,
                    ),
                  ),
                );
              },
              child: Text('クイズに挑戦'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // メインコンテンツ
          Column(
            children: [
              // ヘッダー
              if (_showControls)
                Container(
                  height: 60,
                  color: Colors.black.withOpacity(0.8),
                  child: Row(
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.menu, color: Colors.white),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          '${widget.comic.title[_currentLanguage] ?? widget.comic.title['ja']!} - 第1話',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.language, color: Colors.white),
                        onPressed: _toggleLanguage,
                      ),
                      IconButton(
                        icon: Icon(Icons.fullscreen, color: Colors.white),
                        onPressed: _toggleControls,
                      ),
                    ],
                  ),
                ),

              // ページ表示エリア
              Expanded(
                child: Row(
                  children: [
                    // 左ナビゲーション（PC表示時のみ）
                    if (_showControls && isWide)
                      Container(
                        width: 60,
                        color: Colors.grey[900],
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: _currentPageIndex > 0
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            onPressed: _currentPageIndex > 0
                                ? _previousPage
                                : null,
                          ),
                        ),
                      ),

                    // メインページ
                    Expanded(
                      child: GestureDetector(
                        onTapDown: (details) {
                          // 画面の幅を取得
                          final RenderBox renderBox =
                              context.findRenderObject() as RenderBox;
                          final screenWidth = renderBox.size.width;
                          final tapX = details.localPosition.dx;

                          // 左側3分の1をタップ：前のページ
                          if (tapX < screenWidth / 3) {
                            _previousPage();
                          }
                          // 右側3分の1をタップ：次のページ
                          else if (tapX > screenWidth * 2 / 3) {
                            _nextPage();
                          }
                          // 中央をタップ：コントロール表示切り替え
                          else {
                            _toggleControls();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.black,
                          child: _pages.isNotEmpty
                              ? Stack(
                                  children: [
                                    // 背景画像
                                    Positioned.fill(
                                      child: Image.asset(
                                        _pages[_currentPageIndex].imageUrl,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[800],
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.image_not_supported,
                                                    size: 64,
                                                    color: Colors.grey[400],
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text(
                                                    'ページを読み込めませんでした',
                                                    style: TextStyle(
                                                      color: Colors.grey[400],
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // 吹き出しオーバーレイ
                                    ..._pages[_currentPageIndex].bubbles.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final bubble = entry.value;
                                      final bubbleId = Bubble.generateBubbleId(
                                        widget.comic.id,
                                        widget.episodeId,
                                        _pages[_currentPageIndex].pageId.toString(),
                                        index,
                                      );
                                      return Positioned(
                                        left: bubble.position[0],
                                        top: bubble.position[1],
                                        width: bubble.size[0],
                                        height: bubble.size[1],
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _highlightedBubbleId = bubbleId;
                                            });
                                            Timer(Duration(milliseconds: 500), () {
                                              setState(() {
                                                _highlightedBubbleId = null;
                                              });
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: _highlightedBubbleId == bubbleId
                                                  ? Colors.yellow.withOpacity(0.3)
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.all(8),
                                            child: Center(
                                              child: Text(
                                                bubble.text[_currentLanguage] ??
                                                    bubble.text['ja'] ??
                                                    '',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 2,
                                                      color: Colors.black,
                                                    ),
                                                  ],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    // 右ナビゲーション（PC表示時のみ）
                    if (_showControls && isWide)
                      Container(
                        width: 60,
                        color: Colors.grey[900],
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: _currentPageIndex < _pages.length - 1
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            onPressed: _currentPageIndex < _pages.length - 1
                                ? _nextPage
                                : _showQuiz,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // フッター（ページ情報）
              if (_showControls)
                Container(
                  height: 60,
                  color: Colors.black.withOpacity(0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_currentPageIndex + 1} / ${_pages.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          // ナビゲーションヒント（スマホのみ）
          if (_showNavigationHint && !isWide)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Row(
                  children: [
                    // 左側ヒント
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  size: 32,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '前のページ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 中央
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.settings,
                                  size: 32,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'コントロール',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 右側ヒント
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_forward,
                                  size: 32,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '次のページ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
}
