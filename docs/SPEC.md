# QuickBucks — Business Rules (authoritative)

Source: requirements gathered from the owner (richiesmake / @tapiwamakandigona) in
Slack DM, 2026-07-06. Confirmed by him, including the worked interest example.
**If code and this document disagree, this document wins.** If a rule is unclear,
ask the owner — do not guess. Real people rely on these numbers.

All amounts are **USD, stored as integer cents**. All dates are **local calendar
dates** (no timezones/timestamps in business logic).

---

## 1. Cycle

- A **cycle** is one full run of the savings group.
- Created with: a **start date**, a list of **members**, and each member's
  **multiplier** (integer ≥ 1).
- Members and multipliers are **locked once the cycle starts** — they cannot be
  edited mid-cycle. Roster changes (new members, members leaving, new multipliers)
  happen when **starting the next cycle**.
- A cycle has an **end date** which is:
  - settable when the cycle is created (optional),
  - **editable at any time** while the cycle is active,
  - overridable with an **"End now"** button that ends the cycle immediately and
    triggers share-out.
- Ended cycles are **archived**: read-only, still viewable and PDF-exportable.
- Only **one active cycle** at a time.

## 2. Weekly contributions

- Every member owes **$10 × multiplier** each **Saturday** during the cycle.
- The treasurer ticks each member off **manually** (10 quick taps); the app never
  auto-marks anyone as paid.
- Backfilling past Saturdays is allowed (she may record later in the week).
- Historically nobody misses a payment; there are **no fines/penalties** in scope.
  The app should still make an unticked Saturday visible so it isn't forgotten.

## 3. Loans

### 3.1 Taking a loan
- Any member may borrow **any amount** at **any date** during the cycle
  (no cap — not by pool balance, not by savings).
- A member may hold **multiple loans at once; each is fully independent**.
- Flat interest: borrowing principal `P` means the member owes
  **`owed = round_half_up(1.2 × P)`** (in cents).

### 3.2 Due date rule
```
day30 = loan_date + 30 days
due   = day30 if day30 is a Saturday, else the next Saturday after day30
```
Examples (verified against the 2026 calendar):

| Loan taken | day 30 | Due Saturday |
|---|---|---|
| Wed 2026-07-01 | Fri 2026-07-31 | **Sat 2026-08-01** |
| Sat 2026-07-04 | Mon 2026-08-03 | **Sat 2026-08-08** |
| Thu 2026-07-09 | **Sat 2026-08-08** | **Sat 2026-08-08** (day 30 itself) |
| Sun 2026-08-02 | Tue 2026-09-01 | **Sat 2026-09-05** |

### 3.3 Repayments
- Any amount, any date, against a specific loan (loans are separate).
- A repayment **on or before the due Saturday** simply reduces the outstanding
  balance. **No extra interest, no new cycle.** Paying **on the due Saturday
  itself counts as on time.**

### 3.4 Rollover (the only overdue mechanism)
- Evaluated **from the Sunday after the due Saturday** (owner: "most people pay
  on the due date, so only start the loan thing on the Sunday afterwards").
- If outstanding `R > 0` after the due Saturday:
  - the original loan is closed with status `rolled_over`;
  - a **new, independent loan** is created:
    - `principal = R`
    - `loan_date = the Sunday after the due Saturday`
    - `owed = round_half_up(1.2 × R)`
    - due date per the rule in 3.2
    - linked to its parent (`parent_loan_id`) so chains are traceable.
- There are no other penalties; rollover chains can repeat indefinitely.

### 3.5 Confirmed worked example (owner said ✅)
Mary borrows **$100** on **Wed 2026-07-01** → owes **$120**, due **Sat 2026-08-01**.
She pays **$50** on 2026-07-20 → owes **$70**, same due date, no new interest.
The due Saturday passes with $70 unpaid → on **Sun 2026-08-02** a new loan is
created: she now owes **$84** ($70 + 20%), due **Sat 2026-09-05**
(day 30 = Tue 2026-09-01 → next Saturday).

### 3.6 Manual bookkeeping guard
Because the treasurer records payments by hand, the app must **not silently roll
over** a loan the moment the clock passes. On open, for each loan past its due
Saturday, show a prompt: *"This loan was due Sat X. Was any payment made?"* —
she can record a payment **dated on/before the due Saturday** (still on time) or
confirm the rollover. Regardless of when she confirms, the rollover's effective
`loan_date` is always the Sunday after the due Saturday.

## 4. Accounting identities

```
cash_on_hand = Σ contributions + Σ repayments − Σ loan principals paid out − Σ payouts
receivables  = Σ outstanding owed on active loans   (includes the 20%)
pool_value   = cash_on_hand + receivables
```
The app shows **both** cash on hand and pool value (owner confirmed).

## 5. Share-out (cycle end)

Triggered by reaching the end date or "End now".

```
pot      = cash_on_hand + Σ outstanding_i        (outstanding debts are settled against shares)
share_i  = pot × multiplier_i / Σ multipliers
payout_i = share_i − outstanding_i               (may be NEGATIVE)
```
- A negative `payout_i` is shown as a **negative final balance** on the member's
  balance sheet (owner confirmed) — the member still owes the group that amount.
- Sanity check the math: `Σ payout_i = cash_on_hand` (must hold to the cent).
- **Rounding:** compute shares in exact cents using the largest-remainder method
  so the shares sum exactly to the pot.

## 6. Records & PDF export

- **Every transaction is recorded**: contributions, loan disbursements,
  repayments, rollovers, share-out payouts — with dates.
- PDF export available **at any time**, and per archived cycle. Must include:
  1. Cycle summary (dates, members, multipliers, cash/pool totals)
  2. Contribution grid (member × Saturday)
  3. Loan register (every loan: principal, owed, dates, payments, rollover chain)
  4. Share-out balance sheet (share, debts deducted, final payout, negatives clearly marked)

## 7. Catch-up (historical records)

The group's **current cycle started Sat 2026-02-01 and ends Sat 2026-07-26**
(owner, 2026-07-06). The treasurer must be able to enter everything that already
happened and then continue live. Therefore:

- A cycle may be created with a **start date in the past**.
- **All record types accept past dates**: contributions (backfill the Saturday
  grid), loans (past `loan_date`), and payments (past `paid_on`).
- For a backdated loan whose due Saturday already passed, the rollover prompt
  (3.6) walks the chain forward chronologically: for each elapsed due date she
  records what actually happened (payments on/before the due Saturday, or
  confirms the rollover). Rollover effective dates remain the historical Sundays.
- Once caught up, the app behaves identically for live use — catch-up is just
  ordinary data entry with past dates, not a separate storage mode.

## 8. Users & platform

- **Single user:** the treasurer (owner's mother), Samsung Galaxy A35, Android.
- Distributed as an **APK** (like the owner's lanlink app).
- The app name is **QuickBucks** — the owner asked to "make it nice for her":
  friendly, large touch targets, plain English, no jargon.

## 9. Out of scope (explicitly)

- Fines/penalties for missed contributions (nobody misses).
- Loan caps.
- Editing multipliers mid-cycle.
- Multi-currency (USD only).
- Member logins / multi-user access.

## 10. Resolved questions

- Partial weekly contributions: **not needed** — tick = paid in full (owner confirmed 2026-07-06).
- Mid-cycle member joins: **not needed** — roster changes at new cycle only (owner confirmed 2026-07-06).
