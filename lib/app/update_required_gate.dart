import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';

/// Checks for an update once (via [service]) and shows a blocking
/// "update required" screen in place of [child] if one is required —
/// a no-op wrapper (just renders [child]) when [enabled] is `false`.
///
/// The check itself runs in the background — [child] renders
/// immediately and normally while it's in flight, so the app never
/// waits on this. If the check itself fails (no connectivity, server
/// error), this fails open rather than blocking the user.
class UpdateRequiredGate extends StatefulWidget {
  /// Creates an [UpdateRequiredGate].
  const UpdateRequiredGate({
    required this.enabled,
    required this.service,
    required this.child,
    super.key,
  });

  /// Whether the check runs at all. Wire this to
  /// `AppFeatureFlags.enableForceUpdateCheck`.
  final bool enabled;

  /// The service used to check for an update.
  final UpdateCheckService service;

  /// The app content to show when no update is required.
  final Widget child;

  @override
  State<UpdateRequiredGate> createState() => _UpdateRequiredGateState();
}

class _UpdateRequiredGateState extends State<UpdateRequiredGate> {
  AppVersionInfo? _requiredUpdateInfo;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _check();
  }

  Future<void> _check() async {
    final result = await widget.service.checkForUpdate();
    result.when(
      onSuccess: (info) {
        if (mounted && info.updateRequired) {
          setState(() => _requiredUpdateInfo = info);
        }
      },
      // Fail open: a broken update check shouldn't lock users out.
      onFailure: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = _requiredUpdateInfo;
    if (!widget.enabled || info == null) return widget.child;

    final config = AppThemeScope.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(config.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.system_update_outlined,
                size: 48,
                color: config.primary,
              ),
              SizedBox(height: config.spacing.md),
              Text(
                'Update required',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: config.spacing.sm),
              Text(
                'Version ${info.latestVersion} is available. Please '
                'update to continue.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
