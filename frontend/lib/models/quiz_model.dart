class Quiz {
  final String id;
  final String title;
  final String description;
  final List<QuizQuestion> questions;
  final int year;
  final DateTime createdAt;
  final DateTime updatedAt;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.year,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      questions: json['questions'] != null
          ? (json['questions'] as List)
              .map((q) => QuizQuestion.fromJson(q))
              .toList()
          : [],
      year: json['year'] ?? DateTime.now().year,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions.map((q) => q.toJson()).toList(),
      'year': year,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class QuizQuestion {
  final String id;
  final String quizId;
  final String question;
  final String questionType;
  final List<String>? options;
  final String? category;
  final int order;

  QuizQuestion({
    required this.id,
    required this.quizId,
    required this.question,
    required this.questionType,
    this.options,
    this.category,
    required this.order,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] ?? '',
      quizId: json['quizId'] ?? '',
      question: json['question'] ?? '',
      questionType: json['questionType'] ?? 'single_choice',
      options:
          json['options'] != null ? List<String>.from(json['options']) : null,
      category: json['category'],
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'question': question,
      'questionType': questionType,
      'options': options,
      'category': category,
      'order': order,
    };
  }
}

class QuizResponse {
  final String id;
  final String quizId;
  final String studentId;
  final Map<String, dynamic> answers;
  final double score;
  final DateTime completedAt;

  QuizResponse({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.answers,
    required this.score,
    required this.completedAt,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      id: json['id'] ?? '',
      quizId: json['quizId'] ?? '',
      studentId: json['studentId'] ?? '',
      answers: json['answers'] ?? {},
      score: json['score']?.toDouble() ?? 0.0,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'studentId': studentId,
      'answers': answers,
      'score': score,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}

class QuizResult {
  final String id;
  final String studentId;
  final String quizId;
  final double totalScore;
  final Map<String, double> categoryScores;
  final List<String> recommendedCareers;
  final DateTime completedAt;
  final DateTime generatedAt;

  QuizResult({
    required this.id,
    required this.studentId,
    required this.quizId,
    required this.totalScore,
    required this.categoryScores,
    required this.recommendedCareers,
    required this.completedAt,
    required this.generatedAt,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      quizId: json['quizId'] ?? '',
      totalScore: json['totalScore']?.toDouble() ?? 0.0,
      categoryScores: json['categoryScores'] != null
          ? Map<String, double>.from(
              json['categoryScores'].map((k, v) => MapEntry(k, v.toDouble())))
          : {},
      recommendedCareers: json['recommendedCareers'] != null
          ? List<String>.from(json['recommendedCareers'])
          : [],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : DateTime.now(),
      generatedAt: json['generatedAt'] != null
          ? DateTime.parse(json['generatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'quizId': quizId,
      'totalScore': totalScore,
      'categoryScores': categoryScores,
      'recommendedCareers': recommendedCareers,
      'completedAt': completedAt.toIso8601String(),
      'generatedAt': generatedAt.toIso8601String(),
    };
  }
}
