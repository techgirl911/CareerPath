import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_constants.dart';

class AdminService {
  final Dio _dio;

  AdminService({Dio? dio}) : _dio = dio ?? Dio() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(AppConstants.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  // Get admin dashboard stats
  Future<Map<String, dynamic>> getAdminDashboard() async {
    try {
      final response = await _dio.get('/api/admin/dashboard');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      return {'statistics': {}};
    }
  }

  // Get all users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final response = await _dio.get('/api/admin/users');
      final users = response.data as List;
      return users.map((u) => u as Map<String, dynamic>).toList();
    } catch (e) {
      return [];
    }
  }
}
