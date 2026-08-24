import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solo_leveling/view_model/user_progress_view_model.dart';
import 'package:solo_leveling/domain/models/note_model.dart';
import 'package:solo_leveling/feature/tasks/view_models/note_view_model.dart';
import 'package:solo_leveling/feature/tasks/widgets/task_edit_options.dart';
import 'package:solo_leveling/data/db/tables/note_table.dart';
import 'package:solo_leveling/view_model/gamification_provider.dart';
import 'package:solo_leveling/core/widgets/system_overlay.dart';
import 'package:intl/intl.dart';

class HabitTrackerScreen extends ConsumerWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final noteState = ref.watch(noteViewModelProvider);
    final progressAsync = ref.watch(userProgressViewModelProvider);
    final isGamificationEnabled = ref.watch(gamificationProvider);
    final allNotes = noteState.notes;

    // Today's quests only
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayQuests = allNotes.where((n) {
      final date = n.dueDate ?? n.createdAt;
      final localDate = DateTime(date.year, date.month, date.day);
      return localDate == today;
    }).toList();

    final incomplete = todayQuests.where((q) => !q.isCompleted).toList();
    final completed = todayQuests.where((q) => q.isCompleted).toList();

    // Calculate total XP available today
    int totalXpAvailable = 0;
    int totalXpEarned = 0;
    for (final q in todayQuests) {
      final xp = UserProgressViewModel.xpForDifficulty(q.difficulty);
      if (q.isCompleted) {
        totalXpEarned += xp;
      }
      totalXpAvailable += xp;
    }

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
                'Daily Quests',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: cs.onSurface,
                ),
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Streak Card - real data from DB
                progressAsync.when(
                  data: (progress) {
                    final streak = progress?.currentStreak ?? 0;
                    final totalCompleted = progress?.totalTasksCompleted ?? 0;
                    return _buildStreakCard(context, streak, totalCompleted, totalXpEarned, totalXpAvailable);
                  },
                  loading: () => _buildStreakCard(context, 0, 0, 0, 0),
                  error: (_, _) => _buildStreakCard(context, 0, 0, 0, 0),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader(context, "Today's Quests", incomplete.length, completed.length),
                const SizedBox(height: 16),

                // No quests state
                if (todayQuests.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(40),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Icon(
                          Icons.assignment_rounded,
                          size: 48,
                          color: cs.outline.withAlpha(100),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No quests for today',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add a daily quest',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.outline,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Incomplete quests
                ...incomplete.map((note) => _buildQuestItem(context, ref, note, false, isGamificationEnabled)),

                // Completed quests
                if (completed.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Text(
                          'COMPLETED',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.outline,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: cs.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${completed.length}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: cs.primary,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(indent: 12)),
                      ],
                    ),
                  ),
                  ...completed.map((note) => _buildQuestItem(context, ref, note, true, isGamificationEnabled)),
                ],

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, int streak, int totalCompleted, int xpEarned, int xpAvailable) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final progress = xpAvailable > 0 ? xpEarned / xpAvailable : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primaryContainer.withAlpha(200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$streak Day Streak!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalCompleted quests completed',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlpha(200),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.fireplace_rounded,
                    color: Colors.white, size: 32),
              ),
            ],
          ),
          if (xpAvailable > 0) ...[
            const SizedBox(height: 16),
            // XP Progress Bar
            Row(
              children: [
                Icon(Icons.stars_rounded, color: Colors.amber, size: 16),
                const SizedBox(width: 6),
                Text(
                  '$xpEarned / $xpAvailable XP',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withAlpha(40),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 8,
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildSectionHeader(BuildContext context, String title, int incomplete, int completed) {
    final cs = Theme.of(context).colorScheme;
    final total = incomplete + completed;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: cs.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            total > 0 ? '$completed/$total' : 'Daily',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestItem(
      BuildContext context, WidgetRef ref, NoteModel note, bool isCompleted, bool showGamification) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final color = isCompleted
        ? cs.outlineVariant
        : switch (note.priority) {
            Priority.high => cs.error,
            Priority.medium => cs.tertiary,
            Priority.low => cs.primary,
            Priority.none => cs.outlineVariant,
          };

    final xpValue = UserProgressViewModel.xpForDifficulty(note.difficulty);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(60),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted
              ? Colors.transparent
              : color.withAlpha(40),
        ),
      ),
      child: InkWell(
        onLongPress: () =>
            showTaskOptions(context, ref, note.id, note.isCompleted),
        onTap: () async {
          final result = await ref
              .read(noteViewModelProvider.notifier)
              .toggleNoteCompletion(note.id);
          if (result != null && context.mounted) {
            if (result.leveledUp) {
              SystemOverlay.showLevelUp(
                context,
                newLevel: result.newLevel,
                rank: result.newRank,
              );
            } else {
              SystemOverlay.showQuestComplete(
                context,
                questTitle: 'Quest Completed',
                xpGained: result.xpGained,
              );
            }
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (isCompleted ? cs.outlineVariant : color).withAlpha(40),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isCompleted ? cs.outlineVariant : color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration:
                                isCompleted ? TextDecoration.lineThrough : null,
                            color: isCompleted
                                ? cs.onSurfaceVariant.withAlpha(100)
                                : cs.onSurface,
                          ),
                        ),
                      ),
                      if (showGamification && !isCompleted) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.amber.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.stars_rounded, size: 12, color: Colors.amber.shade700),
                              const SizedBox(width: 3),
                              Text(
                                '+$xpValue XP',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.amber.shade700,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (isCompleted) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: cs.primary.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_rounded, size: 12, color: cs.primary),
                              const SizedBox(width: 3),
                              Text(
                                '+$xpValue XP',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: cs.primary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (note.description != null &&
                      note.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      note.description!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant.withAlpha(150),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (note.dueDate != null)
              Text(
                DateFormat('h:mm a').format(note.dueDate!),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.1, end: 0);
  }
}
