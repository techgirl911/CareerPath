import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Load token fresh from storage on each request
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(AppConstants.tokenKey);

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
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
      return Career.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get market demand for career
  Future<MarketDemand> getMarketDemand(String careerId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getMarketDemand(careerId),
      );

      return MarketDemand.fromJson(response.data['data'] ?? response.data);
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

      return (response.data['data'] as List)
          .map((item) => Career.fromJson(item))
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
