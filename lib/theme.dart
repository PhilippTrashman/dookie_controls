import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4290058082),
      surfaceTint: Color(4290058082),
      onPrimary: Color.fromARGB(255, 66, 66, 66),
      primaryContainer: Color(4294930596),
      onPrimaryContainer: Color(4281466902),
      secondary: Color(4288103008),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294944192),
      onSecondaryContainer: Color(4284289843),
      tertiary: Color(4288610388),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4293001338),
      onTertiaryContainer: Color(4294967295),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      background: Color.fromARGB(255, 219, 88, 88),
      onBackground: Color(4280621084),
      surface: Color(4294310654),
      onSurface: Color(4279704608),
      surfaceVariant: Color(4292601066),
      onSurfaceVariant: Color(4282337357),
      outline: Color(4285560958),
      outlineVariant: Color(4290758862),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086261),
      inverseOnSurface: Color(4293784054),
      inversePrimary: Color(4294947272),
      primaryFixed: Color(4294957538),
      onPrimaryFixed: Color(4282253341),
      primaryFixedDim: Color(4294947272),
      onPrimaryFixedVariant: Color(4287496266),
      secondaryFixed: Color(4294957538),
      onSecondaryFixed: Color(4282253341),
      secondaryFixedDim: Color(4294947272),
      onSecondaryFixedVariant: Color(4286130761),
      tertiaryFixed: Color(4294957538),
      onTertiaryFixed: Color(4282253341),
      tertiaryFixedDim: Color(4294947272),
      onTertiaryFixedVariant: Color(4287496266),
      surfaceDim: Color(4292270815),
      surfaceBright: Color(4294310654),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293981433),
      surfaceContainer: Color(4293586675),
      surfaceContainerHigh: Color(4293192173),
      surfaceContainerHighest: Color(4292797416),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4287037510),
      surfaceTint: Color(4290058082),
      onPrimary: Color.fromARGB(255, 136, 213, 243),
      primaryContainer: Color(4292031352),
      onPrimaryContainer: Color.fromARGB(255, 136, 213, 243),
      secondary: Color(4285802053),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4289877879),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4287037510),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4293001338),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      background: Color.fromARGB(255, 136, 213, 243),
      onBackground: Color(4280621084),
      surface: Color(4294310654),
      onSurface: Color(4279704608),
      surfaceVariant: Color(4292601066),
      onSurfaceVariant: Color(4282074185),
      outline: Color(4283981926),
      outlineVariant: Color(4285758593),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086261),
      inverseOnSurface: Color(4293784054),
      inversePrimary: Color(4294947272),
      primaryFixed: Color(4292031352),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4289794655),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4289877879),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4287905630),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4293001338),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4290052192),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292270815),
      surfaceBright: Color(4294310654),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293981433),
      surfaceContainer: Color(4293586675),
      surfaceContainerHigh: Color(4293192173),
      surfaceContainerHighest: Color(4292797416),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4283105316),
      surfaceTint: Color(4290058082),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4287037510),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4282974756),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4285802053),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4283105316),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4287037510),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294965496),
      onBackground: Color(4280621084),
      surface: Color(4294310654),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4292601066),
      onSurfaceVariant: Color(4280100138),
      outline: Color(4282074185),
      outlineVariant: Color(4282074185),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086261),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4294960875),
      primaryFixed: Color(4287037510),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4284350511),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4285802053),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4283960878),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4287037510),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4284350511),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292270815),
      surfaceBright: Color(4294310654),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293981433),
      surfaceContainer: Color(4293586675),
      surfaceContainerHigh: Color(4293192173),
      surfaceContainerHighest: Color(4292797416),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294947272),
      surfaceTint: Color(4294947272),
      onPrimary: Color(4284809267),
      primaryContainer: Color(4292031352),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4294947272),
      onSecondary: Color(4284289842),
      secondaryContainer: Color(4285604674),
      onSecondaryContainer: Color(4294952661),
      tertiary: Color(4294947272),
      onTertiary: Color(4284809267),
      tertiaryContainer: Color(4292935802),
      onTertiaryContainer: Color(4294967295),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      background: Color(4280029203),
      onBackground: Color(4294302946),
      surface: Color(4279178263),
      onSurface: Color(4292797416),
      surfaceVariant: Color(4282337357),
      onSurfaceVariant: Color(4290758862),
      outline: Color(4287206040),
      outlineVariant: Color(4282337357),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797416),
      inverseOnSurface: Color(4281086261),
      inversePrimary: Color(4290058082),
      primaryFixed: Color(4294957538),
      onPrimaryFixed: Color(4282253341),
      primaryFixedDim: Color(4294947272),
      onPrimaryFixedVariant: Color(4287496266),
      secondaryFixed: Color(4294957538),
      onSecondaryFixed: Color(4282253341),
      secondaryFixedDim: Color(4294947272),
      onSecondaryFixedVariant: Color(4286130761),
      tertiaryFixed: Color(4294957538),
      onTertiaryFixed: Color(4282253341),
      tertiaryFixedDim: Color(4294947272),
      onTertiaryFixedVariant: Color(4287496266),
      surfaceDim: Color(4279178263),
      surfaceBright: Color(4281678398),
      surfaceContainerLowest: Color(4278849298),
      surfaceContainerLow: Color(4279704608),
      surfaceContainer: Color(4279967780),
      surfaceContainerHigh: Color(4280625966),
      surfaceContainerHighest: Color(4281349433),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294948812),
      surfaceTint: Color(4294947272),
      onPrimary: Color(4281663511),
      primaryContainer: Color(4294464149),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294948812),
      onSecondary: Color(4281663511),
      secondaryContainer: Color(4292047763),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294948812),
      onTertiary: Color(4281663512),
      tertiaryContainer: Color(4294920342),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4280029203),
      onBackground: Color(4294302946),
      surface: Color(4279178263),
      onSurface: Color(4294507519),
      surfaceVariant: Color(4282337357),
      onSurfaceVariant: Color(4291022034),
      outline: Color(4288390314),
      outlineVariant: Color(4286350474),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797416),
      inverseOnSurface: Color(4280691502),
      inversePrimary: Color(4287627339),
      primaryFixed: Color(4294957538),
      onPrimaryFixed: Color(4281008146),
      primaryFixedDim: Color(4294947272),
      onPrimaryFixedVariant: Color(4285464632),
      secondaryFixed: Color(4294957538),
      onSecondaryFixed: Color(4281008146),
      secondaryFixedDim: Color(4294947272),
      onSecondaryFixedVariant: Color(4284750136),
      tertiaryFixed: Color(4294957538),
      onTertiaryFixed: Color(4281008146),
      tertiaryFixedDim: Color(4294947272),
      onTertiaryFixedVariant: Color(4285464633),
      surfaceDim: Color(4279178263),
      surfaceBright: Color(4281678398),
      surfaceContainerLowest: Color(4278849298),
      surfaceContainerLow: Color(4279704608),
      surfaceContainer: Color(4279967780),
      surfaceContainerHigh: Color(4280625966),
      surfaceContainerHighest: Color(4281349433),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294965753),
      surfaceTint: Color(4294947272),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4294948812),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294965753),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4294948812),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294965753),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4294948812),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4280029203),
      onBackground: Color(4294302946),
      surface: Color(4279178263),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4282337357),
      onSurfaceVariant: Color(4294441983),
      outline: Color(4291022034),
      outlineVariant: Color(4291022034),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797416),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4284022828),
      primaryFixed: Color(4294959078),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4294948812),
      onPrimaryFixedVariant: Color(4281663511),
      secondaryFixed: Color(4294959078),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4294948812),
      onSecondaryFixedVariant: Color(4281663511),
      tertiaryFixed: Color(4294959078),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4294948812),
      onTertiaryFixedVariant: Color(4281663512),
      surfaceDim: Color(4279178263),
      surfaceBright: Color(4281678398),
      surfaceContainerLowest: Color(4278849298),
      surfaceContainerLow: Color(4279704608),
      surfaceContainer: Color(4279967780),
      surfaceContainerHigh: Color(4280625966),
      surfaceContainerHighest: Color(4281349433),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
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
