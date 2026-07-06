import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/db.dart';
import 'data/pin.dart' as pin;
import 'data/repo.dart';
import 'state.dart';
import 'theme.dart';
import 'ui/create_cycle.dart';
import 'ui/home.dart';
import 'ui/lock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDb(driftDatabase(name: 'quickbucks'));
  final state = AppState(Repo(db));
  state.refresh();
  runApp(QuickBucksApp(state: state));
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

class _RootState extends State<_Root> {
  bool? _locked;

  @override
  void initState() {
    super.initState();
    pin.pinIsSet().then((set) {
      if (mounted) setState(() => _locked = set);
    });
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
