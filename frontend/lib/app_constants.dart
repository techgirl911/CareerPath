import 'package:flutter/foundation.dart';

class AppConstants {
  // Select a base URL depending on the runtime environment.
  // Android emulators map host localhost to 10.0.2.2
  static String get baseUrl {
    // Backend is running on port 3001 in this environment.
    if (kIsWeb) return 'http://localhost:3001';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3001';
    }
    return 'http://localhost:3001';
  }

  static const String tokenKey = 'auth_token';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Document Types
  static const String docTypeTranscript = 'transcript';
  static const String docTypeReportCard = 'report_card';
  static const String docTypeCertificate = 'certificate';
  static const String docTypeOther = 'other';
}

class ApiEndpoints {
  static String get base => '${AppConstants.baseUrl}/api';

  // Auth endpoints
  static String get signup => '$base/auth/signup';
  static String get login => '$base/auth/login';
  static String get logout => '$base/auth/logout';
  static String get getCurrentUser => '$base/auth/me';

  // Student endpoints
  static String getStudentDashboard(String studentId) =>
      '$base/students/$studentId/dashboard';
  static String getAcademicProfile(String studentId) =>
      '$base/students/$studentId/academic-profile';
  static String getAcademicResults(String studentId) =>
      '$base/students/$studentId/academic-results';
  static String getRecommendations(String studentId) =>
      '$base/students/$studentId/career-recommendations';

  // Career endpoints
  static String getAllCareers = '$base/careers';
  static String getCareerById(String careerId) => '$base/careers/$careerId';
  static String getMarketDemand(String careerId) =>
      '$base/careers/$careerId/market-demand';
  static String getTrendingCareers = '$base/careers/trending';

  // Quiz endpoints
  static String getAllQuizzes = '$base/quizzes';
  static String getQuizById(String quizId) => '$base/quizzes/$quizId';
  static String getQuizQuestions(String quizId) =>
      '$base/quizzes/$quizId/questions';
  static String submitQuiz(String studentId) =>
      '$base/quizzes/submit?studentId=$studentId';
  static String submitQuizResponse = '$base/quizzes/submit';

  // Parent endpoints
  static String getParentDashboard(String parentId) =>
      '$base/parents/$parentId/dashboard';
  static String getChildRecommendations(String parentId) =>
      '$base/parents/$parentId/child-recommendations';
  static String getChildAcademic(String parentId) =>
      '$base/parents/$parentId/child-academic';

  // Admin endpoints
  static String adminDashboard = '$base/admin/dashboard';
  static String adminUsers = '$base/admin/users';
  static String adminCareers = '$base/admin/careers';
  static String adminQuizzes = '$base/admin/quizzes';
}
