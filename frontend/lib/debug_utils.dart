class DebugUtils {
  static void logRoute(String message) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] 🛣️  ROUTE: $message');
  }

  static void logError(String message, dynamic error) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] ❌ ERROR: $message - $error');
  }

  static void logSuccess(String message) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] ✅ SUCCESS: $message');
  }

  static void logInfo(String message) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] ℹ️  INFO: $message');
  }
}
