// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../app_colors.dart';
import '../app_constants.dart';

class SignupScreen extends StatefulWidget {
  final String userRole;

  const SignupScreen({super.key, required this.userRole});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _adminCodeController = TextEditingController();
  final _parentEmailController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _wantParent = false;
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

  Future<void> _signup() async {
    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _error = 'Please fill all fields');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }

    if (widget.userRole == 'admin' && _adminCodeController.text.isEmpty) {
      setState(() => _error = 'Admin code is required');
      return;
    }

    if (widget.userRole == 'student' &&
        _wantParent &&
        _parentEmailController.text.isEmpty) {
      setState(() => _error = 'Please enter parent email');
      return;
    }

    try {
      setState(() => _isLoading = true);
      print('========== SIGNUP REQUEST ==========');
      print('Full Name: ${_fullNameController.text}');
      print('Email: ${_emailController.text}');
      print('Role: ${widget.userRole}');

      final signupData = {
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'role': widget.userRole,
      };

      if (widget.userRole == 'admin') {
        signupData['adminCode'] = _adminCodeController.text;
      }

      final response = await _dio.post(
        ApiEndpoints.signup,
        data: signupData,
      );

      print('========== SIGNUP RESPONSE ==========');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final userId = response.data['user']['id'];

        // If student wants parent, send request
        if (widget.userRole == 'student' &&
            _wantParent &&
            _parentEmailController.text.isNotEmpty) {
          try {
            print('========== SENDING PARENT REQUEST ==========');
            await _dio.post(
              '${AppConstants.baseUrl}/api/students/request-parent',
              data: {
                'studentId': userId,
                'parentEmail': _parentEmailController.text.trim(),
              },
            );
            print('Parent request sent successfully');
          } catch (e) {
            print('Error sending parent request: $e');
            // Don't fail signup if parent request fails
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful!')),
        );

        context.go('/login?role=${widget.userRole}');
      }
    } on DioException catch (e) {
      print('DIO Error: ${e.message}');
      print('Response: ${e.response?.data}');
      setState(() {
        _error = e.response?.data['message'] ?? 'Signup failed: ${e.message}';
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
        title: const Text('Sign Up'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Account',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign up as ${widget.userRole}',
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

            // Full Name
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
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
            const SizedBox(height: 16),

            // Confirm Password
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Admin Code (only for admin)
            if (widget.userRole == 'admin')
              Column(
                children: [
                  TextField(
                    controller: _adminCodeController,
                    decoration: InputDecoration(
                      labelText: 'Admin Code',
                      prefixIcon: const Icon(Icons.security),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Parent Email (only for student, optional)
            if (widget.userRole == 'student')
              Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _wantParent,
                            onChanged: (value) {
                              setState(() => _wantParent = value ?? false);
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Add a parent to monitor my progress (optional)',
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_wantParent)
                    Column(
                      children: [
                        TextField(
                          controller: _parentEmailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Parent\'s Email',
                            hintText: 'parent@example.com',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                ],
              ),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signup,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Sign Up'),
              ),
            ),
            const SizedBox(height: 16),

            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? '),
                GestureDetector(
                  onTap: () => context.go('/login?role=${widget.userRole}'),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

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
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _adminCodeController.dispose();
    _parentEmailController.dispose();
    super.dispose();
  }
}
