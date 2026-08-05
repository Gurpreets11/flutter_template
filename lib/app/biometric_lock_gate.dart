import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';

/// Shows a lock screen in place of [child] whenever the app resumes
/// from the background, requiring [service] to re-authenticate before
/// continuing — a no-op wrapper (just renders [child]) when [enabled]
/// is `false`, so this can stay in the widget tree permanently and be
/// toggled purely via `AppFeatureFlags.enableBiometricLock`.
class BiometricLockGate extends StatefulWidget {
  /// Creates a [BiometricLockGate].
  const BiometricLockGate({
    required this.enabled,
    required this.service,
    required this.child,
    super.key,
  });

  /// Whether the lock is active. Wire this to
  /// `AppFeatureFlags.enableBiometricLock`.
  final bool enabled;

  /// The service used to check availability and prompt for
  /// authentication.
  final BiometricLockService service;

  /// The app content to show once unlocked.
  final Widget child;

  @override
  State<BiometricLockGate> createState() => _BiometricLockGateState();
}

class _BiometricLockGateState extends State<BiometricLockGate>
    with WidgetsBindingObserver {
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!widget.enabled) return;

    if (state == AppLifecycleState.paused) {
      setState(() => _locked = true);
    } else if (state == AppLifecycleState.resumed && _locked) {
      _attemptUnlock();
    }
  }

  Future<void> _attemptUnlock() async {
    final available = await widget.service.isAvailable;
    if (!available) {
      // No biometric/PIN configured on this device — fail open rather
      // than locking the user out entirely.
      if (mounted) setState(() => _locked = false);
      return;
    }

    final success = await widget.service.authenticate(
      reason: 'Unlock to continue',
    );
    if (success && mounted) {
      setState(() => _locked = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || !_locked) return widget.child;

    final config = AppThemeScope.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(config.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 48, color: config.primary),
              SizedBox(height: config.spacing.md),
              Text(
                'App locked',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: config.spacing.md),
              AppButton(
                label: 'Unlock',
                expand: false,
                onPressed: _attemptUnlock,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
