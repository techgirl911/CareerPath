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
      GoRoute(
        path: '\$quiz/:quizId',
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
      GoRoute(
        path: uploadResults,
        builder: (context, state) => const UploadResultsScreen(),
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
