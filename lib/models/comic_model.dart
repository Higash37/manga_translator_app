class Comic {
  final String id;
  final Map<String, String> title;
  final Map<String, String> description;
  final String coverImage;
  final int episodeCount;
  final List<String> languages;

  Comic({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.episodeCount,
    required this.languages,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      id: json['id'] ?? '',
      title: Map<String, String>.from(json['title'] ?? {}),
      description: Map<String, String>.from(json['description'] ?? {}),
      coverImage: json['coverImage'] ?? 'assets/pages/page001.png',
      episodeCount: json['episodeCount'] ?? 0,
      languages: List<String>.from(json['languages'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'coverImage': coverImage,
      'episodeCount': episodeCount,
      'languages': languages,
    };
  }

  // 言語に応じたタイトルを取得
  String getTitle(String language) {
    return title[language] ?? title['ja'] ?? '';
  }

  // 言語に応じた説明を取得
  String getDescription(String language) {
    return description[language] ?? description['ja'] ?? '';
  }

  // カバー画像URLを取得
  String? get coverImageUrl => coverImage;

  // エピソードリスト（ダミーデータ）
  List<Map<String, dynamic>> get episodes {
    return List.generate(episodeCount, (index) => {
      'id': 'episode_${index + 1}',
      'title': {
        'ja': '第${index + 1}話',
        'en': 'Episode ${index + 1}',
        'zh': '第${index + 1}話',
      },
    });
  }
} 