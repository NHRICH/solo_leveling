import 'dart:async';

import 'package:flutter/material.dart';

import 'package:solo_leveling/core/theme/app_themes.dart';

/// Solo Leveling "System" overlay.
///
/// Shows a black notification with neon cyan text in the signature
/// *Solo Leveling* style. Used for "Quest Complete" and "Level Up" events.
class SystemOverlay {
  /// Shows a "Quest Complete" pop-up (cyan, instant).
  static void showQuestComplete(
    BuildContext context, {
    required String questTitle,
    required int xpGained,
  }) {
    _show(
      context,
      title: 'QUEST COMPLETE',
      message: questTitle,
      subtitle: '+$xpGained XP',
      accent: SystemColors.accent,
    );
  }

  /// Shows a "Level Up" pop-up (shadow violet, with glitch effect).
  static void showLevelUp(
    BuildContext context, {
    required int newLevel,
    required String rank,
  }) {
    _show(
      context,
      title: 'LEVEL UP',
      message: 'LEVEL $newLevel',
      subtitle: 'RANK $rank',
      accent: SystemColors.shadowViolet,
      glitch: true,
    );
  }

  static void _show(
    BuildContext context, {
    required String title,
    required String message,
    required String subtitle,
    required Color accent,
    bool glitch = false,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _SystemOverlayCard(
        title: title,
        message: message,
        subtitle: subtitle,
        accent: accent,
        glitch: glitch,
        onDismiss: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }
}

class _SystemOverlayCard extends StatefulWidget {
  final String title;
  final String message;
  final String subtitle;
  final Color accent;
  final bool glitch;
  final VoidCallback onDismiss;

  const _SystemOverlayCard({
    required this.title,
    required this.message,
    required this.subtitle,
    required this.accent,
    required this.glitch,
    required this.onDismiss,
  });

  @override
  State<_SystemOverlayCard> createState() => _SystemOverlayCardState();
}

class _SystemOverlayCardState extends State<_SystemOverlayCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
    _dismissTimer = Timer(const Duration(milliseconds: 2200), () {
      _controller.reverse().then((_) => widget.onDismiss());
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: FadeTransition(
          opacity: _fade,
          child: Center(
            child: ScaleTransition(
              scale: _scale,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF000000).withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: widget.accent, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accent.withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: widget.accent,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: widget.accent,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}