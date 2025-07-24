class Quiz {
  final String id;
  final String comicId;
  final String episodeId;
  final String question;
  final List<String> choices;
  final int correctIndex;
  final String explanation;
  final String type; // 'grammar', 'vocabulary', 'translation'
  final Map<String, String> context; // セリフの文脈情報

  Quiz({
    required this.id,
    required this.comicId,
    required this.episodeId,
    required this.question,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
    required this.type,
    required this.context,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? '',
      comicId: json['comicId'] ?? '',
      episodeId: json['episodeId'] ?? '',
      question: json['question'] ?? '',
      choices: List<String>.from(json['choices'] ?? []),
      correctIndex: json['correctIndex'] ?? 0,
      explanation: json['explanation'] ?? '',
      type: json['type'] ?? 'grammar',
      context: Map<String, String>.from(json['context'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comicId': comicId,
      'episodeId': episodeId,
      'question': question,
      'choices': choices,
      'correctIndex': correctIndex,
      'explanation': explanation,
      'type': type,
      'context': context,
    };
  }
}

class QuizResult {
  final String quizId;
  final int selectedIndex;
  final bool isCorrect;
  final DateTime answeredAt;
  final int timeSpent; // 秒数

  QuizResult({
    required this.quizId,
    required this.selectedIndex,
    required this.isCorrect,
    required this.answeredAt,
    required this.timeSpent,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      quizId: json['quizId'] ?? '',
      selectedIndex: json['selectedIndex'] ?? 0,
      isCorrect: json['isCorrect'] ?? false,
      answeredAt: DateTime.parse(json['answeredAt']),
      timeSpent: json['timeSpent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'selectedIndex': selectedIndex,
      'isCorrect': isCorrect,
      'answeredAt': answeredAt.toIso8601String(),
      'timeSpent': timeSpent,
    };
  }
} 