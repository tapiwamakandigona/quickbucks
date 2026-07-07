/// "Mark everyone paid" catch-up button: fills every missing tick up to
/// today, skips existing ones, and Undo removes exactly what it added.
library;

import 'dart:ffi' hide Size;
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quickbucks/data/db.dart';
import 'package:quickbucks/data/repo.dart';
import 'package:quickbucks/state.dart';
import 'package:quickbucks/theme.dart';
import 'package:quickbucks/ui/contributions.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;
import 'package:sqlite3/open.dart';

void main() {
  setUpAll(() {
    if (Platform.isLinux) {
      open.overrideFor(OperatingSystem.linux, () {
        try {
          return DynamicLibrary.open('libsqlite3.so');
        } on ArgumentError {
          return DynamicLibrary.open('libsqlite3.so.0');
        }
      });
    }
  });

  testWidgets('mark-everyone-paid fills gaps, skips existing, undo reverts', (
    tester,
  ) async {
    final db = AppDb(NativeDatabase.memory());
    final repo = Repo(db);
    await repo.createCycle(
      name: 'Savings 2026',
      startDate: domain.day(2026, 2, 7),
      members: [MemberInput('Mary', 2), MemberInput('Grace', 1)],
    );
    final cycle = (await repo.activeCycle())!;
    await repo.editEndDate(cycle.id, domain.day(2026, 2, 21)); // 3 Saturdays
    final members = await repo.membersOf(cycle.id);
    final mary = members.firstWhere((m) => m.name == 'Mary');
    // Pre-existing tick: Mary on Feb 7. 5 of 6 cells are missing.
    await repo.tickContribution(
      cycle: cycle,
      member: mary,
      saturday: domain.day(2026, 2, 7),
    );
    final state = AppState(repo);
    await state.refresh();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: MaterialApp(
          theme: quickbucksTheme(),
          home: const ContributionsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.done_all));
    await tester.pumpAndSettle();
    expect(find.text('Tick all 5'), findsOneWidget);
    await tester.tap(find.text('Tick all 5'));
    await tester.pumpAndSettle();

    expect(state.contributions.length, 6); // everyone, every Saturday
    // Skipped the existing one: Mary Feb 7 still exists exactly once.
    expect(
      state.contributions
          .where((c) => c.memberId == mary.id && c.saturday == '2026-02-07')
          .length,
      1,
    );

    // Undo removes only the 5 it added.
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(state.contributions.length, 1);
    expect(state.contributions.single.memberId, mary.id);

    await db.close();
  });
}
