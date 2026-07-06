/// Proves error states are actually VISIBLE to the user — not rendered
/// behind an open bottom sheet or silently swallowed.
library;

import 'dart:ffi' hide Size;
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:quickbucks/data/db.dart';
import 'package:quickbucks/data/repo.dart';
import 'package:quickbucks/state.dart';
import 'package:quickbucks/theme.dart';
import 'package:quickbucks/ui/loans.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;
import 'package:sqlite3/open.dart';

Future<AppState> _seed() async {
  final db = AppDb(NativeDatabase.memory());
  final repo = Repo(db);
  await repo.createCycle(
    name: 'Savings 2026',
    startDate: domain.day(2026, 2, 7),
    members: [MemberInput('Mary', 2), MemberInput('Grace', 1)],
  );
  final cycle = (await repo.activeCycle())!;
  final members = await repo.membersOf(cycle.id);
  await repo.takeLoan(
      cycle: cycle,
      member: members.firstWhere((m) => m.name == 'Mary'),
      principalCents: 10000,
      loanDate: domain.day(2026, 5, 6));
  final state = AppState(repo);
  await state.refresh();
  return state;
}

Widget _app(AppState state, Widget home) => ChangeNotifierProvider.value(
      value: state,
      child: MaterialApp(
        theme: quickbucksTheme(),
        debugShowCheckedModeBanner: false,
        home: home,
      ),
    );

void main() {
  setUpAll(() async {
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
    final dir = Platform.environment['FLUTTER_ROOT'] ?? '/work/tools/flutter';
    final fonts = '$dir/bin/cache/artifacts/material_fonts';
    final loader = FontLoader('Roboto');
    for (final f in [
      'Roboto-Regular.ttf',
      'Roboto-Medium.ttf',
      'Roboto-Bold.ttf',
    ]) {
      final bytes = File('$fonts/$f').readAsBytesSync();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
    await loader.load();
  });

  testWidgets('overpayment error is visible INSIDE the open payment sheet',
      tags: 'golden', (tester) async {
    tester.view.physicalSize = const Size(393, 851) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final state = await _seed();
    await tester.pumpWidget(_app(state, const LoansScreen()));
    await tester.pumpAndSettle();

    // Open Mary's loan payment sheet (via the overdue card's button).
    await tester.tap(find.text('Record payment').first);
    await tester.pumpAndSettle();

    // Type more than she owes ($120) and submit.
    await tester.enterText(find.byType(TextField).last, '500');
    await tester.tap(find.widgetWithText(FilledButton, 'Record payment'));
    await tester.pumpAndSettle();

    // The error text must be visible and the sheet still open.
    expect(find.text('That is more than the \$120.00 owed'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Record payment'), findsOneWidget);

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/error_overpay_sheet.png'));

    // Fix the amount: the error stays until submit, then sheet closes to
    // the confirmation dialog.
    await tester.enterText(find.byType(TextField).last, '50');
    await tester.tap(find.widgetWithText(FilledButton, 'Record payment'));
    await tester.pumpAndSettle();
    expect(find.text('Record this payment?'), findsOneWidget);
    await state.repo.db.close();
  });

  testWidgets('new-loan sheet shows inline validation errors', tags: 'golden',
      (tester) async {
    tester.view.physicalSize = const Size(393, 851) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final state = await _seed();
    await tester.pumpWidget(_app(state, const LoansScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('New loan'));
    await tester.pumpAndSettle();

    // Submit with nothing chosen.
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a member'), findsOneWidget);

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/error_new_loan_sheet.png'));
    await state.repo.db.close();
  });
}
