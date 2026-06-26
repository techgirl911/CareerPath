class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:3000';
  static const String apiVersion = '/api';

  // Timeouts
  static const int connectionTimeout = 10000;
  static const int receiveTimeout = 10000;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String userRoleKey = 'user_role';

  // User Roles
  static const String roleStudent = 'student';
  static const String roleParent = 'parent';
  static const String roleAdmin = 'admin';

  // Document Types
  static const String docTypeTranscript = 'transcript';
  static const String docTypeReportCard = 'report_card';
  static const String docTypeCertificate = 'certificate';

  // Pagination
  static const int defaultPageSize = 20;

  // Match Score Thresholds
  static const double highMatchScore = 75.0;
  static const double mediumMatchScore = 50.0;

  // Market Demand Thresholds
  static const int highDemandScore = 70;
  static const int mediumDemandScore = 40;
}

class ApiEndpoints {
  static const String base =
      '${AppConstants.baseUrl}${AppConstants.apiVersion}';

  // Auth
  static const String signup = '$base/auth/signup';
  static const String login = '$base/auth/login';
  static const String logout = '$base/auth/logout';
  static const String getCurrentUser = '$base/auth/me';

  // Students
  static String getStudentDashboard(String studentId) =>
      '$base/students/$studentId/dashboard';

  static String getRecommendations(String studentId) =>
      '$base/students/$studentId/recommendations';

  static String getAcademicResults(String studentId) =>
      '$base/students/$studentId/academic-results';

  // Careers
  static const String getAllCareers = '$base/careers';

  static String getCareerById(String careerId) => '$base/careers/$careerId';

  static const String getTrendingCareers = '$base/careers/trending';

  // Quizzes
  static const String getAllQuizzes = '$base/quizzes';

  static String getQuizById(String quizId) => '$base/quizzes/$quizId';

  static String submitQuiz(String studentId) =>
      '$base/students/$studentId/submit-quiz';

  // Parents
  static String getParentDashboard(String parentId) =>
      '$base/parents/$parentId/dashboard';

  // Admin
  static const String adminDashboard = '$base/admin/dashboard';
}
