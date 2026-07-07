/// Drift schema — mirrors docs/DATA_MODEL.md.
/// Money = integer cents. Dates = ISO `yyyy-MM-dd` TEXT columns.
library;

import 'package:drift/drift.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;

part 'db.g.dart';

class Cycles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get startDate => text()(); // yyyy-MM-dd
  TextColumn get endDate => text().nullable()(); // editable while active
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get endedOn => text().nullable()();
  IntColumn get weeklyUnitCents =>
      integer().withDefault(const Constant(1000))();
  IntColumn get interestPct => integer().withDefault(const Constant(20))();

  @override
  Set<Column> get primaryKey => {id};
}

class Members extends Table {
  TextColumn get id => text()();
  TextColumn get cycleId => text().references(Cycles, #id)();
  TextColumn get name => text()();
  IntColumn get multiplier => integer()(); // immutable once cycle starts

  @override
  Set<Column> get primaryKey => {id};
}

class Contributions extends Table {
  TextColumn get id => text()();
  TextColumn get cycleId => text().references(Cycles, #id)();
  TextColumn get memberId => text().references(Members, #id)();
  TextColumn get saturday => text()(); // must be a Saturday
  IntColumn get amountCents => integer()();
  TextColumn get recordedOn => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {memberId, saturday},
  ];
}

class Loans extends Table {
  TextColumn get id => text()();
  TextColumn get cycleId => text().references(Cycles, #id)();
  TextColumn get memberId => text().references(Members, #id)();
  IntColumn get principalCents => integer()();
  IntColumn get owedCents => integer()();
  TextColumn get loanDate => text()();
  TextColumn get dueDate => text()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get parentLoanId => text().nullable()();
  TextColumn get closedOn => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LoanPayments extends Table {
  TextColumn get id => text()();
  TextColumn get loanId => text().references(Loans, #id)();
  IntColumn get amountCents => integer()();
  TextColumn get paidOn => text()();
  TextColumn get recordedOn => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class ShareOuts extends Table {
  TextColumn get id => text()();
  TextColumn get cycleId => text().references(Cycles, #id)();
  IntColumn get potCents => integer()();
  IntColumn get cashCents => integer()();
  TextColumn get createdOn => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class ShareOutLines extends Table {
  TextColumn get id => text()();
  TextColumn get shareOutId => text().references(ShareOuts, #id)();
  TextColumn get memberId => text().references(Members, #id)();
  IntColumn get multiplier => integer()();
  IntColumn get shareCents => integer()();
  IntColumn get debtDeductedCents => integer()();
  IntColumn get payoutCents => integer()(); // may be negative

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Cycles,
    Members,
    Contributions,
    Loans,
    LoanPayments,
    ShareOuts,
    ShareOutLines,
  ],
)
class AppDb extends _$AppDb {
  AppDb(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 3) {
        // 2026-07-07 (SPEC §0): whole-dollar money. Recompute `owed` on
        // OPEN loans with nearest-dollar rounding; closed history stays
        // untouched. If payments already exceed the rounded figure the
        // loan is settled at what was actually paid (never negative).
        final rows = await (select(
          loans,
        )..where((l) => l.status.equals('active'))).get();
        for (final l in rows) {
          var owed = domain.roundToDollarHalfUp(l.owedCents);
          final paid =
              await (selectOnly(loanPayments)
                    ..addColumns([loanPayments.amountCents.sum()])
                    ..where(loanPayments.loanId.equals(l.id)))
                  .map((r) => r.read(loanPayments.amountCents.sum()) ?? 0)
                  .getSingle();
          if (paid >= owed) owed = paid; // never let outstanding go negative
          if (owed == l.owedCents) continue;
          await (update(loans)..where((t) => t.id.equals(l.id))).write(
            LoansCompanion(
              owedCents: Value(owed),
              // Fully covered by rounding? Then it is paid off.
              status: paid == owed ? const Value('paid') : const Value.absent(),
            ),
          );
        }
      }
      if (from < 2) {
        // v1.3.0: the due-date rule changed from "loan_date + 30 days
        // rolled to Saturday" to "same date next month, clamped, rolled
        // to Saturday" (owner correction 2026-07-06, SPEC 3.2).
        // Recompute every stored due date from its loan date.
        String pad(int n) => n.toString().padLeft(2, '0');
        final rows = await select(loans).get();
        for (final l in rows) {
          final p = l.loanDate.split('-').map(int.parse).toList();
          final due = domain.dueDateFor(DateTime.utc(p[0], p[1], p[2]));
          final dueIso = "${due.year}-${pad(due.month)}-${pad(due.day)}";
          await (update(loans)..where((t) => t.id.equals(l.id))).write(
            LoansCompanion(dueDate: Value(dueIso)),
          );
        }
      }
    },
  );
}
