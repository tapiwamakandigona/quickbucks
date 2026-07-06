# Handover notes (for any developer or AI continuing QuickBucks)

## Who's who
- **Owner:** GitHub `tapiwamakandigona`, Slack `richiesmake`. He commissioned this
  for his **mother**, the sole user — treasurer of a ~10-person vendors' savings
  group. She uses a Samsung Galaxy A35 (Android).
- Requirements were gathered in a Slack DM on 2026-07-06 and are frozen in
  `docs/SPEC.md`. The owner explicitly confirmed the interest worked example.

## Non-negotiables
1. **`docs/SPEC.md` is the source of truth.** Code follows SPEC, not vice versa.
   If something is ambiguous, **ask the owner** — never guess. Real money.
2. Money = integer cents. Dates = local calendar dates. No floats, no timezones.
3. Every SPEC rule keeps a passing unit test. Don't merge money-logic changes
   without tests. The confirmed example (SPEC 3.5) must exist verbatim as a test.
4. Payment **on** the due Saturday is on time. Rollover starts the **Sunday after**.
5. Never auto-mutate the ledger silently — the treasurer confirms everything
   (see SPEC 3.6 rollover prompt).

## Secrets
- **No credentials in this repo, ever.**
- Appwrite (cloud backup) account + GitHub access are held by the owner — ask him.
- The app itself stores the treasurer's Appwrite session on-device only.

## Conventions
- Flutter + provider + drift; mirror the owner's style in his `lanlink` repo
  (feature folders under `lib/`, plain-English user-facing strings).
- Branches: `feat/…`, `fix/…`; PRs against `main`; keep `docs/ROADMAP.md` statuses
  updated as milestones land.
- Release APKs go on GitHub Releases of this repo.

## Current state
See `docs/ROADMAP.md` — M0 (planning) done; next up M1 (domain engine + tests).
