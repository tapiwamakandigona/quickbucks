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

## v1.1 (owner-approved 2026-07-06) — SHIPPED
- ☑ Member detail screen + shareable per-member statement PDF
- ☑ Undo snackbars (ticks, loans, payments) with rollover-safe guards
- ☑ WhatsApp share-out summary message
- ☑ Split-per-abi APKs (57.8MB → 22MB arm64)
- ☑ Sentry crash reporting (gated on --dart-define=SENTRY_DSN; owner to provide DSN)
- ☑ Inline error text inside bottom sheets (was hidden behind sheet)
- ☐ Appwrite cloud backup (v1.2)

## v1.1.1 (2026-07-06) — UI: "Ledger on Paper"
- ☑ Token design system in app/lib/theme.dart (QSpace/QRadius/QType, tabular money figures)
- ☑ Warm paper surfaces + green ink, hairline borders instead of shadows, paper appbar
- ☑ Flat FAB, gold/danger container tokens, floating dark-ink snackbars
- Inspired by owner's subagent-toolkit frontend-design skill + LanLink v4 "Ember on Paper"

## v1.2.0 (2026-07-06) — owner picks 1, 3, 4, 5 + PDF quality pass
- ☑ Saturday reminder: weekly local notification Sat 08:00 (opt-in toggle in settings, auto-clears when weekly payments end; survives reboot; no exact-alarm permission)
- ☑ Loan preview: "Mary will owe $180.00 by Sat, 8 Aug 2026" live in the new-loan sheet before saving
- ☑ Share-out slips PDF: one dashed-border slip per member, 3 per A4 page (button on share-out screen)
- ☑ Auto-backup: daily snapshot to app storage after every change (keeps 7), "Automatic backups" restore list in settings
- ☑ Auto-lock: PIN asked again after 30s outside the app
- ☑ PDFs: bundled DejaVu font (built-in Helvetica cannot print ✓/—), human dates, one page per category; permanent render harness (test/pdf_render_test.dart)
