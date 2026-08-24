import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solo_leveling/core/theme/app_themes.dart';
import 'package:solo_leveling/view_model/gamification_provider.dart';
import 'package:solo_leveling/view_model/user_progress_view_model.dart';
import 'package:solo_leveling/feature/settings_screen/xp_level_config_screen.dart';

class GamificationScreen extends ConsumerWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isGamificationEnabled = ref.watch(gamificationProvider);
    final progressAsync = ref.watch(userProgressViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'System',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: SystemColors.accent,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: cs.primary,
            size: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (isGamificationEnabled) ...[
            progressAsync.when(
              data: (progress) {
                if (progress == null) return const SizedBox();
                return _buildProgressCard(context, progress);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
            ),
            const SizedBox(height: 24),
          ],
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withAlpha(51),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: SystemColors.accent.withAlpha(51)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quest System',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: SystemColors.accent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Earn XP, levels and streaks by completing quests.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant.withAlpha(150),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isGamificationEnabled,
                  onChanged: (_) =>
                      ref.read(gamificationProvider.notifier).toggle(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildInfoItem(
            context,
            Icons.bolt_rounded,
            'Difficulty XP',
            'Low (10 XP), Medium (25 XP), and High (50 XP) awarded upon completion.',
          ),
          _buildInfoItem(
            context,
            Icons.local_fire_department_rounded,
            'Weekly Streak',
            'Complete quests for 7 days in a row to earn 50 bonus XP.',
          ),
          _buildInfoItem(
            context,
            Icons.stars_rounded,
            'Level Progression',
            'Next Level XP = (Current Level ^ 1.5) * 100',
          ),
          const SizedBox(height: 16),
          // Edit XP Levels button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: SystemColors.accent.withAlpha(80),
                width: 1,
              ),
              gradient: LinearGradient(
                colors: [
                  SystemColors.shadowViolet.withAlpha(30),
                  SystemColors.accent.withAlpha(30),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const XpLevelConfigScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: SystemColors.accent.withAlpha(40),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: SystemColors.accent,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit XP Levels',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: SystemColors.accent,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Customize XP required per level',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant.withAlpha(180),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: SystemColors.accent.withAlpha(150),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, dynamic progress) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final rank = progress.rankEnum;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: SystemColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: SystemColors.accent.withAlpha(80), width: 1),
        boxShadow: [
          BoxShadow(
            color: SystemColors.accent.withAlpha(30),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LEVEL ${progress.currentLevel}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: SystemColors.accent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${progress.totalPoints} Total XP',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: SystemColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: SystemColors.shadowViolet.withAlpha(80),
                    width: 1,
                  ),
                ),
                child: Text(
                  'RANK ${rank.label}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: SystemColors.shadowViolet,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: SystemColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${progress.currentStreak} Day Streak',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: SystemColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: SystemColors.accent,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${progress.totalTasksCompleted} Quests',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.progressPercent,
              backgroundColor: SystemColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(SystemColors.accent),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Next Level: ${progress.nextLevelPoints} XP',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${(progress.progressPercent * 100).toInt()}%',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: SystemColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: SystemColors.surfaceElevated,
              shape: BoxShape.circle,
              border: Border.all(
                color: SystemColors.accent.withAlpha(50),
                width: 1,
              ),
            ),
            child: Icon(icon, color: SystemColors.accent, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: SystemColors.accent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant.withAlpha(150),
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}