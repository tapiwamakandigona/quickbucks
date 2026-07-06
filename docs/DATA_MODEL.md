# QuickBucks — Data Model

All money fields are **integer cents**. All date fields are **local calendar dates**
(stored as `yyyy-MM-dd` text). Times/timezones never enter business logic.

## Entities

### Cycle
| Field | Type | Notes |
|---|---|---|
| id | uuid | |
| name | text | e.g. "2026 Round 1" (auto-suggested, editable) |
| start_date | date | |
| end_date | date? | optional at creation, **editable while active** |
| status | enum | `active` \| `ended` |
| ended_on | date? | set by reaching end_date or "End now" |
| weekly_unit_cents | int | 1000 ($10). Stored per cycle so a future change doesn't rewrite history |
| interest_pct | int | 20. Stored per cycle for the same reason |

Invariant: at most one `active` cycle.

### Member
| Field | Type | Notes |
|---|---|---|
| id | uuid | |
| cycle_id | fk | members belong to a cycle (roster re-entered per cycle; names can be prefilled from the previous cycle) |
| name | text | |
| multiplier | int ≥ 1 | **immutable once the cycle starts** |

### Contribution
| Field | Type | Notes |
|---|---|---|
| id | uuid | |
| cycle_id, member_id | fk | |
| saturday | date | must be a Saturday within the cycle |
| amount_cents | int | always `weekly_unit_cents × multiplier` |
| recorded_on | date | audit trail (backfilling allowed) |

Unique: (member_id, saturday).

### Loan
| Field | Type | Notes |
|---|---|---|
| id | uuid | |
| cycle_id, member_id | fk | |
| principal_cents | int | amount handed out (or rolled over) |
| owed_cents | int | `round_half_up(principal × 1.2)` |
| loan_date | date | disbursement date; for rollovers = the Sunday after parent's due Saturday |
| due_date | date | derived: Saturday on/after `loan_date + 30d` (SPEC 3.2) |
| status | enum | `active` \| `paid` \| `rolled_over` |
| parent_loan_id | fk? | set on rollover loans → full chain traceable |
| closed_on | date? | |

`outstanding = owed_cents − Σ payments` (derived, never stored).

### LoanPayment
| Field | Type | Notes |
|---|---|---|
| id | uuid | |
| loan_id | fk | payments target one specific loan |
| amount_cents | int | > 0, ≤ outstanding at time of entry |
| paid_on | date | ≤ due_date ⇒ on time (due Saturday itself is on time) |
| recorded_on | date | audit trail |

### ShareOut (one per ended cycle)
| Field | Type | Notes |
|---|---|---|
| id | uuid | |
| cycle_id | fk | |
| pot_cents | int | cash_on_hand + Σ outstanding at end |
| cash_cents | int | must equal Σ payout_cents (checked) |

### ShareOutLine
| Field | Type | Notes |
|---|---|---|
| share_out_id, member_id | fk | |
| multiplier | int | frozen copy |
| share_cents | int | largest-remainder split of pot |
| debt_deducted_cents | int | Σ outstanding of that member's active loans |
| payout_cents | int | share − debt, **may be negative** |

### BackupSnapshot (Appwrite side)
Full-ledger JSON, append-only, named `quickbucks-{deviceId}-{iso datetime}.json`.

## Derived views (not stored)

- `cash_on_hand`, `receivables`, `pool_value` — see SPEC §4.
- Contribution grid: members × Saturdays from cycle start to min(today, end_date).
- Overdue list: active loans with `due_date < today` → feeds the rollover prompt (SPEC 3.6).
