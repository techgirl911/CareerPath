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
            print('Request with token: Bearer $_token');
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

  // Load token from storage on app start
  Future<void> initializeToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(AppConstants.tokenKey);
    print('Token initialized: $_token');
  }

  // Signup
  Future<User> signup({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    try {
      print('Signing up with email: $email, role: $role');

      final response = await _dio.post(
        ApiEndpoints.signup,
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
          'role': role,
        },
      );

      print('Signup response: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        _token = response.data['token'];
        print('Token received from signup: $_token');

        // Save token to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, _token!);
        print('Token saved to SharedPreferences');

        final userData = response.data['user'] as Map<String, dynamic>;
        final userRole = userData['role'] as String;

        switch (userRole) {
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
      print('Signup error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // Login
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      print('Logging in with email: $email');

      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      print('Login response status: ${response.statusCode}');
      print('Login response data: ${response.data}');

      if (response.statusCode == 200) {
        _token = response.data['token'];
        print('Token received: $_token');

        // Save token to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, _token!);
        print('Token saved to SharedPreferences');

        // Verify token was saved
        final savedToken = prefs.getString(AppConstants.tokenKey);
        print('Token verified in SharedPreferences: $savedToken');

        final userData = response.data['user'] as Map<String, dynamic>;
        final userRole = userData['role'] as String;

        print('User role: $userRole');

        switch (userRole) {
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
      print('Login error status: ${e.response?.statusCode}');
      print('Login error data: ${e.response?.data}');
      print('Login error message: ${e.message}');
      throw _handleError(e);
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      print('Logging out...');
      // Call backend logout endpoint
      await _dio.post(ApiEndpoints.logout);
    } catch (e) {
      // Continue even if backend fails
      print('Backend logout failed: $e');
    } finally {
      // Always clear local data
      _token = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.tokenKey);
      print('Token cleared from memory and SharedPreferences');
    }
  }

  // Get current user
  Future<User> getCurrentUser() async {
    try {
      print('Getting current user...');
      final response = await _dio.get(ApiEndpoints.getCurrentUser);

      final userData = response.data['user'] as Map<String, dynamic>;
      final userRole = userData['role'] as String;

      switch (userRole) {
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
    print('Token loaded from storage: $_token');
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
