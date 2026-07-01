import 'package:dio/dio.dart';
import '../app_constants.dart';
import '../models/career_model.dart';
import '../models/academic_model.dart';

class ParentService {
  final Dio _dio;

  ParentService({Dio? dio}) : _dio = dio ?? Dio() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout =
        Duration(milliseconds: AppConstants.connectionTimeout);
    _dio.options.receiveTimeout =
        Duration(milliseconds: AppConstants.receiveTimeout);
  }

  // Get parent dashboard
  Future<Map<String, dynamic>> getParentDashboard(String parentId) async {
    try {
      final response =
          await _dio.get('${ApiEndpoints.base}/parents/$parentId/dashboard');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get child career recommendations
  Future<List<CareerRecommendation>> getChildRecommendations(
    String parentId,
  ) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.base}/parents/$parentId/child/recommendations',
      );
      return (response.data['recommendations'] as List)
          .map((item) => CareerRecommendation.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get child academic data
  Future<List<AcademicResult>> getChildAcademic(String parentId) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.base}/parents/$parentId/child/academic',
      );
      return (response.data['academicResults'] as List)
          .map((item) => AcademicResult.fromJson(item))
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
