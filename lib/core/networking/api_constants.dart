import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static const String login = "auth/login";
  static const String signUp = "auth/signup";
  static const String forgetPassword = "auth/password/forgot";
  static const String verifyPassword = "auth/password/verify";
  static const String resetPassword = "auth/password/reset";
  static const String verifyAccount = "auth/signup/verify";
  static const String publishJob = "jobs";
  static const String getOpenJobs = 'jobs/open';
  static const String getJobDetails = 'jobs/{jobId}';
  static const String getRecommendations = 'jobs/recommendations';
  static const String applyForJob = 'applications/jobs/{jobId}/apply';
  static const String updateImageProfile = 'auth/updateImageProfile';
  static const String updateProfile = 'auth/updateProfile';
  static const String createSupportRequest = 'support';
  static const String changePassword = 'auth/change-password';
  static const String updateFcmToken = 'auth/updateFcmToken';
  static const String getAllNotifications = 'notifications/all';
  static const String deleteNotification = 'notifications/{id}';
  static const String deleteAllNotifications = 'notifications/all';
  static const String getMe = 'auth/me';
  static const String myJobs = 'jobs/my-jobs';
}

class ApiErrors {
  static const String badRequestError = 'Bad Request Error';
  static const String noContent = 'No Content';
  static const String forbiddenError = 'Forbidden Error';
  static const String authenticationError = 'Authentication Error';
  static const String notFoundError = 'Not Found Error';
  static const String conflictError = 'Conflict Error';
  static const String internalServerError = 'Internal Server Error';
  static const String unknownError = 'Unknown Error';
  static const String timeoutError = 'Timeout Error';
  static const String defaultError = 'Default Error';
  static const String cacheError = 'Cache Error';
  static const String noInternetError = 'No Internet Error';
  static const String loadingMessage = 'Loading_Message';
  static const String retryAgainMessage = 'Retry_Again_ Message';
  static const String unauthorizedError = 'Unauthorized Error';
  static const String ok = 'OK';
}
