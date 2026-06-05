import 'package:flutter/material.dart';
import 'app_constants.dart';

/// AppTheme provides light and dark theme configurations with Material 3 support
/// Generated with Flutter Theme Generator - Clean, modular, and maintainable
///
/// Features:
/// ✅ Uses AppConstants for consistent design tokens
/// ✅ Modular structure with separate theme components
/// ✅ Material 3 compliant color schemes
/// ✅ Support for 6 contrast modes (light, dark, medium/high contrast variants)
/// ✅ Production-ready with proper type declarations
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎨 PUBLIC THEME GETTERS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Light theme configuration
  static ThemeData get lightTheme => theme(lightScheme());

  /// Dark theme configuration
  static ThemeData get darkTheme => theme(darkScheme());

  /// Light medium contrast theme
  static ThemeData get lightMediumContrast =>
      theme(lightMediumContrastScheme());

  /// Light high contrast theme
  static ThemeData get lightHighContrast => theme(lightHighContrastScheme());

  /// Dark medium contrast theme
  static ThemeData get darkMediumContrast => theme(darkMediumContrastScheme());

  /// Dark high contrast theme
  static ThemeData get darkHighContrast => theme(darkHighContrastScheme());

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🌈 COLOR SCHEMES - Material 3 compliant
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Light color scheme
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFFFA09E),
      surfaceTint: Color(0xFFFFA09E),
      onPrimary: Color(0xFF3F1717),
      primaryContainer: Color(0xFFFFD7D4),
      onPrimaryContainer: Color(0xFF5B2221),
      secondary: Color(0xFF251D24),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFECE3EA),
      onSecondaryContainer: Color(0xFF251D24),
      tertiary: Color(0xFF657A67),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFDDE8DB),
      onTertiaryContainer: Color(0xFF203323),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      surface: Color(0xFFF4ECEA),
      onSurface: Color(0xFF251D24),
      onSurfaceVariant: Color(0xFF6F626B),
      outline: Color(0xFFD5C5CA),
      outlineVariant: Color(0xFFE6D9DC),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF251D24),
      onInverseSurface: Color(0xFFFDF8F6),
      inversePrimary: Color(0xFFFFB9B7),
      primaryFixed: Color(0xFFFFD7D4),
      onPrimaryFixed: Color(0xFF5B2221),
      primaryFixedDim: Color(0xFFFFC3C0),
      onPrimaryFixedVariant: Color(0xFF8A3D3B),
      secondaryFixed: Color(0xFFECE3EA),
      onSecondaryFixed: Color(0xFF251D24),
      secondaryFixedDim: Color(0xFFDCCFD8),
      onSecondaryFixedVariant: Color(0xFF514651),
      tertiaryFixed: Color(0xFFDDE8DB),
      onTertiaryFixed: Color(0xFF203323),
      tertiaryFixedDim: Color(0xFFC3D5C1),
      onTertiaryFixedVariant: Color(0xFF485D4A),
      surfaceDim: Color(0xFFE8DDDC),
      surfaceBright: Color(0xFFFFFBFA),
      surfaceContainerLowest: Color(0xFFFFFBFA),
      surfaceContainerLow: Color(0xFFFCF6F4),
      surfaceContainer: Color(0xFFF9F1EF),
      surfaceContainerHigh: Color(0xFFF0E6E4),
      surfaceContainerHighest: Color(0xFFE8DDDC),
    );
  }

  /// Dark color scheme
  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFB9B7),
      surfaceTint: Color(0xFFFFB9B7),
      onPrimary: Color(0xFF4B1C1C),
      primaryContainer: Color(0xFF763331),
      onPrimaryContainer: Color(0xFFFFDAD7),
      secondary: Color(0xFFF0E5EC),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFF352A34),
      onSecondaryContainer: Color(0xFFF0E5EC),
      tertiary: Color(0xFFC3D5C1),
      onTertiary: Color(0xFF1D2D1F),
      tertiaryContainer: Color(0xFF465A48),
      onTertiaryContainer: Color(0xFFDDE8DB),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF000000),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFFFFF),
      surface: Color(0xFF171214),
      onSurface: Color(0xFFF0E7E6),
      onSurfaceVariant: Color(0xFFCDBFC5),
      outline: Color(0xFF5C4D54),
      outlineVariant: Color(0xFF352A34),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFF0E7E6),
      onInverseSurface: Color(0xFF251D24),
      inversePrimary: Color(0xFFFF7D7A),
      primaryFixed: Color(0xFFFFD7D4),
      onPrimaryFixed: Color(0xFF5B2221),
      primaryFixedDim: Color(0xFFFFC3C0),
      onPrimaryFixedVariant: Color(0xFF8A3D3B),
      secondaryFixed: Color(0xFFECE3EA),
      onSecondaryFixed: Color(0xFF251D24),
      secondaryFixedDim: Color(0xFFDCCFD8),
      onSecondaryFixedVariant: Color(0xFF514651),
      tertiaryFixed: Color(0xFFDDE8DB),
      onTertiaryFixed: Color(0xFF203323),
      tertiaryFixedDim: Color(0xFFC3D5C1),
      onTertiaryFixedVariant: Color(0xFF485D4A),
      surfaceDim: Color(0xFF171214),
      surfaceBright: Color(0xFF352A34),
      surfaceContainerLowest: Color(0xFF0F0B0D),
      surfaceContainerLow: Color(0xFF1E171B),
      surfaceContainer: Color(0xFF251D24),
      surfaceContainerHigh: Color(0xFF352A34),
      surfaceContainerHighest: Color(0xFF423640),
    );
  }

  /// Light medium contrast color scheme
  static ColorScheme lightMediumContrastScheme() {
    return lightScheme().copyWith(
      primary: Color(0xFFd77e53),
      surface: Color(0xFFfaf6f9),
    );
  }

  /// Light high contrast color scheme
  static ColorScheme lightHighContrastScheme() {
    return lightScheme().copyWith(
      primary: Color(0xFFc86f44),
      surface: Color(0xFFf5f1f4),
      outline: const Color(0xff000000),
    );
  }

  /// Dark medium contrast color scheme
  static ColorScheme darkMediumContrastScheme() {
    return darkScheme().copyWith(
      primary: Color(0xFFe1885d),
      surface: Color(0xFF150e12),
    );
  }

  /// Dark high contrast color scheme
  static ColorScheme darkHighContrastScheme() {
    return darkScheme().copyWith(
      primary: Color(0xFFf0976c),
      surface: Color(0xFF1a1317),
      outline: const Color(0xffffffff),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎯 MAIN THEME BUILDER - Clean and modular structure
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Main theme function that combines all theme components
  /// Uses clean, modular structure with proper AppConstants integration
  static ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: _textTheme,
    appBarTheme: colorScheme.brightness == Brightness.light
        ? _lightAppBarTheme
        : _darkAppBarTheme,
    elevatedButtonTheme: elevatedButtonTheme(colorScheme),
    filledButtonTheme: filledButtonTheme(colorScheme),
    textButtonTheme: textButtonTheme(colorScheme),
    outlinedButtonTheme: outlinedButtonTheme(colorScheme),
    iconButtonTheme: iconButtonTheme(colorScheme),
    inputDecorationTheme: _inputDecorationTheme,
    cardTheme: _cardTheme,
    chipTheme: _chipTheme,
    progressIndicatorTheme: _progressIndicatorTheme,
    dividerTheme: _dividerTheme,
    bottomNavigationBarTheme: _bottomNavigationBarTheme,
    tabBarTheme: _tabBarTheme,
    switchTheme: switchTheme(colorScheme),
    checkboxTheme: _checkboxTheme,
    radioTheme: _radioTheme,
    sliderTheme: _sliderTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎨 THEME COMPONENTS - All using AppConstants for consistency
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Text theme using AppConstants for consistent font sizes
  static final TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 44,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.05,
    ),
    displayMedium: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.08,
    ),
    displaySmall: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.12,
    ),
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.14,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.18,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.2,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.22,
    ),
    titleMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.28,
    ),
    titleSmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.24,
    ),
    labelLarge: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.22,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.2,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.18,
    ),
    bodyLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.42,
    ),
    bodyMedium: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.36,
    ),
    bodySmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.28,
    ),
  );

  /// Elevated button theme - M3 compliant with WidgetStateProperty
  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return 0;
            if (states.contains(WidgetState.hovered)) {
              return AppConstants.elevationLevel3;
            }
            if (states.contains(WidgetState.pressed)) {
              return AppConstants.elevationLevel1;
            }
            return AppConstants.elevationLevel2;
          }),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLG,
              vertical: AppConstants.spacingMD,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            ),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.12);
            }
            return colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.onPrimary;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.onPrimary.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.onPrimary.withValues(alpha: 0.08);
            }
            if (states.contains(WidgetState.focused)) {
              return colorScheme.onPrimary.withValues(alpha: 0.1);
            }
            return null;
          }),
          shadowColor: WidgetStateProperty.all(colorScheme.shadow),
        ),
      );

  /// Filled button theme - M3 compliant with WidgetStateProperty
  static FilledButtonThemeData filledButtonTheme(ColorScheme colorScheme) =>
      FilledButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLG,
              vertical: AppConstants.spacingMD,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            ),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.12);
            }
            return colorScheme.secondaryContainer;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.onSecondaryContainer;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.onSecondaryContainer.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.onSecondaryContainer.withValues(alpha: 0.08);
            }
            return null;
          }),
        ),
      );

  /// Text button theme - M3 compliant with WidgetStateProperty
  static TextButtonThemeData textButtonTheme(ColorScheme colorScheme) =>
      TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLG,
              vertical: AppConstants.spacingMD,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            ),
          ),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.primary;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary.withValues(alpha: 0.08);
            }
            if (states.contains(WidgetState.focused)) {
              return colorScheme.primary.withValues(alpha: 0.1);
            }
            return null;
          }),
        ),
      );

  /// Outlined button theme - M3 compliant with WidgetStateProperty
  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colorScheme) =>
      OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLG,
              vertical: AppConstants.spacingMD,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            ),
          ),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(
                color: colorScheme.onSurface.withValues(alpha: 0.12),
              );
            }
            if (states.contains(WidgetState.focused)) {
              return BorderSide(color: colorScheme.primary);
            }
            return BorderSide(color: colorScheme.outline);
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.primary;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary.withValues(alpha: 0.08);
            }
            return null;
          }),
        ),
      );

  /// Icon button theme - M3 compliant with WidgetStateProperty
  static IconButtonThemeData iconButtonTheme(ColorScheme colorScheme) =>
      IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.onSurfaceVariant;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.onSurfaceVariant.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.onSurfaceVariant.withValues(alpha: 0.08);
            }
            return null;
          }),
        ),
      );

  /// Input decoration theme
  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMD,
          vertical: AppConstants.spacingMD,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
      );

  /// App bar theme for light mode
  static final AppBarTheme _lightAppBarTheme = AppBarTheme(
    elevation: AppConstants.elevationLevel1,
    centerTitle: false,
    titleSpacing: AppConstants.spacingMD,
    scrolledUnderElevation: AppConstants.elevationLevel1,
  );

  /// App bar theme for dark mode
  static final AppBarTheme _darkAppBarTheme = AppBarTheme(
    elevation: AppConstants.elevationLevel1,
    centerTitle: false,
    titleSpacing: AppConstants.spacingMD,
    scrolledUnderElevation: AppConstants.elevationLevel1,
  );

  /// Card theme
  static final CardThemeData _cardTheme = CardThemeData(
    elevation: AppConstants.elevationLevel1,
    margin: EdgeInsets.all(AppConstants.spacingSM),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusLG),
    ),
  );

  /// Chip theme
  static final ChipThemeData _chipTheme = ChipThemeData(
    padding: EdgeInsets.symmetric(
      horizontal: AppConstants.spacingMD,
      vertical: AppConstants.spacingSM,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
    ),
  );

  /// Progress indicator theme
  static final ProgressIndicatorThemeData _progressIndicatorTheme =
      ProgressIndicatorThemeData();

  /// Divider theme
  static final DividerThemeData _dividerTheme = DividerThemeData(
    thickness: AppConstants.borderWidthThin,
    space: AppConstants.spacingMD,
  );

  /// Bottom navigation bar theme
  static final BottomNavigationBarThemeData _bottomNavigationBarTheme =
      BottomNavigationBarThemeData(type: BottomNavigationBarType.fixed);

  /// Tab bar theme
  static final TabBarThemeData _tabBarTheme = TabBarThemeData(
    labelPadding: EdgeInsets.symmetric(
      horizontal: AppConstants.spacingMD,
      vertical: AppConstants.spacingSM,
    ),
  );

  /// Switch theme - uses colorScheme from theme() parameter
  static SwitchThemeData switchTheme(ColorScheme colorScheme) =>
      SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer;
          }
          return null;
        }),
      );

  /// Checkbox theme
  static final CheckboxThemeData _checkboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusXS),
    ),
  );

  /// Radio theme
  static final RadioThemeData _radioTheme = RadioThemeData();

  /// Slider theme
  static final SliderThemeData _sliderTheme = SliderThemeData();
}

/// Custom theme colors extension for additional brand colors
extension CustomColors on ColorScheme {
  /// Success color for positive actions and states
  Color get success => const Color(0xFF2E7D32);

  /// Warning color for caution states
  Color get warning => const Color(0xFFF57C00);

  /// Info color for informational states
  Color get info => const Color(0xFF1976D2);

  Color get customPurple => const Color(0xFFa199fd);

  Color get customTeal => const Color(0xFF5ec8c3);

  Color get customDarkBlue => const Color(0xFF134b64);

  Color get customDarkGreen => const Color(0xFF679a88);
}
