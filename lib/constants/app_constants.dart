/// App-wide constants that aren't tied to networking. Centralized here
/// so copy/config changes (support email, min password length shown in
/// validation messages, etc.) happen in one place instead of being
/// duplicated across screens.
abstract final class AppConstants {
  /// The app's display name, shown on the About screen and in the
  /// `MaterialApp.title`.
  static const appName = 'Flutter Starter';

  /// Support contact email shown on the "Contact us" settings item.
  static const supportEmail = 'support@example.com';

  /// Placeholder — replace with the real hosted URL once available.
  static const privacyPolicyUrl = 'https://example.com/privacy';

  /// Placeholder — replace with the real hosted URL once available.
  static const termsOfServiceUrl = 'https://example.com/terms';

  /// Minimum password length enforced by the password validator and
  /// referenced in its validation message — kept here so the login and
  /// change-password screens can't drift out of sync with each other.
  static const minPasswordLength = 8;

  /// Default page size for paginated list screens.
  static const defaultPageSize = 10;
}
