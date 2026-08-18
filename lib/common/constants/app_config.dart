class AppConfig {
  // Base URLs
  static const String baseUrl = 'https://api.gestifysolution.oscarmedina.cloud/api/v1';
  static const String baseServerUrl = 'https://api.gestifysolution.oscarmedina.cloud';

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String validateTokenEndpoint = '/auth/validate-token';
  static const String refreshTokenEndpoint = '/auth/refresh-token';
  static const String logoutEndpoint = '/auth/logout';

  static const String registerEndpoint = '/bosses';
  static const String profileEndpoint = '';

  // Public endpoints (no authentication required)
  static const List<String> publicEndpoints = ['/auth/login', '/auth/validate-token', '/bosses', '/auth/refresh-token'];

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const Duration sendTimeout = Duration(seconds: 10);

  // Storage keys
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String userNameKey = 'userName';
  static const String emailKey = 'email';
  static const String phoneKey = 'phone';
  static const String userIdKey = 'userId';
}
