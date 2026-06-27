import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/role_selection_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/student_dashboard.dart';
import '../screens/parent_dashboard.dart';
import '../screens/admin_dashboard.dart';

class AppRoutes {
  static const String roleSelection = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String studentDashboard = '/student-dashboard';
  static const String parentDashboard = '/parent-dashboard';
  static const String adminDashboard = '/admin-dashboard';

  static final GoRouter router = GoRouter(
    initialLocation: roleSelection,
    routes: [
      GoRoute(
        path: roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'student';
          return LoginScreen(userRole: role);
        },
      ),
      GoRoute(
        path: signup,
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'student';
          return SignupScreen(userRole: role);
        },
      ),
      GoRoute(
        path: studentDashboard,
        builder: (context, state) => const StudentDashboard(),
      ),
      GoRoute(
        path: parentDashboard,
        builder: (context, state) => const ParentDashboard(),
      ),
      GoRoute(
        path: adminDashboard,
        builder: (context, state) => const AdminDashboard(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Page not found'),
            ElevatedButton(
              onPressed: () => context.go(roleSelection),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
