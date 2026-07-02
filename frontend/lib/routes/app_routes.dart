import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/role_selection_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/student_dashboard.dart';
import '../screens/parent_dashboard.dart';
import '../screens/admin_dashboard.dart';
import '../screens/quiz_screen.dart';
import '../screens/upload_results_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/academic_screen.dart';
import '../models/quiz_model.dart';

class AppRoutes {
  static const String roleSelection = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String studentDashboard = '/student-dashboard';
  static const String parentDashboard = '/parent-dashboard';
  static const String adminDashboard = '/admin-dashboard';
  static const String quiz = '/quiz';
  static const String uploadResults = '/upload-results';
  static const String profile = '/profile';
  static const String academic = '/academic';

  static final GoRouter router = GoRouter(
    initialLocation: roleSelection,
    routes: [
      // Role Selection
      GoRoute(
        path: roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),

      // Login
      GoRoute(
        path: login,
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'student';
          return LoginScreen(userRole: role);
        },
      ),

      // Signup
      GoRoute(
        path: signup,
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'student';
          return SignupScreen(userRole: role);
        },
      ),

      // Student Dashboard
      GoRoute(
        path: studentDashboard,
        builder: (context, state) {
          final userName = state.extra as String? ?? 'Student';
          final studentId = state.uri.queryParameters['studentId'];
          return StudentDashboard(
            userName: userName,
            studentId: studentId,
          );
        },
      ),

      // Parent Dashboard
      GoRoute(
        path: parentDashboard,
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
        path: adminDashboard,
        builder: (context, state) {
          final adminName = state.extra as String? ?? 'Admin';
          final adminId = state.uri.queryParameters['adminId'];
          return AdminDashboard(
            adminId: adminId,
            adminName: adminName,
          );
        },
      ),

      // Quiz
      GoRoute(
        path: '$quiz/:quizId',
        builder: (context, state) {
          final dummyQuiz = Quiz(
            id: '1',
            title: 'Career Assessment 2024',
            description: 'Discover your career path',
            questions: [
              QuizQuestion(
                id: '1',
                quizId: '1',
                question: 'What are you most interested in?',
                questionType: 'single_choice',
                options: ['Technology', 'Healthcare', 'Business', 'Arts'],
                order: 1,
              ),
              QuizQuestion(
                id: '2',
                quizId: '1',
                question: 'Which skill do you excel at?',
                questionType: 'single_choice',
                options: [
                  'Problem Solving',
                  'Communication',
                  'Creativity',
                  'Leadership'
                ],
                order: 2,
              ),
              QuizQuestion(
                id: '3',
                quizId: '1',
                question: 'What is your preferred work environment?',
                questionType: 'single_choice',
                options: ['Team', 'Solo', 'Mixed', 'Remote'],
                order: 3,
              ),
            ],
            year: 2024,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          return QuizScreen(quiz: dummyQuiz);
        },
      ),

      // Upload Results
      GoRoute(
        path: uploadResults,
        builder: (context, state) => const UploadResultsScreen(),
      ),

      // Profile Screen
      GoRoute(
        path: profile,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ProfileScreen(
            userName: extra?['userName'],
            userEmail: extra?['userEmail'],
            userId: extra?['userId'],
          );
        },
      ),

      // Academic Screen
      GoRoute(
        path: academic,
        builder: (context, state) {
          final studentId = state.extra as String?;
          print('Routing to academic with studentId: $studentId');
          return AcademicScreen(studentId: studentId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60),
            const SizedBox(height: 16),
            const Text('Page not found'),
            const SizedBox(height: 8),
            Text('Route: ${state.uri}'),
            const SizedBox(height: 16),
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
