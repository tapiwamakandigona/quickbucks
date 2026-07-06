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

## M2 — App scaffold + storage ◐
- ☑ Flutter project in `app/` (Android, `com.tapiwa.quickbucks`)
- ☑ drift schema per DATA_MODEL.md + Repo layer (all mutations via domain engine)
- ☑ Repo integration tests (in-memory SQLite): full Mary story, share-out invariants
- ☐ Material 3 theme (green/gold, large type)
- ☐ Cycle creation flow (members + multipliers, start/end date)

## M3 — Daily use screens ☐
- ☐ Saturday contribution grid with manual ticks + backfill
- ☐ Loans: take loan, record payment, loan detail with chain history
- ☐ Overdue → rollover prompt flow (SPEC 3.6)
- ☐ Catch-up support (SPEC §7): past start date, backdated loans/payments, historical rollover walk-through
- ☐ Home dashboard: cash on hand, pool value, due soon, this Saturday's ticks

## M4 — Cycle end ☐
- ☐ Editable end date + "End now"
- ☐ Share-out flow with per-member balance sheet (negatives clearly shown)
- ☐ Archive: past cycles read-only + start-new-cycle (prefill roster)

## M5 — PDF export ☐
- ☐ Full ledger PDF (summary, contribution grid, loan register, share-out sheet)
- ☐ Share sheet integration; export anytime + per archived cycle

## M6 — Backup & restore ☐
- ☐ Appwrite login + snapshot upload (manual button + auto after changes when online)
- ☐ Restore-on-fresh-install flow

## M7 — Ship ☐
- ☐ App icon + name polish ("QuickBucks", nice for mom)
- ☐ Test pass on Samsung A35 (owner to sideload)
- ☐ Release APK on GitHub Releases; short plain-English user guide (1 page, in-app + PDF)
