/// Share-out math (SPEC 5).
///
/// pot      = cash_on_hand + Σ outstanding_i
/// share_i  = pot × multiplier_i / Σ multipliers   (largest-remainder, exact)
/// payout_i = share_i − outstanding_i              (may be NEGATIVE)
/// invariant: Σ payout_i == cash_on_hand, to the cent.
library;

class ShareOutLine {
  final String memberId;
  final int multiplier;
  final int shareCents;
  final int debtDeductedCents;
  final int payoutCents; // negative = member still owes the group
  ShareOutLine({
    required this.memberId,
    required this.multiplier,
    required this.shareCents,
    required this.debtDeductedCents,
    required this.payoutCents,
  });
}

class ShareOutResult {
  final int potCents;
  final int cashCents;
  final List<ShareOutLine> lines;
  ShareOutResult({
    required this.potCents,
    required this.cashCents,
    required this.lines,
  });
}

/// Splits [potCents] proportionally to integer [weights] so the parts sum to
/// the pot exactly: largest-remainder (Hamilton) method. Ties broken by the
/// larger fractional remainder first, then by lower index (stable/deterministic).
///
/// [quantumCents] sets the rounding unit: 1 = cent-exact (legacy), 100 =
/// whole-dollar shares (SPEC §0). The pot must be a multiple of the quantum.
List<int> largestRemainderSplit(int potCents, List<int> weights,
    {int quantumCents = 1}) {
  if (quantumCents < 1) throw ArgumentError('quantum must be >= 1');
  if (quantumCents > 1) {
    if (potCents % quantumCents != 0) {
      throw ArgumentError(
          'pot $potCents is not a multiple of quantum $quantumCents');
    }
    final units = _largestRemainderSplit(potCents ~/ quantumCents, weights);
    return [for (final u in units) u * quantumCents];
  }
  return _largestRemainderSplit(potCents, weights);
}

List<int> _largestRemainderSplit(int potCents, List<int> weights) {
  if (weights.isEmpty) throw ArgumentError('weights must not be empty');
  if (weights.any((w) => w <= 0)) {
    throw ArgumentError('all weights must be positive');
  }
  if (potCents < 0) throw ArgumentError('pot must be >= 0');
  final total = weights.reduce((a, b) => a + b);
  final floors = <int>[];
  final remainders = <int>[]; // numerator of the fractional part, per member
  for (final w in weights) {
    final exactNumerator = potCents * w; // over denominator `total`
    floors.add(exactNumerator ~/ total);
    remainders.add(exactNumerator % total);
  }
  var leftover = potCents - floors.reduce((a, b) => a + b);
  // Hand the leftover cents to the largest remainders.
  final order = List<int>.generate(weights.length, (i) => i)
    ..sort((a, b) {
      final cmp = remainders[b].compareTo(remainders[a]);
      return cmp != 0 ? cmp : a.compareTo(b);
    });
  final result = List<int>.of(floors);
  for (var k = 0; leftover > 0; k++, leftover--) {
    result[order[k]] += 1;
  }
  return result;
}

/// Computes the full share-out (SPEC 5).
///
/// [multipliers] and [outstandingByMember] are keyed by member id.
/// [cashCents] is cash on hand at cycle end.
///
/// Shares are computed in whole-dollar units when the pot allows it
/// (SPEC §0); legacy pots with coins fall back to cent-exact shares.
ShareOutResult computeShareOut({
  required int cashCents,
  required Map<String, int> multipliers,
  required Map<String, int> outstandingByMember,
}) {
  if (multipliers.isEmpty) throw ArgumentError('no members');
  final memberIds = multipliers.keys.toList(); // insertion order = roster order
  final totalOutstanding =
      memberIds.fold(0, (sum, id) => sum + (outstandingByMember[id] ?? 0));
  final pot = cashCents + totalOutstanding;
  final shares = largestRemainderSplit(
      pot, [for (final id in memberIds) multipliers[id]!],
      quantumCents: pot % 100 == 0 ? 100 : 1);

  final lines = <ShareOutLine>[];
  for (var i = 0; i < memberIds.length; i++) {
    final id = memberIds[i];
    final debt = outstandingByMember[id] ?? 0;
    lines.add(ShareOutLine(
      memberId: id,
      multiplier: multipliers[id]!,
      shareCents: shares[i],
      debtDeductedCents: debt,
      payoutCents: shares[i] - debt,
    ));
  }

  final payoutSum = lines.fold(0, (sum, l) => sum + l.payoutCents);
  if (payoutSum != cashCents) {
    throw StateError(
        'Share-out invariant broken: Σpayout=$payoutSum != cash=$cashCents');
  }
  return ShareOutResult(potCents: pot, cashCents: cashCents, lines: lines);
}
