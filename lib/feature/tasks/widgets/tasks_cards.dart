import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solo_leveling/view_model/gamification_provider.dart';
import 'package:solo_leveling/data/db/tables/note_table.dart';
import 'package:solo_leveling/feature/tasks/view_models/task_category_view_model.dart';
import 'package:solo_leveling/feature/tasks/view_models/note_view_model.dart';
import 'package:solo_leveling/feature/tasks/widgets/task_edit_options.dart';
import 'package:solo_leveling/core/utils/icon_utils.dart';
import 'package:solo_leveling/core/widgets/system_overlay.dart';
import 'package:intl/intl.dart';

class TasksCard extends ConsumerStatefulWidget {
  const TasksCard({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.dueTime,
    required this.priority,
    required this.difficulty,
    required this.isCompleted,
    this.taskType,
  });

  final int id;
  final String title;
  final String description;
  final DateTime dueTime;
  final bool isCompleted;
  final Priority priority;
  final TaskDifficulty difficulty;
  final String? taskType;

  @override
  ConsumerState<TasksCard> createState() => _TasksCardState();
}

class _TasksCardState extends ConsumerState<TasksCard>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  /// Toggles the completion state directly from the circular checkbox and
  /// shows the Solo Leveling "System" overlay when a quest is completed.
  Future<void> _toggleComplete() async {
    final result = await ref
        .read(noteViewModelProvider.notifier)
        .toggleNoteCompletion(widget.id);
    if (!mounted) return;
    if (result != null) {
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
  }

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(taskCategoryViewModelProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Left Border Color based on Priority
    final priorityColor = widget.isCompleted
        ? colorScheme.outlineVariant
        : switch (widget.priority) {
            Priority.high => colorScheme.error,
            Priority.medium => colorScheme.tertiary,
            Priority.low => colorScheme.primary,
            Priority.none => colorScheme.outlineVariant,
          };

    final textColor = widget.isCompleted
        ? theme.hintColor
        : colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onLongPress: () =>
            showTaskOptions(context, ref, widget.id, widget.isCompleted),
        onTap: _toggleExpand,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.isCompleted
                ? colorScheme.surfaceContainerHighest.withAlpha(40)
                : colorScheme.surfaceContainerHighest.withAlpha(80),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.isCompleted
                  ? Colors.transparent
                  : priorityColor.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: circular checkbox toggle + Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Circular checkbox to toggle completion with a single tap
                    GestureDetector(
                      key: ValueKey('task_toggle_${widget.id}'),
                      behavior: HitTestBehavior.opaque,
                      onTap: _toggleComplete,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2, right: 12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: widget.isCompleted
                                ? colorScheme.primary
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.isCompleted
                                  ? colorScheme.primary
                                  : priorityColor,
                              width: 2,
                            ),
                          ),
                          child: widget.isCompleted
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Hero(
                        tag: 'task_title_${widget.id}',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              fontSize: 16,
                              letterSpacing: -0.3,
                              decoration: widget.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Meta Row: Category tags and Time (flowing horizontally)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Category Tags
                    categoriesState.maybeWhen(
                      data: (cats) {
                        if (widget.taskType == null ||
                            widget.taskType!.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final selectedIds = widget.taskType!
                            .split(',')
                            .map((s) => int.tryParse(s.trim()))
                            .whereType<int>()
                            .toList();

                        final allMatches = cats
                            .where((c) => selectedIds.contains(c.id))
                            .toList();

                        if (allMatches.isEmpty) return const SizedBox.shrink();

                        return Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: allMatches
                              .map(
                                (match) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest
                                        .withAlpha(200),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: colorScheme.outline.withAlpha(30),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconUtils.buildCategoryIcon(
                                        match.icon,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        match.name,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 11,
                                              color: colorScheme
                                                  .onSurfaceVariant
                                                  .withAlpha(180),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                      orElse: () => const SizedBox.shrink(),
                    ),

                    // Time indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_filled_rounded,
                            size: 13,
                            color: textColor.withAlpha(100),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            DateFormat('h:mm a').format(widget.dueTime),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: textColor.withAlpha(150),
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Expanded Section: Description
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.description.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        // Removed the "bar roler" (Divider) as requested
                        Text(
                          widget.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textColor.withAlpha(180),
                            height: 1.4,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      // Priority Label explicitly inside expanded view
                      if (widget.priority != Priority.none)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: priorityColor.withAlpha(30),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 3,
                                    backgroundColor: priorityColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.priority.name.toUpperCase(),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: priorityColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (ref.watch(gamificationProvider)) ...[
                        const SizedBox(height: 8),
                        // Difficulty Label explicitly inside expanded view
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest
                                    .withAlpha(30),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons
                                        .bolt_rounded, // Use bolt icon for difficulty
                                    size: 14,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.difficulty.name.toUpperCase(),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: colorScheme.onSurfaceVariant,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
