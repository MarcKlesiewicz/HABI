import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

/// Forui's component theme, aligned with Habi's warm Material palette.
abstract final class AppForuiTheme {
  static final light = FThemeData(
    debugLabel: 'Habi Forui Light',
    colors: const FColors(
      brightness: Brightness.light,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      barrier: Color(0x520F0C0A),
      background: Color(0xFFFFFCF8),
      foreground: Color(0xFF26211F),
      primary: Color(0xFF2F2926),
      primaryForeground: Color(0xFFFFFCF8),
      secondary: Color(0xFFF3ECE5),
      secondaryForeground: Color(0xFF332C28),
      muted: Color(0xFFF6F1EB),
      mutedForeground: Color(0xFF746A64),
      destructive: Color(0xFFB2463D),
      destructiveForeground: Color(0xFFFFFFFF),
      error: Color(0xFFB2463D),
      errorForeground: Color(0xFFFFFFFF),
      border: Color(0xFFE2D9D1),
    ),
  );

  static final dark = FThemeData(
    debugLabel: 'Habi Forui Dark',
    colors: const FColors(
      brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      barrier: Color(0xA3000000),
      background: Color(0xFF211D1B),
      foreground: Color(0xFFF1E8E1),
      primary: Color(0xFFF1E8E1),
      primaryForeground: Color(0xFF26211F),
      secondary: Color(0xFF332D29),
      secondaryForeground: Color(0xFFF1E8E1),
      muted: Color(0xFF2B2623),
      mutedForeground: Color(0xFFBDAFA6),
      destructive: Color(0xFF8E3129),
      destructiveForeground: Color(0xFFFFDAD5),
      error: Color(0xFFFFB4AA),
      errorForeground: Color(0xFF681C15),
      border: Color(0xFF403934),
    ),
  );
}
