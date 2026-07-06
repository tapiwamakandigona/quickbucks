import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'data/db.dart';
import 'data/pin.dart' as pin;
import 'data/reminder.dart' as reminder;
import 'data/repo.dart';
import 'state.dart';
import 'theme.dart';
import 'ui/create_cycle.dart';
import 'ui/home.dart';
import 'ui/lock.dart';

/// Crash reporting is enabled only when a DSN is baked in at build time:
/// `flutter build apk --dart-define=SENTRY_DSN=https://...`.
/// No DSN -> no network calls at all (the ledger itself never leaves the
/// phone either way; Sentry only receives crash stack traces).
const _sentryDsn = String.fromEnvironment('SENTRY_DSN');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDb(driftDatabase(name: 'quickbucks'));
  final state = AppState(Repo(db));
  getApplicationDocumentsDirectory().then((dir) {
    state.autoBackupDir = dir;
  });
  state.refresh().then((_) {
    // Keep the weekly reminder scheduled while payments run; clear it after.
    reminder.syncReminder(
        contributionsRunning: state.cycle?.status == 'active');
  });
  if (_sentryDsn.isEmpty) {
    runApp(QuickBucksApp(state: state));
    return;
  }
  SentryFlutter.init(
    (options) {
      options.dsn = _sentryDsn;
      options.tracesSampleRate = 0; // crashes only, no performance tracing
      options.sendDefaultPii = false;
    },
    appRunner: () => runApp(QuickBucksApp(state: state)),
  );
}

class QuickBucksApp extends StatelessWidget {
  final AppState state;
  const QuickBucksApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: state,
      child: MaterialApp(
        title: 'QuickBucks',
        theme: quickbucksTheme(),
        debugShowCheckedModeBanner: false,
        home: const _Root(),
      ),
    );
  }
}

class _Root extends StatefulWidget {
  const _Root();

  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> with WidgetsBindingObserver {
  bool? _locked;
  DateTime? _leftAt;

  /// Coming back after this long asks for the PIN again.
  static const _relockAfter = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pin.pinIsSet().then((set) {
      if (mounted) setState(() => _locked = set);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    if (lifecycle == AppLifecycleState.paused ||
        lifecycle == AppLifecycleState.hidden) {
      _leftAt ??= DateTime.now();
    } else if (lifecycle == AppLifecycleState.resumed) {
      final leftAt = _leftAt;
      _leftAt = null;
      if (_locked == true || leftAt == null) return;
      if (DateTime.now().difference(leftAt) < _relockAfter) return;
      pin.pinIsSet().then((set) {
        if (set && mounted) setState(() => _locked = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    if (app.loading || _locked == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_locked == true) {
      return LockScreen(onUnlocked: () => setState(() => _locked = false));
    }
    if (app.cycle == null) {
      return const CreateCycleScreen();
    }
    return const HomeScreen();
  }
}
