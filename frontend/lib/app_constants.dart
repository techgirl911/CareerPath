class AppConstants {
  static const String baseUrl = 'http://localhost:3000';
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
  static const String base = 'http://localhost:3000/api';

  // Auth endpoints
  static const String signup = '$base/auth/signup';
  static const String login = '$base/auth/login';
  static const String logout = '$base/auth/logout';
  static const String getCurrentUser = '$base/auth/me';

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
  static const String getAllCareers = '$base/careers';
  static String getCareerById(String careerId) => '$base/careers/$careerId';
  static String getMarketDemand(String careerId) =>
      '$base/careers/$careerId/market-demand';
  static const String getTrendingCareers = '$base/careers/trending';

  // Quiz endpoints
  static const String getAllQuizzes = '$base/quizzes';
  static String getQuizById(String quizId) => '$base/quizzes/$quizId';
  static String getQuizQuestions(String quizId) =>
      '$base/quizzes/$quizId/questions';
  static String submitQuiz(String studentId) =>
      '$base/quizzes/submit?studentId=$studentId';
  static const String submitQuizResponse = '$base/quizzes/submit';

  // Parent endpoints
  static String getParentDashboard(String parentId) =>
      '$base/parents/$parentId/dashboard';
  static String getChildRecommendations(String parentId) =>
      '$base/parents/$parentId/child-recommendations';
  static String getChildAcademic(String parentId) =>
      '$base/parents/$parentId/child-academic';

  // Admin endpoints
  static const String adminDashboard = '$base/admin/dashboard';
  static const String adminUsers = '$base/admin/users';
  static const String adminCareers = '$base/admin/careers';
  static const String adminQuizzes = '$base/admin/quizzes';
}
