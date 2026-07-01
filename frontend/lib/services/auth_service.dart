import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_constants.dart';
import '../models/user_model.dart';

class AuthService {
  final Dio _dio;
  String? _token;

  AuthService({Dio? dio}) : _dio = dio ?? Dio() {
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
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
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

  // Signup
  Future<User> signup({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.signup,
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
          'role': role,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _token = response.data['token'];

        // Save token to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, _token!);

        final userData = response.data['user'] as Map<String, dynamic>;
        final role = userData['role'] as String;

        switch (role) {
          case 'student':
            return Student.fromJson(userData);
          case 'parent':
            return Parent.fromJson(userData);
          case 'admin':
            return Admin.fromJson(userData);
          default:
            return User.fromJson(userData);
        }
      }
      throw Exception('Signup failed');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Login
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        _token = response.data['token'];

        // Save token to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, _token!);

        final userData = response.data['user'] as Map<String, dynamic>;
        final role = userData['role'] as String;

        switch (role) {
          case 'student':
            return Student.fromJson(userData);
          case 'parent':
            return Parent.fromJson(userData);
          case 'admin':
            return Admin.fromJson(userData);
          default:
            return User.fromJson(userData);
        }
      }
      throw Exception('Login failed');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } catch (e) {
      print('Backend logout failed: $e');
    } finally {
      _token = null;
      // Clear token from storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.tokenKey);
    }
  }

  // Get current user
  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get(ApiEndpoints.getCurrentUser);

      final userData = response.data['user'] as Map<String, dynamic>;
      final role = userData['role'] as String;

      switch (role) {
        case 'student':
          return Student.fromJson(userData);
        case 'parent':
          return Parent.fromJson(userData);
        case 'admin':
          return Admin.fromJson(userData);
        default:
          return User.fromJson(userData);
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Load token from storage
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(AppConstants.tokenKey);
  }

  // Getters
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  // Setters
  void setToken(String token) => _token = token;

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
