import 'package:core_package/core_package.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// A demo/stub [UpdateCheckService] — **always reports the app is up
/// to date**. There's no real backend or remote-config source behind
/// this yet, same honest-scope pattern as [AuthRepositoryImpl].
///
/// Replace this with a real implementation once your app has an
/// actual source of truth for "what's the latest/minimum version" —
/// see [UpdateCheckService]'s doc comment for an example shape.
class DemoUpdateCheckServiceImpl implements UpdateCheckService {
  @override
  Future<Result<AppVersionInfo>> checkForUpdate() async {
    final info = await PackageInfo.fromPlatform();
    return Result.success(
      AppVersionInfo(
        currentVersion: info.version,
        latestVersion: info.version,
        updateRequired: false,
      ),
    );
  }
}
