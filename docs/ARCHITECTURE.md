# QuickBucks — Architecture

## Stack decision

| Layer | Choice | Why |
|---|---|---|
| App | **Flutter** (Dart 3, Material 3) | Owner's stack (see his `lanlink` repo); single codebase; ships as APK |
| State | `provider` | Matches lanlink conventions the owner already knows |
| Local DB | **drift (SQLite)** — source of truth | Offline-first: the treasurer is a market vendor, connectivity can't be assumed. All money logic runs locally. |
| Cloud backup | **Appwrite Cloud** | Owner supplied an Appwrite account. Used for **backup/restore only**, not as the primary DB. Protects against phone loss/replacement. |
| PDF | `pdf` + `printing` packages | Generate the ledger locally, share via the Android share sheet |
| Money | integer **cents** (`int`) | No floats, ever |
| Dates | ISO local calendar dates (`yyyy-MM-dd` strings / `DateTime` date-only, tz-free) | The group runs on calendar days, not instants |

## Why local-first + backup (not Appwrite-primary)

- Single user, single device → no concurrent writers, no sync conflicts.
- Must work with zero connectivity at the market.
- Backup = periodic (and on-demand) upload of a full JSON snapshot of the ledger
  to Appwrite Storage under the treasurer's account, plus restore-on-fresh-install.
  Snapshots are append-only (keep history) so a bad state can be recovered.
- Appwrite login credentials are held by the owner — **never commit credentials
  to this repo.**

## Domain layer (the part that must be perfect)

Pure Dart, no Flutter imports, 100% unit-tested. Lives as a standalone package at
`packages/quickbucks_domain/` (the Flutter app depends on it by path), so the money
math can be developed and tested with the plain Dart SDK and never entangles UI:

```
packages/quickbucks_domain/lib/src/
├── money.dart          # cents type, round_half_up, formatting ($1,234.50)
├── dates.dart          # Saturday math: dueDateFor(loanDate), next/prevSaturday, saturdaysBetween
├── loan_engine.dart    # owed = 1.2×P, repayment application, rollover generation (Sunday rule)
├── shareout.dart       # pot, largest-remainder share split, payouts (can be negative), Σpayout==cash check
└── ledger.dart         # accounting identities: cash_on_hand, receivables, pool_value
```

Key invariants enforced by tests (see SPEC.md for the rules):

1. `dueDateFor` = same date next month (clamped to month end), rolled to Saturday on/after.
2. Payment on the due Saturday is on time; rollover only from the Sunday after.
3. Rollover: new loan `principal = remainder`, `loan_date = that Sunday`, fresh 20%.
4. `Σ payout_i == cash_on_hand` exactly, in cents, for arbitrary inputs.
5. Share split uses largest-remainder so `Σ share_i == pot` exactly.

## App structure

```
app/lib/
├── domain/            # pure business logic (above)
├── data/              # drift tables, DAOs, backup/restore (Appwrite)
├── ui/
│   ├── home/          # dashboard: cash on hand, pool value, due-soon loans, this-Saturday tick status
│   ├── cycle/         # create cycle, edit end date, End Now + share-out flow, archive browser
│   ├── contributions/ # Saturday grid, tick members, backfill
│   ├── loans/         # loan list (active/overdue/closed), take loan, record payment, rollover prompts
│   ├── members/       # roster view (read-only mid-cycle)
│   └── reports/       # PDF preview + export/share
└── app.dart
```

## UX principles ("make it nice for her")

- Large type & touch targets, high contrast, warm green/gold money palette.
- Plain English everywhere: "Mary owes $84, due Sat 5 Sep", never "receivable".
- Every money action gets a confirmation with the numbers restated.
- Overdue loans surface as a friendly prompt on open (SPEC 3.6), never silent mutation.
- Home screen answers the treasurer's three questions at a glance:
  *How much cash do we have? Who owes what? Is this Saturday ticked off?*

## Distribution

- Release APKs built with `flutter build apk --release`, attached to GitHub Releases
  on this repo (same pattern as owner's lanlink / lanlink-downloads).
- Target: Android (minSdk 26 is plenty; the device is a Samsung Galaxy A35).
