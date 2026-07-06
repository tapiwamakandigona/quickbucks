import 'package:flutter/material.dart';

/// Warm, friendly money theme: deep green + gold, generous type sizes and
/// touch targets — designed for the treasurer, not for developers.
ThemeData quickbucksTheme() {
  const seed = Color(0xFF1B6E3C); // deep money green
  const gold = Color(0xFFC9A227);

  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    secondary: gold,
    brightness: Brightness.light,
  );

  final base = ThemeData(colorScheme: scheme, useMaterial3: true);

  return base.copyWith(
    scaffoldBackgroundColor: const Color(0xFFF7F6F1),
    textTheme: base.textTheme.copyWith(
      // Bumped sizes: readable at arm's length in a busy market.
      bodyMedium: base.textTheme.bodyMedium!.copyWith(fontSize: 17),
      bodyLarge: base.textTheme.bodyLarge!.copyWith(fontSize: 18),
      titleMedium: base.textTheme.titleMedium!
          .copyWith(fontSize: 19, fontWeight: FontWeight.w600),
      titleLarge: base.textTheme.titleLarge!
          .copyWith(fontSize: 24, fontWeight: FontWeight.w700),
      headlineMedium: base.textTheme.headlineMedium!
          .copyWith(fontSize: 32, fontWeight: FontWeight.w800),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: seed,
      foregroundColor: Colors.white,
      titleTextStyle: base.textTheme.titleLarge!
          .copyWith(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 56),
        textStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 56),
        textStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    cardTheme: base.cardTheme.copyWith(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),
    listTileTheme: const ListTileThemeData(
      titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87),
      subtitleTextStyle:
          TextStyle(fontFamily: 'Roboto', fontSize: 15, color: Colors.black54),
      minVerticalPadding: 12,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      contentTextStyle: TextStyle(fontFamily: 'Roboto', fontSize: 16),
    ),
  );
}

/// Gold accent for highlights (share-out, celebrations).
const kGold = Color(0xFFC9A227);
const kDanger = Color(0xFFB3261E);
