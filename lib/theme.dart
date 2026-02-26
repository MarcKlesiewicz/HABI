import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffc927c),
      surfaceTint: Color(0xffffb4a5),
      onPrimary: Color(0xff561f13),
      primaryContainer: Color(0xff733427),
      onPrimaryContainer: Color(0xffffdad3),
      secondary: Color(0xff9acbfa),
      onSecondary: Color(0xff003352),
      secondaryContainer: Color(0xff0b4a72),
      onSecondaryContainer: Color(0xffcde5ff),
      tertiary: Color(0xffedc06c),
      onTertiary: Color(0xff412d00),
      tertiaryContainer: Color(0xff5e4200),
      onTertiaryContainer: Color(0xffffdea7),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff231917),
      onSurfaceVariant: Color(0xff534340),
      outline: Color(0xff85736f),
      outlineVariant: Color(0xffd8c2bd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff392e2c),
      inversePrimary: Color(0xffffb4a5),
      primaryFixed: Color(0xffffdad3),
      onPrimaryFixed: Color(0xff3a0a03),
      primaryFixedDim: Color(0xffffb4a5),
      onPrimaryFixedVariant: Color(0xff733427),
      secondaryFixed: Color(0xffcde5ff),
      onSecondaryFixed: Color(0xff001d32),
      secondaryFixedDim: Color(0xff9acbfa),
      onSecondaryFixedVariant: Color(0xff0b4a72),
      tertiaryFixed: Color(0xffffdea7),
      onTertiaryFixed: Color(0xff271900),
      tertiaryFixedDim: Color(0xffedc06c),
      onTertiaryFixedVariant: Color(0xff5e4200),
      surfaceDim: Color(0xffe8d6d3),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ee),
      surfaceContainer: Color(0xfffceae6),
      surfaceContainerHigh: Color(0xfff7e4e1),
      surfaceContainerHighest: Color(0xfff1dfdb),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
