import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solo_leveling/core/theme/app_themes.dart';
import 'package:solo_leveling/view_model/user_progress_view_model.dart';
import 'package:solo_leveling/feature/tasks/view_models/note_view_model.dart';
import 'package:solo_leveling/domain/models/note_model.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final progressAsync = ref.watch(userProgressViewModelProvider);
    final noteState = ref.watch(noteViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: theme.scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'System Dashboard',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface,
                ),
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Level & Rank Card
                progressAsync.when(
                  data: (progress) {
                    if (progress == null) {
                      return const SizedBox.shrink();
                    }
                    return _buildLevelCard(context, progress);
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Text('Error: $err'),
                ),
                const SizedBox(height: 32),

                // Daily Quests
                _buildSectionLabel(context, "Today's Quests"),
                const SizedBox(height: 16),
                if (noteState.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  _buildDailyQuests(context, noteState.notes),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, dynamic progress) {
    final theme = Theme.of(context);
    final rank = progress.rankEnum;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            SystemColors.accent.withAlpha(30),
            SystemColors.shadowViolet.withAlpha(30),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
              Text(
                'LEVEL ${progress.currentLevel}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: SystemColors.accent,
                  letterSpacing: 2,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.progressPercent,
              backgroundColor: SystemColors.surfaceElevated,
              valueColor:
                  AlwaysStoppedAnimation<Color>(SystemColors.accent),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${progress.totalPoints} Total XP',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${progress.pointsToNextLevel} XP to next level',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: SystemColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyQuests(BuildContext context, List<NoteModel> notes) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final quests = notes.where((n) {
      final date = n.dueDate ?? n.createdAt;
      final localDate = DateTime(date.year, date.month, date.day);
      return localDate == today;
    }).toList();

    if (quests.isEmpty) {
      return Center(
        child: Text(
          "No quests for today. Add one to begin your hunt!",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: quests
          .map(
            (quest) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withAlpha(60),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withAlpha(50),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    quest.isCompleted
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: quest.isCompleted
                        ? SystemColors.accent
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      quest.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            decoration: quest.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: quest.isCompleted
                                ? Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant
                                    .withAlpha(100)
                                : null,
                          ),
                    ),
                  ),
                  Text(
                    DateFormat('h:mm a').format(quest.dueDate ?? quest.createdAt),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w900,
        color: Theme.of(context).colorScheme.outline,
        letterSpacing: 1.5,
      ),
    );
  }
}
