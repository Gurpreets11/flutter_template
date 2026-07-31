/// Networking constants — base URL, timeouts, and endpoint paths.
///
/// These are placeholders until real API integration happens (a
/// planned next step after this settings work). Nothing in this app
/// wires these into `ApiClient` yet — `AuthRepositoryImpl` is still
/// the demo/mock implementation described in the README.
abstract final class ApiConstants {
  /// The backend's base URL. Replace per environment (dev/staging/
  /// prod) once real API integration begins — likely via Flutter
  /// flavors rather than a single hardcoded constant.
  static const baseUrl = 'https://api.example.com';

  /// Default connect timeout for `Dio`'s `BaseOptions`.
  static const connectTimeout = Duration(seconds: 15);

  /// Default receive timeout for `Dio`'s `BaseOptions`.
  static const receiveTimeout = Duration(seconds: 15);

  // Endpoint paths — placeholders, update to match the real API.
  static const loginPath = '/auth/login';
  static const logoutPath = '/auth/logout';
  static const changePasswordPath = '/auth/change-password';
}
