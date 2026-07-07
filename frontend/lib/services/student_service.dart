// ignore_for_file: unused_import

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Load token fresh from storage on each request
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(AppConstants.tokenKey);

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            print('StudentService - Token added: Bearer $token');
          } else {
            print('StudentService - No token found!');
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          print('API Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  // Get student dashboard
  Future<Map<String, dynamic>> getStudentDashboard(String studentId) async {
    try {
      print('Fetching dashboard for student: $studentId');
      final response =
          await _dio.get(ApiEndpoints.getStudentDashboard(studentId));
      print('Dashboard response received');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print('Dashboard error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // Get academic profile
  Future<StudentAcademicProfile> getAcademicProfile(String studentId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getAcademicProfile(studentId),
      );
      return StudentAcademicProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get academic results
  Future<List<AcademicResult>> getAcademicResults(String studentId) async {
    try {
      final response =
          await _dio.get(ApiEndpoints.getAcademicResults(studentId));

      final data = response.data;
      if (data is List) {
        return data.map((item) => AcademicResult.fromJson(item)).toList();
      }

      if (data is Map<String, dynamic>) {
        final results = data['results'];
        if (results is List) {
          return results.map((item) => AcademicResult.fromJson(item)).toList();
        }
      }

      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get career recommendations
  Future<List<CareerRecommendation>> getCareerRecommendations(
    String studentId,
  ) async {
    try {
      print('Fetching recommendations for student: $studentId');
      final response =
          await _dio.get(ApiEndpoints.getRecommendations(studentId));
      print('Recommendations received');
      return (response.data['recommendations'] as List)
          .map((item) => CareerRecommendation.fromJson(item))
          .toList();
    } on DioException catch (e) {
      print('Recommendations error: ${e.response?.data}');
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
