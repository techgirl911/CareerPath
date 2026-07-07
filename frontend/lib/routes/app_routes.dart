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
import '../screens/quiz_screen.dart';
import '../screens/upload_results_screen.dart';

// Create GoRouter instance
final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  errorBuilder: (context, state) {
    print('Route error: ${state.uri}');
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60),
            const SizedBox(height: 16),
            const Text('Page Not Found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        print('Route: Home');
        return const RoleSelectionScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        print('Route: Login');
        final role = state.uri.queryParameters['role'] ?? 'student';
        return LoginScreen(userRole: role);
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) {
        print('Route: Signup');
        final role = state.uri.queryParameters['role'] ?? 'student';
        return SignupScreen(userRole: role);
      },
    ),
    GoRoute(
      path: '/student-dashboard',
      builder: (context, state) {
        print('Route: Student Dashboard');
        final userName = state.uri.queryParameters['userName'] ?? 'Student';
        final userEmail = state.uri.queryParameters['userEmail'] ?? '';
        final studentId = state.uri.queryParameters['studentId'] ?? '';
        return StudentDashboard(
          userName: userName,
          studentId: studentId,
          userEmail: userEmail,
        );
      },
    ),
    GoRoute(
      path: '/parent-dashboard',
      builder: (context, state) {
        print('Route: Parent Dashboard');
        final parentName = state.uri.queryParameters['parentName'] ?? 'Parent';
        final parentId = state.uri.queryParameters['parentId'] ?? '';
        return ParentDashboard(
          parentId: parentId,
          parentName: parentName,
        );
      },
    ),
    GoRoute(
      path: '/admin-dashboard',
      builder: (context, state) {
        print('Route: Admin Dashboard');
        final adminName = state.uri.queryParameters['adminName'] ?? 'Admin';
        final adminId = state.uri.queryParameters['adminId'] ?? '';
        return AdminDashboard(
          adminId: adminId,
          adminName: adminName,
        );
      },
    ),
    GoRoute(
      path: '/academic',
      builder: (context, state) {
        print('Route: Academic');
        final studentId = state.uri.queryParameters['studentId'] ?? '';
        return AcademicScreen(studentId: studentId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        print('Route: Profile');
        final studentId = state.uri.queryParameters['studentId'] ?? '';
        return ProfileScreen(
          userName: state.uri.queryParameters['userName'] ?? 'User',
          userEmail: state.uri.queryParameters['userEmail'] ?? '',
          userId: studentId,
        );
      },
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) {
        print('Route: Quiz');
        final quizId = state.uri.queryParameters['quizId'] ?? '';
        final studentId = state.uri.queryParameters['studentId'] ?? '';
        return QuizScreen(
          quizId: quizId,
          studentId: studentId,
        );
      },
    ),
    GoRoute(
      path: '/upload',
      builder: (context, state) {
        print('Route: Upload');
        final studentId = state.uri.queryParameters['studentId'] ?? '';
        return UploadResultsScreen(studentId: studentId);
      },
    ),
  ],
);
