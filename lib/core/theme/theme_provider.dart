import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solo_leveling/core/theme/app_themes.dart';
import 'package:solo_leveling/core/services/app_preferences.dart';

class ThemeState {
  final ThemeMode themeMode;
  final AppThemePreset preset;
  final bool pureDark;

  const ThemeState({
    required this.themeMode,
    required this.preset,
    required this.pureDark,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    AppThemePreset? preset,
    bool? pureDark,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      preset: preset ?? this.preset,
      pureDark: pureDark ?? this.pureDark,
    );
  }
}

final themeProvider = NotifierProvider<ThemeController, ThemeState>(
  () => ThemeController(),
);

class ThemeController extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    return _loadState();
  }

  ThemeState _loadState() {
    final themeStr = AppPreferences.getPreference(AppPreferences.keyTheme);
    final presetStr = AppPreferences.getPreference(
      AppPreferences.keyThemePreset,
    );
    final pureDark =
        AppPreferences.getPreferenceBool(AppPreferences.keyPureDark) ?? true;

    final themeMode = switch (themeStr) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.dark,
    };

    final preset = AppThemes.presets.firstWhere(
      (p) => p.name == presetStr,
      orElse: () => AppThemes.soloLeveling,
    );

    return ThemeState(themeMode: themeMode, preset: preset, pureDark: pureDark);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await AppPreferences.setPreference(AppPreferences.keyTheme, value);
  }

  Future<void> setPreset(AppThemePreset preset) async {
    state = state.copyWith(preset: preset);
    await AppPreferences.setPreference(
      AppPreferences.keyThemePreset,
      preset.name,
    );
  }

  Future<void> togglePureDark() async {
    final pureDark = !state.pureDark;
    state = state.copyWith(pureDark: pureDark);
    await AppPreferences.setPreferenceBool(
      AppPreferences.keyPureDark,
      pureDark,
    );
  }
}

class FadePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

/// Light-mode readable text color (dark, visible on light backgrounds).
const lightOnSurface = Color(0xFF1A1A2E);

ThemeData buildTheme(
  ColorScheme colorScheme,
  Brightness brightness,
  bool pureDark,
) {
  final isDark = brightness == Brightness.dark;

  final accent = SystemColors.accent;
  final shadowViolet = SystemColors.shadowViolet;

  Color backgroundColor;
  Color surfaceColor;
  Color onSurfaceColor;
  Color appBarForegroundColor;
  Color cardColor;
  Color dialogBackgroundColor;
  Color bottomSheetBackgroundColor;
  Color snackBarBackgroundColor;
  Brightness statusBarIconBrightness;
  Brightness navBarIconBrightness;

  if (isDark) {
    backgroundColor = SystemColors.background;
    surfaceColor = SystemColors.surfaceElevated;
    onSurfaceColor = SystemColors.text;
    appBarForegroundColor = SystemColors.text;
    cardColor = SystemColors.surface;
    dialogBackgroundColor = SystemColors.surfaceElevated;
    bottomSheetBackgroundColor = SystemColors.surfaceElevated;
    snackBarBackgroundColor = SystemColors.surfaceElevated;
    statusBarIconBrightness = Brightness.light;
    navBarIconBrightness = Brightness.light;
  } else {
    backgroundColor = Color.alphaBlend(
      accent.withValues(alpha: 0.03),
      const Color(0xFFF8F9FC),
    );
    surfaceColor = Colors.white;
    onSurfaceColor = lightOnSurface;
    appBarForegroundColor = lightOnSurface;
    cardColor = Colors.white;
    dialogBackgroundColor = Colors.white;
    bottomSheetBackgroundColor = Colors.white;
    snackBarBackgroundColor = Colors.white;
    statusBarIconBrightness = Brightness.dark;
    navBarIconBrightness = Brightness.dark;
  }

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme.copyWith(
      primary: accent,
      secondary: shadowViolet,
      tertiary: shadowViolet,
      onPrimary: const Color(0xFF002A2E),
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      surface: surfaceColor,
      onSurface: onSurfaceColor,
      outline: accent.withValues(alpha: 0.4),
      outlineVariant: accent.withValues(alpha: 0.2),
    ),
    scaffoldBackgroundColor: backgroundColor,
    dividerTheme: DividerThemeData(color: accent.withValues(alpha: 0.15)),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: FadePageTransitionsBuilder(),
        TargetPlatform.iOS: FadePageTransitionsBuilder(),
        TargetPlatform.linux: FadePageTransitionsBuilder(),
        TargetPlatform.macOS: FadePageTransitionsBuilder(),
        TargetPlatform.windows: FadePageTransitionsBuilder(),
      },
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: statusBarIconBrightness,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: navBarIconBrightness,
      ),
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      foregroundColor: appBarForegroundColor,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: accent.withValues(alpha: 0.4), width: 1),
      ),
      color: cardColor,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: dialogBackgroundColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: accent.withValues(alpha: 0.5), width: 1),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: bottomSheetBackgroundColor,
      surfaceTintColor: Colors.transparent,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accent,
      foregroundColor: const Color(0xFF002A2E),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: const Color(0xFF002A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: snackBarBackgroundColor,
      contentTextStyle: const TextStyle(
        color: SystemColors.accent,
        fontFamily: 'monospace',
        letterSpacing: 0.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: accent.withValues(alpha: 0.5), width: 1),
      ),
    ),
    textTheme: Typography.material2021(platform: TargetPlatform.android)
        .black
        .apply(
          bodyColor: isDark ? SystemColors.text : lightOnSurface,
          displayColor: isDark ? SystemColors.text : lightOnSurface,
          fontFamily: 'monospace',
        ),
  );
}

final doubleTapToExitProvider =
    NotifierProvider<DoubleTapToExitController, bool>(
      () => DoubleTapToExitController(),
    );

class DoubleTapToExitController extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return false;
  }

  Future<void> _load() async {
    state =
        AppPreferences.getPreferenceBool(AppPreferences.keyDoubleTapToExit) ??
        false;
  }

  Future<void> toggle() async {
    state = !state;
    await AppPreferences.setPreferenceBool(
      AppPreferences.keyDoubleTapToExit,
      state,
    );
  }
}
