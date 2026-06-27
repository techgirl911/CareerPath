import 'package:dio/dio.dart';
import '../app_constants.dart';
import '../models/quiz_model.dart';

class QuizService {
  final Dio _dio;

  QuizService({Dio? dio}) : _dio = dio ?? Dio() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout =
        Duration(milliseconds: AppConstants.connectionTimeout);
    _dio.options.receiveTimeout =
        Duration(milliseconds: AppConstants.receiveTimeout);
  }

  // Get all quizzes
  Future<List<Quiz>> getAllQuizzes({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getAllQuizzes,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return (response.data['data'] as List)
          .map((item) => Quiz.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get quiz by ID
  Future<Quiz> getQuizById(String quizId) async {
    try {
      final response = await _dio.get(ApiEndpoints.getQuizById(quizId));
      return Quiz.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get quiz questions
  Future<List<QuizQuestion>> getQuizQuestions(String quizId) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.base}/quizzes/$quizId/questions',
      );

      return (response.data as List)
          .map((item) => QuizQuestion.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Submit quiz responses
  Future<QuizResult> submitQuizResponse({
    required String studentId,
    required String quizId,
    required Map<String, dynamic> answers,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.submitQuiz(studentId),
        data: {
          'quizId': quizId,
          'answers': answers,
        },
      );

      return QuizResult.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get quiz result
  Future<QuizResult> getQuizResult(String resultId) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.base}/quiz-results/$resultId',
      );

      return QuizResult.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Create quiz (admin only)
  Future<Quiz> createQuiz({
    required String title,
    required String description,
    required List<QuizQuestion> questions,
    required int year,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getAllQuizzes,
        data: {
          'title': title,
          'description': description,
          'questions': questions.map((q) => q.toJson()).toList(),
          'year': year,
        },
      );

      return Quiz.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Update quiz (admin only)
  Future<Quiz> updateQuiz(String quizId, Quiz quiz) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.getQuizById(quizId),
        data: quiz.toJson(),
      );

      return Quiz.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Delete quiz (admin only)
  Future<void> deleteQuiz(String quizId) async {
    try {
      await _dio.delete(ApiEndpoints.getQuizById(quizId));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ?? 'An error occurred';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Receive timeout';
    } else {
      return e.message ?? 'An error occurred';
    }
  }
}
