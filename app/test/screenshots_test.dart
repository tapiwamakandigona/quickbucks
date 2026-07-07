/// Visual smoke test: renders the real screens with realistic seeded data
/// and writes PNG screenshots to test/goldens/ (run with --update-goldens).
/// Doubles as a "does every main screen build without crashing" test.
library;

import 'dart:ffi' hide Size;
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickbucks/state.dart';
import 'package:quickbucks/theme.dart';
import 'package:quickbucks/ui/contributions.dart';
import 'package:quickbucks/ui/create_cycle.dart';
import 'package:quickbucks/ui/cycle_end.dart';
import 'package:quickbucks/ui/home.dart';
import 'package:quickbucks/ui/loans.dart';
import 'package:quickbucks/ui/lock.dart';
import 'package:quickbucks/ui/member_detail.dart';
import 'package:sqlite3/open.dart';

import 'support/seed.dart';

// Samsung Galaxy A35 logical resolution (1080x2340 @ ~2.75x).
const _phone = Size(393, 851);

Future<void> _shot(
  WidgetTester tester,
  AppState state,
  Widget screen,
  String name,
) async {
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: state,
      child: MaterialApp(
        theme: quickbucksTheme(),
        debugShowCheckedModeBanner: false,
        home: screen,
      ),
    ),
  );
  await tester.pumpAndSettle();
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/$name.png'),
  );
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    if (Platform.isLinux) {
      open.overrideFor(OperatingSystem.linux, () {
        try {
          return DynamicLibrary.open('libsqlite3.so');
        } on ArgumentError {
          return DynamicLibrary.open('libsqlite3.so.0');
        }
      });
    }
    await loadAppFonts();
    // loadAppFonts misses some Roboto weights -> Ahem boxes. Load them all.
    final dir = Platform.environment['FLUTTER_ROOT'] ?? '/work/tools/flutter';
    final fonts = '$dir/bin/cache/artifacts/material_fonts';
    final loader = FontLoader('Roboto');
    for (final f in [
      'Roboto-Regular.ttf',
      'Roboto-Medium.ttf',
      'Roboto-Bold.ttf',
      'Roboto-Light.ttf',
      'Roboto-Black.ttf',
      'Roboto-Italic.ttf',
    ]) {
      final bytes = File('$fonts/$f').readAsBytesSync();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
    await loader.load();
  });

  testWidgets('screenshot: all main screens render', tags: 'golden', (
    tester,
  ) async {
    tester.view.physicalSize = _phone * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final state = await seedAppState();
    await _shot(tester, state, const HomeScreen(), 'home');
    await _shot(tester, state, const ContributionsScreen(), 'saturday_book');
    await _shot(tester, state, const LoansScreen(), 'loans');
    // The Paid tab of the loans book.
    await tester.tap(find.text('Paid'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/loans_paid.png'),
    );
    await _shot(tester, state, const SaturdayLoansScreen(), 'saturday_loans');
    await _shot(tester, state, const CycleSettingsScreen(), 'settings');
    await _shot(tester, state, const CreateCycleScreen(), 'create_cycle');
    await _shot(tester, state, LockScreen(onUnlocked: () {}), 'lock');
    final mary = state.members.firstWhere((m) => m.name == 'Mary');
    await _shot(
      tester,
      state,
      MemberDetailScreen(member: mary),
      'member_detail',
    );
    await state.repo.db.close();
  });
}
