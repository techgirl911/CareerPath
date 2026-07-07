// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_colors.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  final String? userId;

  const ProfileScreen({
    super.key,
    this.userName,
    this.userEmail,
    this.userId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  bool _isEditing = false;
  bool _showPasswordForm = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName ?? '');
    _emailController = TextEditingController(text: widget.userEmail ?? '');
    _phoneController = TextEditingController();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      print('Updating profile...');
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      setState(() {
        _successMessage = 'Profile updated successfully!';
        _isEditing = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    if (_newPasswordController.text.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('Changing password...');
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      setState(() {
        _successMessage = 'Password changed successfully!';
        _showPasswordForm = false;
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password changed successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.maybeOf(context);
              final navigator = Navigator.of(context);
              navigator.pop();
              try {
                final authService = AuthService();
                await authService.logout();
                if (!mounted) return;
                if (context.mounted) {
                  context.go('/');
                }
                if (!mounted || messenger == null) return;
                messenger.showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              } catch (e) {
                if (!mounted || messenger == null) return;
                messenger.showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final navigator = Navigator.of(context);
            if (navigator.canPop()) {
              navigator.pop();
            } else {
              context.go('/student-dashboard?studentId=${widget.userId ?? ""}');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                    child: const Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.userName ?? 'User',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.userEmail ?? 'email@example.com',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Error/Success messages
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            if (_successMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _successMessage!,
                  style: TextStyle(color: AppColors.success),
                ),
              ),
            const SizedBox(height: 24),

            // Profile Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Personal Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (!_isEditing)
                  TextButton.icon(
                    onPressed: () => setState(() => _isEditing = true),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Name Field
            TextFormField(
              controller: _nameController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),

            // Email Field
            TextFormField(
              controller: _emailController,
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Phone Field
            TextFormField(
              controller: _phoneController,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone_outlined),
                hintText: '+1 (555) 123-4567',
              ),
            ),
            const SizedBox(height: 24),

            // Save/Cancel Buttons
            if (_isEditing)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfile,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Save Changes'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _isEditing = false),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 32),

            // Security Section
            Text(
              'Security',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Change Password Button
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Change Password'),
                subtitle: const Text('Update your password regularly'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () =>
                    setState(() => _showPasswordForm = !_showPasswordForm),
              ),
            ),

            // Password Change Form
            if (_showPasswordForm) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _changePassword,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Change Password'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          setState(() => _showPasswordForm = false),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
