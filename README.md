# QuickBucks 💵

> A simple, friendly Android app that runs a weekly savings group (mukando/round):
> weekly contributions, loans with flat 20% interest, and a fair share-out at the end
> of the cycle — with a full PDF record of everything.

Built for **one user**: the group's treasurer (the owner's mother), on a
**Samsung Galaxy A35** (Android). Real people's money depends on this app, so
**correctness beats features** — every money rule is specified in
[`docs/SPEC.md`](docs/SPEC.md) and must be covered by unit tests.

## The group in one paragraph

~10 market vendors. Each member picks a **multiplier** (1, 2, 3, …) at the start of
a cycle and pays **$10 × multiplier every Saturday**. Members may borrow any amount
from the pool at any time; a loan carries a **flat 20%** charge and is due on the
**Saturday on/after day 30**. Anything unpaid after the due Saturday rolls into a
**new loan** (fresh 20%, fresh deadline). When the cycle ends, the pot is split in
proportion to multipliers, minus whatever each member still owes. USD only.

## Repo map

| Path | What it is |
|---|---|
| `docs/SPEC.md` | **Authoritative business rules.** If code and SPEC disagree, SPEC wins. |
| `docs/ARCHITECTURE.md` | Stack, storage, backup, PDF, project structure |
| `docs/DATA_MODEL.md` | Entities, fields, invariants |
| `docs/ROADMAP.md` | Milestones and current status |
| `AGENTS.md` | Handover notes for any developer or AI continuing this project |
| `app/` | The Flutter app (created in Milestone 1) |

## Ground rules

1. **Money is integer cents.** Never floats.
2. **Dates are local calendar dates** (no times, no timezones) — the group operates
   on "which day is it", not timestamps.
3. **Every rule in SPEC.md has a unit test** before it ships.
4. The treasurer records everything **manually** — the app prompts and verifies,
   it never silently invents transactions.
