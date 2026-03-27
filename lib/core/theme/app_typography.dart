import 'package:flutter/material.dart';

/// Typography scale with CJK-aware font stacks.
class AppTypography {
  const AppTypography._();

  // CJK font family — Noto Sans SC bundled in assets
  static const String cjkFontFamily = 'NotoSansSC';

  // Hanzi display — large character for flashcards and detail
  static TextStyle hanziDisplay(BuildContext context) => TextStyle(
        fontFamily: cjkFontFamily,
        fontSize: 64,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: Theme.of(context).colorScheme.onSurface,
      );

  // Hanzi in list items
  static TextStyle hanziListItem(BuildContext context) => TextStyle(
        fontFamily: cjkFontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: Theme.of(context).colorScheme.onSurface,
      );

  // Pinyin text
  static TextStyle pinyin(BuildContext context) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  // Pinyin small (in list items)
  static TextStyle pinyinSmall(BuildContext context) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  // Meaning text
  static TextStyle meaning(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: Theme.of(context).colorScheme.onSurface,
      );
}
