# QuickBucks — Roadmap

Status legend: ☐ todo · ◐ in progress · ☑ done

## M0 — Planning ☑
- ☑ Requirements gathered & confirmed with owner (Slack DM, 2026-07-06)
- ☑ SPEC / ARCHITECTURE / DATA_MODEL written

## M1 — Domain engine (the money math) ☐
The most important milestone. Pure Dart, zero UI.
- ☐ `money.dart`, `dates.dart`, `loan_engine.dart`, `shareout.dart`, `ledger.dart`
- ☐ Exhaustive unit tests for every SPEC rule, incl. the confirmed worked example
  (Mary, $100, 2026-07-01) reproduced verbatim as a test
- ☐ Property test: Σ payouts == cash_on_hand for random scenarios

## M2 — App scaffold + storage ☐
- ☐ Flutter project in `app/`, Material 3 theme (green/gold, large type)
- ☐ drift schema per DATA_MODEL.md, DAOs
- ☐ Cycle creation flow (members + multipliers, start/end date)

## M3 — Daily use screens ☐
- ☐ Saturday contribution grid with manual ticks + backfill
- ☐ Loans: take loan, record payment, loan detail with chain history
- ☐ Overdue → rollover prompt flow (SPEC 3.6)
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
