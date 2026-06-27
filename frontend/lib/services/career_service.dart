import 'package:dio/dio.dart';
import '../app_constants.dart';
import '../models/career_model.dart';

class CareerService {
  final Dio _dio;

  CareerService({Dio? dio}) : _dio = dio ?? Dio() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout =
        Duration(milliseconds: AppConstants.connectionTimeout);
    _dio.options.receiveTimeout =
        Duration(milliseconds: AppConstants.receiveTimeout);
  }

  // Get all careers
  Future<List<Career>> getAllCareers({
    int page = 1,
    int limit = 20,
    String? searchQuery,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getAllCareers,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (searchQuery != null) 'search': searchQuery,
        },
      );

      return (response.data['data'] as List)
          .map((item) => Career.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get career by ID
  Future<Career> getCareerById(String careerId) async {
    try {
      final response = await _dio.get(ApiEndpoints.getCareerById(careerId));
      return Career.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get careers by subject
  Future<List<Career>> getCareersBySubject(String subject) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.base}/careers/subject/$subject',
      );

      return (response.data as List)
          .map((item) => Career.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get market demand for career
  Future<MarketDemand> getMarketDemand(String careerId) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.base}/careers/$careerId/market-demand',
      );

      return MarketDemand.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get trending careers
  Future<List<Career>> getTrendingCareers({int limit = 10}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getTrendingCareers,
        queryParameters: {'limit': limit},
      );

      return (response.data as List)
          .map((item) => Career.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Search careers
  Future<List<Career>> searchCareers(String query) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.base}/careers/search',
        queryParameters: {'q': query},
      );

      return (response.data as List)
          .map((item) => Career.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get market demand index
  Future<List<MarketDemand>> getMarketDemandIndex() async {
    try {
      final response = await _dio.get('${ApiEndpoints.base}/market-demand');
      return (response.data as List)
          .map((item) => MarketDemand.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Create career (admin only)
  Future<Career> createCareer(Career career) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getAllCareers,
        data: career.toJson(),
      );

      return Career.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Update career (admin only)
  Future<Career> updateCareer(String careerId, Career career) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.getCareerById(careerId),
        data: career.toJson(),
      );

      return Career.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Delete career (admin only)
  Future<void> deleteCareer(String careerId) async {
    try {
      await _dio.delete(ApiEndpoints.getCareerById(careerId));
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
