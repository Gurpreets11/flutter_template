import 'package:core_package/core_package.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The connectivity service used by [AppConnectivityBanner] at the app
/// root. Kept here (rather than in `features/auth/`) since it's a
/// cross-cutting, app-wide concern, not specific to any one feature.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityServiceImpl();
});
