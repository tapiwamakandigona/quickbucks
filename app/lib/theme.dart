import 'package:flutter/material.dart';

/// QuickBucks "Ledger on Paper" design system.
///
/// Warm paper surfaces + deep green ink, hairline borders instead of
/// shadows, one gold accent, and a fixed large-type scale (the treasurer
/// reads this at arm's length in a busy market). Money always renders in
/// tabular figures so columns of amounts line up like a real ledger.
///
/// Token discipline (adapted from LanLink v4): screens should never
/// hard-code a `Color(0x...)` or an ad-hoc font size — colors come from
/// `Theme.of(context).colorScheme` (+ [kGold]/[kDanger] semantics), sizes
/// from [QType], spacing from multiples of 4, radii from [QRadius].

// ─── Spacing: 4px scale ───────────────────────────────────────────────
abstract final class QSpace {
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x5 = 20;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x12 = 48;
}

// ─── Radius voice: "warm product" ─────────────────────────────────────
/// Controls 12, cards 16, sheets/dialogs 24. Nothing else.
abstract final class QRadius {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius sheetTop =
      BorderRadius.vertical(top: Radius.circular(lg));
}

// ─── Type scale: 13 / 15 / 17 / 18 / 20 / 24 / 28 / 40 ────────────────
/// Deliberately larger than a typical app: the sole user asked for big
/// readable numbers. `fontFamily` is set explicitly so golden tests don't
/// fall back to Ahem blocks.
abstract final class QType {
  static const String _font = 'Roboto';

  /// Hero numbers (share-out pot, dashboard money).
  static const TextStyle display = TextStyle(
    fontFamily: _font,
    fontSize: 40,
    height: 1.05,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Money amounts in cards and stats — tabular so digits align.
  static const TextStyle money = TextStyle(
    fontFamily: _font,
    fontSize: 28,
    height: 1.1,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle title = TextStyle(
      fontFamily: _font,
      fontSize: 24,
      height: 1.15,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3);
  static const TextStyle heading = TextStyle(
      fontFamily: _font,
      fontSize: 20,
      height: 1.2,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2);
  static const TextStyle bodyStrong = TextStyle(
      fontFamily: _font, fontSize: 18, height: 1.35, fontWeight: FontWeight.w600);
  static const TextStyle body =
      TextStyle(fontFamily: _font, fontSize: 17, height: 1.45);
  static const TextStyle label = TextStyle(
      fontFamily: _font,
      fontSize: 14,
      height: 1.3,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2);
  static const TextStyle caption =
      TextStyle(fontFamily: _font, fontSize: 13, height: 1.3);

  /// Small-caps style section label (stat headers).
  static const TextStyle overline = TextStyle(
      fontFamily: _font,
      fontSize: 13,
      height: 1.3,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8);
}

// ─── Semantic colors ──────────────────────────────────────────────────
/// Gold: celebrations, share-out, collection phase. The ONLY yellow.
const kGold = Color(0xFFA97F10);
const kGoldContainer = Color(0xFFF5E7C2);

/// Danger: overdue, errors. The ONLY red.
const kDanger = Color(0xFFA83224);
const kDangerContainer = Color(0xFFF6DAD4);

/// Ink for text on paper — never pure black.
const kInk = Color(0xFF23201A);

ThemeData quickbucksTheme() {
  const seed = Color(0xFF1B6E3C); // deep money green

  final scheme = ColorScheme.fromSeed(seedColor: seed).copyWith(
    primary: const Color(0xFF175E33),
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFD5EBDA),
    onPrimaryContainer: const Color(0xFF0D3A1E),
    secondary: kGold,
    secondaryContainer: kGoldContainer,
    onSecondaryContainer: const Color(0xFF453400),
    error: kDanger,
    errorContainer: kDangerContainer,
    // Paper: warm off-white; only the lowest card is near-white.
    surface: const Color(0xFFF7F3EA),
    onSurface: kInk,
    onSurfaceVariant: const Color(0xFF6E655A),
    surfaceContainerLowest: const Color(0xFFFFFEFA),
    surfaceContainerLow: const Color(0xFFF1EBDF),
    surfaceContainer: const Color(0xFFEBE3D4),
    surfaceContainerHigh: const Color(0xFFE4DACA),
    surfaceContainerHighest: const Color(0xFFDDD2C0),
    outline: const Color(0xFF8A7E6F),
    outlineVariant: const Color(0xFFE2D9C8),
    inverseSurface: const Color(0xFF332D24),
    surfaceTint: Colors.transparent,
  );

  final base = ThemeData(colorScheme: scheme, useMaterial3: true);

  return base.copyWith(
    scaffoldBackgroundColor: scheme.surface,
    textTheme: base.textTheme.copyWith(
      bodyMedium: base.textTheme.bodyMedium!.merge(QType.body),
      bodyLarge: base.textTheme.bodyLarge!.merge(QType.bodyStrong),
      titleMedium: base.textTheme.titleMedium!.merge(QType.heading),
      titleLarge: base.textTheme.titleLarge!.merge(QType.title),
      headlineMedium: base.textTheme.headlineMedium!.merge(QType.display),
    ),
    // Paper appbar, ink title — the ledger book, not a billboard.
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: QType.title.copyWith(color: scheme.onSurface),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 56),
        textStyle: QType.bodyStrong,
        shape: const RoundedRectangleBorder(borderRadius: QRadius.smAll),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 56),
        textStyle: QType.bodyStrong,
        foregroundColor: scheme.onSurface,
        side: BorderSide(color: scheme.outline),
        shape: const RoundedRectangleBorder(borderRadius: QRadius.smAll),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: QType.bodyStrong,
        foregroundColor: scheme.primary,
        shape: const RoundedRectangleBorder(borderRadius: QRadius.smAll),
      ),
    ),
    // Hairline borders on near-white plates; no shadows anywhere.
    cardTheme: base.cardTheme.copyWith(
      elevation: 0,
      color: scheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: QRadius.mdAll,
        side: BorderSide(color: scheme.outlineVariant),
      ),
      margin: const EdgeInsets.symmetric(
          horizontal: QSpace.x4, vertical: QSpace.x2 - 2),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: scheme.onSurfaceVariant,
      titleTextStyle: QType.bodyStrong.copyWith(color: scheme.onSurface),
      subtitleTextStyle: QType.caption
          .copyWith(fontSize: 15, color: scheme.onSurfaceVariant),
      minVerticalPadding: QSpace.x3,
    ),
    dividerTheme: DividerThemeData(
        color: scheme.outlineVariant, thickness: 1, space: 1),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(borderRadius: QRadius.smAll),
      enabledBorder: OutlineInputBorder(
          borderRadius: QRadius.smAll,
          borderSide: BorderSide(color: scheme.outline)),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: QSpace.x4, vertical: QSpace.x4 + 2),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: QRadius.sheetTop),
    ),
    dialogTheme: base.dialogTheme.copyWith(
      backgroundColor: scheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: QRadius.lgAll),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF332D24), // dark ink
      contentTextStyle: QType.body.copyWith(color: const Color(0xFFF4EFE4)),
      actionTextColor: const Color(0xFFEFC75E),
      shape: const RoundedRectangleBorder(borderRadius: QRadius.smAll),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      extendedTextStyle: QType.bodyStrong,
      shape: const RoundedRectangleBorder(borderRadius: QRadius.mdAll),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: scheme.primary,
      linearTrackColor: scheme.surfaceContainerHigh,
    ),
  );
}
