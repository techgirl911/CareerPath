import 'package:dio/dio.dart';
import '../app_constants.dart';
import '../models/user_model.dart';
import '../models/career_model.dart';
import '../models/quiz_model.dart';
import '../models/academic_model.dart';

class StudentService {
  final Dio _dio;

  StudentService({Dio? dio}) : _dio = dio ?? Dio() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout =
        Duration(milliseconds: AppConstants.connectionTimeout);
    _dio.options.receiveTimeout =
        Duration(milliseconds: AppConstants.receiveTimeout);
  }

  // Get student dashboard
  Future<Map<String, dynamic>> getStudentDashboard(String studentId) async {
    try {
      final response =
          await _dio.get(ApiEndpoints.getStudentDashboard(studentId));
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get academic profile
  Future<StudentAcademicProfile> getAcademicProfile(String studentId) async {
    try {
      final response = await _dio
          .get('${ApiEndpoints.base}/students/$studentId/academic-profile');
      return StudentAcademicProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get academic results
  Future<List<AcademicResult>> getAcademicResults(String studentId) async {
    try {
      final response = await _dio
          .get('${ApiEndpoints.base}/students/$studentId/academic-results');
      return (response.data as List)
          .map((item) => AcademicResult.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get career recommendations
  Future<List<CareerRecommendation>> getCareerRecommendations(
    String studentId,
  ) async {
    try {
      final response =
          await _dio.get(ApiEndpoints.getRecommendations(studentId));
      return (response.data as List)
          .map((item) => CareerRecommendation.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get quiz results
  Future<List<QuizResult>> getQuizResults(String studentId) async {
    try {
      final response = await _dio
          .get('${ApiEndpoints.base}/students/$studentId/quiz-results');
      return (response.data as List)
          .map((item) => QuizResult.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Submit quiz
  Future<QuizResult> submitQuiz({
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

  // Upload document
  Future<DocumentUpload> uploadDocument({
    required String studentId,
    required String documentType,
    required String filePath,
    required String fileName,
  }) async {
    try {
      final formData = FormData.fromMap({
        'studentId': studentId,
        'documentType': documentType,
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '${ApiEndpoints.base}/students/upload-document',
        data: formData,
      );

      return DocumentUpload.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Update profile
  Future<void> updateProfile({
    required String studentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _dio.put(
        '${ApiEndpoints.base}/students/$studentId/profile',
        data: data,
      );
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
