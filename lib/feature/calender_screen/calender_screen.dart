import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solo_leveling/core/constants/solo_leveling_quotes.dart';
import 'package:solo_leveling/core/theme/app_themes.dart';
import 'package:solo_leveling/feature/calender_screen/provider/calendar_date_provider.dart';
import 'package:solo_leveling/feature/tasks/view_models/note_view_model.dart';
import 'package:solo_leveling/feature/tasks/widgets/tasks_cards.dart';
import 'package:solo_leveling/view_model/user_progress_view_model.dart';
import 'package:solo_leveling/domain/models/note_model.dart';
import 'widgets/week_carousel_widget.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  final bool _showCompleted = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(selectedCalendarDateProvider.notifier).setDate(_selectedDate);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final noteState = ref.watch(noteViewModelProvider);
    final progressAsync = ref.watch(userProgressViewModelProvider);
    final allTasks = noteState.notes;

    final tasksForDate = allTasks.where((note) {
      final dateToMatch = (note.dueDate ?? note.createdAt).toLocal();
      return dateToMatch.year == _selectedDate.year &&
          dateToMatch.month == _selectedDate.month &&
          dateToMatch.day == _selectedDate.day;
    }).toList();

    final remainingTasks = tasksForDate.where((t) => !t.isCompleted).toList();
    final completedTasks = tasksForDate.where((t) => t.isCompleted).toList();

    remainingTasks.sort(
      (a, b) => (a.dueDate ?? a.createdAt).compareTo(b.dueDate ?? b.createdAt),
    );
    completedTasks.sort(
      (a, b) => (a.dueDate ?? a.createdAt).compareTo(b.dueDate ?? b.createdAt),
    );

    final List<dynamic> listItems = [...remainingTasks];
    if (completedTasks.isNotEmpty && _showCompleted) {
      listItems.add("COMPLETED_HEADER");
      listItems.addAll(completedTasks);
    }

    // Today's quests for system overview
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayQuests = allTasks.where((n) {
      final date = n.dueDate ?? n.createdAt;
      final localDate = DateTime(date.year, date.month, date.day);
      return localDate == today;
    }).toList();

    // The whole page scrolls together as one view so nothing gets "stuck" and
    // the task list stays in sync with the selected day.
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 4),
          sliver: SliverToBoxAdapter(
            child: progressAsync.when(
              data: (progress) {
                if (progress == null) return const SizedBox.shrink();
                return _buildLevelCard(context, progress, todayQuests);
              },
              loading: () => const SizedBox(
                height: 8,
                child: Center(child: LinearProgressIndicator()),
              ),
              error: (err, _) => const SizedBox.shrink(),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: WeekCarouselWidget(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() => _selectedDate = date);
              ref
                  .read(selectedCalendarDateProvider.notifier)
                  .setDate(date);
            },
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              if (listItems.isEmpty)
                SizedBox(
                  height: 320,
                  child: _buildEmptyState(context),
                )
              else ...[
                // Remaining Tasks
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 16,
                  runSpacing: 16,
                  children: remainingTasks
                      .map(
                        (item) => TasksCard(
                          id: item.id,
                          title: item.title,
                          description: item.description ?? '',
                          dueTime: item.dueDate ?? item.createdAt,
                          priority: item.priority,
                          difficulty: item.difficulty,
                          isCompleted: item.isCompleted,
                          taskType: item.taskType,
                        ),
                      )
                      .toList(),
                ),
                if (completedTasks.isNotEmpty && _showCompleted) ...[
                  _buildCompletedHeader(cs, theme, completedTasks.length),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 16,
                    runSpacing: 16,
                    children: completedTasks
                        .map(
                          (item) => TasksCard(
                            id: item.id,
                            title: item.title,
                            description: item.description ?? '',
                            dueTime: item.dueDate ?? item.createdAt,
                            priority: item.priority,
                            difficulty: item.difficulty,
                            isCompleted: item.isCompleted,
                            taskType: item.taskType,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ]),
          ),
        ),
      ],
    );
  }

  /// Dramatic Solo Leveling "System" popup card.
  Widget _buildLevelCard(
    BuildContext context,
    dynamic progress,
    List<NoteModel> todayQuests,
  ) {
    final theme = Theme.of(context);
    final rank = progress.rankEnum;
    final todayIncomplete = todayQuests.where((q) => !q.isCompleted).length;
    final todayCompleted = todayQuests.where((q) => q.isCompleted).length;
    final quote = SoloLevelingQuotes.random;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        // Clamp value to [0,1] to avoid invalid transform matrices
        final clamped = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: clamped,
          child: Transform.scale(
            scale: 0.95 + (0.05 * clamped),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              SystemColors.surfaceElevated,
              SystemColors.surface,
              SystemColors.shadowViolet.withAlpha(40),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: SystemColors.accent.withAlpha(120),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: SystemColors.accent.withAlpha(60),
              blurRadius: 24,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: SystemColors.shadowViolet.withAlpha(40),
              blurRadius: 40,
              spreadRadius: -4,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Glow corner accents
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      SystemColors.accent.withAlpha(80),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -24,
              left: -24,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      SystemColors.shadowViolet.withAlpha(70),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: SYSTEM + rank badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'SYSTEM',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: SystemColors.accent,
                        ),
                      ),
                    ),
                    _buildRankBadge(rank.label),
                  ],
                ),
                const SizedBox(height: 14),
                // Level + XP
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'LVL ${progress.currentLevel}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: theme.colorScheme.onSurface,
                        shadows: [
                          Shadow(
                            color: SystemColors.accent.withAlpha(120),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${progress.totalPoints} XP',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // XP progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: progress.progressPercent),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          SystemColors.accent,
                        ),
                        minHeight: 10,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${progress.pointsToNextLevel} XP to next level',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: SystemColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${(progress.progressPercent * 100).toInt()}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Quote
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: SystemColors.shadowViolet.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: SystemColors.shadowViolet.withAlpha(50),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.format_quote_rounded,
                        color: SystemColors.shadowViolet,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          quote,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(220),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Stats row
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildStatChip(
                      context,
                      Icons.local_fire_department_rounded,
                      Colors.amber,
                      '${progress.currentStreak} day',
                    ),
                    _buildStatChip(
                      context,
                      Icons.check_circle_rounded,
                      SystemColors.accent,
                      '$todayCompleted/$todayIncomplete done',
                    ),
                    _buildStatChip(
                      context,
                      Icons.sports_kabaddi_rounded,
                      theme.colorScheme.primary,
                      '${progress.totalTasksCompleted} total',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Animated glowing rank badge.
  Widget _buildRankBadge(String rankLabel) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: math.sin(value * math.pi * 2) * 0.05,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  SystemColors.shadowViolet,
                  SystemColors.accent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: SystemColors.shadowViolet.withAlpha(120),
                  blurRadius: 16 + (value * 8),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(
              'RANK $rankLabel',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    IconData icon,
    Color color,
    String text,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 10,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedHeader(ColorScheme cs, ThemeData theme, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: cs.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.primary.withAlpha(30)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_rounded, size: 16, color: cs.primary),
                const SizedBox(width: 10),
                Text(
                  "COMPLETED QUESTS",
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 10),
                Text("•", style: TextStyle(color: cs.primary.withAlpha(100))),
                const SizedBox(width: 10),
                Text(
                  "$count",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: Divider(indent: 12, endIndent: 4)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cs.primary.withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_available_rounded,
              size: 64,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Dungeon clear for today!",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            "Add a new quest or explore the guild.",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: cs.outline),
          ),
        ],
      ),
    );
  }
}