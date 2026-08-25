import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:solo_leveling/core/services/notification_service.dart';
import 'package:solo_leveling/core/theme/app_themes.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class FocusModeScreen extends StatefulWidget {
  const FocusModeScreen({super.key});

  @override
  State<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen> {
  static const int _defaultMinutes = 25;

  /// Configured session duration in seconds (set in the settings dialog).
  int _focusSeconds = _defaultMinutes * 60;

  /// Seconds remaining, kept in sync with the wall clock while running.
  int _secondsRemaining = _defaultMinutes * 60;

  bool _isRunning = false;
  Timer? _timer;

  /// Absolute time the current run should end. Used to compute the countdown
  /// from the clock so it stays accurate even when the app is backgrounded or
  /// the screen turns off (when Dart timers are suspended by the OS).
  DateTime? _endTime;

  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(onResume: _syncRemainingTime);
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _timer?.cancel();
    WakelockPlus.disable();
    NotificationService().cancelFocusCountdownNotification();
    NotificationService().cancelFocusCompletion();
    super.dispose();
  }

  /// Recomputes the remaining seconds from [_endTime]. If the session is over
  /// (e.g. timed out while the app was backgrounded), it finalizes the run.
  void _syncRemainingTime() {
    if (!_isRunning || _endTime == null) return;

    final remaining = _endTime!.difference(DateTime.now());
    if (remaining <= Duration.zero) {
      _timer?.cancel();
      _timer = null;
      setState(() {
        _isRunning = false;
        _secondsRemaining = 0;
        _endTime = null;
      });
      WakelockPlus.disable();
      NotificationService().cancelFocusCountdownNotification();
      NotificationService().cancelFocusCompletion();
      _showQuestCompleteDialog();
    } else {
      setState(() => _secondsRemaining = remaining.inSeconds);
      _updateCountdownNotification();
    }
  }

  void _startTimer() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
      _endTime = DateTime.now().add(Duration(seconds: _secondsRemaining));
    });
    WakelockPlus.enable(); // keep the screen on so the timer never sleeps
    NotificationService().requestExactAlarmPermission();
    NotificationService().scheduleFocusCompletion(when: _endTime);
    _updateCountdownNotification();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _syncRemainingTime();
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
    if (_endTime != null) {
      final remaining = _endTime!.difference(DateTime.now()).inSeconds;
      _secondsRemaining = remaining.clamp(0, _focusSeconds).toInt();
      _endTime = null;
    }
    setState(() => _isRunning = false);
    WakelockPlus.disable();
    NotificationService().cancelFocusCountdownNotification();
    NotificationService().cancelFocusCompletion();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = null;
    _endTime = null;
    setState(() {
      _isRunning = false;
      _secondsRemaining = _focusSeconds;
    });
    WakelockPlus.disable();
    NotificationService().cancelFocusCountdownNotification();
    NotificationService().cancelFocusCompletion();
  }

  /// Pushes the current remaining time to the ongoing countdown notification.
  void _updateCountdownNotification() {
    if (!_isRunning) return;
    final notif = NotificationService();
    final formatted = _formatTime(_secondsRemaining);
    notif.showFocusCountdownNotification(
      title: 'Focus Dungeon',
      body: '$formatted  remaining — press to open the app',
    );
  }

  void _showSettingsDialog() {
    final cs = Theme.of(context).colorScheme;
    int tempHours = _focusSeconds ~/ 3600;
    int tempMinutes = (_focusSeconds % 3600) ~/ 60;

    void apply() {
      final totalSeconds = tempHours * 3600 + tempMinutes * 60;
      setState(() {
        _focusSeconds = totalSeconds < 60 ? 60 : totalSeconds;
        _secondsRemaining = _focusSeconds;
        _isRunning = false;
        _endTime = null;
      });
      _timer?.cancel();
      WakelockPlus.disable();
      NotificationService().cancelFocusCountdownNotification();
      NotificationService().cancelFocusCompletion();
    }

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
            const SizedBox(height: 16),
            // Quick presets
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [25, 45, 90, 120, 240]
                  .map(
                    (mins) => ChoiceChip(
                      label: Text(mins >= 60
                          ? '${mins ~/ 60}h${mins % 60 == 0 ? '' : ' ${mins % 60}m'}'
                          : '$mins min'),
                      selected: tempHours * 60 + tempMinutes == mins,
                      onSelected: (_) => setState(() {
                        tempHours = mins ~/ 60;
                        tempMinutes = mins % 60;
                      }),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hours wheel
                SizedBox(
                  width: 90,
                  height: 180,
                  child: ListWheelScrollView(
                    itemExtent: 44,
                    diameterRatio: 2,
                    useMagnifier: true,
                    magnification: 1.2,
                    onSelectedItemChanged: (index) {
                      setState(() => tempHours = index);
                    },
                    children: List.generate(13, (i) {
                      final isSelected = i == tempHours;
                      return Center(
                        child: Text(
                          '$i h',
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
                ),
                const SizedBox(width: 8),
                // Minutes wheel
                SizedBox(
                  width: 90,
                  height: 180,
                  child: ListWheelScrollView(
                    itemExtent: 44,
                    diameterRatio: 2,
                    useMagnifier: true,
                    magnification: 1.2,
                    onSelectedItemChanged: (index) {
                      setState(() => tempMinutes = index);
                    },
                    children: List.generate(60, (i) {
                      final isSelected = i == tempMinutes;
                      return Center(
                        child: Text(
                          '$i min',
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
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${tempHours}h ${tempMinutes.toString().padLeft(2, '0')}m',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.primary,
              ),
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
              apply();
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
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = (seconds % 60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:$secs';
    }
    return '${minutes.toString().padLeft(2, '0')}:$secs';
  }

  String _timeUnitLabel(int seconds) =>
      seconds >= 3600 ? 'HOURS' : 'MINUTES';

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _formatTime(_secondsRemaining),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.primary,
                    letterSpacing: -2,
                  ),
                ),
              ),
            ),
            Text(
              _timeUnitLabel(_secondsRemaining),
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