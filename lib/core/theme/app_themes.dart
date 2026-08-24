import 'package:flutter/material.dart';

/// Solo Leveling "System" color palette.
abstract class SystemColors {
  static const background = Color(0xFF0A0A0A);
  static const surface = Color(0xFF121212);
  static const surfaceElevated = Color(0xFF16161A);
  static const surfaceContainer = Color(0xFF1C1C22);
  static const text = Colors.white;
  static const accent = Color(0xFF00F2FF);
  static const shadowViolet = Color(0xFF7C4DFF);
  static const glitchMagenta = Color(0xFFFF2E63);
}

class AppThemePreset {
  final String name;
  final Color seedColor;
  final bool useDynamic;

  const AppThemePreset({
    required this.name,
    required this.seedColor,
    this.useDynamic = false,
  });
}

class AppThemes {
  static const violet = AppThemePreset(
    name: 'Violet',
    seedColor: Colors.deepPurple,
  );

  static const dynamic = AppThemePreset(
    name: 'Dynamic',
    seedColor: Colors.blue,
    useDynamic: true,
  );

  static const miku = AppThemePreset(
    name: 'Miku',
    seedColor: Color(0xFF00BFA6),
  );

  static const soloLeveling = AppThemePreset(
    name: 'Solo Leveling',
    seedColor: SystemColors.accent,
  );

  static const presets = [soloLeveling, miku, dynamic, violet];
}