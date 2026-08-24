import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solo_leveling/data/db/tables/note_table.dart';
import 'package:solo_leveling/feature/tasks/view_models/note_view_model.dart';
import 'package:solo_leveling/domain/models/note_model.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final TextEditingController _journalController = TextEditingController();

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    final text = _journalController.text.trim();
    if (text.isEmpty) return;

    await ref
        .read(noteViewModelProvider.notifier)
        .insertNote(
          text, // title
          null, // description
          null, // dueDate
          null, // priority
          TaskDifficulty.easy, // difficulty
          null, // taskType
        );

    _journalController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final noteState = ref.watch(noteViewModelProvider);
    final notes = noteState.notes;

    // Filter notes that look like journal entries (no due date, easy difficulty)
    final journalEntries = notes
        .where((n) => n.dueDate == null)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: theme.scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cs.tertiaryContainer.withAlpha(100),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              title: Text(
                'System Journal',
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
                _buildJournalInput(context),
                const SizedBox(height: 32),
                _buildSectionLabel(context, "Quest Log"),
                const SizedBox(height: 16),
                if (noteState.isLoading && journalEntries.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else if (journalEntries.isEmpty)
                  _buildEmptyState(context)
                else
                  ...journalEntries.map(
                    (note) => _buildJournalCard(
                      context,
                      note.title,
                      note.description ?? '',
                      formatDateAndTimeDifference(note.createdAt),
                    ),
                  ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalInput(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: cs.outlineVariant.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _journalController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Record your daily quest notes...",
              hintStyle: TextStyle(
                color: cs.onSurfaceVariant.withAlpha(100),
              ),
              border: InputBorder.none,
            ),
          ),
          const Divider(),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.image_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.emoji_emotions_outlined),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Save Entry'),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
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

  Widget _buildJournalCard(
    BuildContext context,
    String title,
    String content,
    String time,
  ) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(40),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                time,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.05, end: 0);
  }

  Widget _buildEmptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 64,
            color: cs.primary.withAlpha(80),
          ),
          const SizedBox(height: 16),
          Text(
            "No quests recorded yet",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Document your daily adventures to track your growth.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant.withAlpha(150),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
