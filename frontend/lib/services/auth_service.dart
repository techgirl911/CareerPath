import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'package:jwt_decoder/jwt_decoder.dart';
import '../app_constants.dart';
import '../models/user_model.dart';

class AuthService {
  late Dio _dio;

  AuthService() {
    _dio = Dio();
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
          print('API Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onError: (error, handler) {
          print('API Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> initializeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.tokenKey);
      print('Token initialized: $token');
    } catch (e) {
      print('Error initializing token: $e');
    }
  }

  Future<User> signup({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? adminCode,
  }) async {
    try {
      print('========== SIGNUP REQUEST ==========');
      print('Name: $fullName');
      print('Email: $email');
      print('Role: $role');
      print('Admin Code: ${adminCode ?? "N/A"}');

      final data = {
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': role,
      };

      // Add admin code if role is admin
      if (role == 'admin' && adminCode != null) {
        data['adminCode'] = adminCode;
      }

      final response = await _dio.post(
        ApiEndpoints.signup,
        data: data,
      );

      print('========== SIGNUP RESPONSE ==========');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final user = User.fromJson(response.data['user'] ?? response.data);
        print('User created: ${user.fullName}');
        return user;
      } else {
        throw Exception(
            'Signup failed: ${response.data['message'] ?? 'Unknown error'}');
      }
    } on DioException catch (e) {
      print('DIO Error: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      print('Error: $e');
      throw Exception('Signup error: $e');
    }
  }

  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      print('========== LOGIN REQUEST ==========');
      print('Email: $email');

      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      print('========== LOGIN RESPONSE ==========');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final userData = response.data['user'];

        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, token);
        print('Token saved to SharedPreferences');

        final user = User.fromJson(userData);
        print('Login successful: ${user.fullName}');
        return user;
      } else {
        throw Exception(
            'Login failed: ${response.data['message'] ?? 'Unknown error'}');
      }
    } on DioException catch (e) {
      print('DIO Error: ${e.response?.data}');
      final errorMsg = e.response?.data['message'] ?? e.message;
      throw Exception(errorMsg);
    } catch (e) {
      print('Error: $e');
      throw Exception('Login error: $e');
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.tokenKey);

      if (token == null) {
        throw Exception('No token found');
      }

      final response = await _dio.get(
        ApiEndpoints.getCurrentUser,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final user = User.fromJson(response.data);
      return user;
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.tokenKey);
      print('User logged out');
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }

  Future<String?> loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.tokenKey);
      print('Token loaded: $token');
      return token;
    } catch (e) {
      print('Error loading token: $e');
      return null;
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ?? 'Error: ${e.response?.statusCode}';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Receive timeout';
    } else {
      return e.message ?? 'An error occurred';
    }
  }
}
