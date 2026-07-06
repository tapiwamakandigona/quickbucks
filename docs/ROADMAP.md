# QuickBucks — Roadmap

Status legend: ☐ todo · ◐ in progress · ☑ done

## M0 — Planning ☑
- ☑ Requirements gathered & confirmed with owner (Slack DM, 2026-07-06)
- ☑ SPEC / ARCHITECTURE / DATA_MODEL written

## M1 — Domain engine (the money math) ☑
The most important milestone. Pure Dart, zero UI → `packages/quickbucks_domain/`.
- ☑ `money.dart`, `dates.dart`, `loan_engine.dart`, `shareout.dart`, `ledger.dart`
- ☑ Unit tests for every SPEC rule (42 tests), incl. the confirmed worked example
  (Mary, $100, 2026-07-01) reproduced verbatim as a test
- ☑ Property test: Σ payouts == cash_on_hand for 2000 random scenarios
- ☑ GitHub Actions CI: format + analyze + test on every push/PR

## M2 — App scaffold + storage ☑
- ☑ Flutter project in `app/` (Android, `com.tapiwa.quickbucks`)
- ☑ drift schema per DATA_MODEL.md + Repo layer (all mutations via domain engine)
- ☑ Repo integration tests (in-memory SQLite): full Mary story, share-out invariants
- ☑ Material 3 theme (green/gold, large type)
- ☑ Cycle creation flow (members + multipliers, start/end date, past dates OK)

## M3 — Daily use screens ◐
- ☑ Saturday contribution grid with manual ticks + backfill
- ☑ Loans: take loan, record payment (defaults overdue payments to the due Saturday)
- ☑ Overdue → rollover prompt flow (SPEC 3.6) with restated numbers
- ☑ Catch-up support (SPEC §7): past start date, backdated loans/payments
- ☑ Home dashboard: cash on hand, pool value, due soon, this Saturday's ticks
- ☐ On-device walkthrough / polish pass
- ☐ Home dashboard: cash on hand, pool value, due soon, this Saturday's ticks

## M4 — Cycle end ◐
- ☑ Editable start + end dates; two-step end (collection phase → share out)
- ☑ Share-out flow with per-member balance sheet (negatives clearly shown)
- ☑ Archive: past cycles read-only
- ☐ Start-new-cycle with roster prefill from previous cycle

## M5 — PDF export ◐
- ☑ Full ledger PDF (summary, contribution grid, loan register, payment log, share-out sheet)
- ☑ Share sheet integration; export anytime + per archived cycle
- ☐ Verify rendering on device

## M6 — Backup & restore ◐
- ☑ Local backup: full-ledger JSON export via share sheet + restore from file (validated, transactional)
- ☑ App PIN lock (owner request): salted-hash PIN, lock screen, set/change/remove
- ☐ v1.1: Appwrite cloud snapshot upload + restore-on-fresh-install

## M7 — Ship ◐
- ☑ App icon (green/gold coin) + label "QuickBucks"
- ☑ Release APK v1.0.0 built + GitHub Release
- ☐ Test pass on Samsung A35 (owner to sideload)
- ☐ v1.1: short plain-English user guide
