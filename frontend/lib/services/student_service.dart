import 'package:dio/dio.dart';
import '../app_constants.dart';
import '../models/user_model.dart';
import '../models/career_model.dart';
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
      final response = await _dio.get(
        '${ApiEndpoints.base}/students/$studentId/academic-profile',
      );
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
      return (response.data['recommendations'] as List)
          .map((item) => CareerRecommendation.fromJson(item))
          .toList();
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
