import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/role_selection_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/student_dashboard.dart';
import '../screens/parent_dashboard.dart';
import '../screens/admin_dashboard.dart';
import '../screens/academic_screen.dart';
import '../screens/profile_screen.dart';

class AppRoutes {
  static const String roleSelection = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String studentDashboard = '/student-dashboard';
  static const String parentDashboard = '/parent-dashboard';
  static const String adminDashboard = '/admin-dashboard';
  static const String academic = '/academic';
  static const String profile = '/profile';

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // ===== ROOT ROUTES =====

      // 1. Role Selection (Home)
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const RoleSelectionScreen(),
      ),

      // 2. Login
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'student';
          return LoginScreen(userRole: role);
        },
      ),

      // 3. Signup
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'student';
          return SignupScreen(userRole: role);
        },
      ),

      // 4. Student Dashboard
      GoRoute(
        path: '/student-dashboard',
        name: 'studentDashboard',
        builder: (context, state) {
          final userName = state.uri.queryParameters['userName'] ?? 'Student';
          final userEmail = state.uri.queryParameters['userEmail'] ?? '';
          final studentId = state.uri.queryParameters['studentId'];

          print('=== STUDENT DASHBOARD ROUTE ===');
          print('Path: ${state.uri.path}');
          print('StudentID: $studentId');
          print('UserName: $userName');

          return StudentDashboard(
            userName: userName,
            studentId: studentId,
            userEmail: userEmail,
          );
        },
      ),

      // 5. Parent Dashboard
      GoRoute(
        path: '/parent-dashboard',
        name: 'parentDashboard',
        builder: (context, state) {
          final parentName =
              state.uri.queryParameters['parentName'] ?? 'Parent';
          final parentId = state.uri.queryParameters['parentId'];

          print('=== PARENT DASHBOARD ROUTE ===');
          print('ParentID: $parentId');
          print('ParentName: $parentName');

          return ParentDashboard(
            parentId: parentId,
            parentName: parentName,
          );
        },
      ),

      // 6. Admin Dashboard
      GoRoute(
        path: '/admin-dashboard',
        name: 'adminDashboard',
        builder: (context, state) {
          final adminName = state.uri.queryParameters['adminName'] ?? 'Admin';
          final adminId = state.uri.queryParameters['adminId'];

          print('=== ADMIN DASHBOARD ROUTE ===');
          print('AdminID: $adminId');
          print('AdminName: $adminName');

          return AdminDashboard(
            adminId: adminId,
            adminName: adminName,
          );
        },
      ),

      // 7. Academic Screen
      GoRoute(
        path: '/academic',
        name: 'academic',
        builder: (context, state) {
          final studentId = state.uri.queryParameters['studentId'];

          print('=== ACADEMIC ROUTE ===');
          print('Path: ${state.uri.path}');
          print('StudentID: $studentId');
          print('Full URI: ${state.uri}');

          return AcademicScreen(studentId: studentId);
        },
      ),

      // 8. Profile Screen
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) {
          final studentId = state.uri.queryParameters['studentId'];
          final userName = state.uri.queryParameters['userName'] ?? 'User';
          final userEmail = state.uri.queryParameters['userEmail'] ?? '';

          print('=== PROFILE ROUTE ===');
          print('Path: ${state.uri.path}');
          print('StudentID: $studentId');
          print('UserName: $userName');
          print('Full URI: ${state.uri}');

          return ProfileScreen(
            userName: userName,
            userEmail: userEmail,
            userId: studentId,
          );
        },
      ),
    ],

    // Error Handler
    errorBuilder: (context, state) {
      print('=== ROUTE ERROR ===');
      print('Attempted path: ${state.uri}');
      print('Error: Route not found');

      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60),
              const SizedBox(height: 16),
              const Text('Page Not Found'),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Route: ${state.uri}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
