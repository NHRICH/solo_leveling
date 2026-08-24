import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:solo_leveling/core/theme/app_themes.dart';

class FocusModeScreen extends StatefulWidget {
  const FocusModeScreen({super.key});

  @override
  State<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen> {
  static const int _defaultMinutes = 25;
  int _focusMinutes = _defaultMinutes;
  int _secondsRemaining = _defaultMinutes * 60;
  bool _isRunning = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _initialSeconds => _focusMinutes * 60;

  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        setState(() => _isRunning = false);
        _showQuestCompleteDialog();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsRemaining = _initialSeconds;
    });
  }

  void _showSettingsDialog() {
    final cs = Theme.of(context).colorScheme;
    int tempMinutes = _focusMinutes;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: SystemColors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: cs.primary.withAlpha(60), width: 1),
        ),
        title: Text(
          'Dungeon Duration',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set your focus time',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            StatefulBuilder(
              builder: (context, setDialogState) {
                return SizedBox(
                  height: 200,
                  child: ListWheelScrollView(
                    itemExtent: 48,
                    diameterRatio: 2,
                    useMagnifier: true,
                    magnification: 1.2,
                    onSelectedItemChanged: (index) {
                      setDialogState(() => tempMinutes = index + 1);
                    },
                    children: List.generate(120, (index) {
                      final mins = index + 1;
                      final isSelected = mins == tempMinutes;
                      return Center(
                        child: Text(
                          '$mins min',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w900
                                    : FontWeight.w500,
                                color: isSelected
                                    ? cs.primary
                                    : cs.onSurfaceVariant,
                                letterSpacing: -0.5,
                              ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: cs.onSurfaceVariant)),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _focusMinutes = tempMinutes;
                _secondsRemaining = tempMinutes * 60;
                _isRunning = false;
                _timer?.cancel();
              });
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: cs.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Apply',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  void _showQuestCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: SystemColors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: SystemColors.accent.withAlpha(80),
            width: 1,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.stars_rounded,
              size: 48,
              color: SystemColors.accent,
            ),
            const SizedBox(height: 16),
            Text(
              'Quest Complete!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: SystemColors.accent,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have successfully completed your focus dungeon.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTimer();
            },
            child: Text(
              'Continue',
              style: TextStyle(color: SystemColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Text(
              'Focus Dungeon',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ).animate().fadeIn().scale(),
            const SizedBox(height: 8),
            Text(
              'Deep work, no distractions.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            _buildTimer(context),
            const Spacer(),
            _buildActionButtons(context),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTimer(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: cs.primary.withAlpha(50), width: 2),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withAlpha(20),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatTime(_secondsRemaining),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.primary,
                letterSpacing: -2,
              ),
            ),
            Text(
              'MINUTES',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.primary.withAlpha(150),
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .shimmer(duration: 3.seconds, color: cs.primaryContainer.withAlpha(100));
  }

  Widget _buildActionButtons(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircleButton(
          Icons.refresh_rounded,
          cs.surfaceContainerHighest,
          cs.onSurfaceVariant,
          onPressed: _resetTimer,
        ),
        const SizedBox(width: 24),
        _buildCircleButton(
          _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
          cs.primary,
          Colors.white,
          size: 80,
          iconSize: 40,
          onPressed: _isRunning ? _pauseTimer : _startTimer,
        ),
        const SizedBox(width: 24),
        _buildCircleButton(
          Icons.settings_rounded,
          cs.surfaceContainerHighest,
          cs.onSurfaceVariant,
          onPressed: _showSettingsDialog,
        ),
      ],
    );
  }

  Widget _buildCircleButton(
    IconData icon,
    Color bg,
    Color fg, {
    double size = 60,
    double iconSize = 24,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: bg.withAlpha(40),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(icon, color: fg, size: iconSize),
      ),
    );
  }
}