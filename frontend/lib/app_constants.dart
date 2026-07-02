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

  // ===== Auth Endpoints =====
  static const String signup = '$base/auth/signup';
  static const String login = '$base/auth/login';
  static const String logout = '$base/auth/logout';
  static const String getCurrentUser = '$base/auth/me';

  // ===== Student Endpoints =====
  static String getStudentDashboard(String studentId) =>
      '$base/students/$studentId/dashboard';

  static String getRecommendations(String studentId) =>
      '$base/students/$studentId/recommendations';

  static String getAcademicProfile(String studentId) =>
      '$base/students/$studentId/academic-profile';

  static String getAcademicResults(String studentId) =>
      '$base/students/$studentId/academic-results';

  static String submitQuiz(String studentId) =>
      '$base/students/$studentId/submit';

  static String uploadDocument(String studentId) =>
      '$base/students/$studentId/upload-document';

  // ===== Career Endpoints =====
  static const String getAllCareers = '$base/careers';

  static String getCareerById(String careerId) => '$base/careers/$careerId';

  static String getCareersBySubject(String subject) =>
      '$base/careers/subject/$subject';

  static String getMarketDemand(String careerId) =>
      '$base/careers/$careerId/market-demand';

  static const String getTrendingCareers = '$base/careers/trending';

  static String searchCareers(String query) => '$base/careers/search?q=$query';

  // ===== Quiz Endpoints =====
  static const String getAllQuizzes = '$base/quizzes';

  static String getQuizById(String quizId) => '$base/quizzes/$quizId';

  static String getQuizQuestions(String quizId) =>
      '$base/quizzes/$quizId/questions';

  static String submitQuizResponse(String studentId) =>
      '$base/quizzes/$studentId/submit';

  // ===== Parent Endpoints =====
  static String getParentDashboard(String parentId) =>
      '$base/parents/$parentId/dashboard';

  static String getChildRecommendations(String parentId) =>
      '$base/parents/$parentId/child/recommendations';

  static String getChildAcademic(String parentId) =>
      '$base/parents/$parentId/child/academic';

  static String getChildQuizResults(String parentId) =>
      '$base/parents/$parentId/child/quiz-results';

  // ===== Admin Endpoints =====
  static const String adminDashboard = '$base/admin/dashboard';

  static String getAllUsers({int page = 1, int limit = 20}) =>
      '$base/admin/users?page=$page&limit=$limit';

  static String deactivateUser(String userId) =>
      '$base/admin/users/$userId/deactivate';

  static String activateUser(String userId) =>
      '$base/admin/users/$userId/activate';

  static const String createCareer = '$base/admin/careers';

  static String deleteCareer(String careerId) =>
      '$base/admin/careers/$careerId';

  static const String createQuiz = '$base/admin/quizzes';

  static String deleteQuiz(String quizId) => '$base/admin/quizzes/$quizId';

  // ===== Health Check =====
  static const String health = '$base/health';
}
