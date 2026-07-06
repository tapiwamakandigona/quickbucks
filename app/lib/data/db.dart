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
  IntColumn get weeklyUnitCents => integer().withDefault(const Constant(1000))();
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
        {memberId, saturday}
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

@DriftDatabase(tables: [
  Cycles,
  Members,
  Contributions,
  Loans,
  LoanPayments,
  ShareOuts,
  ShareOutLines,
])
class AppDb extends _$AppDb {
  AppDb(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
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
              await (update(loans)..where((t) => t.id.equals(l.id)))
                  .write(LoansCompanion(dueDate: Value(dueIso)));
            }
          }
        },
      );
}
