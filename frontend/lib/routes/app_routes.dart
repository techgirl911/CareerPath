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
  static const String studentAcademic = '/student-dashboard/academic';
  static const String studentProfile = '/student-dashboard/profile';
  static const String parentDashboard = '/parent-dashboard';
  static const String adminDashboard = '/admin-dashboard';

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'roleSelection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'student';
          return LoginScreen(userRole: role);
        },
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'student';
          return SignupScreen(userRole: role);
        },
      ),
      // Student Dashboard Routes
      GoRoute(
        path: '/student-dashboard',
        name: 'studentDashboard',
        builder: (context, state) {
          final userName = state.extra as String? ?? 'Student';
          final studentId = state.uri.queryParameters['studentId'];
          return StudentDashboard(
            userName: userName,
            studentId: studentId,
          );
        },
        routes: [
          GoRoute(
            path: 'academic',
            name: 'studentAcademic',
            builder: (context, state) {
              final studentId = state.uri.queryParameters['studentId'];
              return AcademicScreen(studentId: studentId);
            },
          ),
          GoRoute(
            path: 'profile',
            name: 'studentProfile',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final studentId = state.uri.queryParameters['studentId'];
              return ProfileScreen(
                userName: extra?['userName'],
                userEmail: extra?['userEmail'],
                userId: studentId,
              );
            },
          ),
        ],
      ),
      // Parent Dashboard
      GoRoute(
        path: '/parent-dashboard',
        name: 'parentDashboard',
        builder: (context, state) {
          final parentName = state.extra as String? ?? 'Parent';
          final parentId = state.uri.queryParameters['parentId'];
          return ParentDashboard(
            parentId: parentId,
            parentName: parentName,
          );
        },
      ),
      // Admin Dashboard
      GoRoute(
        path: '/admin-dashboard',
        name: 'adminDashboard',
        builder: (context, state) {
          final adminName = state.extra as String? ?? 'Admin';
          final adminId = state.uri.queryParameters['adminId'];
          return AdminDashboard(
            adminId: adminId,
            adminName: adminName,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
