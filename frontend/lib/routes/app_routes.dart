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
import '../debug_utils.dart';

class AppRoutes {
  static const String home = '/';
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
    redirect: (context, state) {
      DebugUtils.logRoute('Redirect: ${state.uri}');
      return null;
    },
    errorBuilder: (context, state) {
      DebugUtils.logError('Route Error', state.uri.toString());
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60),
              const SizedBox(height: 16),
              const Text('Route Not Found'),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    },
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) {
          DebugUtils.logRoute('Home');
          return const RoleSelectionScreen();
        },
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) {
          DebugUtils.logRoute('Login');
          final role = state.uri.queryParameters['role'] ?? 'student';
          return LoginScreen(userRole: role);
        },
      ),
      GoRoute(
        path: signup,
        name: 'signup',
        builder: (context, state) {
          DebugUtils.logRoute('Signup');
          final role = state.uri.queryParameters['role'] ?? 'student';
          return SignupScreen(userRole: role);
        },
      ),
      GoRoute(
        path: studentDashboard,
        name: 'studentDashboard',
        builder: (context, state) {
          DebugUtils.logRoute('Student Dashboard');
          DebugUtils.logInfo('URI: ${state.uri}');
          DebugUtils.logInfo('Params: ${state.uri.queryParameters}');

          final userName = state.uri.queryParameters['userName'] ?? 'Student';
          final userEmail = state.uri.queryParameters['userEmail'] ?? '';
          final studentId = state.uri.queryParameters['studentId'] ?? '';

          DebugUtils.logSuccess('Student Dashboard loaded - ID: $studentId');

          return StudentDashboard(
            userName: userName,
            studentId: studentId,
            userEmail: userEmail,
          );
        },
      ),
      GoRoute(
        path: parentDashboard,
        name: 'parentDashboard',
        builder: (context, state) {
          DebugUtils.logRoute('Parent Dashboard');
          DebugUtils.logInfo('URI: ${state.uri}');
          DebugUtils.logInfo('Params: ${state.uri.queryParameters}');

          final parentName =
              state.uri.queryParameters['parentName'] ?? 'Parent';
          final parentId = state.uri.queryParameters['parentId'] ?? '';

          DebugUtils.logSuccess('Parent Dashboard loaded - ID: $parentId');

          return ParentDashboard(
            parentId: parentId,
            parentName: parentName,
          );
        },
      ),
      GoRoute(
        path: adminDashboard,
        name: 'adminDashboard',
        builder: (context, state) {
          DebugUtils.logRoute('Admin Dashboard');
          DebugUtils.logInfo('URI: ${state.uri}');
          DebugUtils.logInfo('Params: ${state.uri.queryParameters}');

          final adminName = state.uri.queryParameters['adminName'] ?? 'Admin';
          final adminId = state.uri.queryParameters['adminId'] ?? '';

          DebugUtils.logSuccess('Admin Dashboard loaded - ID: $adminId');

          return AdminDashboard(
            adminId: adminId,
            adminName: adminName,
          );
        },
      ),
      GoRoute(
        path: academic,
        name: 'academic',
        builder: (context, state) {
          DebugUtils.logRoute('Academic');
          final studentId = state.uri.queryParameters['studentId'] ?? '';
          DebugUtils.logSuccess('Academic loaded - ID: $studentId');
          return AcademicScreen(studentId: studentId);
        },
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) {
          DebugUtils.logRoute('Profile');
          final studentId = state.uri.queryParameters['studentId'] ?? '';
          final userName = state.uri.queryParameters['userName'] ?? 'User';
          final userEmail = state.uri.queryParameters['userEmail'] ?? '';
          DebugUtils.logSuccess('Profile loaded - ID: $studentId');
          return ProfileScreen(
            userName: userName,
            userEmail: userEmail,
            userId: studentId,
          );
        },
      ),
    ],
  );
}
