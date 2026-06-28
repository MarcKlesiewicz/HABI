import 'package:flutter/material.dart';

import 'app_constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => theme(lightScheme());

  static ThemeData get darkTheme => theme(darkScheme());

  static ThemeData get lightMediumContrast =>
      theme(lightScheme().copyWith(primary: const Color(0xFF9E4F45)));

  static ThemeData get lightHighContrast => theme(
    lightScheme().copyWith(
      primary: const Color(0xFF7B352E),
      outline: const Color(0xFF4B403C),
    ),
  );

  static ThemeData get darkMediumContrast =>
      theme(darkScheme().copyWith(primary: const Color(0xFFFFB7AA)));

  static ThemeData get darkHighContrast => theme(
    darkScheme().copyWith(
      primary: const Color(0xFFFFD2CA),
      outline: const Color(0xFFEDE1DC),
    ),
  );

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFC86858),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFF9DAD2),
      onPrimaryContainer: Color(0xFF4E211A),
      secondary: Color(0xFF342D2A),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFE9E1DA),
      onSecondaryContainer: Color(0xFF2E2825),
      tertiary: Color(0xFF687966),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFDCE8D6),
      onTertiaryContainer: Color(0xFF21331F),
      error: Color(0xFFB2463D),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFF8DAD6),
      onErrorContainer: Color(0xFF55140F),
      surface: Color(0xFFF3F0EA),
      onSurface: Color(0xFF26211F),
      onSurfaceVariant: Color(0xFF736963),
      outline: Color(0xFFCFC5BE),
      outlineVariant: Color(0xFFE3DCD5),
      shadow: Color(0xFF2B221E),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF302A27),
      onInverseSurface: Color(0xFFF7F1EC),
      inversePrimary: Color(0xFFFFB7AA),
      surfaceTint: Color(0xFFC86858),
      primaryFixed: Color(0xFFF9DAD2),
      onPrimaryFixed: Color(0xFF4E211A),
      primaryFixedDim: Color(0xFFEAB8AD),
      onPrimaryFixedVariant: Color(0xFF7B352E),
      secondaryFixed: Color(0xFFE9E1DA),
      onSecondaryFixed: Color(0xFF2E2825),
      secondaryFixedDim: Color(0xFFD9CEC6),
      onSecondaryFixedVariant: Color(0xFF5B514B),
      tertiaryFixed: Color(0xFFDCE8D6),
      onTertiaryFixed: Color(0xFF21331F),
      tertiaryFixedDim: Color(0xFFC0D3B9),
      onTertiaryFixedVariant: Color(0xFF4E604A),
      surfaceDim: Color(0xFFE7E0D8),
      surfaceBright: Color(0xFFFFFCF8),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFBF7F1),
      surfaceContainer: Color(0xFFF7F1EA),
      surfaceContainerHigh: Color(0xFFF0E8E0),
      surfaceContainerHighest: Color(0xFFE8DED6),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFB7AA),
      onPrimary: Color(0xFF5B251D),
      primaryContainer: Color(0xFF873E34),
      onPrimaryContainer: Color(0xFFFFDCD5),
      secondary: Color(0xFFE6DCD5),
      onSecondary: Color(0xFF312A27),
      secondaryContainer: Color(0xFF463C38),
      onSecondaryContainer: Color(0xFFF2E7E0),
      tertiary: Color(0xFFC0D3B9),
      onTertiary: Color(0xFF2B3A28),
      tertiaryContainer: Color(0xFF465842),
      onTertiaryContainer: Color(0xFFE1EDD9),
      error: Color(0xFFFFB4AA),
      onError: Color(0xFF681C15),
      errorContainer: Color(0xFF8E3129),
      onErrorContainer: Color(0xFFFFDAD5),
      surface: Color(0xFF171413),
      onSurface: Color(0xFFF1E8E1),
      onSurfaceVariant: Color(0xFFCFC3BA),
      outline: Color(0xFF655B55),
      outlineVariant: Color(0xFF3D3531),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFF1E8E1),
      onInverseSurface: Color(0xFF302A27),
      inversePrimary: Color(0xFFC86858),
      surfaceTint: Color(0xFFFFB7AA),
      primaryFixed: Color(0xFFFFDCD5),
      onPrimaryFixed: Color(0xFF4E211A),
      primaryFixedDim: Color(0xFFEAB8AD),
      onPrimaryFixedVariant: Color(0xFF7B352E),
      secondaryFixed: Color(0xFFE9E1DA),
      onSecondaryFixed: Color(0xFF2E2825),
      secondaryFixedDim: Color(0xFFD9CEC6),
      onSecondaryFixedVariant: Color(0xFF5B514B),
      tertiaryFixed: Color(0xFFDCE8D6),
      onTertiaryFixed: Color(0xFF21331F),
      tertiaryFixedDim: Color(0xFFC0D3B9),
      onTertiaryFixedVariant: Color(0xFF4E604A),
      surfaceDim: Color(0xFF171413),
      surfaceBright: Color(0xFF3B3430),
      surfaceContainerLowest: Color(0xFF100E0D),
      surfaceContainerLow: Color(0xFF211D1B),
      surfaceContainer: Color(0xFF282320),
      surfaceContainerHigh: Color(0xFF332D29),
      surfaceContainerHighest: Color(0xFF403934),
    );
  }

  static ThemeData theme(ColorScheme colorScheme) {
    final isLight = colorScheme.brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      textTheme: _textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        titleTextStyle: _textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      elevatedButtonTheme: elevatedButtonTheme(colorScheme),
      filledButtonTheme: filledButtonTheme(colorScheme),
      textButtonTheme: textButtonTheme(colorScheme),
      outlinedButtonTheme: outlinedButtonTheme(colorScheme),
      iconButtonTheme: iconButtonTheme(colorScheme),
      inputDecorationTheme: inputDecorationTheme(colorScheme),
      cardTheme: cardTheme(colorScheme),
      chipTheme: chipTheme(colorScheme),
      dividerTheme: dividerTheme(colorScheme),
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 10,
        shadowColor: colorScheme.shadow.withValues(alpha: isLight ? 0.12 : 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        ),
      ),
      segmentedButtonTheme: segmentedButtonTheme(colorScheme),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.onSurface,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
      ),
      switchTheme: switchTheme(colorScheme),
      checkboxTheme: checkboxTheme(colorScheme),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return colorScheme.onSurfaceVariant;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        thumbColor: colorScheme.primary,
      ),
    );
  }

  static final TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.02,
    ),
    displayMedium: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.06,
    ),
    displaySmall: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.08,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.12,
    ),
    headlineMedium: TextStyle(
      fontSize: 27,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.16,
    ),
    headlineSmall: TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.18,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.2,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.25,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.28,
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
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.44,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.38,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.32,
    ),
  );

  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return 0;
          if (states.contains(WidgetState.pressed)) return 1;
          return 8;
        }),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.10);
          }
          return colorScheme.secondary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.36);
          }
          return colorScheme.onSecondary;
        }),
        shadowColor: WidgetStateProperty.all(
          colorScheme.shadow.withValues(alpha: 0.18),
        ),
      ),
    );
  }

  static FilledButtonThemeData filledButtonTheme(ColorScheme colorScheme) {
    return FilledButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.10);
          }
          return colorScheme.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.36);
          }
          return colorScheme.onPrimary;
        }),
      ),
    );
  }

  static TextButtonThemeData textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          ),
        ),
        foregroundColor: WidgetStateProperty.all(colorScheme.primary),
      ),
    );
  }

  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          ),
        ),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return BorderSide(color: colorScheme.primary, width: 1.2);
          }
          return BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.9),
          );
        }),
        foregroundColor: WidgetStateProperty.all(colorScheme.onSurface),
        backgroundColor: WidgetStateProperty.all(
          colorScheme.surfaceContainerLowest.withValues(alpha: 0.42),
        ),
      ),
    );
  }

  static IconButtonThemeData iconButtonTheme(ColorScheme colorScheme) {
    return IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.34);
          }
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return colorScheme.onSurfaceVariant;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.onSurface.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.onSurface.withValues(alpha: 0.05);
          }
          return null;
        }),
      ),
    );
  }

  static InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
    final radius = BorderRadius.circular(AppConstants.radiusLG);

    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerLowest.withValues(alpha: 0.58),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      hintStyle: TextStyle(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.72),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colorScheme.error),
      ),
    );
  }

  static CardThemeData cardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      color: colorScheme.surfaceContainerLow.withValues(alpha: 0.86),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.72),
        ),
      ),
    );
  }

  static ChipThemeData chipTheme(ColorScheme colorScheme) {
    return ChipThemeData(
      backgroundColor: colorScheme.surfaceContainerHigh.withValues(alpha: 0.78),
      selectedColor: colorScheme.primaryContainer,
      disabledColor: colorScheme.surfaceContainerHighest,
      labelStyle: TextStyle(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      secondaryLabelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
    );
  }

  static DividerThemeData dividerTheme(ColorScheme colorScheme) {
    return DividerThemeData(
      color: colorScheme.outlineVariant.withValues(alpha: 0.72),
      thickness: 1,
      space: AppConstants.spacingMD,
    );
  }

  static SegmentedButtonThemeData segmentedButtonTheme(
    ColorScheme colorScheme,
  ) {
    return SegmentedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          ),
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.72)),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.secondary;
          }
          return colorScheme.surfaceContainerLowest.withValues(alpha: 0.46);
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onSecondary;
          }
          return colorScheme.onSurfaceVariant;
        }),
      ),
    );
  }

  static SwitchThemeData switchTheme(ColorScheme colorScheme) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return colorScheme.primary;
        return colorScheme.surfaceContainerLowest;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primaryContainer;
        }
        return colorScheme.surfaceContainerHighest;
      }),
    );
  }

  static CheckboxThemeData checkboxTheme(ColorScheme colorScheme) {
    return CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusXS),
      ),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return colorScheme.primary;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
      side: BorderSide(color: colorScheme.outline),
    );
  }
}

extension CustomColors on ColorScheme {
  Color get success => const Color(0xFF4F7D5A);

  Color get warning => const Color(0xFFB7833F);

  Color get info => const Color(0xFF557A95);

  Color get customPurple => const Color(0xFF8C83B5);

  Color get customTeal => const Color(0xFF6E9993);

  Color get customDarkBlue => const Color(0xFF2F5361);

  Color get customDarkGreen => const Color(0xFF637B65);
}
