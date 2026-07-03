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
      title: json['title'] ?? 'Quiz',
      description: json['description'] ?? '',
      questions: (json['questions'] as List?)
              ?.map((q) => QuizQuestion.fromJson(q))
              .toList() ??
          [],
      year: json['year'] ?? DateTime.now().year,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'questions': questions.map((q) => q.toJson()).toList(),
        'year': year,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class QuizQuestion {
  final String id;
  final String quizId;
  final String question;
  final String questionType;
  final List<String> options;
  final int order;
  final String? correctAnswer;

  QuizQuestion({
    required this.id,
    required this.quizId,
    required this.question,
    required this.questionType,
    required this.options,
    required this.order,
    this.correctAnswer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] ?? '',
      quizId: json['quizId'] ?? '',
      question: json['question'] ?? '',
      questionType: json['questionType'] ?? 'single_choice',
      options: List<String>.from(json['options'] ?? []),
      order: json['order'] ?? json['questionOrder'] ?? 1,
      correctAnswer: json['correctAnswer'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'quizId': quizId,
        'question': question,
        'questionType': questionType,
        'options': options,
        'order': order,
        'correctAnswer': correctAnswer,
      };
}

class QuizResponse {
  final String id;
  final String studentId;
  final String quizId;
  final Map<String, String> answers;
  final DateTime submittedAt;

  QuizResponse({
    required this.id,
    required this.studentId,
    required this.quizId,
    required this.answers,
    required this.submittedAt,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      quizId: json['quizId'] ?? '',
      answers: Map<String, String>.from(json['answers'] ?? {}),
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'quizId': quizId,
        'answers': answers,
        'submittedAt': submittedAt.toIso8601String(),
      };
}

class QuizResult {
  final String id;
  final String studentId;
  final String quizId;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;

  QuizResult({
    required this.id,
    required this.studentId,
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      quizId: json['quizId'] ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'quizId': quizId,
        'score': score,
        'totalQuestions': totalQuestions,
        'completedAt': completedAt.toIso8601String(),
      };
}
