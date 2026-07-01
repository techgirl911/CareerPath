import 'package:dio/dio.dart';
import '../app_constants.dart';
import '../models/career_model.dart';

class AdminService {
  final Dio _dio;

  AdminService({Dio? dio}) : _dio = dio ?? Dio() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout =
        Duration(milliseconds: AppConstants.connectionTimeout);
    _dio.options.receiveTimeout =
        Duration(milliseconds: AppConstants.receiveTimeout);
  }

  // Get admin dashboard
  Future<Map<String, dynamic>> getAdminDashboard() async {
    try {
      final response = await _dio.get('${ApiEndpoints.base}/admin/dashboard');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get all users
  Future<List<Map<String, dynamic>>> getAllUsers({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.base}/admin/users',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return List<Map<String, dynamic>>.from(response.data['data'] ?? []);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Deactivate user
  Future<void> deactivateUser(String userId) async {
    try {
      await _dio.put('${ApiEndpoints.base}/admin/users/$userId/deactivate');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Activate user
  Future<void> activateUser(String userId) async {
    try {
      await _dio.put('${ApiEndpoints.base}/admin/users/$userId/activate');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Create career
  Future<String> createCareer({
    required String title,
    required String description,
    required String salaryRange,
    required List<String> requiredSkills,
    required List<String> subjects,
    required int demandIndex,
    required String demandTrend,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.base}/admin/careers',
        data: {
          'title': title,
          'description': description,
          'salaryRange': salaryRange,
          'requiredSkills': requiredSkills,
          'subjects': subjects,
          'demandIndex': demandIndex,
          'demandTrend': demandTrend,
        },
      );

      return response.data['careerId'] ?? '';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Delete career
  Future<void> deleteCareer(String careerId) async {
    try {
      await _dio.delete('${ApiEndpoints.base}/admin/careers/$careerId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Create quiz
  Future<String> createQuiz({
    required String title,
    required String description,
    required int year,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.base}/admin/quizzes',
        data: {
          'title': title,
          'description': description,
          'year': year,
        },
      );

      return response.data['quizId'] ?? '';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Delete quiz
  Future<void> deleteQuiz(String quizId) async {
    try {
      await _dio.delete('${ApiEndpoints.base}/admin/quizzes/$quizId');
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
