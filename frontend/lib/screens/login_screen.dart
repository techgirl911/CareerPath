// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_colors.dart';
import '../app_constants.dart';

class LoginScreen extends StatefulWidget {
  final String userRole;

  const LoginScreen({super.key, required this.userRole});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _error;

  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _setupDio();
  }

  void _setupDio() {
    _dio = Dio();
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _error = 'Please enter email and password');
      return;
    }

    try {
      setState(() => _isLoading = true);
      print('========== LOGIN START ==========');
      print('Email: ${_emailController.text}');
      print('Expected Role (from selection): ${widget.userRole}');

      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      print('========== LOGIN RESPONSE ==========');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final user = response.data['user'];

        print('========== LOGIN SUCCESS ==========');
        print('User Full Name: ${user['fullName']}');
        print('User Email: ${user['email']}');
        print('User Role (from backend): ${user['role']}');
        print('User ID: ${user['id']}');

        // Save token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, token);
        print('Token saved to SharedPreferences');

        print('========== NAVIGATION DECISION ==========');
        print('Selected role at login: ${widget.userRole}');
        print('role: ${user['role']}');

        // Route based on actual role from backend
        if (user['role'] == 'student') {
          print('Navigating to STUDENT dashboard');
          context.go(
            '/student-dashboard?studentId=${user['id']}&userName=${user['fullName']}&userEmail=${user['email']}',
          );
        } else if (user['role'] == 'parent') {
          print('Navigating to PARENT dashboard');
          context.go(
            '/parent-dashboard?parentId=${user['id']}&parentName=${user['fullName']}',
          );
        } else if (user['role'] == 'admin') {
          print('Navigating to ADMIN dashboard');
          context.go(
            '/admin-dashboard?adminId=${user['id']}&adminName=${user['fullName']}',
          );
        } else {
          print('Unknown role: ${user['role']}');
          setState(() => _error = 'Unknown user role');
        }
      } else {
        setState(() => _error = 'Login failed');
      }
    } on DioException catch (e) {
      print('DIO Error: ${e.message}');
      print('Response: ${e.response?.data}');
      setState(() {
        _error = e.response?.data['message'] ?? 'Login error: ${e.message}';
      });
    } catch (e) {
      print('Error: $e');
      setState(() => _error = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to continue as ${widget.userRole}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Error message
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            const SizedBox(height: 16),

            // Email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Sign In'),
              ),
            ),
            const SizedBox(height: 16),

            // Sign Up Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account? '),
                GestureDetector(
                  onTap: () => context.go('/signup?role=${widget.userRole}'),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Back to role selection
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to Role Selection'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
