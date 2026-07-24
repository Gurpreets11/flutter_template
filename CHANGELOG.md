# Changelog

## 0.1.0

Initial Phase 1 scaffold:

- Networking: `ApiClient`, `Result<T>`, `AuthInterceptor`, `LoggingInterceptor`
- Exceptions: `AppException` hierarchy, `Failure` hierarchy, `ExceptionMapper`
- Logging: `AppLogger` (silent in release builds)
- Validation: `Validators` (required, email, phone, min/max length, password, matches, compose)
- Theming: `AppThemeConfig`, `AppThemeScope`
- Base architecture: `UseCase<Type, Params>`, `Repository` marker interface
