import 'package:flutter/material.dart';

/// Solo Leveling "System" color palette.
/// Cyber-inspired, high contrast, with the signature neon blue.
class AppColors {
  AppColors._();

  /// Primary backgrounds: deep charcoal to near-black.
  static const background = Color(0xFF0A0A0A);
  static const surface = Color(0xFF121212);
  static const surfaceElevated = Color(0xFF1C1C24);

  /// Thin glowing border around widgets/cards (1px).
  static const border = Color(0xFF2A2A35);

  /// Accent / System UI color: electric neon cyan.
  static const neonCyan = Color(0xFF00F2FF);

  /// Secondary accent: shadow violet for magical/special effects.
  static const shadowViolet = Color(0xFF7C4DFF);

  /// Glitch/magenta accent for special states.
  static const glitchMagenta = Color(0xFFFF2E63);

  /// Gold accent for rank/level highlights.
  static const systemGold = Color(0xFFFFD54F);

  /// Danger/error red.
  static const dangerRed = Color(0xFFFF5252);

  /// Success green.
  static const successGreen = Color(0xFF69F0AE);

  /// Text: crisp white for body, system messages in neon cyan.
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFB0BEC5);
}